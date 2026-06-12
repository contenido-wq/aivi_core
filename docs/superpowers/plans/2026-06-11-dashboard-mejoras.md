# Dashboard Mejoras Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Corregir datos rotos (investment/ROAS siempre 0, columnas de planes siempre 0, meta diaria hardcodeada) y exponer datos que ya se cargan pero no se muestran (semana/mes revenue, nuevos compradores hoy, sync UTMify).

**Architecture:** Cambios en la capa de servicio (`dashboard.ts`) fluyen hacia los componentes (`KPIRow`, `UsersTable`, `TopNav`, `Sidebar`) a través de props existentes o nuevas. Se agrega un hook (`useDailyGoal`) para persistencia en localStorage. Sin nuevas consultas a Supabase salvo la suma de `daily_metrics.investment` en `getKPIs()`.

**Tech Stack:** React 19, TypeScript, Supabase JS v2, Vite, Lucide React, inline styles con tokens en `src/tokens.ts`

---

## Mapa de archivos

| Archivo | Acción | Responsabilidad |
|---|---|---|
| `src/services/dashboard.ts` | Modificar | Leer investment real, calcular ROAS, detectar período de facturación en planes, exponer `syncUtmify()` |
| `src/hooks/useDailyGoal.ts` | Crear | Leer/escribir meta diaria en localStorage |
| `src/components/dashboard/KPIRow.tsx` | Modificar | Recibir `daily` + `weekRevenue` + `monthRevenue`, renderizar subtítulos de tendencia |
| `src/components/dashboard/UsersTable.tsx` | Modificar | Agrupar planes por familia, renderizar filas de familia + sub-filas |
| `src/components/dashboard/TopNav.tsx` | Modificar | Agregar botón Sync UTMify con 4 estados visuales |
| `src/components/layout/Sidebar.tsx` | Modificar | Usar `useDailyGoal`, agregar edición inline de la meta |
| `src/views/DashboardView.tsx` | Modificar | Pasar nuevas props a `KPIRow` y `TopNav`, conectar `syncUtmify` |

---

## Task 1: Corregir `getKPIs()` y agregar `syncUtmify()`

**Archivo:** `src/services/dashboard.ts`

- [ ] **Paso 1.1 — Agregar lectura de inversión histórica en `getKPIs()`**

Ubica la función `getKPIs()` (línea ~138). Justo antes del bloque `return { mrr, arr, ... }`, agrega la siguiente consulta (después de que ya se calculó `grossRevenue`):

```typescript
  // Leer inversión histórica acumulada desde daily_metrics
  const { data: metricRows } = await supabase
    .from("daily_metrics")
    .select("investment");

  const totalInvestment = (metricRows ?? [])
    .reduce((s: number, r: any) => s + Number(r.investment ?? 0), 0);

  const roas = totalInvestment > 0
    ? Math.round((grossRevenue / totalInvestment) * 100) / 100
    : 0;
```

- [ ] **Paso 1.2 — Actualizar el `return` de `getKPIs()`**

Reemplaza las líneas con `investment: 0` y `roas: 0` por valores reales (solo cuando el filtro es "todos"; en otros filtros UTMify no discrimina por producto):

```typescript
  return {
    mrr,
    arr:          mrr * 12,
    activeTotal:  active.length + trials.length,
    cancelled:    cancelled.length,
    delayed:      delayed.length,
    grossRevenue,
    investment:   filter === "todos" ? totalInvestment : 0,
    roas:         filter === "todos" ? roas : 0,
    monthsActive,
  };
```

- [ ] **Paso 1.3 — Agregar función `syncUtmify()` al final de `dashboard.ts`**

Al final del archivo, después de `syncToday()`, agrega:

