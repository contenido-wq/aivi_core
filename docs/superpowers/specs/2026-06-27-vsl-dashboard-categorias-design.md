# VSL Dashboard por Categorías

**Fecha:** 2026-06-27
**Estado:** Aprobado

## Resumen

Agregar navegación por tabs de dimensiones dentro del `VSLIntelligencePanel`, inspirada en YouTube Studio Analytics. Permite ver el rendimiento del VSL segmentado por país, dispositivo, sistema operativo, navegador y fuente de tráfico — con sincronización automática desde VTurb API.

---

## 1. Base de Datos

### Tablas nuevas (migración: `20260627000001_vturb_dimensions.sql`)

```sql
vturb_by_country (video_id, date, country_code, country_name, plays, views)
vturb_by_device  (video_id, date, device_type, plays, views)
vturb_by_os      (video_id, date, os_name, plays, views)
vturb_by_browser (video_id, date, browser_name, plays, views)
```

- **Unique constraint** por `(video_id, date, dimensión)` — permite upsert idempotente
- **Índice compuesto** `(video_id, date)` en cada tabla — optimiza las queries del panel
- **RLS:** `service_role` escribe, `authenticated` lee (igual al patrón de `vturb_analytics`)

### Fuente de "Países" para conversiones

`transactions.buyer_country` ya existe (llega del webhook Hotmart). Se cruza con `vturb_by_country` para mostrar plays + conversiones reales en el mismo tab.

---

## 2. Sync Automático (`vturb-sync` Edge Function)

### Endpoints VTurb nuevos por player activo

```
POST /events/total_by_device      → { device_type, total }[]
POST /events/total_by_country     → { country_code, country_name, total }[]
POST /events/total_by_browser     → { browser, total }[]
POST /events/total_by_os          → { os, total }[]
```

### Función `syncDimensions(supabase, apiKey, from, to)`

- Obtiene players activos en el período (reutiliza la llamada de `syncRetention`)
- Por cada player activo: llama las 4 dimensiones en `Promise.all` en paralelo
- Upsert por tabla según dimensión
- Fallo en una dimensión no bloquea las otras

### Orden en `runSync`

```
syncAnalytics()    ← sin cambios
syncRetention()    ← sin cambios
syncDimensions()   ← nuevo
```

Cron sin cambios: `30 * * * *` (horario). Los endpoints exactos de VTurb se verifican contra la API real al hacer deploy — el diseño es resiliente a variaciones de nombre.

---

## 3. Capa de Servicio (`src/services/analytics.ts`)

### Tipos nuevos

```typescript
export interface DimensionRow {
  label:       string   // country_name | device_type | os_name | browser_name | source
  code?:       string   // country_code (solo para países)
  plays:       number
  views:       number
  pct:         number   // % del total de plays
  conversions: number   // ventas atribuidas (donde aplica)
}
```

### Funciones nuevas

```typescript
getVSLByCountry(r: DateRange, videoId: string): Promise<DimensionRow[]>
getVSLByDevice (r: DateRange, videoId: string): Promise<DimensionRow[]>
getVSLByOS     (r: DateRange, videoId: string): Promise<DimensionRow[]>
getVSLByBrowser(r: DateRange, videoId: string): Promise<DimensionRow[]>
getVSLBySource (r: DateRange, videoId: string): Promise<DimensionRow[]>
```

- Todas retornan `DimensionRow[]` ordenado por `plays` desc
- `getVSLByCountry` cruza con `transactions.buyer_country` para `conversions`
- `getVSLBySource` cruza `traffic_source` de `transactions` con plays del funnel
- Top 8 filas + agrupa el resto en "Otros" — mantiene charts legibles

---

## 4. Hook (`src/hooks/useAnalyticsData.ts`)

### Estado nuevo

```typescript
type DimensionTab = "general" | "country" | "device" | "os" | "browser" | "source"

activeTab:        DimensionTab
dimensionCache:   Partial<Record<DimensionTab, DimensionRow[]>>
dimensionLoading: boolean
showConversions:  boolean   // toggle independiente
```

### Comportamiento

- **Lazy load con caché:** solo carga `general` al montar. Cada tab fetcha al primer click y guarda en `dimensionCache`.
- **Invalidación de caché:** al cambiar período (`setPeriod`) se limpia `dimensionCache` completo.
- **`showConversions`** es un booleano independiente del tab activo — se pasa al panel para superponer conversiones donde aplique.
- `setActiveTab(tab)` → si `dimensionCache[tab]` existe, no refetch.

---

## 5. UI (`src/components/analytics/VSLIntelligencePanel.tsx`)

### Tab bar (encima del gráfico actual)

```
[ Retención general ] [ Países ] [ Dispositivos ] [ S. Operativo ] [ Navegadores ] [ Fuente de tráfico ]     Conversiones ⬜
```

- Tabs izquierda: pills con color activo en `C.orange`
- Toggle "Conversiones" derecha: aplica sobre cualquier tab compatible
- Mismo alto que el header actual — no agrega altura extra

### Vista por tab

**Retención general** — curva de área existente, sin cambios

**Países** — lista con barra de progreso inline:
```
🇨🇴 Colombia   ████████░░  48%   12 conv.
🇲🇽 México     █████░░░░░  31%   7 conv.
```

**Dispositivos** — 3 KpiCards (Mobile / Desktop / Tablet) + `PieChart` Recharts pequeño

**S. Operativo / Navegadores** — `BarChart` horizontal Recharts, top 8 + "Otros"

**Fuente de tráfico** — misma estructura que Países (barra inline + conversiones)

### Estados de carga

- Loading → skeleton del mismo alto que el chart activo (sin layout shift)
- Sin datos → texto inline discreto, no rompe el panel
- Error → texto rojo pequeño, no bloquea el resto del panel

---

## Archivos afectados

| Archivo | Acción |
|---|---|
| `supabase/migrations/20260627000001_vturb_dimensions.sql` | Nuevo |
| `supabase/functions/vturb-sync/index.ts` | Extender con `syncDimensions` |
| `src/services/analytics.ts` | Agregar 5 funciones + tipo `DimensionRow` |
| `src/hooks/useAnalyticsData.ts` | Agregar estado de tab + lazy cache |
| `src/components/analytics/VSLIntelligencePanel.tsx` | Agregar tab bar + 5 vistas |

---

## Criterios de éxito

- El cron sincroniza las 4 dimensiones sin errores ni impacto en el sync existente
- Cambiar de tab no hace scroll ni layout shift
- El primer click en un tab carga datos en < 500ms
- Cambiar período limpia la caché y refetch al volver a cada tab
- Si VTurb no tiene datos para una dimensión, el tab muestra estado vacío — no error
