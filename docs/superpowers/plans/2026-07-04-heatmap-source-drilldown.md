# Heatmap Source Drilldown Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Clicking a populated cell in the "Conversiones por Hora y Día" heatmap shows a breakdown of which campaign/traffic source produced those conversions.

**Architecture:** Pure frontend + one query-shape change. `getHourlyHeatmap` already fetches every active transaction's `created_at` in the date range in a single query; we add `traffic_source` to that same `select` and accumulate a per-cell source breakdown alongside the existing count, exposed as a new `bySource` field on `HeatmapCell`. `HourlyHeatmap.tsx` gets a `selectedCell` state and an `onClick` handler that toggles a breakdown panel below the grid, reusing the `traffic_source ?? "Sin UTM"` labeling convention already used by `getVSLBySource`/`getLTVBySource` elsewhere in `analytics.ts`.

**Tech Stack:** React 19 + TypeScript (Vite SPA), Supabase JS client. No test framework in this repo — verify with `npm run build` (tsc type-check) plus manual browser check per this project's CLAUDE.md instruction to test UI changes in-browser before claiming completion.

## Global Constraints

- No DB migrations, no Supabase Edge Function changes — 100% `src/` frontend, one query-shape change only (adding a column to an existing `select`).
- No test framework exists in this repo — do not introduce one. Verify with `npm run build` and manual browser checks only.
- No additional Supabase round-trips — the source breakdown must come from the same fetch `getHourlyHeatmap` already makes, not a new query fired on click.
- All Spanish-language UI copy stays in Spanish (existing project convention).
- Reuse existing color tokens from `src/tokens.ts` (`C.orange`, `C.white`, `C.mutedLight`, `C.mutedMid`, `C.border`) — do not hardcode new hex colors.
- The `"Sin UTM"` fallback label for a null/missing `traffic_source` must match the exact string already used elsewhere in `analytics.ts` (`getVSLBySource`, `getLTVBySource`) — same convention, same string.

---

### Task 1: Add `bySource` to `HeatmapCell` and populate it in `getHourlyHeatmap`

**Files:**
- Modify: `src/services/analytics.ts:115` (the `HeatmapCell` interface)
- Modify: `src/services/analytics.ts:325-343` (the `getHourlyHeatmap` function)

**Interfaces:**
- Produces: `HeatmapCell` now has `bySource: { source: string; count: number }[]` (sorted descending by `count`) — consumed by Task 2 (`HourlyHeatmap.tsx`).

- [ ] **Step 1: Update the `HeatmapCell` interface**

Replace:

```typescript
export interface HeatmapCell { hour: number; dow: number; value: number }
```

with:

```typescript
export interface HeatmapCell {
  hour:     number;
  dow:      number;
  value:    number;
  bySource: { source: string; count: number }[];
}
```

- [ ] **Step 2: Update `getHourlyHeatmap` to select `traffic_source` and build the per-cell breakdown**

Replace the entire function:

```typescript
export async function getHourlyHeatmap(r: DateRange): Promise<HeatmapCell[]> {
  const { data } = await supabase
    .from("transactions")
    .select("created_at")
    .gte("created_at", r.fromTs).lte("created_at", r.toTs)
    .eq("status", "active");

  const cells: Record<string, number> = {};
  for (const tx of (data ?? [])) {
    const d = new Date(tx.created_at);
    const k = `${d.getHours()}-${d.getDay()}`;
    cells[k] = (cells[k] ?? 0) + 1;
  }

  return Object.entries(cells).map(([k, value]) => {
    const [hour, dow] = k.split("-").map(Number);
    return { hour, dow, value };
  });
}
```

with:

```typescript
export async function getHourlyHeatmap(r: DateRange): Promise<HeatmapCell[]> {
  const { data } = await supabase
    .from("transactions")
    .select("created_at, traffic_source")
    .gte("created_at", r.fromTs).lte("created_at", r.toTs)
    .eq("status", "active");

  const cells:     Record<string, number> = {};
  const bySources: Record<string, Record<string, number>> = {};

  for (const tx of (data ?? [])) {
    const d = new Date(tx.created_at);
    const k = `${d.getHours()}-${d.getDay()}`;
    cells[k] = (cells[k] ?? 0) + 1;

    const source = tx.traffic_source ?? "Sin UTM";
    if (!bySources[k]) bySources[k] = {};
    bySources[k][source] = (bySources[k][source] ?? 0) + 1;
  }

  return Object.entries(cells).map(([k, value]) => {
    const [hour, dow] = k.split("-").map(Number);
    const bySource = Object.entries(bySources[k] ?? {})
      .map(([source, count]) => ({ source, count }))
      .sort((a, b) => b.count - a.count);
    return { hour, dow, value, bySource };
  });
}
```

