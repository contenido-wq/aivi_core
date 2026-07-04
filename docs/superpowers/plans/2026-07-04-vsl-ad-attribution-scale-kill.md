# VSL Ad Attribution + Scale/Kill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fuse ad attribution (which campaign/anuncio drove traffic) and the ESCALAR/PAUSAR/MONITOREAR verdict into `VSLIntelligencePanel`'s "Fuente de tráfico" tab, replacing the separate `ScaleRadar`/`AdsRankingTable` portfolio-wide components.

**Architecture:** Pure frontend change, no DB/Edge Function work. `AdRankRow[]` (investment/CAC/ROAS/score/videoId per campaign) is already fetched once in `useAnalyticsData` and stored as `ranking` in `AnalyticsView`. We pass `ranking` + the existing `cacTarget`/`ticketMin` thresholds down into `VSLIntelligencePanel` as new props; the panel filters `ranking` by `primary.videoId` client-side and renders a new `AdSourceView` table instead of the old conversions-only `SourceView`. The duplicated `classify`/`classifyRow` logic is extracted once into `src/services/analytics.ts` as `classifyAd`. `ScaleRadar.tsx` and `AdsRankingTable.tsx` are deleted once nothing references them.

**Tech Stack:** React 19 + TypeScript (Vite SPA), Recharts, Supabase JS client. No test framework is present in this repo (`package.json` has no `test` script, no jest/vitest config) — verification is via `npm run build` (runs `tsc -b`, catches type errors) plus manual browser verification with `npm run dev`, per this project's CLAUDE.md instruction to test UI changes in-browser before claiming completion.

## Global Constraints

- No DB migrations, no Supabase Edge Function changes — this is 100% `src/` frontend.
- No test framework exists in this repo — do not introduce one. Verify with `npm run build` (type-check) and manual browser checks only.
- All Spanish-language UI copy stays in Spanish (existing project convention, see `CLAUDE.md`: "Idioma: Español neutro latinoamericano en toda la UI").
- Reuse existing color tokens from `src/tokens.ts` (`C.green`, `C.red`, `C.yellow`, `C.orange`, `C.mutedMid`, `C.mutedLight`, `C.border`, `C.bgSecondary`, `C.white`) — do not hardcode new hex colors.
- Do not change the CAC/ROAS/ticket classification thresholds (`sales >= 1 && cac <= cacTarget && roas >= 2.0` for ESCALAR, `cac > cacTarget * 1.5 || roas < 1.0` for PAUSAR) — only relocate the logic, do not alter it.

---

### Task 1: Extract `classifyAd` and remove dead `getVSLBySource` in `analytics.ts`

**Files:**
- Modify: `src/services/analytics.ts:103` (insert after `AdRankRow` interface)
- Modify: `src/services/analytics.ts:608-641` (delete `getVSLBySource`)

**Interfaces:**
- Produces: `export type AdAction = "ESCALAR" | "PAUSAR" | "MONITOREAR"` and `export function classifyAd(r: AdRankRow, cacTarget: number, ticketMin: number): AdAction` — consumed by Task 2.
- Removes: `getVSLBySource(r: DateRange, videoId: string): Promise<DimensionRow[]>` — confirmed its only other reference is `src/components/analytics/VSLIntelligencePanel.tsx` (removed in Task 2), no other consumers (verified via `grep -rn "getVSLBySource" src/`).

- [ ] **Step 1: Insert `AdAction` type and `classifyAd` function right after the `AdRankRow` interface**

Open `src/services/analytics.ts`, find the `AdRankRow` interface (ends at line 103 with a closing `}`):

```typescript
export interface AdRankRow {
  campaignName: string;
  investment:   number;
  clicks:       number;
  impressions:  number;
  cpm:          number;
  cpc:          number;
  plays:        number;
  playRate:     number;
  sales:        number;
  cac:          number;
  roas:         number;
  videoId:      string | null;
  videoName:    string | null;
  score:        number;
}
```

