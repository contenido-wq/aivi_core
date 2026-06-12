# Dashboard AIVI Core — Mejoras (Enfoque B)

**Fecha:** 2026-06-11  
**Vista afectada:** `src/views/DashboardView.tsx`  
**Archivos afectados:** `src/services/dashboard.ts`, `src/components/dashboard/KPIRow.tsx`, `src/components/dashboard/UsersTable.tsx`, `src/components/dashboard/TopNav.tsx`, `src/components/layout/Sidebar.tsx`, `src/hooks/useDashboardData.ts`

---

## Objetivo

Corregir datos incorrectos y mostrar información que ya se carga pero no se visualiza. Sin cambios en el layout general. Sin nuevas consultas a Supabase salvo la lectura de inversión histórica en `getKPIs()`.

---

## Cambios por área

### 1. KPI Row — Inversión, ROAS y tendencias

**Problema actual:** `getKPIs()` retorna `investment: 0` y `roas: 0` hardcodeados. `ComparisonData` (ayer/semana/mes) se carga en `useDashboardData` pero nunca llega a ningún componente.

**Solución:**

#### `src/services/dashboard.ts` — `getKPIs()`

Agregar consulta a `daily_metrics` para sumar inversión histórica:

```typescript
const { data: metricRows } = await supabase
  .from("daily_metrics")
  .select("investment");

const totalInvestment = (metricRows ?? [])
  .reduce((s: number, r: any) => s + Number(r.investment ?? 0), 0);

const roas = totalInvestment > 0 ? grossRevenue / totalInvestment : 0;
```

Retornar `investment: totalInvestment` y `roas` calculado (ya no hardcodeados en 0).

> **Nota:** La inversión acumulada histórica aplica al filtro `todos` y no cambia con el filtro de producto. Cuando `filter !== "todos"`, mostrar `investment: 0` y `roas: 0` para evitar datos engañosos, ya que UTMify no discrimina por producto.

#### `src/components/dashboard/KPIRow.tsx`

Agregar prop `comparison: ComparisonData | null`.

Cambios visuales por card:

| Card | Subtítulo actual | Subtítulo nuevo |
|---|---|---|
| Facturación Bruta (hero) | "N meses activo" | "N meses · semana $X · mes $X" |
| Inversión Total | — | "acumulado histórico" |
| ROAS | "Ingresos / Inversión" | badge `↑ vs ayer Xx` si hay dato |
| Activos / Cancel | — | badge `+N nuevos hoy` si `daily.newUsers > 0` |
| Atrasados | "Pagos pendientes" | sin cambio |

Los badges de tendencia usan el sistema existente de colores (`C.green`, `C.red`, `C.yellow`). Formato: `span` inline con `fontSize: 9`, fondo semitransparente, sin romper el layout actual.

`KPIRow` recibe `daily: DailyData | null` como prop adicional para acceder a `daily.newUsers` (nuevos compradores de hoy). No requiere pasar `comparison` al componente ya que `weekRevenue` y `monthRevenue` se extraen en `DashboardView` y se pasan directamente como props opcionales `weekRevenue` y `monthRevenue`.

#### `src/views/DashboardView.tsx`

Pasar `daily` y las métricas de comparación al `KPIRow`:

```tsx
<KPIRow
  kpis={kpis}
  daily={daily}
  weekRevenue={comparison?.weekRevenue ?? 0}
  monthRevenue={comparison?.monthRevenue ?? 0}
/>
```

Las variables `daily` y `comparison` ya existen en el estado de `useDashboardData` — solo faltaba pasarlas.

---

### 2. Tabla "Usuarios por Plan" — agrupada por familia

**Problema actual:** `PlanRow` no tiene campos `mensual`, `trimestral`, `anual`, `trial`. `UsersTable` los accede con `(p as any).mensual` → siempre `0`.

**Solución:**

#### `src/services/dashboard.ts` — `PlanRow` y `getPlansBreakdown()`

Extender la interfaz:

```typescript
export interface PlanRow {
  name:       string;
  family:     string;   // nuevo — familia del producto
  active:     number;
  cancelled:  number;
  delayed:    number;
  mensual:    number;   // nuevo
  anual:      number;   // nuevo
  trial:      number;   // nuevo
}
```

En `getPlansBreakdown()`, detectar el período de facturación por palabras clave en el nombre del plan (case-insensitive):

- Contiene `"mensual"` o `"monthly"` → `mensual++`
- Contiene `"anual"` o `"annual"` o `"yearly"` → `anual++`
- Contiene `"trial"` → `trial++`
- Cualquier otro activo → `mensual++` como fallback

Usar `getProductFamily()` (ya existente en `dashboard.ts`) para asignar el campo `family`.

#### `src/components/dashboard/UsersTable.tsx`

Agrupar los planes por `family` antes de renderizar. Estructura de renderizado:

```
[Fila de familia — fondo sutil, nombre en color de producto]
  [Sub-fila plan 1 — indent izquierdo, texto muted]
  [Sub-fila plan 2]
[Fila de familia siguiente]
...
[Fila de Total]
```

