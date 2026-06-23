# VSL Command Center — Design Spec
**Fecha:** 2026-06-23  
**Vista:** `AnalyticsView` (`src/views/AnalyticsView.tsx`)  
**Estado:** Aprobado por usuario

---

## Objetivo

Convertir la vista de Analytics en un **Centro de Decisión por VSL**: el usuario selecciona un VSL, ve la salud del video (Vturb) y el rendimiento de cada anuncio que envía tráfico a ese VSL (UTMify + Hotmart), y toma decisiones de escalar/pausar con datos — no por impulso.

**Pregunta que responde en 10 segundos:** *¿Qué anuncios de este VSL escalo hoy y cuáles apago?*

---

## Contexto técnico

### Fuentes de datos existentes
| Tabla Supabase | Qué aporta |
|---|---|
| `vturb_analytics` | plays, button_clicks por video_id + date |
| `vturb_retention` | curva de retención por segundo (video_id + date) |
| `campaign_investment_data` | investment, impressions, clicks por campaign_name + date |
| `campaign_vsl_mapping` | puente campaign_name → video_id + video_name |
| `transactions` | ventas con traffic_source (UTM), amount |

### Tipos existentes relevantes
```typescript
VSLData        // videoId, videoName, plays, ret25/50/75, ctaClicks, sales, convRate, retention[], dropSecond
VSLMapping     // campaignName, videoId, videoName
AdRankRow      // campaignName, investment, clicks, impressions, plays, sales, cac, roas, score, videoName
FunnelCampaign // campaignName, videoId, investment, impressions, clicks, plays, ctaClicks, sales, cac, roas
```

### Lógica de conexión VSL → Campañas
`campaign_vsl_mapping` es el puente. Dado un `videoId` seleccionado:
1. Filtrar `AdRankRow[]` donde `videoName` coincide con el VSL seleccionado
2. Filtrar `FunnelCampaign[]` donde `videoId` coincide
3. Los `VSLData` ya vienen por video — seleccionar el que corresponde

---

## Arquitectura de la solución

### Cambios en `useAnalyticsData`
Agregar al estado:
```typescript
selectedVslId:  string | null   // videoId del VSL primario
compareVslId:   string | null   // videoId del VSL de comparación (opcional)
setSelectedVsl: (id: string | null) => void
setCompareVsl:  (id: string | null) => void
```

No se hacen nuevas queries. Los datos ya se cargan; simplemente se exponen los setters de filtro. El filtrado ocurre con `useMemo` en el hook o en la vista.

### Cambios en `AnalyticsView`
Agrega la `VSLSelectorBar` debajo del header. Pasa `selectedVslId` / `compareVslId` a los paneles que necesitan filtrar.

---

## Componentes nuevos

### 1. `VSLSelectorBar`
**Archivo:** `src/components/analytics/VSLSelectorBar.tsx`

**Responsabilidad:** Mostrar chips de VSL disponibles. Manejar selección primaria y modo comparación.

**Props:**
```typescript
interface VSLSelectorBarProps {
  vsls:           VSLData[]
  selectedId:     string | null
  compareId:      string | null
  onSelect:       (id: string) => void
  onCompare:      (id: string | null) => void
}
```

**Comportamiento:**
- Un chip por cada `VSLData` en el sistema. El primero se preselecciona al cargar.
- Chip activo: borde naranja + fondo sutil.
- Botón "+ Comparar" aparece solo si hay 2+ VSLs disponibles y hay uno seleccionado. Al hacer click, muestra chips secundarios para elegir el VSL de comparación.
- Si `compareId` está activo, el botón cambia a "× Comparar" para desactivar.
- En mobile: scroll horizontal de chips.

---

### 2. `VSLIntelligencePanel`
**Archivo:** `src/components/analytics/VSLIntelligencePanel.tsx`

**Responsabilidad:** Mostrar la salud completa del VSL seleccionado — retención, métricas clave y veredicto editorial. Cuando hay `compareVsl`, muestra las dos curvas en el mismo chart.

**Props:**
```typescript
interface VSLIntelligencePanelProps {
  primary:  VSLData | null
  compare?: VSLData | null
}
```

**Layout — 3 columnas en desktop, apilado en mobile:**