Immediately after it, insert:

```typescript

export type AdAction = "ESCALAR" | "PAUSAR" | "MONITOREAR";

export function classifyAd(r: AdRankRow, cacTarget: number, ticketMin: number): AdAction {
  const avgTicket = r.sales > 0 && r.investment > 0 ? (r.investment * r.roas) / r.sales : 0;
  const ticketOk  = ticketMin === 0 || avgTicket >= ticketMin;
  if (r.sales >= 1 && r.cac > 0 && r.cac <= cacTarget && r.roas >= 2.0 && ticketOk) return "ESCALAR";
  if ((r.cac > 0 && r.cac > cacTarget * 1.5) || (r.roas < 1.0 && r.investment > 0)) return "PAUSAR";
  return "MONITOREAR";
}
```

- [ ] **Step 2: Verify no other file references `getVSLBySource` before deleting it**

Run: `grep -rn "getVSLBySource" src/`
Expected output: two matches, both in `src/components/analytics/VSLIntelligencePanel.tsx` (one import, one call site) — no matches in any other file. If any other file references it, stop and re-scope this task before proceeding (Task 2 assumes it's safe to delete).

- [ ] **Step 3: Delete the `getVSLBySource` function**

In `src/services/analytics.ts`, delete the entire function (it is the last thing in the file, lines 608-641):

```typescript
export async function getVSLBySource(r: DateRange, videoId: string): Promise<DimensionRow[]> {
  const [mappingRes, txRes] = await Promise.all([
    supabase
      .from("campaign_vsl_mapping")
      .select("campaign_name")
      .eq("video_id", videoId),
    supabase
      .from("transactions")
      .select("traffic_source")
      .gte("created_at", r.fromTs)
      .lte("created_at", r.toTs)
      .eq("status", "active"),
  ]);

  const mapped = new Set((mappingRes.data ?? []).map((m: any) => m.campaign_name as string));

  const convMap: Record<string, number> = {};
  for (const tx of (txRes.data ?? [])) {
    const src = (tx.traffic_source ?? "Sin UTM") as string;
    if (mapped.has(src)) convMap[src] = (convMap[src] ?? 0) + 1;
  }

  const totalConv = Object.values(convMap).reduce((s, n) => s + n, 0) || 1;

  return Object.entries(convMap)
    .map(([label, conversions]) => ({
      label,
      plays: 0,
      views: 0,
      pct:   Math.round((conversions / totalConv) * 1000) / 10,
      conversions,
    }))
    .sort((a, b) => b.conversions - a.conversions);
}
```

Leave the file ending cleanly after the previous function (`getVSLByBrowser`) with a single trailing newline — no dangling blank sections.

- [ ] **Step 4: Type-check**

Run: `npm run build`
Expected: This will currently FAIL with a TypeScript error in `VSLIntelligencePanel.tsx` (`getVSLBySource` no longer exported) — that's expected at this point in the plan. Confirm the *only* new errors are about `getVSLBySource` being missing from `VSLIntelligencePanel.tsx` (Task 2 fixes this). If there are unrelated errors, stop and investigate before continuing.

- [ ] **Step 5: Commit**

```bash
git add src/services/analytics.ts
git commit -m "refactor(analytics): extract classifyAd, remove dead getVSLBySource"
```

---

### Task 2: Replace `SourceView` with `AdSourceView` in `VSLIntelligencePanel.tsx`

**Files:**
- Modify: `src/components/analytics/VSLIntelligencePanel.tsx`

**Interfaces:**
- Consumes: `AdRankRow`, `AdAction`, `classifyAd(r: AdRankRow, cacTarget: number, ticketMin: number): AdAction` from `../../services/analytics` (Task 1).
- Produces: `VSLIntelligencePanel` now requires 3 new props — `ranking: AdRankRow[]`, `cacTarget: number`, `ticketMin: number` — consumed by Task 3 (`AnalyticsView.tsx`).

- [ ] **Step 1: Update imports**

Replace (around line 1 and lines 8-12):

```typescript
import { useState, useEffect, useCallback } from "react";
```
```typescript
import type { VSLData, DateRange, DimensionRow } from "../../services/analytics";
import {
  getVSLByCountry, getVSLByDevice, getVSLByOS,
  getVSLByBrowser, getVSLBySource,
} from "../../services/analytics";
```

with:

```typescript
import { useState, useEffect, useCallback, useMemo } from "react";
```
```typescript
import type { VSLData, DateRange, DimensionRow, AdRankRow, AdAction } from "../../services/analytics";
import {
  getVSLByCountry, getVSLByDevice, getVSLByOS,
  getVSLByBrowser, classifyAd,
} from "../../services/analytics";
```

- [ ] **Step 2: Replace the `SourceView` function with `AdSourceView`**

Find and delete this entire function (currently lines 175-195, right before the "Tabs config" section):

```typescript
// Vista: Fuente de tráfico (conversiones por campaña/UTM)
function SourceView({ rows }: { rows: DimensionRow[] }) {
  if (rows.length === 0) return (
    <DimEmpty msg="Sin ventas atribuidas a este VSL en el período" />
  );
  return (
    <div style={{ padding: "8px 20px 12px", display: "flex", flexDirection: "column", gap: 7 }}>
      {rows.map(r => (
        <div key={r.label} style={{ display: "flex", alignItems: "center", gap: 10 }}>
          <div style={{ fontSize: 12, color: C.mutedLight, width: 160, flexShrink: 0, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{r.label}</div>
          <div style={{ flex: 1, height: 5, background: "rgba(255,255,255,0.07)", borderRadius: 3, overflow: "hidden" }}>
            <div style={{ height: "100%", width: `${r.pct}%`, background: "#22c55e", borderRadius: 3, transition: "width 0.4s ease" }} />
          </div>
          <div style={{ fontSize: 11, color: "#22c55e", width: 64, textAlign: "right", flexShrink: 0 }}>
            {r.conversions} {r.conversions === 1 ? "venta" : "ventas"}
          </div>
        </div>
      ))}
    </div>
  );
}
```

Replace it with:

```typescript
// Vista: Fuente de tráfico (anuncios que trajeron tráfico a este VSL + veredicto)
const AD_ACTION_STYLE: Record<AdAction, { color: string; bg: string; border: string }> = {
  ESCALAR:    { color: C.green,  bg: "rgba(48,209,88,0.12)",  border: "rgba(48,209,88,0.3)"  },
  PAUSAR:     { color: C.red,    bg: "rgba(255,65,59,0.12)",  border: "rgba(255,65,59,0.3)"  },
  MONITOREAR: { color: C.yellow, bg: "rgba(255,194,82,0.12)", border: "rgba(255,194,82,0.3)" },
};

function adCacColor(cac: number, target: number) {
  if (cac === 0 || target === 0) return C.mutedMid;
  if (cac <= target)       return C.green;
  if (cac <= target * 1.5) return C.yellow;
  return C.red;
}

function adScoreColor(s: number) {
  return s >= 80 ? C.green : s >= 50 ? C.yellow : C.red;
}

function AdSourceView({ rows, cacTarget, ticketMin }: { rows: AdRankRow[]; cacTarget: number; ticketMin: number }) {
  if (rows.length === 0) return (
    <DimEmpty msg="Sin anuncios atribuidos a este VSL en el período. Verifica el mapeo campaña→VSL arriba." />
  );
  return (
    <div style={{ padding: "8px 16px 12px", overflowX: "auto" }}>
      <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 12 }}>
        <thead>
          <tr style={{ borderBottom: `1px solid ${C.border}` }}>
            {["Campaña", "Inv.", "Ventas", "CAC", "ROAS", "Score", "Acción"].map(h => (
              <th key={h} style={{ padding: "6px 8px", color: C.mutedMid, fontWeight: 500, textAlign: "left", whiteSpace: "nowrap" }}>
                {h}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((r, i) => {
            const action  = classifyAd(r, cacTarget, ticketMin);
            const acStyle = AD_ACTION_STYLE[action];
            return (
              <tr key={`${r.campaignName}-${i}`} style={{ borderBottom: `1px solid ${C.border}` }}>
                <td style={{ padding: "9px 8px", color: C.white, fontWeight: 500, maxWidth: 160, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                  {r.campaignName}
                </td>
                <td style={{ padding: "9px 8px", color: C.mutedLight }}>${r.investment.toFixed(0)}</td>
                <td style={{ padding: "9px 8px", color: C.mutedLight }}>{r.sales}</td>
                <td style={{ padding: "9px 8px", color: adCacColor(r.cac, cacTarget), fontWeight: 700 }}>
                  {r.cac > 0 ? `$${r.cac.toFixed(0)}` : "—"}
                </td>
                <td style={{ padding: "9px 8px", color: r.roas >= 2 ? C.green : r.roas >= 1 ? C.yellow : C.red, fontWeight: 600 }}>
                  {r.roas > 0 ? `${r.roas.toFixed(2)}x` : "—"}
                </td>
                <td style={{ padding: "9px 8px" }}>
                  <span style={{ background: `${adScoreColor(r.score)}20`, color: adScoreColor(r.score), borderRadius: 12, padding: "2px 8px", fontSize: 11, fontWeight: 700 }}>
                    {r.score}
                  </span>
                </td>
                <td style={{ padding: "9px 8px" }}>
                  <span style={{ background: acStyle.bg, border: `1px solid ${acStyle.border}`, color: acStyle.color, borderRadius: 12, padding: "2px 10px", fontSize: 10, fontWeight: 700, whiteSpace: "nowrap" }}>
                    {action}
                  </span>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
```

- [ ] **Step 3: Update the `Props` interface and component signature**

Replace:

```typescript
interface Props {
  primary:  VSLData | null;
  compare?: VSLData | null;
  range:    DateRange | null;
}
```
```typescript
export function VSLIntelligencePanel({ primary, compare, range }: Props) {
```

with:

```typescript
interface Props {
  primary:   VSLData | null;
  compare?:  VSLData | null;
  range:     DateRange | null;
  ranking:   AdRankRow[];
  cacTarget: number;
  ticketMin: number;
}
```
```typescript
export function VSLIntelligencePanel({ primary, compare, range, ranking, cacTarget, ticketMin }: Props) {
```

- [ ] **Step 4: Add the `adsForThisVsl` memo**

Right after the existing state hooks (after the `showConversions` `useState` line, before the `useEffect` that resets `dimCache`), add:

```typescript
const adsForThisVsl = useMemo(
  () => ranking.filter(r => r.videoId === primary?.videoId),
  [ranking, primary?.videoId],
);
```

- [ ] **Step 5: Stop fetching "source" as an async dimension tab**

Replace the `fetchTab` callback:

```typescript
const fetchTab = useCallback(async (tab: DimensionTab) => {
    if (!primary || !range || tab === "general" || dimCache[tab] !== undefined) return;
    setDimLoading(true);
    try {
      const fetchers: Record<Exclude<DimensionTab, "general">, () => Promise<DimensionRow[]>> = {
        country: () => getVSLByCountry(range, primary.videoId),
        device:  () => getVSLByDevice(range, primary.videoId),
        os:      () => getVSLByOS(range, primary.videoId),
        browser: () => getVSLByBrowser(range, primary.videoId),
        source:  () => getVSLBySource(range, primary.videoId),
      };
      const data = await fetchers[tab as Exclude<DimensionTab, "general">]();
      setDimCache(prev => ({ ...prev, [tab]: data }));
    } catch (e) {
      console.error(`fetchTab ${tab}:`, e);
      setDimCache(prev => ({ ...prev, [tab]: [] }));
    } finally {
      setDimLoading(false);
    }
  }, [primary, range, dimCache]);
```

with:

```typescript
const fetchTab = useCallback(async (tab: DimensionTab) => {
    if (!primary || !range || tab === "general" || tab === "source" || dimCache[tab] !== undefined) return;
    setDimLoading(true);
    try {
      const fetchers: Record<Exclude<DimensionTab, "general" | "source">, () => Promise<DimensionRow[]>> = {
        country: () => getVSLByCountry(range, primary.videoId),
        device:  () => getVSLByDevice(range, primary.videoId),
        os:      () => getVSLByOS(range, primary.videoId),
        browser: () => getVSLByBrowser(range, primary.videoId),
      };
      const data = await fetchers[tab as Exclude<DimensionTab, "general" | "source">]();
      setDimCache(prev => ({ ...prev, [tab]: data }));
    } catch (e) {
      console.error(`fetchTab ${tab}:`, e);
      setDimCache(prev => ({ ...prev, [tab]: [] }));
    } finally {
      setDimLoading(false);
    }
  }, [primary, range, dimCache]);
```

- [ ] **Step 6: Render `AdSourceView` for the "source" tab**

Replace:

```typescript
{activeTab !== "general" && dimLoading && <DimSkeleton />}
{activeTab === "country" && !dimLoading && <CountryView rows={dimCache.country ?? []} showConversions={showConversions} />}
{activeTab === "device"  && !dimLoading && <DeviceView  rows={dimCache.device  ?? []} />}
{activeTab === "os"      && !dimLoading && <HBarView    rows={dimCache.os      ?? []} label="S. Operativo" />}
{activeTab === "browser" && !dimLoading && <HBarView    rows={dimCache.browser ?? []} label="Navegadores"  />}
{activeTab === "source"  && !dimLoading && <SourceView  rows={dimCache.source  ?? []} />}
```

with:

```typescript
{activeTab !== "general" && activeTab !== "source" && dimLoading && <DimSkeleton />}
{activeTab === "country" && !dimLoading && <CountryView rows={dimCache.country ?? []} showConversions={showConversions} />}
{activeTab === "device"  && !dimLoading && <DeviceView  rows={dimCache.device  ?? []} />}
{activeTab === "os"      && !dimLoading && <HBarView    rows={dimCache.os      ?? []} label="S. Operativo" />}
{activeTab === "browser" && !dimLoading && <HBarView    rows={dimCache.browser ?? []} label="Navegadores"  />}
{activeTab === "source"  && <AdSourceView rows={adsForThisVsl} cacTarget={cacTarget} ticketMin={ticketMin} />}
```

- [ ] **Step 7: Type-check**

Run: `npm run build`
Expected: PASS with no TypeScript errors (this resolves the expected failure from Task 1 Step 4).

- [ ] **Step 8: Commit**

```bash
git add src/components/analytics/VSLIntelligencePanel.tsx
git commit -m "feat(analytics): show ad attribution + escalar/pausar verdict in VSL source tab"
```

---

### Task 3: Wire new props into `AnalyticsView.tsx`, remove `ScaleRadar`/`AdsRankingTable`, relocate controls

**Files:**
- Modify: `src/views/AnalyticsView.tsx`

**Interfaces:**
- Consumes: `VSLIntelligencePanel` now requires `ranking: AdRankRow[]`, `cacTarget: number`, `ticketMin: number` (Task 2). `ranking` is already available as `const { ..., ranking, ... } = useAnalyticsData()` (line 40, unchanged).
- `cacTarget`/`setCacTarget`, `ticketMin`/`setTicketMin`, `mappingOpen`/`setMappingOpen` state already exists (lines 45-47) — reused, not recreated.

- [ ] **Step 1: Remove the now-unused imports**

Delete these two lines (around lines 10-11):

```typescript
import { ScaleRadar }                 from "../components/analytics/ScaleRadar";
import { AdsRankingTable }            from "../components/analytics/AdsRankingTable";
```

- [ ] **Step 2: Remove the `filteredRanking` memo**

Delete (around lines 56-59):

```typescript
const filteredRanking = useMemo(
    () => selectedVslId ? ranking.filter(r => r.videoId === selectedVslId) : ranking,
    [ranking, selectedVslId],
  );
```

- [ ] **Step 3: Move CAC/Ticket/Configurar VSLs controls into the top bar**

Replace the top bar block:

```tsx
<div style={{
          display: "flex", alignItems: "center", justifyContent: "space-between",
          padding: "0 24px", height: 56, borderBottom: `1px solid ${C.border}`,
          background: C.nav, flexShrink: 0,
        }}>
          <div style={{ fontSize: 15, fontWeight: 700, color: C.white }}>Analytics Command Center</div>
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
        </div>
```

with:

```tsx
<div style={{
          display: "flex", alignItems: "center", justifyContent: "space-between",
          padding: "10px 24px", minHeight: 56, borderBottom: `1px solid ${C.border}`,
          background: C.nav, flexShrink: 0, flexWrap: "wrap", gap: 12,
        }}>
          <div style={{ fontSize: 15, fontWeight: 700, color: C.white }}>Analytics Command Center</div>
          <div style={{ display: "flex", gap: 16, alignItems: "center", flexWrap: "wrap" }}>
            <div style={{ display: "flex", gap: 12, alignItems: "center" }}>
              <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
                <span style={{ fontSize: 11, color: C.mutedMid }}>CAC objetivo $</span>
                <input
                  type="number" value={cacTarget}
                  onChange={e => setCacTarget(Number(e.target.value))}
                  style={{
                    width: 64, background: C.bgSecondary,
                    border: `1px solid ${C.border}`, borderRadius: 6,
                    padding: "4px 8px", color: C.white, fontSize: 12,
                    fontFamily: "inherit",
                  }}
                />
              </div>
              <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
                <span style={{ fontSize: 11, color: C.mutedMid }}>Ticket mín. $</span>
                <input
                  type="number" value={ticketMin}
                  onChange={e => setTicketMin(Number(e.target.value))}
                  style={{
                    width: 64, background: C.bgSecondary,
                    border: `1px solid ${C.border}`, borderRadius: 6,
                    padding: "4px 8px", color: C.white, fontSize: 12,
                    fontFamily: "inherit",
                  }}
                />
              </div>
              <button
                onClick={() => setMappingOpen(true)}
                style={{
                  background: `rgba(254,128,63,0.12)`, border: `1px solid rgba(254,128,63,0.30)`,
                  color: C.orange, borderRadius: 8, padding: "4px 12px", fontSize: 12, cursor: "pointer",
                }}
              >
                Configurar VSLs
              </button>
            </div>
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
          </div>
        </div>
```

- [ ] **Step 4: Pass new props to `VSLIntelligencePanel` and remove `ScaleRadar`/`AdsRankingTable`**

Replace:

```tsx
<VSLIntelligencePanel primary={selectedVsl} compare={compareVsl} range={range} />

          <ScaleRadar campaigns={filteredRanking} cacTarget={cacTarget} ticketMin={ticketMin} />
```

with:

```tsx
<VSLIntelligencePanel
            primary={selectedVsl}
            compare={compareVsl}
            range={range}
            ranking={ranking}
            cacTarget={cacTarget}
            ticketMin={ticketMin}
          />
```

- [ ] **Step 5: Remove the `AdsRankingTable` render**

Delete:

```tsx
<AdsRankingTable
            rows={filteredRanking}
            cacTarget={cacTarget}
            ticketMin={ticketMin}
            onCacTargetChange={setCacTarget}
            onTicketMinChange={setTicketMin}
            onOpenMapping={() => setMappingOpen(true)}
          />
```

- [ ] **Step 6: Type-check**

Run: `npm run build`
Expected: PASS with no TypeScript errors.

- [ ] **Step 7: Commit**

```bash
git add src/views/AnalyticsView.tsx
git commit -m "feat(analytics): move CAC/ticket/mapping controls to top bar, wire ranking into VSL panel"
```

---

### Task 4: Delete `ScaleRadar.tsx` and `AdsRankingTable.tsx`

**Files:**
- Delete: `src/components/analytics/ScaleRadar.tsx`
- Delete: `src/components/analytics/AdsRankingTable.tsx`

**Interfaces:** None — these files have no remaining consumers after Task 3.

- [ ] **Step 1: Confirm nothing still imports these components**

Run: `grep -rn "ScaleRadar\|AdsRankingTable" src/`
Expected: no matches anywhere (Task 3 already removed the only import/render sites).

- [ ] **Step 2: Delete the files**

```bash
git rm src/components/analytics/ScaleRadar.tsx src/components/analytics/AdsRankingTable.tsx
```

- [ ] **Step 3: Type-check**

Run: `npm run build`
Expected: PASS with no TypeScript errors.

- [ ] **Step 4: Commit**

```bash
git commit -m "chore(analytics): remove ScaleRadar/AdsRankingTable, superseded by VSL panel source tab"
```

---

### Task 5: Manual browser verification

**Files:** None (verification only).

- [ ] **Step 1: Start the dev server**

Run: `npm run dev`
Expected: Vite starts without errors, prints a local URL (e.g. `http://localhost:5173`).

- [ ] **Step 2: Open Analytics and select a VSL that has mapped campaigns with sales**

Navigate to the Analytics view in the browser. In `VSLSelectorBar`, click a VSL known to have campaign mappings and sales in the current period. Open the "Fuente de tráfico" tab in `VSLIntelligencePanel`.

Expected: A table appears with columns Campaña / Inv. / Ventas / CAC / ROAS / Score / Acción, one row per campaign mapped to this VSL, each with a colored ESCALAR/PAUSAR/MONITOREAR badge — no loading skeleton flashes (data is already in memory).

- [ ] **Step 3: Verify data parity against the values the deleted `AdsRankingTable` used to show**

Before this change, `AdsRankingTable` (portfolio-wide) had a "VSL" column showing which video each row belonged to. Cross-check: for the VSL selected in Step 2, the rows and dollar/percentage values in the new "Fuente de tráfico" tab should match what the old table showed for that same `videoName`, for the same date range (compare against a screenshot or your memory of the old table if available — main thing is CAC/ROAS/investment/sales numbers per campaign are unchanged, only the surface moved).

- [ ] **Step 4: Verify the CAC/Ticket controls in the top bar affect the verdict live**

In the top bar, change "CAC objetivo $" to a much lower number (e.g. 1). Expected: badges in the "Fuente de tráfico" tab update to more PAUSAR/MONITOREAR without a page reload. Set it back to its original value.

- [ ] **Step 5: Verify the empty state**

Select a VSL with no campaigns mapped to it (or temporarily pick one with zero sales in the period). Open "Fuente de tráfico".

Expected: message "Sin anuncios atribuidos a este VSL en el período. Verifica el mapeo campaña→VSL arriba." — no crash, no empty table.

- [ ] **Step 6: Verify "Configurar VSLs" still opens the mapping modal**

Click "Configurar VSLs" in the top bar. Expected: `CampaignMappingModal` opens exactly as before (this button was only relocated, not changed).

- [ ] **Step 7: Verify no VSL selected shows the existing placeholder, not a portfolio view**

Deselect the VSL (if `VSLSelectorBar` supports clearing selection) or reload without a selection.

Expected: `VSLIntelligencePanel` shows its existing "Selecciona un VSL..." placeholder. There is no longer any section on the page showing all campaigns from all VSLs at once (previously `ScaleRadar`/`AdsRankingTable` showed this when no VSL was selected — this is the intended, approved removal, not a regression).

- [ ] **Step 8: Final build check**

Run: `npm run build`
Expected: PASS, confirming the whole change set compiles cleanly end-to-end.
