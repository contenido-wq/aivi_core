# Selector de Fechas con Panel Desplegable

**Fecha:** 2026-07-04
**Estado:** Aprobado

## Resumen

El selector de período de Analytics hoy son 5 pills fijos: Noche, Día, Hoy, Ayer, 7 días — sin forma de ver más de una semana atrás ni elegir un rango arbitrario. Este cambio reemplaza esos pills por un único botón con panel desplegable que ofrece 6 presets (Hoy, Ayer, 7 días, Mes, 3 Meses, Total) más un rango de fechas personalizado vía dos campos de fecha nativos — sin agregar dependencias nuevas (no hay librería de calendario en el proyecto; se usa `<input type="date">`).

"Noche"/"Día" (ventanas horarias 8pm-8am / 8am-10pm) se eliminan por completo, reemplazados enteramente por el nuevo set de 6 presets.

---

## 1. Períodos (`src/services/analytics.ts`)

### `PeriodKey` (modificado)

```typescript
export type PeriodKey = "hoy" | "ayer" | "7dias" | "mes" | "3meses" | "total" | "custom";
```

### `buildRange` (modificado)

- Se eliminan los casos `"noche"` y `"dia"`.
- Se agregan:
  - `"mes"` → últimos 30 días rolling (mismo patrón que `"7dias"`, ventana `[hoy - 29 días, hoy]`).
  - `"3meses"` → últimos 90 días rolling (`[hoy - 89 días, hoy]`).
  - `"total"` → `from` fijo en `"2020-01-01"` (fecha ancla anterior a cualquier dato real del negocio), `to` = hoy.
- Los casos `"hoy"`, `"ayer"`, `"7dias"`, `"custom"` no cambian.

```typescript
export function buildRange(key: PeriodKey, custom?: { from: string; to: string }): DateRange {
  // ... (today/yesterday sin cambios)
  if (key === "custom" && custom) { /* sin cambios */ }
  if (key === "ayer")   { /* sin cambios */ }
  if (key === "7dias")  { /* sin cambios */ }
  if (key === "mes") {
    const from30 = ymd(new Date(col.getTime() - 29 * 86400000));
    return { from: from30, to: today, fromTs: `${from30}T00:00:00`, toTs: `${today}T23:59:59` };
  }
  if (key === "3meses") {
    const from90 = ymd(new Date(col.getTime() - 89 * 86400000));
    return { from: from90, to: today, fromTs: `${from90}T00:00:00`, toTs: `${today}T23:59:59` };
  }
  if (key === "total") {
    return { from: "2020-01-01", to: today, fromTs: "2020-01-01T00:00:00", toTs: `${today}T23:59:59` };
  }
  // default: "hoy"
  return { from: today, to: today, fromTs: `${today}T00:00:00`, toTs: `${today}T23:59:59` };
}
```

---

## 2. Componente nuevo: `DateRangePicker`

**Archivo:** `src/components/analytics/DateRangePicker.tsx`

### Props

```typescript
interface Props {
  period: PeriodKey;
  range:  DateRange | null;
  onSelect: (key: PeriodKey, custom?: { from: string; to: string }) => void;
}
```

(La firma coincide exactamente con `setPeriod` ya expuesto por `useAnalyticsData` — se pasa directo, sin adaptador.)

### Comportamiento

- Botón principal: muestra la etiqueta del preset activo ("Hoy", "Ayer", "7 días", "Mes", "3 Meses", "Total"), o si `period === "custom"`, el rango formateado `DD/MM - DD/MM` a partir de `range.from`/`range.to`.
- Clic en el botón abre/cierra un panel flotante (`position: absolute`, anclado debajo del botón).
- Dentro del panel:
  - 6 botones verticales, uno por preset. Clic → llama `onSelect(key)` y cierra el panel.
  - Separador, luego dos `<input type="date">` (Desde / Hasta), inicializados con `range?.from`/`range?.to` si `period === "custom"`, o vacíos en otro caso.
  - Botón "Aplicar": deshabilitado si falta alguna fecha. Al hacer clic, si `desde > hasta` se intercambian antes de llamar `onSelect("custom", { from, to })`; cierra el panel.
- Clic fuera del panel (o en el botón principal de nuevo) lo cierra sin aplicar cambios pendientes en los inputs de fecha.

---

## 3. Integración en `AnalyticsView.tsx`

- Se elimina el bloque de pills `(["noche", "dia", "hoy", "ayer", "7dias"] as PeriodKey[]).map(...)`.
- Se elimina `PERIOD_LABELS` (ya no aplica — las etiquetas viven dentro de `DateRangePicker`).
- Se reemplaza por:
  ```tsx
  <DateRangePicker period={period} range={range} onSelect={setPeriod} />
  ```
  en el mismo lugar del top bar donde estaban los pills, junto al botón de refresh (↺, sin cambios).
- El label usado en `AIAnalyst`/`runAIAnalysis` (`labels: Record<PeriodKey, string>` en `useAnalyticsData.ts`) se actualiza para reflejar las nuevas claves.

---

## Criterios de éxito

- Los 6 presets calculan el rango correcto (verificable comparando `KPISummary`/`funnel` antes y después para "Hoy"/"Ayer"/"7 días", que no cambian de comportamiento).
- "Mes" y "3 Meses" traen datos de hasta 30 y 90 días atrás respectivamente.
- "Total" trae todo el histórico sin excluir transacciones antiguas.
- Rango personalizado con fechas invertidas (Desde > Hasta) se corrige automáticamente antes de aplicar.
- El panel se cierra correctamente en todos los casos (selección de preset, aplicar custom, clic afuera).
- No se agregan dependencias nuevas al `package.json`.
