# Transactions Pagination Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Agregar paginación server-side (50 filas/página) a la vista de Transacciones, conectar el filtro de producto AIVI/MV3/Todos a la consulta, y mostrar datos de 2026 por defecto.

**Architecture:** Se extiende `getFullTransactions` con parámetros de filtro de producto y paginación usando `.range()` de Supabase. Se agrega `getTransactionCount` para calcular el total de páginas. `TransactionsView` agrega estado de paginación, resetea la página al cambiar filtros, y renderiza controles Anterior/Siguiente al fondo de la tabla.

**Tech Stack:** Supabase JS client (`.range()`, `.select("*", { count: "exact", head: true })`), React useState/useEffect, TypeScript, tokens de diseño `C` existentes.

---

## Mapa de Archivos

| Acción | Archivo |
|--------|---------|
| Modificar | `src/services/dashboard.ts` (líneas ~791-828) |
| Modificar | `src/views/TransactionsView.tsx` (líneas ~35-56 estado, ~87-105 load, ~fondo tabla) |

---

## Task 1: Extender `getFullTransactions` y agregar `getTransactionCount`

**Files:**
- Modify: `src/services/dashboard.ts`

- [ ] **Step 1: Leer el archivo para ubicar las líneas exactas**

```bash
grep -n "getFullTransactions\|getTransactionCount\|limit(500)" src/services/dashboard.ts
```

Esperado: líneas alrededor de 791-828 con `getFullTransactions` y `.limit(500)`.

- [ ] **Step 2: Reemplazar `getFullTransactions` con la nueva firma**

Localizar la función completa (desde `export async function getFullTransactions` hasta su cierre `}`). Reemplazar con:

```typescript
export async function getFullTransactions(
  category: TxCategory,
  startDate: Date | null,
  endDate: Date | null,
  search: string = "",
  productFilter: ProductFilter = "todos",
  page: number = 1,
  pageSize: number = 50
): Promise<Transaction[]> {
  const statuses = STATUS_BY_CATEGORY[category];
  const from     = (page - 1) * pageSize;
  const to       = from + pageSize - 1;

  let query = supabase
    .from("transactions")
    .select("id, hotmart_id, event_type, buyer_name, buyer_email, buyer_phone, buyer_country, offer_code, sale_origin, traffic_source, plan_name, amount, currency, created_at, status")
    .in("status", statuses)
    .order("created_at", { ascending: false })
    .range(from, to);

  if (startDate) {
    const { start } = localDayRange(startDate);
    query = query.gte("created_at", start);
  }
  if (endDate) {
    const { end } = localDayRange(endDate);
    query = query.lte("created_at", end);
  }
  if (productFilter === "AIVI") {
    query = query.ilike("plan_name", "AIVI%");
  } else if (productFilter === "MV3") {
    query = query.or("plan_name.ilike.Método V3%,plan_name.ilike.MV3%");
  }

  const { data } = await query;
  const rows = (data ?? []) as any[];

  const lowerSearch = search.toLowerCase().trim();
  const filtered = lowerSearch
    ? rows.filter((r) =>
        (r.buyer_name  ?? "").toLowerCase().includes(lowerSearch) ||
        (r.buyer_email ?? "").toLowerCase().includes(lowerSearch) ||
        (r.buyer_phone ?? "").toLowerCase().includes(lowerSearch)
      )
    : rows;

  return filtered.map(mapTransaction);
}
```

- [ ] **Step 3: Agregar `getTransactionCount` justo después de `getFullTransactions`**

Insertar la siguiente función inmediatamente después del cierre `}` de `getFullTransactions` y antes de `syncToday`:

```typescript
export async function getTransactionCount(
  category: TxCategory,
  startDate: Date | null,
  endDate: Date | null,
  productFilter: ProductFilter = "todos"
): Promise<number> {
  const statuses = STATUS_BY_CATEGORY[category];

  let query = supabase
    .from("transactions")
    .select("*", { count: "exact", head: true })
    .in("status", statuses);

  if (startDate) {
    const { start } = localDayRange(startDate);
    query = query.gte("created_at", start);
  }
  if (endDate) {
    const { end } = localDayRange(endDate);
    query = query.lte("created_at", end);
  }
  if (productFilter === "AIVI") {
    query = query.ilike("plan_name", "AIVI%");
  } else if (productFilter === "MV3") {
    query = query.or("plan_name.ilike.Método V3%,plan_name.ilike.MV3%");
  }

  const { count } = await query;
  return count ?? 0;
}
```

- [ ] **Step 4: Verificar TypeScript**