```typescript
export async function syncUtmify(): Promise<{ ok: boolean; totalInvestment?: number; error?: string }> {
  const url = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/utmify-sync`;
  try {
    const res = await fetch(url, {
      headers: { Authorization: `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}` },
    });
    if (!res.ok) {
      const text = await res.text().catch(() => "");
      return { ok: false, error: `HTTP ${res.status}: ${text.slice(0, 100)}` };
    }
    return res.json();
  } catch (e) {
    return { ok: false, error: String(e) };
  }
}
```

- [ ] **Paso 1.4 — Verificar en dev server**

```bash
npm run dev
```

Abrir el dashboard con filtro "Todos". Los KPI cards de Inversión y ROAS deben mostrar valores distintos de `$0.00` / `0.00x` si la tabla `daily_metrics` tiene filas con `investment > 0`. Con filtro "AIVI", deben volver a mostrar `$0.00`.

- [ ] **Paso 1.5 — Commit**

```bash
git add src/services/dashboard.ts
git commit -m "feat: getKPIs reads real investment from daily_metrics, add syncUtmify()"
```

---

## Task 2: Extender `PlanRow` con campos de período y familia

**Archivo:** `src/services/dashboard.ts`

- [ ] **Paso 2.1 — Agregar función helper `getBillingPeriod()`**

Justo antes de `getPlansBreakdown()` (línea ~201), agrega:

```typescript
function getBillingPeriod(planName: string): "mensual" | "anual" | "trial" {
  const lower = (planName ?? "").toLowerCase();
  if (lower.includes("trial"))                                          return "trial";
  if (lower.includes("anual") || lower.includes("annual") || lower.includes("yearly")) return "anual";
  return "mensual";
}
```

- [ ] **Paso 2.2 — Actualizar la interfaz `PlanRow`**

Reemplaza la interfaz existente:

```typescript
// ANTES
export interface PlanRow {
  name:      string;
  active:    number;
  cancelled: number;
  delayed:   number;
}

// DESPUÉS
export interface PlanRow {
  name:      string;
  family:    string;
  active:    number;
  cancelled: number;
  delayed:   number;
  mensual:   number;
  anual:     number;
  trial:     number;
}
```

- [ ] **Paso 2.3 — Actualizar `getPlansBreakdown()` para poblar los nuevos campos**

Dentro de `getPlansBreakdown()`, reemplaza el bloque del `for` loop con:

```typescript
  for (const row of (data ?? [])) {
    if (!matchesPlan(row.plan_name, filter)) continue;
    if (!map[row.plan_name]) {
      map[row.plan_name] = {
        name:      row.plan_name,
        family:    getProductFamily(row.plan_name),
        active:    0,
        cancelled: 0,
        delayed:   0,
        mensual:   0,
        anual:     0,
        trial:     0,
      };
    }
    if (row.status === "active") {
      map[row.plan_name].active++;
      const period = getBillingPeriod(row.plan_name);
      map[row.plan_name][period]++;
    }
    if (row.status === "cancelled") map[row.plan_name].cancelled++;
    if (row.status === "delayed")   map[row.plan_name].delayed++;
  }
```

- [ ] **Paso 2.4 — Verificar que TypeScript no reporta errores**

```bash
npx tsc --noEmit
```

Esperado: sin errores de tipo.

- [ ] **Paso 2.5 — Commit**

```bash
git add src/services/dashboard.ts
git commit -m "feat: PlanRow adds family/mensual/anual/trial fields with billing period detection"
```

---

## Task 3: Crear hook `useDailyGoal`

**Archivo:** `src/hooks/useDailyGoal.ts` (nuevo)

- [ ] **Paso 3.1 — Crear el archivo**

```typescript
import { useState } from "react";

const STORAGE_KEY = "aivi_daily_goal";
const DEFAULT_GOAL = 400;

