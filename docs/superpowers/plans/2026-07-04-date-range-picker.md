# Date Range Picker Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the fixed 5-pill period selector (Noche/Día/Hoy/Ayer/7 días) in Analytics with a single dropdown button offering 6 presets (Hoy, Ayer, 7 días, Mes, 3 Meses, Total) plus a custom date-range picker using native `<input type="date">` fields.

**Architecture:** `PeriodKey` and `buildRange` in `src/services/analytics.ts` gain 2 new rolling-window presets (`mes` = 30 days, `3meses` = 90 days) and one all-time preset (`total`), and drop the `noche`/`dia` cases. A new self-contained `DateRangePicker` component renders the button + dropdown panel and calls the existing `setPeriod(key, custom?)` callback from `useAnalyticsData` — no changes to the hook's data-fetching logic, only to the type it accepts and one label map inside it.

**Tech Stack:** React 19 + TypeScript (Vite SPA). No new dependencies — native `<input type="date">`, no calendar library. No test framework in this repo — verify with `npm run build` (tsc type-check) plus manual browser check per this project's CLAUDE.md instruction to test UI changes in-browser before claiming completion.

## Global Constraints

- No new npm dependencies (no calendar/date-picker library) — use native `<input type="date">`.
- No DB migrations, no Supabase Edge Function changes — 100% `src/` frontend.
- No test framework exists in this repo — verify via `npm run build` and manual browser checks only.
- All Spanish-language UI copy stays in Spanish.
- Reuse existing color tokens from `src/tokens.ts` (`C.orange`, `C.white`, `C.mutedLight`, `C.mutedMid`, `C.border`, `C.panel`, `C.bgSecondary`, `C.nav`) — do not hardcode new hex colors.
- `"noche"` and `"dia"` are removed entirely, not kept alongside the new presets (per approved design).
- Custom range: if the user enters "Desde" later than "Hasta", swap them before applying — never send an inverted range to `onSelect`.

---

### Task 1: Update `PeriodKey` and `buildRange` in `analytics.ts`, and the AI-analysis label map in `useAnalyticsData.ts`

**Files:**
- Modify: `src/services/analytics.ts:6` (the `PeriodKey` type)
- Modify: `src/services/analytics.ts:10-31` (the `buildRange` function)
- Modify: `src/hooks/useAnalyticsData.ts:81-83` (the `labels` record inside `runAIAnalysis`)

**Interfaces:**
- Produces: `PeriodKey = "hoy" | "ayer" | "7dias" | "mes" | "3meses" | "total" | "custom"` and a `buildRange` that handles all 7 keys — consumed by Task 2 (`DateRangePicker`) and Task 3 (`AnalyticsView`).

- [ ] **Step 1: Update the `PeriodKey` type**

Replace:

```typescript
export type PeriodKey = "noche" | "dia" | "hoy" | "ayer" | "7dias" | "custom";
```

with:

```typescript
export type PeriodKey = "hoy" | "ayer" | "7dias" | "mes" | "3meses" | "total" | "custom";
```

- [ ] **Step 2: Update `buildRange`**

Replace the entire function:

```typescript
export function buildRange(key: PeriodKey, custom?: { from: string; to: string }): DateRange {
  const now    = new Date();
  const colMs  = now.getTime() - 5 * 60 * 60 * 1000; // UTC → Colombia (UTC-5), sin depender del timezone del browser
  const col    = new Date(colMs);
  const pad    = (n: number) => String(n).padStart(2, "0");
  const ymd    = (d: Date) => `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`;

  const today     = ymd(col);
  const yesterday = ymd(new Date(col.getTime() - 86400000));

  if (key === "custom" && custom) {
    return { from: custom.from, to: custom.to, fromTs: `${custom.from}T00:00:00`, toTs: `${custom.to}T23:59:59` };
  }
  if (key === "noche")  return { from: yesterday, to: today,     fromTs: `${yesterday}T22:00:00`, toTs: `${today}T08:00:00` };
  if (key === "dia")    return { from: today,     to: today,     fromTs: `${today}T08:00:00`,     toTs: `${today}T22:00:00` };
  if (key === "ayer")   return { from: yesterday, to: yesterday, fromTs: `${yesterday}T00:00:00`, toTs: `${yesterday}T23:59:59` };
  if (key === "7dias") {
    const from7 = ymd(new Date(col.getTime() - 6 * 86400000));
    return { from: from7, to: today, fromTs: `${from7}T00:00:00`, toTs: `${today}T23:59:59` };
  }
  return { from: today, to: today, fromTs: `${today}T00:00:00`, toTs: `${today}T23:59:59` };
}
```

