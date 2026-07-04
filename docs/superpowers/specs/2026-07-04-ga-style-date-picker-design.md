# Selector de Fechas Estilo Google Analytics

**Fecha:** 2026-07-04
**Estado:** Aprobado

## Resumen

Reemplaza el panel simple de `DateRangePicker` (lista de 6 presets + 2 `<input type="date">`) por un panel más rico calcado del selector de fechas de Google Analytics: botón con etiqueta `<Preset>: D mon YYYY - D mon YYYY`, panel con 13 presets (radio buttons), dos calendarios de mes visuales lado a lado con navegación por flechas, casilla "Comparar" (solo visual), y botones Cancelar/Actualizar que confirman el cambio explícitamente en vez de aplicar al instante. No se agregan dependencias nuevas (sin librería de calendario).

Simplificaciones acordadas frente al ejemplo:
- Sin dropdowns de mes/año por calendario — solo flechas ‹ › que avanzan ambos calendarios un mes a la vez.
- Los campos Desde/Hasta siguen siendo `<input type="date">` nativos, no texto largo estilizado.
- "Comparar" es una casilla visual sin lógica — no cambia ningún cálculo.

---

## 1. Períodos (`src/services/analytics.ts`)

### `PeriodKey` (reemplaza el set actual)

```typescript
export type PeriodKey =
  | "hoy" | "ayer" | "hoyAyer"
  | "7dias" | "14dias" | "28dias" | "30dias"
  | "estaSemana" | "semanaPasada"
  | "esteMes" | "mesPasado"
  | "maximo" | "custom";
```

Se elimina el set anterior (`"mes" | "3meses" | "total"`), introducido en la sesión anterior — este cambio lo reemplaza por el set completo de 13 presets.

### `buildRange` — nuevos casos

- **`hoyAyer`**: `from = yesterday, to = today`.
- **`14dias` / `28dias` / `30dias`**: mismo patrón rolling que `7dias` (ventana `[hoy - (N-1) días, hoy]`).
- **`estaSemana`**: lunes de la semana actual (semana Lun-Dom) hasta hoy. `dow = col.getDay()`; offset a lunes = `(dow + 6) % 7`.
- **`semanaPasada`**: lunes a domingo de la semana calendario anterior completa (`estaSemana.monday - 7` a `estaSemana.monday - 1`).
- **`esteMes`**: día 1 del mes actual hasta hoy.
- **`mesPasado`**: mes calendario anterior completo (día 1 al último día, `new Date(year, month, 0)` para el último día).
- **`maximo`**: igual que el `"total"` anterior — `from` fijo `"2020-01-01"` hasta hoy (renombrado).

### Formato del botón

Nueva función `formatDateEs(dateStr: string): string` → `"D mon YYYY"` (ej. `"4 jun 2026"`), meses abreviados en español (`ene, feb, mar, abr, may, jun, jul, ago, sep, oct, nov, dic`). El botón muestra: `${PRESET_LABEL[period]}: ${formatDateEs(range.from)} - ${formatDateEs(range.to)}`.

### Labels (`useAnalyticsData.ts` y `DateRangePicker.tsx`)

```typescript
hoy: "Hoy"
ayer: "Ayer"
hoyAyer: "Hoy y ayer"
"7dias": "Últimos 7 días"
"14dias": "Últimos 14 días"
"28dias": "Últimos 28 días"
"30dias": "Últimos 30 días"
estaSemana: "Esta semana"
semanaPasada: "La semana pasada"
esteMes: "Este mes"
mesPasado: "El mes pasado"
maximo: "Máximo"
custom: "Personalizado"
```

---

## 2. Componente nuevo: `MonthCalendar`

**Archivo:** `src/components/analytics/MonthCalendar.tsx`

### Props

```typescript
interface Props {
  year:       number;
  month:      number; // 0-11
  rangeStart: string | null; // YYYY-MM-DD
  rangeEnd:   string | null; // YYYY-MM-DD
  onDayClick: (dateStr: string) => void;
}
```

Renderiza: etiqueta "mon YYYY" (texto, sin dropdown), fila de encabezado Lun-Dom, cuadrícula de días con celdas vacías antes del día 1 (offset Monday-start). Cada celda de día resaltada si cae dentro de `[rangeStart, rangeEnd]`; extremos (`rangeStart`/`rangeEnd`) con estilo más marcado (círculo relleno). Sin datos de otros meses en las celdas vacías (igual que el ejemplo).

---

## 3. `DateRangePicker` — modelo de staging

**Archivo:** `src/components/analytics/DateRangePicker.tsx` (reescritura completa)

### Cambio de comportamiento

Hoy: clic en preset aplica y cierra al instante. Nuevo: todo cambio (preset o clic en calendario) queda en estado "borrador" dentro del panel; solo se aplica al hacer clic en **Actualizar** (o se descarta con **Cancelar**, que cierra sin aplicar).