export function useDailyGoal() {
  const [goal, setGoalState] = useState<number>(() => {
    const stored = localStorage.getItem(STORAGE_KEY);
    return stored ? Math.max(1, Number(stored)) : DEFAULT_GOAL;
  });

  const setGoal = (value: number) => {
    const safe = Math.max(1, Math.round(value));
    localStorage.setItem(STORAGE_KEY, String(safe));
    setGoalState(safe);
  };

  return { goal, setGoal };
}
```

- [ ] **Paso 3.2 — Verificar TypeScript**

```bash
npx tsc --noEmit
```

Esperado: sin errores.

- [ ] **Paso 3.3 — Commit**

```bash
git add src/hooks/useDailyGoal.ts
git commit -m "feat: add useDailyGoal hook with localStorage persistence"
```

---

## Task 4: Actualizar `KPIRow` con datos de tendencia

**Archivo:** `src/components/dashboard/KPIRow.tsx`

- [ ] **Paso 4.1 — Actualizar imports y la interfaz `KPIRowProps`**

Al inicio del archivo, agrega `DailyData` al import de servicios:

```typescript
import type { KPIData, DailyData } from "../../services/dashboard";
```

Actualiza la interfaz:

```typescript
// ANTES
interface KPIRowProps { kpis: KPIData | null; }

