# Desglose de Fuente por Celda en el Heatmap de Conversiones

**Fecha:** 2026-07-04
**Estado:** Aprobado

## Resumen

`HourlyHeatmap` ("Conversiones por Hora y Día") muestra cuántas conversiones cayeron en cada bloque hora+día, pero no de dónde vinieron. Este cambio agrega un desglose por campaña/UTM al hacer clic en una celda con conversiones, reutilizando el mismo patrón de agrupación por `traffic_source ?? "Sin UTM"` que ya usan `getVSLBySource`/`getLTVBySource`.

No requiere cambios de base de datos. `getHourlyHeatmap` ya trae todas las transacciones activas del rango en una sola consulta — solo se agrega `traffic_source` al `select` existente.

---

## 1. Capa de servicio (`src/services/analytics.ts`)

### Tipo `HeatmapCell` (ampliado)

```typescript
export interface HeatmapCell {
  hour:      number;
  dow:       number;
  value:     number;
  bySource:  { source: string; count: number }[];  // nuevo, ordenado desc por count
}
```

### `getHourlyHeatmap` (modificado)

- El `select` pasa de `"created_at"` a `"created_at, traffic_source"`.
- Por cada celda `hour-dow`, además de incrementar `value`, se acumula un contador por `tx.traffic_source ?? "Sin UTM"`.
- Al construir el resultado final, cada celda incluye `bySource` como arreglo ordenado descendente por `count`.

No cambia la firma de la función ni quién la consume hoy (`useAnalyticsData` sigue llamándola igual) — `bySource` es un campo adicional en el tipo de retorno.

---

## 2. UI (`src/components/analytics/HourlyHeatmap.tsx`)

### Interacción

- El hover (tooltip flotante actual con "Día Hora → N conversiones") no cambia.
- Nuevo: **clic** en una celda con `value > 0` fija esa celda como "seleccionada" (estado `selectedCell: { h, dow } | null`) y muestra, debajo del grid (reemplazando o junto al tooltip de hover), un panel con el desglose:

```
Mié 8h → 24 conversiones
├─ campana_black_friday      18
├─ campana_retargeting        4
└─ Sin UTM                    2
```

- Clic en la misma celda de nuevo, o en una celda con `value === 0`, deselecciona (oculta el panel).
- Clic en otra celda con conversiones reemplaza el panel por el desglose de esa celda.
- Visualmente: la celda seleccionada obtiene un borde distinto (ej. `border: 2px solid C.orange`) para indicar cuál está activa, sin afectar el borde de hover ya existente.

### Sin datos / celda vacía

- Clic en una celda con `value === 0` no hace nada (no hay panel que mostrar, mismo comportamiento que hoy).

---

## 3. Archivos modificados

| Archivo | Cambio |
|---|---|
| `src/services/analytics.ts` | `HeatmapCell` gana campo `bySource`; `getHourlyHeatmap` agrupa también por `traffic_source` |
| `src/components/analytics/HourlyHeatmap.tsx` | Estado `selectedCell`, `onClick` en cada celda, panel de desglose por fuente |

---

## Criterios de éxito

- Clic en una celda con conversiones muestra el desglose correcto por campaña/UTM, sumando exactamente al `value` de la celda.
- Clic en una celda sin conversiones no hace nada.
- Clic repetido en la misma celda alterna mostrar/ocultar el panel.
- El hover sigue funcionando exactamente igual que antes.
- No hay llamadas adicionales a Supabase — el desglose sale del mismo fetch que ya trae `getHourlyHeatmap`.
