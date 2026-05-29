# Transactions View — Paginación, Filtro de Producto y Año 2026 por Defecto

## Goal

Reemplazar el límite estático de 500 filas con paginación server-side real (50 filas/página), conectar el filtro de producto AIVI/MV3/Todos a la consulta, y establecer 2026 como año por defecto al abrir la vista.

---

## Cambios por Archivo

### `src/services/dashboard.ts`

**`getFullTransactions` — nuevos parámetros**

```typescript
export async function getFullTransactions(
  category: TxCategory,
  startDate: Date | null,
  endDate: Date | null,
  search: string = "",
  productFilter: ProductFilter = "todos",
  page: number = 1,
  pageSize: number = 50
): Promise<Transaction[]>
```

- `productFilter`: filtra `plan_name` con `ilike` en Supabase:
  - `"AIVI"` → `.ilike("plan_name", "AIVI%")`
  - `"MV3"` → `.or("plan_name.ilike.Método V3%,plan_name.ilike.MV3%")`
  - `"todos"` → sin filtro adicional
- Paginación: `.range((page - 1) * pageSize, page * pageSize - 1)` (reemplaza `.limit(500)`)
- La búsqueda por texto (nombre/email/teléfono) se mantiene como filtro client-side sobre las filas retornadas

**Nueva función `getTransactionCount`**

```typescript
export async function getTransactionCount(
  category: TxCategory,
  startDate: Date | null,
  endDate: Date | null,
  search: string = "",
  productFilter: ProductFilter = "todos"
): Promise<number>
```

- Mismos filtros que `getFullTransactions` pero usa `.select("*", { count: "exact", head: true })`
- Retorna `data.count ?? 0`
- No incluye la búsqueda de texto (se cuenta sobre el total sin filtro de texto — aceptable porque la búsqueda filtra localmente sobre las 50 filas cargadas)

---

### `src/views/TransactionsView.tsx`

**Estado nuevo**
```typescript
const [currentPage, setCurrentPage] = useState(1);
const [totalCount, setTotalCount]   = useState(0);
const PAGE_SIZE = 50;
```

**Fecha por defecto**
```typescript
const [startDate, setStartDate] = useState("2026-01-01");  // cambia de "" a "2026-01-01"
const [endDate, setEndDate]     = useState("");
```

**`load` actualizado**
- Llama `getFullTransactions(activeTab, start, end, search, filter, currentPage, PAGE_SIZE)`
- Llama `getTransactionCount(activeTab, start, end, search, filter)` en paralelo
- Ambas llamadas en `Promise.all` para una sola espera

**Reset de página**
- `currentPage` se resetea a `1` cuando cambia: `activeTab`, `startDate`, `endDate`, `search`, o `filter`
- Implementado con un `useEffect` separado que observa esas dependencias

**Filtro de producto conectado**
- El estado `filter` ya existe en el componente pero no se pasaba a `getFullTransactions` — se pasa ahora

**Controles de paginación** (al fondo de la tabla, solo visible cuando `rows.length > 0`)

```
← Anterior    Página 3 de 12 · 582 registros    Siguiente →
```

- `totalPages = Math.ceil(totalCount / PAGE_SIZE)`
- Botón "Anterior" deshabilitado en página 1
- Botón "Siguiente" deshabilitado en última página
- Texto central: `Página {currentPage} de {totalPages} · {totalCount} registros`

---

## Comportamiento

| Acción | Resultado |
|--------|-----------|
| Abrir vista | Carga 2026-01-01 → hoy, categoría "Compras Aprobadas", página 1 |
| Cambiar tab | Reset a página 1, carga nueva categoría |
| Cambiar filtro AIVI/MV3 | Reset a página 1, recarga con filtro |
| Búsqueda de texto | Filtra las 50 filas de la página actual (no recarga) |
| Click Limpiar | Reset fechas a 2026-01-01/"", búsqueda vacía, página 1 |
| Click Anterior/Siguiente | Cambia página, recarga filas |

---

## Lo que NO cambia

- Las 11 columnas de la tabla (incluyendo "Fuente Tráfico" con SSK)
- La exportación CSV (exporta las filas de la página actual)
- El layout con Sidebar
- Los 6 tabs de categorías
- El filtro de fechas manual

---

## Archivos a Modificar

| Archivo | Cambio |
|---------|--------|
| `src/services/dashboard.ts` | Nuevos params en `getFullTransactions`, nueva función `getTransactionCount` |
| `src/views/TransactionsView.tsx` | Estado paginación, fecha default 2026, filtro conectado, controles UI |