// DESPUÉS
interface KPIRowProps {
  kpis:         KPIData   | null;
  daily:        DailyData | null;
  weekRevenue:  number;
  monthRevenue: number;
}
```

- [ ] **Paso 4.2 — Actualizar la firma de `KPIRow`**

```typescript
export function KPIRow({ kpis, daily, weekRevenue, monthRevenue }: KPIRowProps) {
```

- [ ] **Paso 4.3 — Agregar helper de formato dentro de `KPIRow`**

Justo después de la declaración de `fmt`, agrega:

```typescript
  const fmtShort = (n: number) =>
    n >= 1000
      ? `$${(n / 1000).toFixed(1)}k`
      : `$${n.toFixed(0)}`;
```

- [ ] **Paso 4.4 — Actualizar la card de Facturación Bruta (hero)**

Reemplaza la `KPICard` del hero con:

```tsx
<KPICard
  icon={<DollarSign size={iconSize}/>}
  label="Facturación Bruta"
  value={fmt(kpis?.grossRevenue ?? 0)}
  valueColor={C.green}
  hero
  compact={compact}
  sub={
    weekRevenue > 0
      ? `${kpis?.monthsActive ?? 0} meses · sem ${fmtShort(weekRevenue)} · mes ${fmtShort(monthRevenue)}`
      : `${kpis?.monthsActive ?? 0} ${(kpis?.monthsActive ?? 0) === 1 ? "mes" : "meses"} activo`
  }
/>
```

- [ ] **Paso 4.5 — Actualizar la card de Activos / Cancel**

Reemplaza la `KPICard` de Activos con:

```tsx
<KPICard
  icon={<Users size={iconSize}/>}
  label="Activos / Cancel"
  value={
    <span>
      <span style={{ color: C.green }}>{kpis?.activeTotal ?? 0}</span>
      <span style={{ color: C.muted, fontSize: compact ? 16 : 22, margin: "0 4px" }}>/</span>
      <span style={{ color: C.red }}>{kpis?.cancelled ?? 0}</span>
    </span>
  }
  valueColor={C.green}
  compact={compact}
  sub={
    (daily?.newUsers ?? 0) > 0
      ? `+${daily!.newUsers} nuevos hoy`
      : undefined
  }
/>
```

- [ ] **Paso 4.6 — Verificar en dev server**

```bash
npm run dev
```

La card hero debe mostrar "N meses · sem $Xk · mes $Xk" en el subtítulo cuando hay datos de comparación. La card Activos debe mostrar "+N nuevos hoy" cuando hay compradores hoy.

Si `DashboardView` aún no pasa las nuevas props, habrá un error de TypeScript. Es normal — se resuelve en Task 8.

- [ ] **Paso 4.7 — Commit**

```bash
git add src/components/dashboard/KPIRow.tsx
git commit -m "feat: KPIRow shows week/month revenue and new buyers count as subtitles"
```

---

## Task 5: Actualizar `UsersTable` con agrupación por familia

**Archivo:** `src/components/dashboard/UsersTable.tsx`

- [ ] **Paso 5.1 — Agregar `useMemo` y `Fragment` al import de React y el tipo correcto de `PlanRow`**

```typescript
import { useMemo, Fragment } from "react";
import type { PlanRow, KPIData } from "../../services/dashboard";
```

- [ ] **Paso 5.2 — Agregar el helper de colores de familia justo antes del componente**

```typescript
const FAMILY_COLORS: Record<string, string> = {
  "AIVI":         "#FF6B2C",
  "Método V3":    "#FFC247",
  "Reto 15D":     "#2FB7FF",
  "Reto 11D":     "#2FB7FF",
  "Master Creator": "#A78BFA",
};

function familyColor(family: string): string {
  return FAMILY_COLORS[family] ?? "#A0A0B4";
}
```

- [ ] **Paso 5.3 — Agregar el cálculo de familias agrupadas dentro de `UsersTable`**

Justo después de la desestructuración de props, añade:

```typescript
  const families = useMemo(() => {
    const map: Record<string, PlanRow[]> = {};
    for (const plan of plans) {
      const key = plan.family || plan.name;
      if (!map[key]) map[key] = [];
      map[key].push(plan);
    }
    return Object.entries(map)
      .map(([family, rows]) => ({
        family,
        rows,
        totalActive:    rows.reduce((s, r) => s + r.active,    0),
        totalCancelled: rows.reduce((s, r) => s + r.cancelled, 0),
        totalDelayed:   rows.reduce((s, r) => s + r.delayed,   0),
        totalMensual:   rows.reduce((s, r) => s + r.mensual,   0),
        totalAnual:     rows.reduce((s, r) => s + r.anual,     0),
        totalTrial:     rows.reduce((s, r) => s + r.trial,     0),
      }))
      .sort((a, b) => b.totalActive - a.totalActive);
  }, [plans]);

  const totalActive     = families.reduce((s, f) => s + f.totalActive,    0);
  const totalCancelled  = families.reduce((s, f) => s + f.totalCancelled, 0);
  const totalDelayed    = families.reduce((s, f) => s + f.totalDelayed,   0);
  const totalMensual    = families.reduce((s, f) => s + f.totalMensual,   0);
  const totalAnual      = families.reduce((s, f) => s + f.totalAnual,     0);
  const totalTrial      = families.reduce((s, f) => s + f.totalTrial,     0);
```

Elimina las líneas antiguas de `totalActive`, `totalCancelled`, `totalDelayed`, `totalMensual`, `totalTrimestral`, `totalAnual`, `totalTrial`.

- [ ] **Paso 5.4 — Reemplazar el `<thead>` — eliminar columna Trimestral**

```tsx
<thead>
  <tr>
    <th style={{ ...th, textAlign: "left" }}>Familia / Plan</th>
    <th style={th}>Activos</th>
    <th style={th}>Cancel.</th>
    <th style={th}>Mensual</th>
    <th style={th}>Anual</th>
    <th style={th}>Trial</th>
  </tr>
</thead>
```

- [ ] **Paso 5.5 — Reemplazar el `<tbody>` con filas de familia + sub-filas**

Reemplaza todo el `<tbody>` existente con:

```tsx
<tbody>
  {families.length === 0 ? (
    <tr><td colSpan={6} style={{ ...td, textAlign: "center", color: C.muted }}>Sin datos aún</td></tr>
  ) : families.map(({ family, rows, totalActive: fActive, totalCancelled: fCancelled, totalMensual: fMensual, totalAnual: fAnual, totalTrial: fTrial }) => (
    <Fragment key={family}>
      {/* Fila de familia */}
      <tr style={{ background: "rgba(255,255,255,0.025)" }}>
        <td style={{ ...td, textAlign: "left", borderTop: `1px solid ${C.borderMid}` }}>
          <span style={{ fontWeight: 900, fontSize: 12, color: familyColor(family) }}>{family}</span>
          <span style={{
            marginLeft: 8, fontSize: 9, fontWeight: 700, padding: "1px 6px",
            borderRadius: 8, background: `${familyColor(family)}15`,
            color: familyColor(family), border: `0.5px solid ${familyColor(family)}30`,
          }}>{fActive} activos</span>
        </td>
        <td style={{ ...td, color: C.green, fontWeight: 900, borderTop: `1px solid ${C.borderMid}` }}>{fActive}</td>
        <td style={{ ...td, borderTop: `1px solid ${C.borderMid}` }}><PillBadge n={fCancelled} color={C.red} /></td>
        <td style={{ ...td, borderTop: `1px solid ${C.borderMid}` }}><PillBadge n={fMensual} color={C.white} /></td>
        <td style={{ ...td, borderTop: `1px solid ${C.borderMid}` }}><PillBadge n={fAnual}   color={C.white} /></td>
        <td style={{ ...td, borderTop: `1px solid ${C.borderMid}` }}><PillBadge n={fTrial}   color={C.yellow} /></td>
      </tr>
      {/* Sub-filas de planes */}
      {rows.map((p, i) => (
        <tr key={`plan-${family}-${i}`} className="aivi-row">
          <td style={{ ...td, textAlign: "left", paddingLeft: isMobile ? 14 : 20, fontSize: 11, color: C.mutedLight, fontWeight: 600 }}>
            {p.name.replace(`${family} — `, "").replace("AIVI — ", "").replace("Método V3 — ", "")}
          </td>
          <td style={{ ...td, color: C.green }}>{p.active}</td>
          <td style={td}><PillBadge n={p.cancelled} color={C.red} /></td>
          <td style={td}><PillBadge n={p.mensual}   color={C.white} /></td>
          <td style={td}><PillBadge n={p.anual}     color={C.white} /></td>
          <td style={td}><PillBadge n={p.trial}     color={C.yellow} /></td>
        </tr>
      ))}
    </Fragment>
  ))}
  {/* Fila de totales */}
  {families.length > 0 && (
    <tr style={{ background: "rgba(255,107,44,0.05)" }}>
      <td style={{ ...td, fontWeight: 900, fontSize: 13, color: C.white }}>Total</td>
      <td style={{ ...td, color: C.green,  fontWeight: 900 }}>{totalActive}</td>
      <td style={{ ...td, color: C.red,    fontWeight: 900 }}>{totalCancelled}</td>
      <td style={{ ...td, color: C.white,  fontWeight: 900 }}>{totalMensual}</td>
      <td style={{ ...td, color: C.white,  fontWeight: 900 }}>{totalAnual}</td>
      <td style={{ ...td, color: C.yellow, fontWeight: 900 }}>{totalTrial}</td>
    </tr>
  )}
</tbody>
```

- [ ] **Paso 5.6 — Actualizar los indicadores inferiores (eliminar Trimestral)**

Reemplaza el bloque de métricas inferiores:

```tsx
{[
  ["CPA",        `$${cpa}`,              C.yellow],
  ["Ticket Prom.", `$${ticket}`,         C.green],
  ["Cancelados", String(totalCancelled), C.red],
  ["Atrasados",  String(totalDelayed),   C.yellow],
].map(([lbl, val, col]) => (
  <div key={lbl as string}>
    <div style={{ fontSize: 9, color: C.muted, fontWeight: 700, textTransform: "uppercase", letterSpacing: ".06em", marginBottom: 2 }}>{lbl}</div>
    <div style={{ fontSize: isMobile ? 14 : 16, fontWeight: 900, color: col as string }}>{val}</div>
  </div>
))}
```

- [ ] **Paso 5.7 — Verificar en dev server**

```bash
npm run dev
```

La tabla debe mostrar filas de familia en naranja/amarillo/azul con sub-filas indentadas. Las columnas Mensual/Anual/Trial deben tener valores reales (no 0) si los nombres de los planes contienen esas palabras.

- [ ] **Paso 5.8 — Commit**

```bash
git add src/components/dashboard/UsersTable.tsx
git commit -m "feat: UsersTable groups plans by family with billing period sub-rows"
```

---

## Task 6: Meta diaria editable en `Sidebar`

**Archivo:** `src/components/layout/Sidebar.tsx`

- [ ] **Paso 6.1 — Agregar imports**

```typescript
import { useState }       from "react";
import { Pencil }         from "lucide-react";
import { useDailyGoal }   from "../../hooks/useDailyGoal";
```

`useState` ya puede estar importado — verifica y no dupliques.

- [ ] **Paso 6.2 — Usar el hook y estado de edición dentro de `Sidebar`**

Al inicio de la función `Sidebar`, después de `fmtK`, agrega:

```typescript
  const { goal, setGoal }               = useDailyGoal();
  const [editingGoal, setEditingGoal]   = useState(false);
  const [goalInput,   setGoalInput]     = useState("");

  const startEdit = () => { setGoalInput(String(goal)); setEditingGoal(true); };
  const saveGoal  = () => {
    const parsed = Number(goalInput);
    if (!isNaN(parsed) && parsed > 0) setGoal(parsed);
    setEditingGoal(false);
  };
  const cancelEdit = () => setEditingGoal(false);
```

- [ ] **Paso 6.3 — Reemplazar `const goal = 400` y el bloque de meta diaria**

Elimina la línea `const goal = 400;` (dentro del IIFE que renderiza la meta).

Reemplaza todo el bloque `(() => { const goal = 400; ... })()` con el siguiente JSX (mantén el mismo nivel de indentación):

```tsx
{/* Meta diaria */}
<div style={{ paddingTop: 8 }}>
  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 5 }}>
    <span style={{ fontSize: 10, color: C.mutedLight, display: "flex", alignItems: "center", gap: 4 }}>
      Meta diaria
      {!editingGoal && (
        <button
          onClick={startEdit}
          title="Editar meta"
          style={{ background: "none", border: "none", cursor: "pointer", color: C.muted, padding: "0 2px", display: "flex", alignItems: "center" }}
        >
          <Pencil size={9} />
        </button>
      )}
    </span>
    {!editingGoal && (
      <span style={{ fontSize: 11, fontWeight: 800, color: ((daily?.revenue ?? 0) / goal) >= 1 ? C.green : C.orange }}>
        {Math.min(Math.round(((daily?.revenue ?? 0) / goal) * 100), 100)}%
      </span>
    )}
  </div>

  {editingGoal ? (
    <div style={{ display: "flex", alignItems: "center", gap: 4, marginBottom: 6 }}>
      <input
        type="number"
        min={1}
        value={goalInput}
        onChange={e => setGoalInput(e.target.value)}
        onKeyDown={e => { if (e.key === "Enter") saveGoal(); if (e.key === "Escape") cancelEdit(); }}
        autoFocus
        style={{
          background: "rgba(255,255,255,0.07)", border: `1px solid rgba(255,107,44,0.4)`,
          borderRadius: 6, color: C.white, fontSize: 12, fontWeight: 700,
          padding: "3px 6px", width: 72, outline: "none", fontFamily: "inherit",
        }}
      />
      <button onClick={saveGoal} style={{ background: "rgba(255,107,44,0.15)", border: `1px solid rgba(255,107,44,0.35)`, borderRadius: 5, color: C.orange, fontSize: 10, fontWeight: 700, padding: "3px 8px", cursor: "pointer" }}>
        OK
      </button>
      <button onClick={cancelEdit} style={{ background: "none", border: `1px solid ${C.border}`, borderRadius: 5, color: C.muted, fontSize: 10, padding: "3px 6px", cursor: "pointer" }}>
        ×
      </button>
    </div>
  ) : null}

  <div style={{ height: 4, background: "rgba(255,255,255,0.06)", borderRadius: 2, overflow: "hidden" }}>
    <div style={{
      height: "100%",
      width: `${Math.min(((daily?.revenue ?? 0) / goal) * 100, 100)}%`,
      borderRadius: 2,
      transition: "width 0.6s ease",
      background: ((daily?.revenue ?? 0) / goal) >= 1 ? C.green : `linear-gradient(90deg, ${C.orange}, ${C.yellow})`,
    }} />
  </div>