- [ ] **Step 3: Type-check**

Run: `npm run build`
Expected: This will currently FAIL with a TypeScript error in `src/components/analytics/HourlyHeatmap.tsx` if it destructures `HeatmapCell` in a way that's now incompatible — check the output. If the only errors are inside `HourlyHeatmap.tsx` about the new required `bySource` field not being handled, that's expected (Task 2 fixes it). If there are errors anywhere else, stop and investigate before continuing.

- [ ] **Step 4: Commit**

```bash
git add src/services/analytics.ts
git commit -m "feat(analytics): add per-cell traffic source breakdown to getHourlyHeatmap"
```

---

### Task 2: Click-to-drilldown panel in `HourlyHeatmap.tsx`

**Files:**
- Modify: `src/components/analytics/HourlyHeatmap.tsx`

**Interfaces:**
- Consumes: `HeatmapCell.bySource: { source: string; count: number }[]` (Task 1).

- [ ] **Step 1: Add `selectedCell` state next to the existing `tooltip` state**

Replace:

```typescript
export function HourlyHeatmap({ cells }: Props) {
  const [tooltip, setTooltip] = useState<{ h: number; dow: number; val: number } | null>(null);
```

with:

```typescript
export function HourlyHeatmap({ cells }: Props) {
  const [tooltip,      setTooltip]      = useState<{ h: number; dow: number; val: number } | null>(null);
  const [selectedCell, setSelectedCell] = useState<{ h: number; dow: number } | null>(null);
```

- [ ] **Step 2: Build a lookup for `bySource` alongside the existing `lookup` for `value`**

Replace:

```typescript
  const maxVal = Math.max(1, ...cells.map(c => c.value));
  const lookup: Record<string, number> = {};
  for (const c of cells) lookup[`${c.hour}-${c.dow}`] = c.value;

  const totalConversions = cells.reduce((s, c) => s + c.value, 0);
```

with:

```typescript
  const maxVal = Math.max(1, ...cells.map(c => c.value));
  const lookup: Record<string, number> = {};
  const sourceLookup: Record<string, { source: string; count: number }[]> = {};
  for (const c of cells) {
    lookup[`${c.hour}-${c.dow}`]       = c.value;
    sourceLookup[`${c.hour}-${c.dow}`] = c.bySource;
  }

  const totalConversions = cells.reduce((s, c) => s + c.value, 0);
  const selectedSources = selectedCell
    ? (sourceLookup[`${selectedCell.h}-${selectedCell.dow}`] ?? [])
    : [];
  const selectedVal = selectedCell
    ? (lookup[`${selectedCell.h}-${selectedCell.dow}`] ?? 0)
    : 0;
```

- [ ] **Step 3: Add the click handler and selected-cell border to each grid cell**

Replace:

```typescript
                return (
                  <div
                    key={dow}
                    onMouseEnter={() => setTooltip({ h, dow, val })}
                    onMouseLeave={() => setTooltip(null)}
                    style={{
                      height: 24,
                      borderRadius: 4,
                      background: val > 0
                        ? `rgba(254,128,63,${alpha.toFixed(2)})`
                        : "rgba(255,255,255,0.04)",
                      border: `1px solid ${isHot ? "rgba(254,128,63,0.6)" : "rgba(255,255,255,0.06)"}`,
                      display: "flex", alignItems: "center", justifyContent: "center",
                      cursor: val > 0 ? "default" : "default",
                      transition: "border-color 0.1s",
                      position: "relative",
                    }}
                  >
```

with:

```typescript
                const isSelected = selectedCell?.h === h && selectedCell?.dow === dow;
                return (
                  <div
                    key={dow}
                    onMouseEnter={() => setTooltip({ h, dow, val })}
                    onMouseLeave={() => setTooltip(null)}
                    onClick={() => {
                      if (val === 0) return;
                      setSelectedCell(prev => (prev?.h === h && prev?.dow === dow) ? null : { h, dow });
                    }}
                    style={{
                      height: 24,
                      borderRadius: 4,
                      background: val > 0
                        ? `rgba(254,128,63,${alpha.toFixed(2)})`
                        : "rgba(255,255,255,0.04)",
                      border: isSelected
                        ? `2px solid ${C.orange}`
                        : `1px solid ${isHot ? "rgba(254,128,63,0.6)" : "rgba(255,255,255,0.06)"}`,
                      display: "flex", alignItems: "center", justifyContent: "center",
                      cursor: val > 0 ? "pointer" : "default",
                      transition: "border-color 0.1s",
                      position: "relative",
                    }}
                  >
```