**Columna 1 — Curva de retención:**
- `LineChart` de Recharts con `retention[]` del VSL primario
- Si hay `compare`, agrega segunda línea en color distinto
- `ReferenceDot` rojo en `dropSecond` con label: *"Audiencia abandona aquí"*
- Eje X: tiempo en MM:SS. Eje Y: 0–100%

**Columna 2 — Métricas del video:**
```
Plays total          [valor]
Play Rate            [%] — plays / views
Retención 25%        [%]
Retención 50%        [%]
Retención 75%        [%]
CTA Click Rate       [%] — ctaClicks / plays
Conv. Rate           [%]
```
Cada métrica con color semántico (verde/amarillo/rojo según umbrales).

**Columna 3 — Veredicto:**
Tres filas de score con puntos visuales (●●● = bueno, ●●○ = medio, ●○○ = débil):
- **Hook** (retención a los 30s): basado en `ret25`
- **Retención media** (ret50): qué tan bien mantiene la atención
- **Cierre** (CTA rate): si el video convierte la atención en intención

Los umbrales son:
| Score | Hook (ret25) | Retención (ret50) | CTA Rate |
|---|---|---|---|
| ●●● | ≥ 60% | ≥ 40% | ≥ 8% |
| ●●○ | 40–59% | 25–39% | 4–7% |
| ●○○ | < 40% | < 25% | < 4% |

---

### 3. `ScaleRadar`
**Archivo:** `src/components/analytics/ScaleRadar.tsx`

**Responsabilidad:** Resumen de decisión inmediata — cuántos anuncios escalar, pausar y monitorear.

**Props:**
```typescript
interface ScaleRadarProps {
  campaigns:  FilteredCampaign[]   // campañas ya filtradas por VSL
  cacTarget:  number
  ticketMin?: number               // ticket mínimo para considerar escalar (opcional, default 0)
}
```

**Lógica de clasificación:**
```
ESCALAR  → cac ≤ cacTarget  AND  roas ≥ 2.0  AND  sales ≥ 1
PAUSAR   → cac > cacTarget * 1.5  OR  roas < 1.0
MONITOREAR → resto (borderline o sin ventas aún)
```

**UI:** Tres chips grandes con icono, conteo y lista expandible de nombres de campaña al hacer hover/click.

---

## Componentes modificados

### `AdsRankingTable`
**Cambio:** Acepta prop `vslFilter?: string | null`. Cuando está activo, muestra solo filas donde `row.videoName` coincide con el VSL seleccionado. Si no hay filtro, comportamiento actual.

Agrega columna **Acción** al final:
- `ESCALAR` (verde) — badge con fondo `rgba(48,209,88,0.12)`, borde verde
- `PAUSAR` (rojo) — badge rojo
- `MONITOREAR` (amarillo) — badge amarillo
- Lógica de clasificación: igual que `ScaleRadar`

### `CampaignFunnelCard` / sección Funnels
La sección en `AnalyticsView` filtra el array `funnel[]` por `videoId` del VSL seleccionado antes de pasarlo. No se toca el componente `CampaignFunnelCard`.

### `KPISummary`
**Cambio:** Acepta prop `vslFilter?: string | null`. Cuando está activo, recalcula los KPIs solo con las campañas mapeadas al VSL. Requiere pasar también los `funnel[]` filtrados para sumar investment/sales.

Alternativa más simple (preferida): mostrar una nota bajo los KPIs cuando hay filtro activo: *"Filtrando por VSL Principal"* — y calcular los totales sumando solo las campañas filtradas.

### `HourlyHeatmap`
**No se filtra por VSL en esta versión.** Filtrar el heatmap requeriría reescribir `getHourlyHeatmap()` para cruzar `traffic_source` con `campaign_vsl_mapping`, lo que añade complejidad sin un beneficio proporcional. Queda como vista global del período seleccionado. Se puede filtrar en una iteración futura.

### `LTVTable`
Sin cambios — es por fuente UTM, no por VSL.

### `VSLComparator`
**Eliminado como bloque independiente.** Su funcionalidad de curva de retención queda absorbida dentro de `VSLIntelligencePanel`. La tabla comparativa de métricas (plays, ret25/50/75, CTA, conv) se mueve a `VSLIntelligencePanel` columna 2, y cuando hay comparación, muestra dos columnas paralelas.

---

## Flujo de datos

