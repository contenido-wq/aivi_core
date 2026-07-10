# VSL Command Center — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convertir la vista de Analytics en un centro de decisión por VSL que muestra la salud del video (Vturb) y el rendimiento de cada anuncio conectado (UTMify + Hotmart) para decidir qué escalar y qué pausar con datos.

**Architecture:** Se agrega una `VSLSelectorBar` como filtro global en `AnalyticsView`; el VSL seleccionado filtra `funnel[]` y `ranking[]` vía `useMemo`; tres componentes nuevos (`VSLSelectorBar`, `VSLIntelligencePanel`, `ScaleRadar`) encapsulan la lógica visual; `VSLComparator` queda absorbido por `VSLIntelligencePanel`.

**Tech Stack:** React 18, TypeScript, Recharts (ya instalado), tokens de diseño de `src/tokens.ts`

## Global Constraints

- Dark mode obligatorio — todos los colores desde `C` (tokens.ts), nunca hardcoded
- Fuente: `'Hanken Grotesk', sans-serif` (`FONT` de tokens.ts)
- Mínimo `fontSize: 10` — nunca por debajo
- Español neutro latinoamericano en toda la UI
- Sin comentarios en el código excepto cuando el WHY es no obvio
- No agregar dependencias nuevas — Recharts ya está disponible
- TypeScript estricto — verificar con `npm run build` después de cada task

---

## File Map

| Acción | Archivo |
|---|---|
| Modificar | `src/services/analytics.ts` — agregar `videoId` a `AdRankRow` |
| Modificar | `src/hooks/useAnalyticsData.ts` — agregar estado de selección VSL |
| **Crear** | `src/components/analytics/VSLSelectorBar.tsx` |
| **Crear** | `src/components/analytics/VSLIntelligencePanel.tsx` |
| **Crear** | `src/components/analytics/ScaleRadar.tsx` |
| Modificar | `src/components/analytics/AdsRankingTable.tsx` — agregar `ticketMin` + columna Acción |
| Modificar | `src/views/AnalyticsView.tsx` — integrar todo, filtros useMemo, reemplazar VSLComparator |

---

## Task 1: Agregar `videoId` a `AdRankRow`

**Files:**
- Modify: `src/services/analytics.ts`

**Interfaces:**
- Produces: `AdRankRow.videoId: string | null` — usado en Task 7 para filtrar ranking por VSL

- [ ] **Step 1: Agregar `videoId` a la interfaz `AdRankRow`**

En `src/services/analytics.ts`, localizar la interfaz `AdRankRow` (línea ~87) y agregar el campo:

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
  videoId:      string | null;   // ← NUEVO
  videoName:    string | null;
  score:        number;
}
```

- [ ] **Step 2: Propagar `videoId` en `getAdsRanking()`**

Localizar la función `getAdsRanking` (línea ~279) y agregar `videoId: f.videoId` en el map:

```typescript
export async function getAdsRanking(r: DateRange): Promise<AdRankRow[]> {
  const funnel = await getFunnelByCampaign(r);
  return funnel.map(f => ({
    campaignName: f.campaignName,
    investment:   f.investment,
    clicks:       f.clicks,
    impressions:  f.impressions,
    cpm:          f.impressions > 0 ? (f.investment / f.impressions) * 1000 : 0,
    cpc:          f.clicks > 0 ? f.investment / f.clicks : 0,
    plays:        f.plays,
    playRate:     f.clicks > 0 ? (f.plays / f.clicks) * 100 : 0,
    sales:        f.sales,
    cac:          f.cac,
    roas:         f.roas,
    videoId:      f.videoId,    // ← NUEVO
    videoName:    f.videoName,
    score:        f.score,
  }));
}
```

- [ ] **Step 3: Verificar que compila**

```bash
npm run build
```
Esperado: `✓ built in X.XXs` sin errores TypeScript.

- [ ] **Step 4: Commit**

```bash
git add src/services/analytics.ts
git commit -m "feat(analytics): add videoId to AdRankRow for VSL filtering"
```

---

## Task 2: Agregar estado de selección VSL a `useAnalyticsData`

**Files:**
- Modify: `src/hooks/useAnalyticsData.ts`

**Interfaces:**
- Produces: `selectedVslId: string | null`, `compareVslId: string | null`, `setSelectedVsl(id)`, `setCompareVsl(id)` — consumidos por Task 7

- [ ] **Step 1: Agregar estados al hook**

En `src/hooks/useAnalyticsData.ts`, agregar tres `useState` después de `const [aiLoading, ...]`:

```typescript
const [selectedVslId, setSelectedVslId] = useState<string | null>(null);
const [compareVslId,  setCompareVslId]  = useState<string | null>(null);
```

- [ ] **Step 2: Auto-seleccionar el primer VSL al cargar datos**

Dentro del bloque `try` de la función `load`, justo después del `setState(...)`, agregar:

```typescript
setSelectedVslId(prev => prev ?? (vsls[0]?.videoId ?? null));
```

El `??` garantiza que si el usuario ya eligió un VSL manualmente, no se sobrescribe al refrescar.

- [ ] **Step 3: Exponer los nuevos valores en el return**

Reemplazar el `return` al final del hook:

```typescript
return {
  ...state,
  period, setPeriod, refresh: load,
  aiResult, aiLoading, runAIAnalysis,
  selectedVslId, compareVslId,
  setSelectedVsl: setSelectedVslId,
  setCompareVsl:  setCompareVslId,
};
```

- [ ] **Step 4: Verificar que compila**

```bash
npm run build
```
Esperado: sin errores.

- [ ] **Step 5: Commit**

```bash
git add src/hooks/useAnalyticsData.ts
git commit -m "feat(analytics): add VSL selection state to useAnalyticsData"
```

---

## Task 3: Crear `VSLSelectorBar`

**Files:**
- Create: `src/components/analytics/VSLSelectorBar.tsx`

**Interfaces:**
- Consumes: `VSLData[]` de `../../services/analytics`, tokens `C` de `../../tokens`
- Produces: `<VSLSelectorBar vsls comparator selectedId compareId onSelect onCompare />` — montado en Task 7

- [ ] **Step 1: Crear el componente**

Crear `src/components/analytics/VSLSelectorBar.tsx` con el siguiente contenido completo:

```typescript
import { C } from "../../tokens";
import type { VSLData } from "../../services/analytics";