```bash
npx tsc --noEmit 2>&1 | head -20
```

Esperado: sin errores relacionados con `getFullTransactions` o `getTransactionCount`.

- [ ] **Step 5: Commit**

```bash
git add src/services/dashboard.ts
git commit -m "feat: getFullTransactions con productFilter y paginación; agrega getTransactionCount"
```

---

## Task 2: Actualizar TransactionsView — estado, carga y controles de paginación

**Files:**
- Modify: `src/views/TransactionsView.tsx`

### Paso A — Actualizar imports y estado

- [ ] **Step 1: Agregar `getTransactionCount` al import de dashboard**

Localizar:
```typescript
import {
  getFullTransactions,
  type Transaction,
  type TxCategory,
  type ProductFilter,
} from "../services/dashboard";
```

Reemplazar con:
```typescript
import {
  getFullTransactions,
  getTransactionCount,
  type Transaction,
  type TxCategory,
  type ProductFilter,
} from "../services/dashboard";
```

- [ ] **Step 2: Actualizar el bloque de estado en el componente**

Localizar el bloque actual (líneas ~35-42):
```typescript
  const [activeTab, setActiveTab] = useState<TxCategory>("compras");
  const [rows, setRows]           = useState<Transaction[]>([]);
  const [loading, setLoading]     = useState(false);
  const [search, setSearch]       = useState("");
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate]     = useState("");
```

Reemplazar con:
```typescript
  const PAGE_SIZE = 50;

  const [activeTab, setActiveTab]   = useState<TxCategory>("compras");
  const [rows, setRows]             = useState<Transaction[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [loading, setLoading]       = useState(false);
  const [search, setSearch]         = useState("");
  const [startDate, setStartDate]   = useState("2026-01-01");
  const [endDate, setEndDate]       = useState("");
```

### Paso B — Actualizar la función `load`

- [ ] **Step 3: Reemplazar `load` con la versión que usa paginación y filtro de producto**

Localizar el `useCallback` actual (líneas ~44-54):
```typescript
  const load = useCallback(async () => {
    setLoading(true);
    try {
      const start = startDate ? new Date(startDate) : null;
      const end   = endDate   ? new Date(endDate)   : null;
      const data  = await getFullTransactions(activeTab, start, end, search);
      setRows(data);
    } finally {
      setLoading(false);
    }
  }, [activeTab, startDate, endDate, search]);
```

Reemplazar con:
```typescript
  const load = useCallback(async () => {
    setLoading(true);
    try {
      const start = startDate ? new Date(startDate) : null;
      const end   = endDate   ? new Date(endDate)   : null;
      const [data, total] = await Promise.all([
        getFullTransactions(activeTab, start, end, search, filter, currentPage, PAGE_SIZE),
        getTransactionCount(activeTab, start, end, filter),
      ]);
      setRows(data);
      setTotalCount(total);
    } finally {
      setLoading(false);
    }
  }, [activeTab, startDate, endDate, search, filter, currentPage]);
```

### Paso C — Resetear página al cambiar filtros

- [ ] **Step 4: Agregar `useEffect` que resetea `currentPage` a 1 cuando cambian los filtros**

Insertar después de `useEffect(() => { load(); }, [load]);`:

```typescript
  useEffect(() => {
    setCurrentPage(1);
  }, [activeTab, startDate, endDate, filter]);
```

### Paso D — Actualizar el botón "Limpiar"

- [ ] **Step 5: Actualizar el botón Limpiar para que también resetee la página y restaure la fecha 2026**

Localizar:
```typescript
onClick={() => { setStartDate(""); setEndDate(""); setSearch(""); }}
```

Reemplazar con:
```typescript
onClick={() => { setStartDate("2026-01-01"); setEndDate(""); setSearch(""); setCurrentPage(1); }}
```

### Paso E — Agregar controles de paginación al fondo de la tabla

- [ ] **Step 6: Agregar los controles de paginación como hermano del bloque tabla**

La estructura actual del contenido scrolleable es:
```
<div style={{ flex:1, overflowY:"auto", ... }}>   ← scrollable externo
  {/* Tabs */}   <div>...</div>
  {/* Filters */} <div>...</div>
  {/* Table */}   <div style={{ flex:1, overflowX:"auto" }}>...</div>
  ← AQUÍ va la paginación (fuera del overflowX para no scrollear horizontalmente)
</div>
```

Localizar el comentario `{/* Table */}` y su `</div>` de cierre. Agregar el bloque de paginación DESPUÉS de ese `</div>`, como hermano al mismo nivel:

```tsx
          {/* Paginación */}
          {totalCount > 0 && (() => {
            const totalPages = Math.ceil(totalCount / PAGE_SIZE);
            return (
              <div style={{
                display: "flex", alignItems: "center", justifyContent: "center",
                gap: 16, padding: "14px 20px",
                borderTop: `1px solid ${C.border}`,
                background: C.panel,
                flexShrink: 0,
              }}>
                <button
                  onClick={() => setCurrentPage((p) => Math.max(1, p - 1))}
                  disabled={currentPage === 1}
                  style={{
                    padding: "6px 14px", borderRadius: 8, fontSize: 12, fontWeight: 700,
                    background: currentPage === 1 ? C.card : C.orange,
                    border: "none",
                    color: currentPage === 1 ? C.muted : "#fff",
                    cursor: currentPage === 1 ? "not-allowed" : "pointer",
                  }}
                >
                  ← Anterior
                </button>
                <span style={{ fontSize: 12, color: C.mutedLight }}>
                  Página <strong style={{ color: C.white }}>{currentPage}</strong> de{" "}
                  <strong style={{ color: C.white }}>{totalPages || 1}</strong>
                  <span style={{ color: C.muted }}> · {totalCount.toLocaleString()} registros</span>
                </span>
                <button
                  onClick={() => setCurrentPage((p) => Math.min(totalPages, p + 1))}
                  disabled={currentPage >= totalPages}
                  style={{
                    padding: "6px 14px", borderRadius: 8, fontSize: 12, fontWeight: 700,
                    background: currentPage >= totalPages ? C.card : C.orange,
                    border: "none",
                    color: currentPage >= totalPages ? C.muted : "#fff",
                    cursor: currentPage >= totalPages ? "not-allowed" : "pointer",
                  }}
                >
                  Siguiente →
                </button>
              </div>
            );
          })()}
```

- [ ] **Step 7: Actualizar el texto del header para mostrar la página actual**

Localizar:
```tsx
            {loading ? "Cargando..." : `${rows.length} registros · ${activeCategory.label}`}
```

Reemplazar con:
```tsx
            {loading
              ? "Cargando..."
              : `${totalCount.toLocaleString()} registros · ${activeCategory.label}`}
```

- [ ] **Step 8: Verificar TypeScript**

```bash
npx tsc --noEmit 2>&1 | head -20
```

Esperado: 0 errores.

- [ ] **Step 9: Commit**

```bash
git add src/views/TransactionsView.tsx
git commit -m "feat: paginación server-side 50/página, filtro producto, fecha 2026 por defecto"
```

---

## Task 3: Verificación manual

- [ ] **Step 1: Levantar el servidor de desarrollo**

```bash
npm run dev
```

- [ ] **Step 2: Verificar estado inicial**

1. Ir a la app → click en "Transacciones"
2. La tabla debe mostrar datos de 2026 (el campo de fecha debe mostrar "2026-01-01")
3. El header debe mostrar el total real de registros (ej: "582 registros · Compras Aprobadas")
4. Los controles de paginación deben aparecer al fondo: `← Anterior  Página 1 de 12  Siguiente →`

- [ ] **Step 3: Verificar navegación de páginas**

1. Click en "Siguiente →" → la tabla carga la página 2, el indicador muestra "Página 2 de 12"
2. Click en "← Anterior" → regresa a página 1
3. "← Anterior" debe estar deshabilitado (gris) en página 1
4. "Siguiente →" debe estar deshabilitado en la última página

- [ ] **Step 4: Verificar reset de página al cambiar filtros**

1. Navegar a página 3
2. Click en tab "Cancelaciones" → debe volver a página 1 automáticamente
3. Navegar a página 2
4. Cambiar filtro del Sidebar a "AIVI" → debe volver a página 1

- [ ] **Step 5: Verificar filtro de producto**

1. Con filtro "AIVI" activo: todas las filas deben tener plan_name que empiece con "AIVI"
2. Con filtro "MV3": todas las filas deben tener plan_name con "Método V3" o "MV3"
3. Con filtro "Todos": sin restricción de plan

- [ ] **Step 6: Verificar búsqueda de texto**

1. Buscar "maria" → filtra las 50 filas de la página actual
2. El total de registros en el header NO cambia (la búsqueda es client-side sobre la página)

- [ ] **Step 7: Commit de cierre si todo funciona**

```bash
git add -A
git commit -m "feat: transacciones completa — paginación, filtro producto, 2026 por defecto"
git push origin main
```