```
useAnalyticsData()
  ├── vsls[]         → VSLSelectorBar (chips disponibles)
  │                  → VSLIntelligencePanel (primary + compare)
  ├── selectedVslId  → filtra funnel[], ranking[]
  ├── funnel[]       → filtrado por videoId → CampaignFunnelCard section + KPISummary
  ├── ranking[]      → filtrado por videoId → AdsRankingTable + ScaleRadar
  ├── heatmap[]      → HourlyHeatmap (global, sin filtro VSL en esta versión)
  └── ltv[]          → LTVTable (sin filtro VSL — es por fuente UTM)
```

El filtrado ocurre en `AnalyticsView` con `useMemo`:
```typescript
const filteredFunnel  = useMemo(() => selectedVslId ? funnel.filter(f => f.videoId === selectedVslId) : funnel, [funnel, selectedVslId])
const filteredRanking = useMemo(() => selectedVslId ? ranking.filter(r => r.videoId === selectedVslId) : ranking, [ranking, selectedVslId])
```

> **Nota:** `AdRankRow` actualmente no incluye `videoId`. Se debe agregar este campo en `services/analytics.ts` tanto en la interfaz como en el `map()` dentro de `getAdsRanking()`.

---

## Modo Comparación

Cuando `compareVslId` está activo:
- `VSLIntelligencePanel` muestra dos líneas en el chart (colores distintos: naranja primario, amarillo comparación)
- Columna 2 (métricas) muestra dos columnas paralelas con los valores de cada VSL
- Columna 3 (veredicto) muestra scores de ambos uno bajo el otro
- El resto de la vista (Ads, Funnel, Heatmap) **no** cambia — sigue filtrando por el VSL primario únicamente. La comparación es solo editorial/video, no de campañas.

---

## Layout final de `AnalyticsView`

```
Header (período)
VSLSelectorBar                          ← NUEVO
VSLIntelligencePanel                    ← NUEVO (reemplaza VSLComparator)
ScaleRadar                              ← NUEVO
Alertas (sin cambio)
KPISummary (con filtro VSL)             ← MODIFICADO
Funnels por Campaña (filtrado)          ← MODIFICADO (filtro en view)
AdsRankingTable (filtrado + col Acción) ← MODIFICADO
HourlyHeatmap (filtrado)                ← sin cambio en componente
LTVTable                                ← sin cambio
AIAnalyst                               ← sin cambio
```

---

## Métricas clave expuestas (checklist del trafficker)

| Métrica | Fuente | Dónde aparece | Decisión |
|---|---|---|---|
| Play Rate | Vturb | VSLIntelligencePanel | ¿El tráfico está interesado? |
| Retención 25/50/75% | Vturb | VSLIntelligencePanel | ¿El video engancha y retiene? |
| Drop Second | Vturb | Curva con marca roja | ¿Dónde está el problema editorial? |
| CTA Click Rate | Vturb | VSLIntelligencePanel | ¿El cierre funciona? |
| CAC por campaña | UTMify+Hotmart | AdsRankingTable | ¿Está dentro del rango? |
| ROAS por campaña | UTMify+Hotmart | AdsRankingTable | ¿Rentable? |
| Ticket promedio por campaña | Hotmart | AdsRankingTable | ¿Atrae el buyer adecuado? |
| Leads (plays atribuidos) | Vturb+Mapping | AdsRankingTable | ¿Cuánto tráfico genera? |
| Escalar / Pausar | Calculado | ScaleRadar + col Acción | Decisión final |

---

## Archivos a crear / modificar

**Crear:**
- `src/components/analytics/VSLSelectorBar.tsx`
- `src/components/analytics/VSLIntelligencePanel.tsx`
- `src/components/analytics/ScaleRadar.tsx`

**Modificar:**
- `src/services/analytics.ts` — agregar `videoId: string | null` a `AdRankRow` y al `map()` en `getAdsRanking()`
- `src/hooks/useAnalyticsData.ts` — agregar `selectedVslId`, `compareVslId`, `ticketMin`, setters
- `src/views/AnalyticsView.tsx` — integrar nueva estructura, filtros `useMemo`
- `src/components/analytics/AdsRankingTable.tsx` — prop `vslFilter`, columna Acción
- `src/components/analytics/KPISummary.tsx` — recalcular totales con `funnel` ya filtrado desde la vista

**Eliminar como bloque independiente:**
- `src/components/analytics/VSLComparator.tsx` — funcionalidad absorbida por `VSLIntelligencePanel`