interface VSLSelectorBarProps {
  vsls:       VSLData[];
  selectedId: string | null;
  compareId:  string | null;
  onSelect:   (id: string) => void;
  onCompare:  (id: string | null) => void;
}

export function VSLSelectorBar({ vsls, selectedId, compareId, onSelect, onCompare }: VSLSelectorBarProps) {
  const canCompare = vsls.length >= 2;

  return (
    <div style={{
      display: "flex", alignItems: "center", gap: 8,
      padding: "0 24px", height: 44,
      background: C.bgSecondary,
      borderBottom: `1px solid ${C.border}`,
      flexShrink: 0, overflowX: "auto",
    }}>
      <span style={{
        fontSize: 10, fontWeight: 700, color: C.muted,
        textTransform: "uppercase", letterSpacing: "0.08em", flexShrink: 0,
      }}>VSL</span>

      <div style={{ display: "flex", gap: 4, alignItems: "center" }}>
        {vsls.map(v => {
          const isSelected = v.videoId === selectedId;
          const isCompare  = v.videoId === compareId;
          return (
            <button
              key={v.videoId}
              onClick={() => onSelect(v.videoId)}
              style={{
                padding: "4px 14px", borderRadius: 20,
                fontSize: 12, fontWeight: isSelected ? 700 : 400,
                border: `1px solid ${isSelected ? C.orange : isCompare ? C.yellow : C.border}`,
                background: isSelected ? `rgba(254,128,63,0.18)` : isCompare ? `rgba(255,194,82,0.12)` : "transparent",
                color: isSelected ? C.orange : isCompare ? C.yellow : C.mutedLight,
                cursor: "pointer", whiteSpace: "nowrap", transition: "all 0.15s",
              }}
            >
              {v.videoName}
            </button>
          );
        })}
      </div>

      {canCompare && (
        <>
          <div style={{ width: 1, height: 20, background: C.border, flexShrink: 0 }} />
          {compareId ? (
            <button
              onClick={() => onCompare(null)}
              style={{
                padding: "4px 12px", borderRadius: 20, fontSize: 11, fontWeight: 600,
                border: `1px solid ${C.border}`, background: "transparent",
                color: C.mutedMid, cursor: "pointer", whiteSpace: "nowrap",
              }}
            >
              × Comparación
            </button>
          ) : (
            <div style={{ display: "flex", gap: 4, alignItems: "center" }}>
              <span style={{ fontSize: 11, color: C.muted, whiteSpace: "nowrap" }}>
                + Comparar con:
              </span>
              {vsls
                .filter(v => v.videoId !== selectedId)
                .map(v => (
                  <button
                    key={v.videoId}
                    onClick={() => onCompare(v.videoId)}
                    style={{
                      padding: "4px 12px", borderRadius: 20, fontSize: 11,
                      border: `1px solid ${C.border}`, background: "transparent",
                      color: C.mutedMid, cursor: "pointer", whiteSpace: "nowrap",
                      transition: "all 0.15s",
                    }}
                  >
                    {v.videoName}
                  </button>
                ))}
            </div>
          )}
        </>
      )}
    </div>
  );
}
```

- [ ] **Step 2: Verificar que compila**

```bash
npm run build
```
Esperado: sin errores.

- [ ] **Step 3: Commit**

```bash
git add src/components/analytics/VSLSelectorBar.tsx
git commit -m "feat(analytics): add VSLSelectorBar component"
```

---

## Task 4: Crear `VSLIntelligencePanel`

**Files:**
- Create: `src/components/analytics/VSLIntelligencePanel.tsx`

**Interfaces:**
- Consumes: `VSLData` de `../../services/analytics`, Recharts (ya instalado), `C`, `FONT` de `../../tokens`
- Produces: `<VSLIntelligencePanel primary={VSLData|null} compare={VSLData|null} />` — montado en Task 7

- [ ] **Step 1: Crear el componente**

Crear `src/components/analytics/VSLIntelligencePanel.tsx`:

```typescript
import {
  LineChart, Line, XAxis, YAxis, Tooltip,
  ReferenceDot, ResponsiveContainer,
} from "recharts";
import { C, FONT } from "../../tokens";
import type { VSLData } from "../../services/analytics";

type Level = "high" | "mid" | "low";

function scoreLevel(value: number, hi: number, mid: number): Level {
  if (value >= hi)  return "high";
  if (value >= mid) return "mid";
  return "low";
}

const LEVEL_COLOR: Record<Level, string> = { high: C.green, mid: C.yellow, low: C.red };
const LEVEL_DOTS:  Record<Level, string> = { high: "●●●", mid: "●●○", low: "●○○" };