with:

```typescript
export function buildRange(key: PeriodKey, custom?: { from: string; to: string }): DateRange {
  const now    = new Date();
  const colMs  = now.getTime() - 5 * 60 * 60 * 1000; // UTC → Colombia (UTC-5), sin depender del timezone del browser
  const col    = new Date(colMs);
  const pad    = (n: number) => String(n).padStart(2, "0");
  const ymd    = (d: Date) => `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`;

  const today     = ymd(col);
  const yesterday = ymd(new Date(col.getTime() - 86400000));

  if (key === "custom" && custom) {
    return { from: custom.from, to: custom.to, fromTs: `${custom.from}T00:00:00`, toTs: `${custom.to}T23:59:59` };
  }
  if (key === "ayer")   return { from: yesterday, to: yesterday, fromTs: `${yesterday}T00:00:00`, toTs: `${yesterday}T23:59:59` };
  if (key === "7dias") {
    const from7 = ymd(new Date(col.getTime() - 6 * 86400000));
    return { from: from7, to: today, fromTs: `${from7}T00:00:00`, toTs: `${today}T23:59:59` };
  }
  if (key === "mes") {
    const from30 = ymd(new Date(col.getTime() - 29 * 86400000));
    return { from: from30, to: today, fromTs: `${from30}T00:00:00`, toTs: `${today}T23:59:59` };
  }
  if (key === "3meses") {
    const from90 = ymd(new Date(col.getTime() - 89 * 86400000));
    return { from: from90, to: today, fromTs: `${from90}T00:00:00`, toTs: `${today}T23:59:59` };
  }
  if (key === "total") {
    return { from: "2020-01-01", to: today, fromTs: "2020-01-01T00:00:00", toTs: `${today}T23:59:59` };
  }
  // default: "hoy"
  return { from: today, to: today, fromTs: `${today}T00:00:00`, toTs: `${today}T23:59:59` };
}
```

- [ ] **Step 3: Update the AI-analysis label map in `useAnalyticsData.ts`**

Replace:

```typescript
      const labels: Record<PeriodKey, string> = {
        noche: "Noche", dia: "Día", hoy: "Hoy", ayer: "Ayer", "7dias": "Últimos 7 días", custom: "Rango personalizado",
      };
```

with:

```typescript
      const labels: Record<PeriodKey, string> = {
        hoy: "Hoy", ayer: "Ayer", "7dias": "Últimos 7 días", mes: "Último mes", "3meses": "Últimos 3 meses", total: "Total", custom: "Rango personalizado",
      };
```

- [ ] **Step 4: Type-check**

Run: `npm run build`
Expected: This will currently FAIL with a TypeScript error in `src/views/AnalyticsView.tsx`, because it still references the removed `"noche"`/`"dia"` keys and the old `PERIOD_LABELS` record (which is now missing the new keys and has stale ones). That's expected — Task 3 fixes `AnalyticsView.tsx`. Confirm the *only* errors are in `AnalyticsView.tsx` about `PeriodKey`/`PERIOD_LABELS` mismatches. If there are errors anywhere else (e.g. inside `analytics.ts` or `useAnalyticsData.ts` itself), stop and investigate — those must be clean.

- [ ] **Step 5: Commit**

