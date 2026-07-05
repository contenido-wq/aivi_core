# Sección de Ingresos por Producto (AIVI, Contenido que Vende con IA, MV3)

**Fecha:** 2026-07-05
**Estado:** Aprobado

## Resumen

Nueva sección en Analytics que muestra ingresos/ventas/ticket promedio para 3 productos específicos vendidos en Hotmart, agrupando por `transactions.plan_name` (que sí tiene datos limpios, a diferencia de `traffic_source` que está roto). Rango de fechas **fijo**: 1 de octubre de 2025 hasta hoy — independiente del selector de fechas de la parte superior de Analytics.

## Mapeo de productos (confirmado con el usuario)

```typescript
const PRODUCT_GROUPS: Record<string, string[]> = {
  "AIVI": [
    "AIVI",
    "AIVI — Creator Lite Semestral",
  ],
  "Contenido que Vende con IA": [
    "Taller: Contenido que V3NDE con Inteligencia Artificial (Marzo 9, 10, 11 y 12)",
    "Taller: Contenido que V3NDE con Inteligencia Artificial (Enero 19, 20, 21 y 22)",
  ],
  "MV3": [
    "Método V3 - [Viralidad, Comunidad y Ventas]",
    "Master Creator - MV3",
    "Master Creator",
  ],
};
```

Cualquier `plan_name` fuera de estas listas (Reto 15D, Pack de plantillas, etc.) queda excluido — no se muestra "otros".

## Diseño

### 1. Servicio (`src/services/analytics.ts`)

```typescript
export interface ProductRevenueRow {
  product:   string;
  revenue:   number;
  sales:     number;
  avgTicket: number;
}

export async function getProductRevenue(): Promise<ProductRevenueRow[]> {
  // from fijo: 2025-10-01. to: hoy, calculado igual que buildRange (hora Colombia).
  // Una sola consulta a transactions (plan_name, amount, currency), status=active,
  // acotada por created_at en ese rango. Se agrupa client-side según PRODUCT_GROUPS.
}
```

- Un solo query a `transactions` (no depende de `DateRange` del picker superior).
- `revenue` usa `toUSD(amount, currency)` igual que el resto del código.
- `avgTicket = sales > 0 ? revenue / sales : 0`.

### 2. Componente nuevo (`src/components/analytics/ProductRevenueTable.tsx`)

Tarjetas o tabla simple: Producto | Ingresos | Ventas | Ticket Promedio, con encabezado "1 oct 2025 - hoy" fijo (no editable).

### 3. Hook (`src/hooks/useAnalyticsData.ts`)

Se agrega `getProductRevenue()` al mismo `Promise.all` de `load()`, expuesto como `productRevenue: ProductRevenueRow[]` en el estado — se refresca junto con todo lo demás (botón ↺), aunque no depende del período seleccionado.

### 4. Vista (`src/views/AnalyticsView.tsx`)

Se agrega `<ProductRevenueTable rows={productRevenue} />` como nueva sección, sin tocar la tabla de LTV existente.

## Criterios de éxito

- Los 3 productos muestran ingresos/ventas/ticket promedio correctos según el mapeo de `plan_name` de arriba.
- El rango 1-oct-2025 a hoy es fijo — cambiar el selector de fechas de la parte superior de Analytics no afecta esta sección.
- Ventas de productos no listados (Reto 15D, etc.) no aparecen en esta sección.
- No se modifica la tabla de LTV existente ni su lógica de atribución por campaña.