Las sub-filas son siempre visibles (sin toggle/collapse). Las familias se ordenan por `active` descendente. Los totales de familia se calculan sumando sus sub-planes.

Columnas: `Plan | Activos | Cancel. | Mensual | Anual | Trial`  
Eliminar la columna `Trimestral` — no existe ese período en los datos actuales de Hotmart.

---

### 3. Meta diaria configurable

**Problema actual:** `const dailyGoal = 400` hardcodeado en `Sidebar.tsx` (línea 178) y `DailyPanel.tsx` (línea 34).

**Solución:**

#### Nuevo hook `src/hooks/useDailyGoal.ts`

```typescript
const STORAGE_KEY = "aivi_daily_goal";
const DEFAULT_GOAL = 400;

export function useDailyGoal() {
  const [goal, setGoalState] = useState<number>(() => {
    const stored = localStorage.getItem(STORAGE_KEY);
    return stored ? Number(stored) : DEFAULT_GOAL;
  });

  const setGoal = (value: number) => {
    const safe = Math.max(1, Math.round(value));
    localStorage.setItem(STORAGE_KEY, String(safe));
    setGoalState(safe);
  };

  return { goal, setGoal };
}
```

#### `src/components/layout/Sidebar.tsx`

- Reemplazar `const goal = 400` por `const { goal, setGoal } = useDailyGoal()`
- Agregar estado local `const [editing, setEditing] = useState(false)`
- Junto al label "Meta diaria", renderizar un ícono ✏️ (`<Pencil size={10} />` de lucide-react)
- Al hacer click en ✏️: mostrar `<input type="number">` con el valor actual + botones "Guardar" / "×"
- Al guardar: llamar `setGoal(value)` y `setEditing(false)`
- Al cancelar (Escape o "×"): `setEditing(false)` sin guardar
- El `DailyPanel.tsx` standalone no se usa en el dashboard — no requiere cambio activo, queda como componente inactivo

---

### 4. Botón Sync UTMify en TopNav

**Contexto:** La Edge Function `supabase/functions/utmify-sync/index.ts` ya existe y escribe en `daily_metrics.investment`. No hay forma de triggerearla manualmente desde el frontend actualmente.

**Solución:**

#### `src/services/dashboard.ts` — nueva función `syncUtmify()`

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

#### `src/components/dashboard/TopNav.tsx`

Agregar prop `onSyncUtmify?: () => Promise<{ ok: boolean; totalInvestment?: number; error?: string }>`.

Estado local del botón: `"idle" | "loading" | "ok" | "error"` con mensaje de resultado.

Cuatro estados visuales:
- **idle**: fondo neutro, texto "⚡ Sync UTMify" — borde naranja al hover
- **loading**: fondo naranja suave, ícono `<RefreshCw>` girando, texto "Sincronizando..."
- **ok**: fondo verde suave, texto "✓ $XXX sincronizado" — vuelve a idle después de 2 segundos
- **error**: fondo rojo suave, texto "✗ Error UTMify" — vuelve a idle después de 2 segundos

Al completarse con éxito, llamar `onSync()` (el refresh existente del dashboard) para recargar los KPIs con la inversión actualizada.

#### `src/views/DashboardView.tsx`

```tsx
const handleSyncUtmify = useCallback(async () => {
  const result = await syncUtmify();
  if (result.ok) await refresh();
  return result;
}, [refresh]);

<TopNav
  ...
  onSyncUtmify={handleSyncUtmify}
/>
```

---

## Lo que NO cambia

- Layout general del dashboard (grid, alturas, breakpoints)
- `AtRiskPanel`, `ChartPanel`, `CountriesPanel`, `TransactionsPanel`, `DashFooter`
- Consultas a Supabase en `getDailyMetrics()`, `getTransactions()`, `getAtRiskUsers()`
- El botón "Sync Hotmart" existente en `TopNav` (el nuevo botón UTMify es adicional)
- La Edge Function `utmify-sync` (no se modifica, solo se llama)
- Vistas `UsersView` y `TransactionsView`

---

## Criterios de éxito

1. Los KPI cards de Inversión y ROAS muestran valores mayores a $0 cuando `utmify-sync` ha corrido
2. La card de Facturación Bruta muestra totales de semana y mes en el subtítulo
3. La card de Activos muestra "+N nuevos hoy" cuando `daily.newUsers > 0`
4. La tabla de planes muestra filas de familia con sub-filas por plan, y las columnas Mensual/Anual/Trial tienen valores reales (no 0)
5. Hacer click en ✏️ de meta diaria abre el input; guardar persiste en localStorage y la barra de progreso se actualiza inmediatamente
6. El botón "Sync UTMify" completa el ciclo idle→loading→ok y los KPIs se recargan tras el éxito
7. En filtro de producto distinto de "todos", Investment y ROAS muestran 0 sin causar errores
