# Spec: Tarjeta KPI de Renovaciones en el Dashboard

**Fecha:** 2026-07-07
**Estado:** Aprobado

---

## Contexto

Ya existe (spec `2026-07-07-renewals-summary-users-view-design.md`) un resumen de renovaciones en Trazabilidad de Usuarios, calculado sobre `UserProfile.renewalsCount` (que viene de `getUsersTraceability()`, una función pesada: trae hasta 50.000 transacciones + 50.000 suscripciones y arma un perfil completo por usuario). El usuario ahora quiere ver este mismo dato también en el Dashboard principal.

`DashboardView.tsx` no usa `getUsersTraceability()` — carga sus datos vía `useDashboardData()` (`src/hooks/useDashboardData.ts`), que dispara 11 queries livianas y específicas en paralelo (`getKPIs`, `getPlansBreakdown`, `getAtRiskUsers`, etc.). Reusar `getUsersTraceability()` en el Dashboard encarecería la carga inicial sin necesidad, ya que el Dashboard no necesita el historial completo por usuario — solo el conteo agregado.

---

## Solución

### 1. Nueva función liviana: `getRenewalSummary()`

En `src/services/dashboard.ts`, junto a `getAtRiskUsers`/`getUsersTraceability`:

```ts
export interface RenewalSummary {
  renewed: number;
  total:   number;
  buckets: { "0": number; "1": number; "2": number; "3+": number };
}

export async function getRenewalSummary(filter: ProductFilter = "todos"): Promise<RenewalSummary> {
  const { data: allTx } = await supabase
    .from("transactions")
    .select("buyer_email, plan_name, status")
    .in("status", ["active", "delayed"])
    .limit(50000);

  const counts: Record<string, number> = {};
  for (const tx of allTx ?? []) {
    if (!tx.buyer_email || tx.buyer_email === "—") continue;
    if (!matchesPlan(tx.plan_name, filter)) continue;
    counts[tx.buyer_email] = (counts[tx.buyer_email] ?? 0) + 1;
  }

  const buckets = { "0": 0, "1": 0, "2": 0, "3+": 0 };
  for (const count of Object.values(counts)) {
    const renewals = Math.max(0, count - 1);
    const k = renewals >= 3 ? "3+" : (String(renewals) as "0" | "1" | "2");
    buckets[k]++;
  }
  const total   = Object.keys(counts).length;
  const renewed = total - buckets["0"];
  return { renewed, total, buckets };
}
```

Mismo criterio que `renewalsCount` en `getUsersTraceability` (`activeTxs.length - 1`, contando transacciones `active`/`delayed`), pero sin construir el perfil completo — solo `buyer_email`, `plan_name`, `status` por fila, y solo cuenta.

### 2. Wire en `useDashboardData`

`src/hooks/useDashboardData.ts`:
- Importar `getRenewalSummary` y el tipo `RenewalSummary`.
- Agregar `renewalSummary: RenewalSummary | null` a `DashboardState` (default `null` en `EMPTY`).
- Agregar `getRenewalSummary(filter)` al `Promise.all` existente (12vo elemento) y al `setState(...)`.

### 3. Nueva tarjeta KPI en `KPIRow.tsx`

- Importar ícono `Repeat` de `lucide-react`.
- Nueva prop `renewalSummary?: RenewalSummary | null`.
- Nueva `<KPICard>` (5ta): icono `Repeat`, label "Renovaron", `value` = `renewalSummary?.renewed ?? 0`, `valueColor={C.orange}`, `sub` = `${pct}% de la base` donde `pct = total > 0 ? Math.round(renewed/total*100) : 0`.
- `gridCols` desktop pasa de `"1.4fr 1fr 1fr 1fr"` (4 columnas) a `"1.2fr 1fr 1fr 1fr 1fr"` (5 columnas). Mobile/tablet se mantienen en `repeat(2, 1fr)` (la 5ta tarjeta cae en una fila propia, sin cambios de breakpoint).

### 4. `DashboardView.tsx`

- Destructurar `renewalSummary` del resultado de `useDashboardData(...)`.
- Pasar `renewalSummary={renewalSummary}` en los 3 usos existentes de `<KPIRow>` (línea ~126, ~162, ~204 — layout desktop pantalla corta, desktop alto, y mobile/tablet).

---

## Lo que NO cambia

- `getUsersTraceability()` y todo lo de `UsersView.tsx` — sin tocar.
- El resto de `KPIRow` (Facturación, Inversión, ROAS, Activos/Cancelados) — sin cambios de comportamiento.
- No se agrega ningún desglose 0/1/2/3+ en el Dashboard (eso ya vive en Trazabilidad de Usuarios) — aquí solo el total de usuarios que renovaron, por decisión explícita del usuario (tarjeta KPI simple, no panel detallado).

---

## Archivos a modificar

| Archivo | Cambio |
|---|---|
| `src/services/dashboard.ts` | Nueva función `getRenewalSummary` + tipo `RenewalSummary` |
| `src/hooks/useDashboardData.ts` | Wire de la nueva query al estado |
| `src/components/dashboard/KPIRow.tsx` | Nueva tarjeta KPI + ajuste de grid a 5 columnas |
| `src/views/DashboardView.tsx` | Pasar `renewalSummary` a los 3 usos de `<KPIRow>` |

---

## Criterios de éxito

- El Dashboard muestra una 5ta tarjeta KPI "Renovaron" con el conteo de usuarios y su % sobre la base, respetando el filtro de producto activo (Todos/AIVI/MV3/Reto15D).
- La carga inicial del Dashboard no se vuelve notablemente más lenta (la nueva query es liviana: solo 3 columnas, sin parseo de `raw_payload` ni construcción de historial completo).
- En mobile/tablet la tarjeta se acomoda en el grid de 2 columnas sin romper el layout.