- [ ] **Step 4: Render the breakdown panel below the tooltip**

Replace:

```typescript
          {/* Tooltip flotante */}
          {tooltip && (
            <div style={{
              marginTop: 12, padding: "6px 12px",
              background: "rgba(254,128,63,0.12)",
              border: "1px solid rgba(254,128,63,0.3)",
              borderRadius: 8, fontSize: 12, color: C.white,
              display: "inline-flex", alignItems: "center", gap: 6,
            }}>
              <span style={{ color: C.orange, fontWeight: 700 }}>{DAYS[tooltip.dow]} {tooltip.h}h</span>
              <span style={{ color: C.mutedLight }}>→</span>
              <span style={{ fontWeight: 600 }}>{tooltip.val} conversión{tooltip.val !== 1 ? "es" : ""}</span>
            </div>
          )}
```

with:

```typescript
          {/* Tooltip flotante */}
          {tooltip && (
            <div style={{
              marginTop: 12, padding: "6px 12px",
              background: "rgba(254,128,63,0.12)",
              border: "1px solid rgba(254,128,63,0.3)",
              borderRadius: 8, fontSize: 12, color: C.white,
              display: "inline-flex", alignItems: "center", gap: 6,
            }}>
              <span style={{ color: C.orange, fontWeight: 700 }}>{DAYS[tooltip.dow]} {tooltip.h}h</span>
              <span style={{ color: C.mutedLight }}>→</span>
              <span style={{ fontWeight: 600 }}>{tooltip.val} conversión{tooltip.val !== 1 ? "es" : ""}</span>
            </div>
          )}

          {/* Panel de desglose por fuente (clic en celda) */}
          {selectedCell && (
            <div style={{
              marginTop: 12, padding: "12px 16px",
              background: "rgba(255,255,255,0.03)",
              border: `1px solid ${C.border}`,
              borderRadius: 8, fontSize: 12,
            }}>
              <div style={{ display: "flex", alignItems: "center", gap: 6, marginBottom: 8 }}>
                <span style={{ color: C.orange, fontWeight: 700 }}>
                  {DAYS[selectedCell.dow]} {selectedCell.h}h
                </span>
                <span style={{ color: C.mutedLight }}>→</span>
                <span style={{ color: C.white, fontWeight: 600 }}>
                  {selectedVal} conversión{selectedVal !== 1 ? "es" : ""}
                </span>
              </div>
              <div style={{ display: "flex", flexDirection: "column", gap: 4 }}>
                {selectedSources.map(({ source, count }) => (
                  <div key={source} style={{ display: "flex", justifyContent: "space-between", gap: 12 }}>
                    <span style={{ color: C.mutedLight, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                      {source}
                    </span>
                    <span style={{ color: C.white, fontWeight: 600, flexShrink: 0 }}>{count}</span>
                  </div>
                ))}
              </div>
            </div>
          )}
```

- [ ] **Step 5: Type-check**

Run: `npm run build`
Expected: PASS with no TypeScript errors (this resolves any expected failure from Task 1 Step 3).

- [ ] **Step 6: Commit**

```bash
git add src/components/analytics/HourlyHeatmap.tsx
git commit -m "feat(analytics): show traffic source breakdown on heatmap cell click"
```

---

### Task 3: Manual browser verification

**Files:** None (verification only).

- [ ] **Step 1: Start the dev server (skip if already running)**

Run: `npm run dev`
Expected: Vite starts without errors, prints a local URL (e.g. `http://localhost:5173`).

- [ ] **Step 2: Click a populated cell in the heatmap**

Navigate to Analytics. Scroll to "Conversiones por Hora y Día". Click a cell showing a number (e.g. the largest one).

Expected: A panel appears below the grid showing "`<Día> <Hora>h → N conversiones`" followed by a list of sources and counts that sum to N. The clicked cell gets a visibly distinct border (2px orange) while selected.

- [ ] **Step 3: Click the same cell again**

Expected: The panel disappears and the cell's border returns to normal.

- [ ] **Step 4: Click an empty cell (no number shown)**

Expected: Nothing happens — no panel appears, no border change.

- [ ] **Step 5: Verify hover still works independently**

Hover over any populated cell without clicking.

Expected: The existing hover tooltip ("`<Día> <Hora>h → N conversiones`") still appears exactly as before, regardless of whether a cell is currently selected via click.

- [ ] **Step 6: Final build check**

Run: `npm run build`
Expected: PASS, confirming the whole change set compiles cleanly end-to-end.
