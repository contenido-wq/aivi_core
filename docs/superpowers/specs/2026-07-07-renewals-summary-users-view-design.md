# Spec: Resumen y Filtro de Renovaciones en Trazabilidad de Usuarios

**Fecha:** 2026-07-07
**Estado:** Aprobado

---

## Contexto

El usuario quiere poder revisar cuántos usuarios han renovado y cuántas veces. El dato ya existe: `getUsersTraceability()` (`src/services/dashboard.ts:800-948`) calcula `UserProfile.renewalsCount` por usuario (`Math.max(0, activeTxs.length - 1)`, línea 943) y ya se muestra en el panel de detalle de `UsersView.tsx` (tile "Renovaciones", timeline con etiqueta "Renovación" por transacción).

Lo que falta es una vista agregada y la capacidad de explorar la lista completa por ese criterio — hoy solo se ve uno por uno, seleccionando un usuario a la vez. No se requiere ningún cambio de backend/Supabase: todo el trabajo es de agregación y UI sobre datos que `UsersView.tsx` ya carga en memoria (`users: UserProfile[]`).

---

## Solución

Todo el cambio vive en `src/views/UsersView.tsx`.

### 1. Franja de resumen (nueva, ancho completo, debajo del topbar existente)

Nuevo bloque `<div>` con `gridColumn: "1/-1"` entre el `topbar` y el grid de dos paneles, mismo `background: C.sidebar` / `borderBottom` que el resto de la UI. Contenido:

- `Renovaron: X de Y (Z%)` — `X` = usuarios con `renewalsCount >= 1`, `Y` = `users.length`, `Z` = `Math.round(X/Y*100)`.
- Chips de distribución: `0 renov.`, `1`, `2`, `3+` — cada uno como badge pequeño (mismo estilo que los badges de estado: `borderRadius: 4, fontSize: 9-10, padding: "1px 7px"`), con el conteo de usuarios en cada bucket.

Cálculo agregado con un `useMemo` sobre `users` (mismo alcance que `activeCount`/`ltvProm`/`users.length` ya existentes en el topbar — es decir, refleja el filtro de programa activo (`programFilter`), no los filtros adicionales de estado/búsqueda/renovaciones):

```ts
const renewalStats = useMemo(() => {
  const buckets = { 0: 0, 1: 0, 2: 0, "3+": 0 };
  for (const u of users) {
    const k = u.renewalsCount >= 3 ? "3+" : u.renewalsCount;
    buckets[k]++;
  }
  const renewed = users.length - buckets[0];
  return { buckets, renewed, total: users.length };
}, [users]);
```

### 2. Badge de renovaciones por fila

En cada fila de `filtered.map(u => ...)` (línea ~399-429), junto al badge de estado (`statusBadge(u.status)`) y antes/después del badge de multi-producto existente: si `u.renewalsCount > 0`, mostrar un badge `↻ {u.renewalsCount}` (ícono `Repeat` de `lucide-react`, tamaño 9-10px, color `C.orange` si `renewalsCount >= 3` o `C.mutedLight` si es 1-2, mismo estilo visual que el badge de multi-producto ya existente). Si `renewalsCount === 0`, no se muestra nada (evita ruido visual en la mayoría de filas).

### 3. Filtro por renovaciones

Nuevo estado `const [renewalFilter, setRenewalFilter] = useState<"todos" | "0" | "1+" | "3+">("todos")`.

Nuevo grupo de botones, mismo estilo que el filtro de estado existente (línea 351-366), insertado inmediatamente debajo de ese filtro:

| Botón | Condición |
|---|---|
| Todos | sin filtro |
| Sin renovar | `renewalsCount === 0` |
| 1+ | `renewalsCount >= 1` |
| 3+ | `renewalsCount >= 3` |

Se aplica dentro del `useMemo` de `filtered` (línea 234-251), como un filtro adicional encadenado (mismo patrón que `statusFilter`).

### 4. Ordenar por renovaciones

Nuevo estado `const [sortBy, setSortBy] = useState<"ltv" | "renewals">("ltv")` (default `"ltv"` preserva el comportamiento actual, que ya viene pre-ordenado por LTV desde `getUsersTraceability`).

Los encabezados de columna (línea 387-389, hoy texto estático `Usuario` / `LTV`) se vuelven botones clickeables; se agrega un tercer encabezado `Renovaciones`. Click en `LTV` o `Renovaciones` alterna `sortBy` y reordena `filtered` (orden descendente por el campo elegido — no se agrega orden ascendente/descendente configurable, para no sobre-diseñar algo que no se pidió). El encabezado activo se resalta en `C.orange`.

---

## Lo que NO cambia

- `getUsersTraceability()` / `src/services/dashboard.ts` — sin cambios, el dato ya existe.
- El panel de detalle (`rightPanel`) y su tile de "Renovaciones" — sin cambios.
- El resto de filtros existentes (programa, búsqueda, multiProducto) — siguen funcionando igual, se combinan con el nuevo filtro de renovaciones.
- No se agrega ninguna vista/ruta nueva — todo vive dentro de `UsersView.tsx` existente.

---

## Archivos a modificar

| Archivo | Cambio |
|---|---|
| `src/views/UsersView.tsx` | Franja de resumen, badge por fila, filtro de renovaciones, encabezados ordenables |

---

## Criterios de éxito

- Debajo del topbar de Trazabilidad de Usuarios se ve cuántos usuarios renovaron (X de Y, Z%) y la distribución 0/1/2/3+.
- Cada usuario con `renewalsCount > 0` muestra su badge de renovaciones en la lista, sin necesidad de abrir el detalle.
- El filtro "Sin renovar / 1+ / 3+" reduce la lista correctamente y es combinable con los filtros existentes.
- Click en el encabezado "Renovaciones" ordena la lista de mayor a menor número de renovaciones; click en "LTV" vuelve al orden por LTV.
- El resumen y los filtros respetan el `programFilter` activo (AIVI/MV3/Reto15D/Todos), igual que las estadísticas actuales del topbar.