</div>
```

- [ ] **Paso 6.4 — Verificar en dev server**

```bash
npm run dev
```

En la sidebar, junto a "Meta diaria" debe aparecer un ícono de lápiz. Al hacer click: aparece un input con el valor actual. Enter o "OK" guarda. "×" cancela. Después de guardar, la barra de progreso se recalcula con la nueva meta. Recargar la página debe mantener el valor guardado.

- [ ] **Paso 6.5 — Commit**

```bash
git add src/components/layout/Sidebar.tsx src/hooks/useDailyGoal.ts
git commit -m "feat: daily goal is configurable via inline edit, persists in localStorage"
```

---

## Task 7: Botón Sync UTMify en `TopNav`

**Archivo:** `src/components/dashboard/TopNav.tsx`

- [ ] **Paso 7.1 — Actualizar imports y la interfaz `TopNavProps`**

```typescript
import { useState }                                from "react";
import { RefreshCw, BarChart2, Bell, Zap, Menu }  from "lucide-react";
import { C }                                       from "../../tokens";
import { Toggle }                                  from "../ui/Toggle";
```

Actualiza la interfaz:

```typescript
interface TopNavProps {
  time:            string;
  adsOn:           boolean;
  onAdsToggle:     () => void;
  isMobile?:       boolean;
  onMenuOpen?:     () => void;
  onSync?:         () => Promise<void>;
  onSyncUtmify?:   () => Promise<{ ok: boolean; totalInvestment?: number; error?: string }>;
}
```

- [ ] **Paso 7.2 — Agregar estado del botón UTMify dentro de `TopNav`**

Después de `const [syncing, setSyncing] = useState(false);`, agrega:

```typescript
  type UtmStatus = "idle" | "loading" | "ok" | "error";
  const [utmStatus, setUtmStatus] = useState<UtmStatus>("idle");
  const [utmMsg,    setUtmMsg]    = useState("");

  const handleSyncUtmify = async () => {
    if (!onSyncUtmify || utmStatus === "loading") return;
    setUtmStatus("loading");
    const result = await onSyncUtmify();
    if (result.ok) {
      setUtmMsg(result.totalInvestment !== undefined ? `$${result.totalInvestment.toFixed(2)} sync` : "Sincronizado");
      setUtmStatus("ok");
    } else {
      setUtmMsg("Error UTMify");
      setUtmStatus("error");
    }
    setTimeout(() => setUtmStatus("idle"), 2000);
  };