### Estado interno

```typescript
const [open,        setOpen]        = useState(false);
const [pendingKey,  setPendingKey]  = useState<PeriodKey>(period);
const [pendingFrom, setPendingFrom] = useState("");
const [pendingTo,   setPendingTo]   = useState("");
const [viewYear,    setViewYear]    = useState(...); // año del calendario izquierdo
const [viewMonth,   setViewMonth]   = useState(...); // mes del calendario izquierdo (0-11)
const [selecting,   setSelecting]   = useState<"start" | "end">("start"); // próximo clic de calendario
const [compare,     setCompare]     = useState(false); // visual, sin efecto
```

Al abrir el panel (`open` pasa a `true`): `pendingKey` se inicializa a `period`, `pendingFrom`/`pendingTo` a `range.from`/`range.to` (o recalculados vía `buildRange(period)` si `range` es null), y `viewYear`/`viewMonth` se anclan al mes de `pendingFrom`.

### Interacciones

- **Clic en preset (radio):** `setPendingKey(key)`; recalcula `pendingFrom`/`pendingTo` vía `buildRange(key)`; re-ancla `viewYear`/`viewMonth` al mes de la nueva `pendingFrom`. No cierra el panel.
- **Clic en flechas ‹ ›:** decrementa/incrementa `viewMonth` (con acarreo de año), sin tocar `pendingKey`/`pendingFrom`/`pendingTo`.
- **Clic en un día del calendario:** cambia `pendingKey` a `"custom"` automáticamente.
  - Si `selecting === "start"`: `pendingFrom = fecha`, `pendingTo = ""`, `selecting = "end"`.
  - Si `selecting === "end"`: si `fecha < pendingFrom` se intercambian; se fija `pendingTo`; `selecting` vuelve a `"start"`.
- **Editar inputs Desde/Hasta:** cambia `pendingKey` a `"custom"`, actualiza `pendingFrom`/`pendingTo` directamente.
- **Casilla Comparar:** solo alterna `compare` (booleano local), sin efecto en ningún cálculo.
- **Actualizar:** si `pendingKey !== "custom"` → `onSelect(pendingKey)`; si es `"custom"` → requiere `pendingFrom` y `pendingTo` no vacíos → `onSelect("custom", { from: pendingFrom, to: pendingTo })`. Cierra el panel.
- **Cancelar:** cierra el panel sin llamar `onSelect` — el próximo `open` reinicia el borrador desde `period`/`range` actuales.

### Layout del panel

```
┌─────────────────────────────────────────────────────────┐
│ ○ Hoy                    ‹   jun 2026        jul 2026   › │
│ ○ Ayer                    Lun Mar Mié Jue Vie Sáb Dom     │
│ ○ Hoy y ayer                  1   2   3   4   5   6   7  │
│ ○ Últimos 7 días          ...(cuadrícula)...              │
│ ○ Últimos 14 días                                         │
│ ○ Últimos 28 días         ☐ Comparar                      │
│ ● Últimos 30 días         [Últimos 30 días ▾] [Desde][Hasta]│
│ ○ Esta semana                                              │
│ ○ La semana pasada        Las fechas se muestran en la     │
│ ○ Este mes                Hora de Bogotá                    │
│ ○ El mes pasado                        [Cancelar][Actualizar]│
│ ○ Máximo                                                    │
│ ○ Personalizado                                             │
└─────────────────────────────────────────────────────────┘
```

(El "preset ▾" junto a Desde/Hasta es solo texto mostrando `PRESET_LABEL[pendingKey]`, no un dropdown funcional adicional.)

---

## 4. Archivos afectados

| Archivo | Cambio |
|---|---|
| `src/services/analytics.ts` | `PeriodKey` (13 valores), `buildRange` (nuevos casos), `formatDateEs` |
| `src/hooks/useAnalyticsData.ts` | `labels` record actualizado a los 13 keys |
| `src/components/analytics/MonthCalendar.tsx` | Nuevo — grid de un mes |
| `src/components/analytics/DateRangePicker.tsx` | Reescritura: staging, radios, calendarios dobles, Comparar, footer, Cancelar/Actualizar |

---

## Criterios de éxito

- Los 13 presets calculan el rango correcto (semana/mes calendario vs. rolling — no confundir "Esta semana" con "Últimos 7 días").
- El botón muestra `<Preset>: D mon YYYY - D mon YYYY` para presets y para rango personalizado aplicado.
- Ningún cambio se aplica hasta hacer clic en "Actualizar"; "Cancelar" no modifica nada.
- Clic en calendario alterna correctamente entre fijar inicio y fin del rango; fechas invertidas se corrigen solas.
- Las flechas ‹ › navegan ambos calendarios juntos, sin romper el borrador de fechas ya seleccionado.
- "Comparar" no tiene ningún efecto observable en KPIs u otros datos.
- No se agregan dependencias nuevas al `package.json`.