```bash
git add src/services/analytics.ts src/hooks/useAnalyticsData.ts
git commit -m "feat(analytics): replace noche/dia periods with mes/3meses/total presets"
```

---

### Task 2: Create the `DateRangePicker` component

**Files:**
- Create: `src/components/analytics/DateRangePicker.tsx`

**Interfaces:**
- Consumes: `PeriodKey`, `DateRange` types from `../../services/analytics` (Task 1).
- Produces: `export function DateRangePicker({ period, range, onSelect }: Props)` where `Props = { period: PeriodKey; range: DateRange | null; onSelect: (key: PeriodKey, custom?: { from: string; to: string }) => void }` — consumed by Task 3 (`AnalyticsView.tsx`).

- [ ] **Step 1: Write the component**

Create `src/components/analytics/DateRangePicker.tsx` with this exact content:

```typescript
import { useState, useEffect } from "react";
import { C, FONT } from "../../tokens";
import type { PeriodKey, DateRange } from "../../services/analytics";

interface Props {
  period:   PeriodKey;
  range:    DateRange | null;
  onSelect: (key: PeriodKey, custom?: { from: string; to: string }) => void;
}

type PresetKey = Exclude<PeriodKey, "custom">;

const PRESETS: { key: PresetKey; label: string }[] = [
  { key: "hoy",    label: "Hoy" },
  { key: "ayer",   label: "Ayer" },
  { key: "7dias",  label: "Últimos 7 días" },
  { key: "mes",    label: "Último mes" },
  { key: "3meses", label: "Últimos 3 meses" },
  { key: "total",  label: "Total" },
];

const PRESET_LABEL: Record<PresetKey, string> = {
  hoy: "Hoy", ayer: "Ayer", "7dias": "Últimos 7 días",
  mes: "Último mes", "3meses": "Últimos 3 meses", total: "Total",
};

function formatShort(dateStr: string): string {
  const parts = dateStr.split("-");
  return `${parts[2]}/${parts[1]}`;
}

export function DateRangePicker({ period, range, onSelect }: Props) {
  const [open,       setOpen]       = useState(false);
  const [customFrom, setCustomFrom] = useState("");
  const [customTo,   setCustomTo]   = useState("");

  useEffect(() => {
    if (open && period === "custom" && range) {
      setCustomFrom(range.from);
      setCustomTo(range.to);
    }
  }, [open, period, range]);

  const buttonLabel = period === "custom" && range
    ? `${formatShort(range.from)} - ${formatShort(range.to)}`
    : PRESET_LABEL[period as PresetKey] ?? "Hoy";

  const handlePreset = (key: PresetKey) => {
    onSelect(key);
    setOpen(false);
  };

  const handleApply = () => {
    if (!customFrom || !customTo) return;
    const from = customFrom <= customTo ? customFrom : customTo;
    const to   = customFrom <= customTo ? customTo   : customFrom;
    onSelect("custom", { from, to });
    setOpen(false);
  };

  const dateInputStyle: React.CSSProperties = {
    background: C.bgSecondary, border: `1px solid ${C.border}`, borderRadius: 6,
    padding: "6px 8px", color: C.white, fontSize: 12, fontFamily: FONT, width: "100%",
  };

  return (
    <div style={{ position: "relative" }}>
      <button
        onClick={() => setOpen(o => !o)}
        style={{
          background: "transparent", border: `1px solid ${C.border}`,
          borderRadius: 20, padding: "4px 14px", fontSize: 12,
          color: C.white, cursor: "pointer", fontFamily: FONT,
          display: "flex", alignItems: "center", gap: 6,
        }}
      >
        {buttonLabel} <span style={{ color: C.mutedMid, fontSize: 10 }}>▾</span>
      </button>

      {open && (
        <>
          <div style={{ position: "fixed", inset: 0, zIndex: 90 }} onClick={() => setOpen(false)} />
          <div style={{
            position: "absolute", top: "calc(100% + 6px)", right: 0, zIndex: 100,
            background: C.panel, border: `1px solid ${C.border}`, borderRadius: 12,
            padding: 14, width: 220, boxShadow: "0 8px 24px rgba(0,0,0,0.4)",
          }}>
            <div style={{ display: "flex", flexDirection: "column", gap: 4 }}>
              {PRESETS.map(p => (
                <button
                  key={p.key}
                  onClick={() => handlePreset(p.key)}
                  style={{
                    background: period === p.key ? "rgba(254,128,63,0.12)" : "transparent",
                    border: "none", borderRadius: 8, padding: "8px 10px",
                    fontSize: 12, textAlign: "left", cursor: "pointer", fontFamily: FONT,
                    color: period === p.key ? C.orange : C.mutedLight,
                  }}
                >
                  {p.label}
                </button>
              ))}
            </div>

            <div style={{ borderTop: `1px solid ${C.border}`, marginTop: 10, paddingTop: 10 }}>
              <div style={{ fontSize: 11, color: C.mutedMid, marginBottom: 8 }}>Rango personalizado</div>
              <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
                <div>
                  <div style={{ fontSize: 10, color: C.mutedMid, marginBottom: 4 }}>Desde</div>
                  <input type="date" value={customFrom} onChange={e => setCustomFrom(e.target.value)} style={dateInputStyle} />
                </div>
                <div>
                  <div style={{ fontSize: 10, color: C.mutedMid, marginBottom: 4 }}>Hasta</div>
                  <input type="date" value={customTo} onChange={e => setCustomTo(e.target.value)} style={dateInputStyle} />
                </div>
                <button
                  onClick={handleApply}
                  disabled={!customFrom || !customTo}
                  style={{
                    background: C.orange, border: "none", borderRadius: 8, padding: "8px 0",
                    color: C.white, fontSize: 12, fontWeight: 600, cursor: "pointer", fontFamily: FONT,
                    opacity: !customFrom || !customTo ? 0.5 : 1,
                  }}
                >
                  Aplicar
                </button>
              </div>
            </div>
          </div>
        </>
      )}
    </div>
  );
}
```