```

- [ ] **Paso 7.3 — Reemplazar el botón muerto "Sync Ads" con el botón UTMify**

Dentro del bloque `{!isMobile && (...)}`, reemplaza:

```tsx
// ANTES
<button style={{ background: "none", border: "none", color: C.mutedLight, display: "flex", alignItems: "center", gap: 5 }}>
  <BarChart2 size={14} />
  <span>Sync Ads</span>
</button>

// DESPUÉS
<button
  onClick={handleSyncUtmify}
  disabled={utmStatus === "loading"}
  title="Sincronizar inversión desde UTMify"
  style={{
    display: "flex", alignItems: "center", gap: 5,
    borderRadius: 8, padding: "5px 10px", border: "1px solid",
    fontSize: 10, fontWeight: 700, cursor: utmStatus === "loading" ? "not-allowed" : "pointer",
    transition: "all 0.15s",
    ...(utmStatus === "idle"    && { background: "rgba(255,255,255,0.04)", borderColor: "rgba(255,255,255,0.1)",      color: C.mutedLight }),
    ...(utmStatus === "loading" && { background: "rgba(255,107,44,0.08)", borderColor: "rgba(255,107,44,0.25)",      color: C.orange }),
    ...(utmStatus === "ok"      && { background: "rgba(34,197,94,0.08)",  borderColor: "rgba(34,197,94,0.25)",       color: C.green }),
    ...(utmStatus === "error"   && { background: "rgba(255,65,59,0.08)",  borderColor: "rgba(255,65,59,0.25)",       color: C.red }),
  }}