function fmtSec(s: number) {
  return `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`;
}

function MetricRow({ label, value, color }: { label: string; value: string; color?: string }) {
  return (
    <div style={{
      display: "flex", justifyContent: "space-between", alignItems: "center",
      padding: "5px 0", borderBottom: `1px solid ${C.border}`,
    }}>
      <span style={{ fontSize: 11, color: C.muted }}>{label}</span>
      <span style={{ fontSize: 12, fontWeight: 700, color: color ?? C.white }}>{value}</span>
    </div>
  );
}

function VerdictRow({ label, level }: { label: string; level: Level }) {
  return (
    <div style={{
      display: "flex", justifyContent: "space-between", alignItems: "center",
      padding: "6px 0", borderBottom: `1px solid ${C.border}`,
    }}>
      <span style={{ fontSize: 11, color: C.mutedLight }}>{label}</span>
      <span style={{ fontSize: 13, color: LEVEL_COLOR[level], letterSpacing: 1, fontWeight: 700 }}>
        {LEVEL_DOTS[level]}
      </span>
    </div>
  );
}

function buildChartData(primary: VSLData, compare?: VSLData | null) {
  const maxSec = Math.max(
    primary.retention.at(-1)?.second ?? 0,
    compare?.retention.at(-1)?.second ?? 0,
  );
  const data: Record<string, number | null>[] = [];
  for (let s = 0; s <= maxSec; s += 5) {
    const pt: Record<string, number | null> = { s };
    pt["primary"] = primary.retention.find(p => p.second >= s)?.percentage ?? null;
    if (compare) {
      pt["compare"] = compare.retention.find(p => p.second >= s)?.percentage ?? null;
    }
    data.push(pt);
  }
  return data;
}

interface Props {
  primary:  VSLData | null;
  compare?: VSLData | null;
}