- [ ] **Step 2: Type-check**

Run: `npm run build`
Expected: This file compiles on its own (it's not imported anywhere yet), so no new errors should appear beyond the ones already expected from Task 1 (which remain until Task 3). Confirm there are no errors specifically inside `DateRangePicker.tsx`.

- [ ] **Step 3: Commit**

```bash
git add src/components/analytics/DateRangePicker.tsx
git commit -m "feat(analytics): add DateRangePicker component with presets and custom range"
```

---

### Task 3: Wire `DateRangePicker` into `AnalyticsView.tsx`

**Files:**
- Modify: `src/views/AnalyticsView.tsx`

**Interfaces:**
- Consumes: `DateRangePicker` component (Task 2), `PeriodKey`/`buildRange` changes (Task 1).

- [ ] **Step 1: Add the import and remove the now-obsolete `PERIOD_LABELS`**

Replace:

```typescript
import { AIAnalyst }                  from "../components/analytics/AIAnalyst";
import type { AppView }               from "../types";
import type { PeriodKey, AnalyticsSummary } from "../services/analytics";

interface Props {
  onDashboard:    () => void;
  onUsers:        () => void;
  onTransactions: () => void;
  onSettings:     () => void;
  onSignOut:      () => void;
  activeView:     AppView;
  isAdmin:        boolean;
}

const PERIOD_LABELS: Record<PeriodKey, string> = {
  noche:  "Noche",
  dia:    "Día",
  hoy:    "Hoy",
  ayer:   "Ayer",
  "7dias": "7 días",
  custom: "Custom",
};
```

with:

```typescript
import { AIAnalyst }                  from "../components/analytics/AIAnalyst";
import { DateRangePicker }            from "../components/analytics/DateRangePicker";
import type { AppView }               from "../types";
import type { AnalyticsSummary } from "../services/analytics";

interface Props {
  onDashboard:    () => void;
  onUsers:        () => void;
  onTransactions: () => void;
  onSettings:     () => void;
  onSignOut:      () => void;
  activeView:     AppView;
  isAdmin:        boolean;
}
```

(`PeriodKey` is no longer referenced directly in this file — `DateRangePicker` owns the type usage. `AnalyticsSummary` import stays as-is.)

- [ ] **Step 2: Replace the pill row with `DateRangePicker`**

Replace:

```tsx
            <div style={{ display: "flex", gap: 8, alignItems: "center" }}>
              {(["noche", "dia", "hoy", "ayer", "7dias"] as PeriodKey[]).map(key => (
                <button key={key} onClick={() => setPeriod(key)} style={{
                  background: period === key ? C.orange : "transparent",
                  border: `1px solid ${period === key ? C.orange : C.border}`,
                  borderRadius: 20, padding: "4px 14px", fontSize: 12,
                  fontWeight: period === key ? 600 : 400,
                  color: period === key ? C.white : C.mutedLight, cursor: "pointer",
                }}>
                  {PERIOD_LABELS[key]}
                </button>
              ))}
              <button onClick={refresh} style={{
                background: "transparent", border: `1px solid ${C.border}`,
                borderRadius: 20, padding: "4px 12px", fontSize: 12, color: C.mutedMid, cursor: "pointer",
              }}>↺</button>
            </div>
```

with:

```tsx
            <div style={{ display: "flex", gap: 8, alignItems: "center" }}>
              <DateRangePicker period={period} range={range} onSelect={setPeriod} />
              <button onClick={refresh} style={{
                background: "transparent", border: `1px solid ${C.border}`,
                borderRadius: 20, padding: "4px 12px", fontSize: 12, color: C.mutedMid, cursor: "pointer",
              }}>↺</button>
            </div>
```

- [ ] **Step 3: Type-check**

Run: `npm run build`
Expected: PASS with no TypeScript errors (this resolves the expected failures from Task 1 Step 4).

- [ ] **Step 4: Commit**

```bash
git add src/views/AnalyticsView.tsx
git commit -m "feat(analytics): wire DateRangePicker into AnalyticsView top bar"
```

---

### Task 4: Manual browser verification

**Files:** None (verification only).

- [ ] **Step 1: Start the dev server (skip if already running)**

Run: `npm run dev`
Expected: Vite starts without errors, prints a local URL (e.g. `http://localhost:5173`).

- [ ] **Step 2: Open the date range dropdown**

Navigate to Analytics. Click the date-range button in the top bar (shows "Hoy" by default).

Expected: A panel opens below the button showing 6 preset options (Hoy, Ayer, Últimos 7 días, Último mes, Últimos 3 meses, Total) followed by a "Rango personalizado" section with Desde/Hasta date inputs and an "Aplicar" button.

- [ ] **Step 3: Select each preset**

Click "Último mes", then reopen and click "Últimos 3 meses", then "Total".

Expected: Each click closes the panel, the button label updates to match (e.g. "Último mes"), and the page's KPIs/funnel/heatmap refresh for that range without a full page reload. "Total" should show noticeably more historical data than "Hoy" if any exists.

- [ ] **Step 4: Apply a custom range**

Open the panel, set "Desde" to a date and "Hasta" to a later date, click "Aplicar".

Expected: Panel closes, button label shows the range as `DD/MM - DD/MM`, and the data refreshes for that window.

- [ ] **Step 5: Apply an inverted custom range**

Open the panel, set "Desde" to a date LATER than "Hasta" (e.g. Desde = today, Hasta = a week ago), click "Aplicar".

Expected: No crash — the range is silently corrected (swapped) before being applied; the button label shows the corrected (chronological) order.

- [ ] **Step 6: Click outside to close**

Open the panel, then click anywhere outside it (not on a preset or the button).

Expected: The panel closes without changing the selected period.

- [ ] **Step 7: Final build check**

Run: `npm run build`
Expected: PASS, confirming the whole change set compiles cleanly end-to-end.