>
  {utmStatus === "loading"
    ? <><RefreshCw size={11} style={{ animation: "spin 0.8s linear infinite" }} /> Sincronizando…</>
    : utmStatus === "ok"
    ? <>✓ {utmMsg}</>
    : utmStatus === "error"
    ? <>✗ {utmMsg}</>
    : <><BarChart2 size={11} /> UTMify</>
  }
</button>
```

- [ ] **Paso 7.4 — Agregar el prop `onSyncUtmify` a la desestructuración de `TopNav`**

```typescript
export function TopNav({ time, adsOn, onAdsToggle, isMobile, onMenuOpen, onSync, onSyncUtmify }: TopNavProps) {
```

- [ ] **Paso 7.5 — Verificar en dev server**

```bash
npm run dev
```

En el TopNav debe aparecer el botón "UTMify". Al hacer click debe pasar por los estados: loading → ok/error → idle (después de 2 segundos). Si la Edge Function no está desplegada, mostrará error — comportamiento correcto.

- [ ] **Paso 7.6 — Commit**

```bash
git add src/components/dashboard/TopNav.tsx
git commit -m "feat: TopNav adds Sync UTMify button with 4 visual states"
```

---

## Task 8: Conectar todo en `DashboardView`

**Archivo:** `src/views/DashboardView.tsx`

- [ ] **Paso 8.1 — Agregar import de `syncUtmify`**

```typescript
import { syncToday, syncUtmify }  from "../services/dashboard";
```

- [ ] **Paso 8.2 — Agregar handler de UTMify**

Junto al `handleSync` existente, agrega:

```typescript
  const handleSyncUtmify = useCallback(async () => {
    const result = await syncUtmify();
    if (result.ok) await refresh();
    return result;
  }, [refresh]);
```

- [ ] **Paso 8.3 — Actualizar `<TopNav>` para pasar el nuevo prop**

```tsx
<TopNav
  time={time}
  adsOn={adsOn}
  onAdsToggle={() => setAdsOn(!adsOn)}
  isMobile={isMobile || isTablet}
  onMenuOpen={() => setSidebarOpen(true)}
  onSync={handleSync}
  onSyncUtmify={handleSyncUtmify}
/>
```

- [ ] **Paso 8.4 — Actualizar `<KPIRow>` para pasar los nuevos props**

Busca las tres apariciones de `<KPIRow kpis={kpis} />` en el archivo (una por cada breakpoint: desktop tall, laptop/short screen, mobile) y reemplaza todas con:

```tsx
<KPIRow
  kpis={kpis}
  daily={daily}
  weekRevenue={comparison?.weekRevenue ?? 0}
  monthRevenue={comparison?.monthRevenue ?? 0}
/>
```

Son exactamente 3 instancias en el archivo. Reemplázalas todas.

- [ ] **Paso 8.5 — Verificar TypeScript sin errores**

```bash
npx tsc --noEmit
```

Esperado: 0 errores.

- [ ] **Paso 8.6 — Verificar en dev server — prueba completa**

```bash
npm run dev
```

Checklist de verificación:

- [ ] KPI "Facturación Bruta" muestra subtítulo con semana/mes (si `comparison` tiene datos)
- [ ] KPI "Activos" muestra "+N nuevos hoy" cuando hay compras hoy
- [ ] KPI "Inversión Total" muestra valor > $0 con filtro "Todos" (si `daily_metrics` tiene investment)
- [ ] KPI "ROAS" muestra valor > 0 con filtro "Todos"
- [ ] Con filtro "AIVI" o "MV3", Investment y ROAS muestran $0 / 0.00x (comportamiento esperado)
- [ ] Tabla de planes muestra filas de familia coloreadas con sub-filas indentadas
- [ ] Columnas Mensual/Anual/Trial tienen valores reales en la tabla
- [ ] Lápiz ✏️ en sidebar abre input de meta → guardar → barra se actualiza → recarga mantiene el valor
- [ ] Botón UTMify en TopNav pasa por los 4 estados correctamente

- [ ] **Paso 8.7 — Commit final**

```bash
git add src/views/DashboardView.tsx
git commit -m "feat: wire KPIRow trends, UTMify sync, and daily goal into DashboardView"
```