export function VSLIntelligencePanel({ primary, compare }: Props) {
  if (!primary) return null;

  const chartData  = buildChartData(primary, compare);
  const dropPt     = primary.dropSecond != null
    ? primary.retention.find(p => p.second >= primary.dropSecond!)
    : null;
  const ctaRate    = primary.plays > 0 ? (primary.ctaClicks / primary.plays) * 100 : 0;
  const hookLevel  = scoreLevel(primary.ret25,  60, 40);
  const retLevel   = scoreLevel(primary.ret50,  40, 25);
  const ctaLevel   = scoreLevel(ctaRate,         8,  4);

  return (
    <div style={{
      background: C.card, border: `1px solid ${C.border}`,
      borderRadius: 14, padding: 20,
      display: "grid",
      gridTemplateColumns: "1fr 220px 180px",
      gap: 24,
    }}>
      {/* Columna 1 — Curva de retención */}
      <div>
        <div style={{ fontSize: 13, fontWeight: 600, color: C.white, marginBottom: 4 }}>
          Retención — {primary.videoName}
        </div>
        {primary.dropSecond != null && (
          <div style={{ fontSize: 11, color: C.red, marginBottom: 10 }}>
            Audiencia abandona en {fmtSec(primary.dropSecond)}
          </div>
        )}
        <ResponsiveContainer width="100%" height={200}>
          <LineChart data={chartData}>
            <XAxis
              dataKey="s"
              tick={{ fontSize: 10, fill: C.mutedMid, fontFamily: FONT }}
              tickFormatter={fmtSec}
              tickLine={false} axisLine={false}
            />
            <YAxis
              domain={[0, 100]}
              tick={{ fontSize: 10, fill: C.mutedMid, fontFamily: FONT }}
              tickFormatter={v => `${v}%`}
              tickLine={false} axisLine={false}
            />
            <Tooltip
              contentStyle={{
                background: C.card, border: `1px solid ${C.border}`,
                borderRadius: 8, fontSize: 11,
              }}
              labelFormatter={s => `Minuto ${fmtSec(Number(s))}`}
              formatter={(v: number) => [`${Number(v).toFixed(1)}%`, ""]}
            />
            <Line
              type="monotone" dataKey="primary" name={primary.videoName}
              stroke={C.orange} strokeWidth={2} dot={false} connectNulls
            />
            {compare && (
              <Line
                type="monotone" dataKey="compare" name={compare.videoName}
                stroke={C.yellow} strokeWidth={2} dot={false}
                connectNulls strokeDasharray="6 3"
              />
            )}
            {dropPt && (
              <ReferenceDot
                x={primary.dropSecond!} y={dropPt.percentage}
                r={5} fill={C.red} stroke="none"
              />
            )}
          </LineChart>
        </ResponsiveContainer>
        {compare && (
          <div style={{ display: "flex", gap: 16, marginTop: 8 }}>
            <span style={{ fontSize: 11, color: C.mutedLight, display: "flex", alignItems: "center", gap: 5 }}>
              <span style={{ width: 18, height: 2, background: C.orange, display: "inline-block", borderRadius: 1 }} />
              {primary.videoName}
            </span>
            <span style={{ fontSize: 11, color: C.mutedLight, display: "flex", alignItems: "center", gap: 5 }}>
              <span style={{ width: 18, height: 0, borderTop: `2px dashed ${C.yellow}`, display: "inline-block" }} />
              {compare.videoName}
            </span>
          </div>
        )}
      </div>

      {/* Columna 2 — Métricas del video */}
      <div>
        <div style={{
          fontSize: 10, fontWeight: 700, color: C.mutedLight,
          textTransform: "uppercase", letterSpacing: "0.07em", marginBottom: 10,
        }}>
          Métricas del video
        </div>
        <MetricRow label="Plays" value={primary.plays.toLocaleString("es")} />
        <MetricRow
          label="Retención 25%"
          value={`${primary.ret25.toFixed(0)}%`}
          color={primary.ret25 >= 60 ? C.green : primary.ret25 >= 40 ? C.yellow : C.red}
        />
        <MetricRow
          label="Retención 50%"
          value={`${primary.ret50.toFixed(0)}%`}
          color={primary.ret50 >= 40 ? C.green : primary.ret50 >= 25 ? C.yellow : C.red}
        />
        <MetricRow
          label="Retención 75%"
          value={`${primary.ret75.toFixed(0)}%`}
          color={primary.ret75 >= 20 ? C.green : primary.ret75 >= 10 ? C.yellow : C.red}
        />
        <MetricRow label="CTA Clicks" value={primary.ctaClicks.toLocaleString("es")} />
        <MetricRow
          label="CTA Click Rate"
          value={`${ctaRate.toFixed(1)}%`}
          color={ctaRate >= 8 ? C.green : ctaRate >= 4 ? C.yellow : C.red}
        />
        <MetricRow
          label="Conv. Rate"
          value={`${primary.convRate.toFixed(1)}%`}
          color={primary.convRate >= 3 ? C.green : primary.convRate >= 1 ? C.yellow : C.red}
        />
        {compare && (
          <>
            <div style={{ height: 1, background: `${C.yellow}40`, margin: "8px 0" }} />
            <div style={{ fontSize: 11, color: C.yellow, fontWeight: 700, marginBottom: 6 }}>
              {compare.videoName}
            </div>
            <MetricRow label="Plays" value={compare.plays.toLocaleString("es")} />
            <MetricRow
              label="Retención 25%"
              value={`${compare.ret25.toFixed(0)}%`}
              color={compare.ret25 >= 60 ? C.green : compare.ret25 >= 40 ? C.yellow : C.red}
            />
            <MetricRow
              label="Retención 50%"
              value={`${compare.ret50.toFixed(0)}%`}
              color={compare.ret50 >= 40 ? C.green : compare.ret50 >= 25 ? C.yellow : C.red}
            />
            <MetricRow
              label="CTA Click Rate"
              value={`${(compare.plays > 0 ? (compare.ctaClicks / compare.plays) * 100 : 0).toFixed(1)}%`}
              color={(compare.plays > 0 ? (compare.ctaClicks / compare.plays) * 100 : 0) >= 8 ? C.green
                   : (compare.plays > 0 ? (compare.ctaClicks / compare.plays) * 100 : 0) >= 4 ? C.yellow : C.red}
            />
          </>
        )}
      </div>

      {/* Columna 3 — Veredicto */}
      <div>
        <div style={{
          fontSize: 10, fontWeight: 700, color: C.mutedLight,
          textTransform: "uppercase", letterSpacing: "0.07em", marginBottom: 10,
        }}>
          Veredicto
        </div>
        <VerdictRow label="Hook (ret. 25%)"     level={hookLevel} />
        <VerdictRow label="Retención media 50%" level={retLevel}  />
        <VerdictRow label="Cierre (CTA rate)"   level={ctaLevel}  />
        <div style={{
          marginTop: 12, padding: "10px 12px", borderRadius: 8,
          background: "rgba(255,255,255,0.03)", border: `1px solid ${C.border}`,
        }}>
          <div style={{ fontSize: 10, color: C.muted, marginBottom: 4 }}>Drop más pronunciado</div>
          <div style={{ fontSize: 14, fontWeight: 700, color: C.red }}>
            {primary.dropSecond != null ? fmtSec(primary.dropSecond) : "—"}
          </div>
          {primary.dropSecond != null && (
            <div style={{ fontSize: 10, color: C.mutedMid, marginTop: 2 }}>
              Revisar el guión en ese punto
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Verificar que compila**

```bash
npm run build
```
Esperado: sin errores.

- [ ] **Step 3: Commit**

```bash
git add src/components/analytics/VSLIntelligencePanel.tsx
git commit -m "feat(analytics): add VSLIntelligencePanel with retention curve and verdict"
```

---

## Task 5: Crear `ScaleRadar`

**Files:**
- Create: `src/components/analytics/ScaleRadar.tsx`

**Interfaces:**
- Consumes: `AdRankRow[]` de `../../services/analytics` (que ya incluye `videoId` desde Task 1)
- Produces: `<ScaleRadar campaigns cacTarget ticketMin />` — montado en Task 7

- [ ] **Step 1: Crear el componente**

Crear `src/components/analytics/ScaleRadar.tsx`:

```typescript
import { C } from "../../tokens";
import type { AdRankRow } from "../../services/analytics";

type Action = "ESCALAR" | "PAUSAR" | "MONITOREAR";

function classify(r: AdRankRow, cacTarget: number, ticketMin: number): Action {
  const avgTicket = r.sales > 0 && r.investment > 0 ? (r.investment * r.roas) / r.sales : 0;
  const ticketOk  = ticketMin === 0 || avgTicket >= ticketMin;
  if (r.sales >= 1 && r.cac > 0 && r.cac <= cacTarget && r.roas >= 2.0 && ticketOk) return "ESCALAR";
  if ((r.cac > 0 && r.cac > cacTarget * 1.5) || (r.roas < 1.0 && r.investment > 0)) return "PAUSAR";
  return "MONITOREAR";
}

const STYLES: Record<Action, { color: string; bg: string; border: string; icon: string }> = {
  ESCALAR:    { color: C.green,  bg: "rgba(48,209,88,0.10)",  border: "rgba(48,209,88,0.25)",  icon: "🟢" },
  MONITOREAR: { color: C.yellow, bg: "rgba(255,194,82,0.10)", border: "rgba(255,194,82,0.25)", icon: "🟡" },
  PAUSAR:     { color: C.red,    bg: "rgba(255,65,59,0.10)",  border: "rgba(255,65,59,0.25)",  icon: "🔴" },
};

interface Props {
  campaigns: AdRankRow[];
  cacTarget: number;
  ticketMin: number;
}

export function ScaleRadar({ campaigns, cacTarget, ticketMin }: Props) {
  if (campaigns.length === 0) return null;

  const byAction: Record<Action, AdRankRow[]> = { ESCALAR: [], PAUSAR: [], MONITOREAR: [] };
  for (const c of campaigns) byAction[classify(c, cacTarget, ticketMin)].push(c);

  return (
    <div style={{
      background: C.card, border: `1px solid ${C.border}`,
      borderRadius: 14, padding: 20,
    }}>
      <div style={{ fontSize: 13, fontWeight: 600, color: C.white, marginBottom: 16 }}>
        Radar de Decisión
      </div>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 12 }}>
        {(["ESCALAR", "MONITOREAR", "PAUSAR"] as Action[]).map(action => {
          const rows  = byAction[action];
          const style = STYLES[action];
          return (
            <div
              key={action}
              style={{
                background: style.bg, border: `1px solid ${style.border}`,
                borderRadius: 10, padding: "14px 16px",
              }}
            >
              <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 8 }}>
                <span style={{ fontSize: 16, lineHeight: 1 }}>{style.icon}</span>
                <div>
                  <div style={{ fontSize: 10, fontWeight: 700, color: style.color, letterSpacing: "0.06em" }}>
                    {action}
                  </div>
                  <div style={{ fontSize: 22, fontWeight: 900, color: style.color, lineHeight: 1.1 }}>
                    {rows.length}
                  </div>
                </div>
              </div>
              <div style={{ display: "flex", flexDirection: "column", gap: 3 }}>
                {rows.map(c => (
                  <div key={c.campaignName} style={{
                    fontSize: 10, color: style.color, opacity: 0.85,
                    overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
                  }}>
                    {c.campaignName}
                  </div>
                ))}
                {rows.length === 0 && (
                  <div style={{ fontSize: 10, color: C.muted }}>—</div>
                )}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Verificar que compila**

```bash
npm run build
```
Esperado: sin errores.

- [ ] **Step 3: Commit**

```bash
git add src/components/analytics/ScaleRadar.tsx
git commit -m "feat(analytics): add ScaleRadar with ESCALAR/PAUSAR/MONITOREAR classification"
```

---

## Task 6: Modificar `AdsRankingTable` — agregar `ticketMin` y columna Acción

**Files:**
- Modify: `src/components/analytics/AdsRankingTable.tsx`

**Interfaces:**
- Consumes: `AdRankRow` ahora con `videoId: string | null` (Task 1), `ticketMin` del estado de AnalyticsView (Task 7)
- Produces: misma interfaz visual + columna Acción nueva + input para ticketMin

- [ ] **Step 1: Reemplazar el contenido completo del archivo**

Sobreescribir `src/components/analytics/AdsRankingTable.tsx`:

```typescript
import { C } from "../../tokens";
import type { AdRankRow } from "../../services/analytics";

type Action = "ESCALAR" | "PAUSAR" | "MONITOREAR";

function rowBg(cac: number, target: number) {
  if (cac === 0 || target === 0) return "transparent";
  if (cac <= target)       return "rgba(48,209,88,0.04)";
  if (cac <= target * 1.5) return "rgba(255,194,82,0.04)";
  return "rgba(255,65,59,0.04)";
}

function cacColor(cac: number, target: number) {
  if (cac === 0 || target === 0) return C.mutedMid;
  if (cac <= target)       return C.green;
  if (cac <= target * 1.5) return C.yellow;
  return C.red;
}

function scoreColor(s: number) {
  return s >= 80 ? C.green : s >= 50 ? C.yellow : C.red;
}

function classifyRow(r: AdRankRow, cacTarget: number, ticketMin: number): Action {
  const avgTicket = r.sales > 0 && r.investment > 0 ? (r.investment * r.roas) / r.sales : 0;
  const ticketOk  = ticketMin === 0 || avgTicket >= ticketMin;
  if (r.sales >= 1 && r.cac > 0 && r.cac <= cacTarget && r.roas >= 2.0 && ticketOk) return "ESCALAR";
  if ((r.cac > 0 && r.cac > cacTarget * 1.5) || (r.roas < 1.0 && r.investment > 0)) return "PAUSAR";
  return "MONITOREAR";
}

const ACTION_STYLE: Record<Action, { color: string; bg: string; border: string }> = {
  ESCALAR:    { color: C.green,  bg: "rgba(48,209,88,0.12)",  border: "rgba(48,209,88,0.3)"  },
  PAUSAR:     { color: C.red,    bg: "rgba(255,65,59,0.12)",  border: "rgba(255,65,59,0.3)"  },
  MONITOREAR: { color: C.yellow, bg: "rgba(255,194,82,0.12)", border: "rgba(255,194,82,0.3)" },
};

interface Props {
  rows:              AdRankRow[];
  cacTarget:         number;
  ticketMin:         number;
  onCacTargetChange: (n: number) => void;
  onTicketMinChange: (n: number) => void;
  onOpenMapping:     () => void;
}

export function AdsRankingTable({ rows, cacTarget, ticketMin, onCacTargetChange, onTicketMinChange, onOpenMapping }: Props) {
  const inputStyle: React.CSSProperties = {
    width: 64, background: C.bgSecondary,
    border: `1px solid ${C.border}`, borderRadius: 6,
    padding: "4px 8px", color: C.white, fontSize: 12,
    fontFamily: "inherit",
  };

  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 20 }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16, flexWrap: "wrap", gap: 8 }}>
        <div style={{ fontSize: 14, fontWeight: 600, color: C.white }}>Anuncios por CAC</div>
        <div style={{ display: "flex", gap: 12, alignItems: "center", flexWrap: "wrap" }}>
          <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
            <span style={{ fontSize: 11, color: C.mutedMid }}>CAC objetivo $</span>
            <input
              type="number" value={cacTarget}
              onChange={e => onCacTargetChange(Number(e.target.value))}
              style={inputStyle}
            />
          </div>
          <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
            <span style={{ fontSize: 11, color: C.mutedMid }}>Ticket mín. $</span>
            <input
              type="number" value={ticketMin}
              onChange={e => onTicketMinChange(Number(e.target.value))}
              style={inputStyle}
            />
          </div>
          <button
            onClick={onOpenMapping}
            style={{
              background: `rgba(254,128,63,0.12)`, border: `1px solid rgba(254,128,63,0.30)`,
              color: C.orange, borderRadius: 8, padding: "4px 12px", fontSize: 12, cursor: "pointer",
            }}
          >
            Configurar VSLs
          </button>
        </div>
      </div>

      <div style={{ overflowX: "auto" }}>
        <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 12 }}>
          <thead>
            <tr style={{ borderBottom: `1px solid ${C.border}` }}>
              {["Campaña","Inv.","Clicks","CPM","CPC","Plays","Play%","Ventas","Ticket","CAC","ROAS","VSL","Score","Acción"].map(h => (
                <th key={h} style={{
                  padding: "6px 10px", color: C.mutedMid, fontWeight: 500,
                  textAlign: "left", whiteSpace: "nowrap",
                }}>
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {rows.map((r, i) => {
              const action     = classifyRow(r, cacTarget, ticketMin);
              const acStyle    = ACTION_STYLE[action];
              const avgTicket  = r.sales > 0 && r.investment > 0 ? (r.investment * r.roas) / r.sales : 0;
              return (
                <tr key={i} style={{ background: rowBg(r.cac, cacTarget), borderBottom: `1px solid ${C.border}` }}>
                  <td style={{ padding: "9px 10px", color: C.white, fontWeight: 500, maxWidth: 160, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                    {r.campaignName}
                  </td>
                  <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.investment.toFixed(0)}</td>
                  <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.clicks.toLocaleString("es")}</td>
                  <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.cpm.toFixed(2)}</td>
                  <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.cpc.toFixed(2)}</td>
                  <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.plays.toLocaleString("es")}</td>
                  <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.playRate.toFixed(1)}%</td>
                  <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.sales}</td>
                  <td style={{ padding: "9px 10px", color: avgTicket >= ticketMin && ticketMin > 0 ? C.green : C.mutedLight, fontWeight: avgTicket >= ticketMin && ticketMin > 0 ? 700 : 400 }}>
                    {avgTicket > 0 ? `$${avgTicket.toFixed(0)}` : "—"}
                  </td>
                  <td style={{ padding: "9px 10px", color: cacColor(r.cac, cacTarget), fontWeight: 700 }}>
                    {r.cac > 0 ? `$${r.cac.toFixed(0)}` : "—"}
                  </td>
                  <td style={{ padding: "9px 10px", color: r.roas >= 2 ? C.green : r.roas >= 1 ? C.yellow : C.red, fontWeight: 600 }}>
                    {r.roas > 0 ? `${r.roas.toFixed(2)}x` : "—"}
                  </td>
                  <td style={{ padding: "9px 10px", color: C.mutedMid, maxWidth: 100, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                    {r.videoName ?? "—"}
                  </td>
                  <td style={{ padding: "9px 10px" }}>
                    <span style={{ background: `${scoreColor(r.score)}20`, color: scoreColor(r.score), borderRadius: 12, padding: "2px 8px", fontSize: 11, fontWeight: 700 }}>
                      {r.score}
                    </span>
                  </td>
                  <td style={{ padding: "9px 10px" }}>
                    <span style={{ background: acStyle.bg, border: `1px solid ${acStyle.border}`, color: acStyle.color, borderRadius: 12, padding: "2px 10px", fontSize: 10, fontWeight: 700, whiteSpace: "nowrap" }}>
                      {action}
                    </span>
                  </td>
                </tr>
              );
            })}
            {rows.length === 0 && (
              <tr>
                <td colSpan={14} style={{ padding: 20, textAlign: "center", color: C.mutedMid, fontSize: 13 }}>
                  Sin datos de anuncios en el período
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Verificar que compila**

```bash
npm run build
```
Esperado: el único error posible es en `AnalyticsView.tsx` por la nueva prop `onTicketMinChange` (aún no conectada) — se resuelve en Task 7.

- [ ] **Step 3: Commit**

```bash
git add src/components/analytics/AdsRankingTable.tsx
git commit -m "feat(analytics): add ticketMin input and Acción column to AdsRankingTable"
```

---

## Task 7: Integrar todo en `AnalyticsView`

**Files:**
- Modify: `src/views/AnalyticsView.tsx`

**Interfaces:**
- Consumes: `VSLSelectorBar`, `VSLIntelligencePanel`, `ScaleRadar` (Tasks 3–5), `AdsRankingTable` con nuevas props (Task 6), `useAnalyticsData` con VSL state (Task 2)

- [ ] **Step 1: Reemplazar el contenido completo de `AnalyticsView.tsx`**

Sobreescribir `src/views/AnalyticsView.tsx` con el siguiente contenido:

```typescript
import { useState, useMemo }          from "react";
import { C, FONT }                    from "../tokens";
import { useAnalyticsData }           from "../hooks/useAnalyticsData";
import { Sidebar }                    from "../components/layout/Sidebar";
import { AlertsPanel }                from "../components/analytics/AlertsPanel";
import { KPISummary }                 from "../components/analytics/KPISummary";
import { CampaignFunnelCard }         from "../components/analytics/CampaignFunnelCard";
import { VSLSelectorBar }             from "../components/analytics/VSLSelectorBar";
import { VSLIntelligencePanel }       from "../components/analytics/VSLIntelligencePanel";
import { ScaleRadar }                 from "../components/analytics/ScaleRadar";
import { AdsRankingTable }            from "../components/analytics/AdsRankingTable";
import { HourlyHeatmap }              from "../components/analytics/HourlyHeatmap";
import { LTVTable }                   from "../components/analytics/LTVTable";
import { CampaignMappingModal }       from "../components/analytics/CampaignMappingModal";
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

export function AnalyticsView({ onDashboard, onUsers, onTransactions, onSettings, onSignOut, activeView, isAdmin }: Props) {
  const {
    summary, funnel, vsls, ranking, heatmap, ltv, alerts, mappings,
    loading, error, period, setPeriod, refresh, aiResult, aiLoading, runAIAnalysis,
    selectedVslId, compareVslId, setSelectedVsl, setCompareVsl,
  } = useAnalyticsData();

  const [cacTarget,    setCacTarget]    = useState(50);
  const [ticketMin,    setTicketMin]    = useState(0);
  const [mappingOpen,  setMappingOpen]  = useState(false);

  const SIDEBAR_W = 220;

  // ── Filtros derivados del VSL seleccionado ──────────────────────────────────
  const filteredFunnel  = useMemo(
    () => selectedVslId ? funnel.filter(f => f.videoId === selectedVslId) : funnel,
    [funnel, selectedVslId],
  );

  const filteredRanking = useMemo(
    () => selectedVslId ? ranking.filter(r => r.videoId === selectedVslId) : ranking,
    [ranking, selectedVslId],
  );

  const selectedVsl = useMemo(
    () => vsls.find(v => v.videoId === selectedVslId) ?? null,
    [vsls, selectedVslId],
  );

  const compareVsl = useMemo(
    () => compareVslId ? vsls.find(v => v.videoId === compareVslId) ?? null : null,
    [vsls, compareVslId],
  );

  // KPIs filtrados: suma desde funnel filtrado cuando hay VSL activo
  const filteredSummary = useMemo((): AnalyticsSummary | null => {
    if (!selectedVslId || !summary || filteredFunnel.length === 0) return summary;
    const investment = filteredFunnel.reduce((s, f) => s + f.investment, 0);
    const revenue    = filteredFunnel.reduce((s, f) => s + f.investment * f.roas, 0);
    const salesCount = filteredFunnel.reduce((s, f) => s + f.sales, 0);
    const plays      = filteredFunnel.reduce((s, f) => s + f.plays, 0);
    return {
      investment,
      revenue,
      roas:        investment > 0 ? revenue / investment : 0,
      cac:         salesCount > 0 ? investment / salesCount : 0,
      sales:       salesCount,
      plays,
      playRate:    summary.playRate,
      costPerPlay: plays > 0 ? investment / plays : 0,
    };
  }, [selectedVslId, filteredFunnel, summary]);

  return (
    <div style={{ display: "flex", height: "100vh", background: C.bg, fontFamily: FONT, color: C.white, overflow: "hidden" }}>
      <Sidebar
        filter="todos"
        onFilter={() => {}}
        onSettings={onSettings}
        onSignOut={onSignOut}
        onDashboard={onDashboard}
        onUsers={onUsers}
        onTransactions={onTransactions}
        onAnalytics={() => {}}
        activeView={activeView}
        mrr={0} arr={0}
        isAdmin={isAdmin}
        width={SIDEBAR_W}
      />

      <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden", marginLeft: SIDEBAR_W }}>

        {/* Header — período */}
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

        {/* VSL Selector Bar */}
        {vsls.length > 0 && (
          <VSLSelectorBar
            vsls={vsls}
            selectedId={selectedVslId}
            compareId={compareVslId}
            onSelect={setSelectedVsl}
            onCompare={setCompareVsl}
          />
        )}

        {/* Contenido principal */}
        <main style={{ flex: 1, overflowY: "auto", padding: "20px 24px", display: "flex", flexDirection: "column", gap: 20 }}>

          {error && (
            <div style={{ background: "rgba(255,65,59,0.1)", border: "1px solid #FF413B", borderRadius: 10, padding: 14, fontSize: 13, color: "#FF413B" }}>
              Error al cargar datos: {error}
            </div>
          )}

          {/* Alertas */}
          {alerts.length > 0 && <AlertsPanel alerts={alerts} />}

          {/* KPIs filtrados por VSL */}
          <div>
            {selectedVslId && selectedVsl && (
              <div style={{ fontSize: 11, color: C.mutedMid, marginBottom: 8 }}>
                Filtrando por: <span style={{ color: C.orange, fontWeight: 700 }}>{selectedVsl.videoName}</span>
              </div>
            )}
            <KPISummary summary={filteredSummary} loading={loading} />
          </div>

          {/* VSL Intelligence Panel */}
          <VSLIntelligencePanel primary={selectedVsl} compare={compareVsl} />

          {/* Radar de Decisión */}
          <ScaleRadar campaigns={filteredRanking} cacTarget={cacTarget} ticketMin={ticketMin} />

          {/* Funnels por campaña — filtrados por VSL */}
          {(loading || filteredFunnel.length > 0) && (
            <section>
              <div style={{ fontSize: 13, fontWeight: 600, color: C.white, marginBottom: 12 }}>
                Funnels por Campaña
                {selectedVslId && selectedVsl && (
                  <span style={{ fontSize: 11, color: C.mutedMid, fontWeight: 400, marginLeft: 8 }}>
                    · {selectedVsl.videoName}
                  </span>
                )}
              </div>
              {loading ? (
                <div style={{ height: 180, background: C.card, border: `1px solid ${C.border}`, borderRadius: 14 }} />
              ) : (
                <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(340px, 1fr))", gap: 16 }}>
                  {filteredFunnel.map(f => <CampaignFunnelCard key={f.campaignName} campaign={f} />)}
                </div>
              )}
            </section>
          )}

          {/* Tabla de anuncios — filtrada por VSL + columna Acción */}
          <AdsRankingTable
            rows={filteredRanking}
            cacTarget={cacTarget}
            ticketMin={ticketMin}
            onCacTargetChange={setCacTarget}
            onTicketMinChange={setTicketMin}
            onOpenMapping={() => setMappingOpen(true)}
          />

          {/* Heatmap — global (no filtrado por VSL) */}
          <HourlyHeatmap cells={heatmap} />

          {/* LTV */}
          <LTVTable rows={ltv} />

          {/* IA Analyst */}
          <AIAnalyst result={aiResult} loading={aiLoading} onAnalyze={runAIAnalysis} />

        </main>
      </div>

      <CampaignMappingModal
        open={mappingOpen}
        onClose={() => setMappingOpen(false)}
        mappings={mappings}
        campaigns={funnel.map(f => f.campaignName)}
        onSaved={() => { setMappingOpen(false); refresh(); }}
      />
    </div>
  );
}
```

- [ ] **Step 2: Verificar que compila sin errores**

```bash
npm run build
```
Esperado: `✓ built in X.XXs`. Si hay error de tipo en `AnalyticsSummary` (por falta de `prev`), confirmar que el tipo lo tiene como opcional: `prev?: Omit<AnalyticsSummary, "prev">` — si no es opcional, agregar `| undefined` al tipo.

- [ ] **Step 3: Verificar en el browser**

Con el servidor ya corriendo (`npm run dev`), abrir `http://localhost:5175` y navegar a Analytics. Verificar:

1. La barra de VSL aparece entre el header y el contenido (chips con nombres de videos)
2. Al hacer click en un VSL, los KPIs y la tabla de anuncios se filtran
3. El VSLIntelligencePanel muestra la curva de retención con el punto de caída marcado en rojo
4. El Radar de Decisión muestra ESCALAR / PAUSAR / MONITOREAR con los nombres de campaña
5. La columna "Acción" aparece en la tabla de anuncios con badges de color
6. El botón "+ Comparar con:" aparece si hay 2+ VSLs y muestra dos líneas en el gráfico al activarlo

- [ ] **Step 4: Commit final**

```bash
git add src/views/AnalyticsView.tsx
git commit -m "feat(analytics): wire VSL Command Center — selector, intelligence panel, scale radar"
```

---

## Self-Review del Plan

**Cobertura del spec:**
- ✅ VSLSelectorBar con chips, auto-selección, modo comparación → Task 3
- ✅ VSLIntelligencePanel con curva Vturb, métricas, veredicto → Task 4
- ✅ ScaleRadar con lógica ESCALAR/PAUSAR/MONITOREAR → Task 5
- ✅ Filtro de KPISummary por VSL → Task 7 (filteredSummary)
- ✅ Filtro de Funnels por VSL → Task 7 (filteredFunnel)
- ✅ AdsRankingTable con ticketMin y columna Acción → Task 6
- ✅ Filtro de ranking por VSL → Task 7 (filteredRanking)
- ✅ HourlyHeatmap queda global (decisión del spec) → Task 7
- ✅ VSLComparator reemplazado por VSLIntelligencePanel → Task 7 (no se importa más)
- ✅ videoId en AdRankRow para filtro robusto → Task 1

**Consistencia de tipos:**
- `AdRankRow.videoId: string | null` definido en Task 1, usado en Task 6 y Task 7
- `VSLSelectorBar` recibe `VSLData[]` — correcto, `vsls` ya viene del hook
- `VSLIntelligencePanel` recibe `VSLData | null` — `selectedVsl` es `VSLData | undefined`, castear con `?? null` en el prop (ya hecho en Task 7)
- `ScaleRadar` recibe `AdRankRow[]` — `filteredRanking` es `AdRankRow[]` ✅
- `AdsRankingTable` nueva prop `onTicketMinChange` añadida en Task 6, conectada en Task 7 ✅
- `AnalyticsSummary` sin `prev` en `filteredSummary` — `prev` es `prev?: ...` (opcional) ✅
