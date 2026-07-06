# Atribución y métricas a nivel de Anuncio (Anuncio × VSL)

**Fecha:** 2026-07-06
**Estado:** Aprobado (pendiente de plan de implementación)

**Revisión 2026-07-06:** se elimina la tabla `vsl_pitch_marks` y la pestaña manual de configuración de pitch. La documentación pública de la API de VTurb confirma que `pitch_time` ya es nativo por VSL (vía `GET /players/list`), así que se lee de ahí en vez de construir configuración propia. Ver secciones 1, 2.3, 3 y 4.4.

## Resumen

Hoy toda la sección de Analytics (`AnalyticsView.tsx` y sus bloques: funnel, ranking, heatmap, LTV) agrupa por **campaña** (`transactions.traffic_source`). Esto es una capa arriba de lo que el usuario necesita para decidir presupuesto: dentro de una misma campaña de Meta pueden correr varios anuncios (creativos) distintos, cada uno potencialmente apuntando a un VSL distinto, y hoy no hay forma de saber cuál anuncio específico es el ganador — solo se sabe qué campaña gana.

**Hallazgo clave que habilita este proyecto:** Meta ya envía `campaña|adset|ad|placement` concatenado en `purchase.tracking.external_code` de cada venta de Hotmart (constante `EXTERNAL_CODE_DELIMITER = "hQwK21wXxR"`, ver `supabase/functions/hotmart-webhook/index.ts:24-35`). El parser actual (`extractCampaignFromExternalCode`) solo extrae `parts[1]` (la campaña, confirmado correcto contra ~3000 transacciones históricas según el comentario existente en el código) y **descarta el resto**. Este proyecto deja de tirar ese dato y lo convierte en atribución a nivel de anuncio individual.

Los 3 actores/fuentes de datos involucrados no cambian, solo se extienden:
- **Hotmart** — ventas + el rastro de campaña/adset/anuncio/placement en `tracking.external_code`.
- **UTMify** — proxy de la API de Meta Ads (inversión, impresiones, clicks), vía `get_meta_ad_objects` con parámetro `level`.
- **VTurb** — analítica del reproductor de video (plays, views, retención, dimensiones).

No se agrega un cuarto actor ni un sync nuevo — se extienden los 3 syncs existentes (`hotmart-webhook`/`hotmart-sync`, `utmify-sync`, `vturb-sync`).

---

## 1. Arquitectura de datos

### Cambios en `transactions`

Nuevas columnas, parseadas del `external_code` completo (hoy solo se guarda `traffic_source` = segmento de campaña):

```sql
ad_id         text
ad_name       text
adset_id      text
adset_name    text
placement     text
```

### Nueva tabla: `ad_investment_data`

Espejo de `campaign_investment_data` pero a nivel `ad`, poblada por `utmify-sync` pidiendo `level: "ad"` a `get_meta_ad_objects` (hoy solo se pide `"campaign"` y `"account"`):

```sql
id            uuid primary key
ad_id         text not null
ad_name       text
campaign_id   text
campaign_name text
date          date not null
platform      text default 'facebook'
investment    numeric(10,2) default 0
impressions   integer default 0
clicks        integer default 0
synced_at     timestamptz default now()
unique(ad_id, date, platform)
```

### Nueva tabla: `ad_vsl_mapping`

Override opcional de VSL a nivel de anuncio individual. Si un anuncio no tiene entrada aquí, hereda el VSL de su campaña vía `campaign_vsl_mapping` (comportamiento actual, sin cambios):

```sql
ad_id       text primary key
video_id    text not null
video_name  text
created_at  timestamptz default now()
```

### Cambios en `vturb_analytics`

Nuevas columnas:

```sql
unique_views  integer default 0
unique_plays  integer default 0
pitch_second  integer
```

**No se crea tabla `vsl_pitch_marks`.** La documentación pública de la API de VTurb (`vturb.gitbook.io/analytics-api/analytics`) confirma que `pitch_time` ya es una propiedad nativa configurada por VSL dentro del propio dashboard de VTurb — el endpoint `GET /players/list` (que `vturb-sync` ya llama para enriquecer `video_name`) devuelve `pitch_time` en la misma respuesta. Se guarda como `pitch_second` en `vturb_analytics` durante ese mismo enriquecimiento, sin tabla ni UI de configuración manual nueva. Si un VSL no tiene `pitch_time` configurado en VTurb, su fila queda con `pitch_second = null` y "audiencia del pitch" no se muestra para ese VSL hasta que se configure allá — no aquí.

---

## 2. Cambios de ingestión

### 2.1 `hotmart-webhook` / `hotmart-sync` — parsear todos los segmentos

Se reemplaza `extractCampaignFromExternalCode()` por `extractTrackingSegments()`, que devuelve los 4 segmentos (`campaign`, `adset`, `ad`, `placement`) con sus IDs. Se guardan en las nuevas columnas de `transactions`, y `traffic_source`/`sale_origin` no cambian (siguen siendo el campo de campaña que ya usa todo lo existente).

> ⚠️ **Validación requerida antes de escribir el parser (primer paso de la implementación):** solo `parts[1]` (campaña) está confirmado contra datos reales. Nunca se ha extraído ni verificado a qué posición corresponden adset/ad/placement dentro de `external_code`. Se debe leer `raw_payload` de 5-10 transacciones reales (`transactions.raw_payload`) y mapear manualmente cada segmento antes de escribir el parser completo — no se debe adivinar el formato ni asumir el orden textual del comentario existente sin verificarlo.

### 2.2 `utmify-sync` — nivel `ad`

Se agrega una función `syncAds()` análoga a `syncCampaigns()`, llamando `get_meta_ad_objects` con `level: "ad"`, poblando `ad_investment_data` con upsert por `(ad_id, date, platform)`. Mismo filtro por `META_ACCOUNT_ID` que ya usa `syncCampaigns`.

Se agrega un endpoint de debug `?debug-ads` (mismo patrón que el `?debug-campaigns` existente) para inspeccionar el raw de Meta a nivel `ad` antes de confiar en el upsert.

### 2.3 `vturb-sync` — vistas/reproducciones únicas + segundo del pitch

Resuelto contra la documentación pública de la API (`vturb.gitbook.io/analytics-api/analytics`), sin necesidad de investigación en producción:

- **Únicos:** el endpoint que ya se llama hoy, `POST /events/total_by_company_players`, documenta que su respuesta trae métricas de unicidad (`total`, `total_uniq_sessions`, `total_uniq_device`) — el código actual (`vturb-sync/index.ts:82-94`) solo lee `e.total` y descarta el resto. Se usa `total_uniq_sessions` como `unique_views`/`unique_plays` (unicidad por sesión, más representativa de "personas distintas" que por dispositivo). El nombre exacto del campo en la respuesta real se confirma con el endpoint de debug (abajo) antes de escribir el parser final, ya que la documentación no publica el JSON de ejemplo completo.
- **`pitch_second`:** `GET /players/list` (ya se llama para enriquecer `video_name`) devuelve `pitch_time` por player. Se guarda como `pitch_second` en el mismo paso de enriquecimiento.

Se agrega un endpoint de debug `?debug` que devuelve el raw de VTurb (incluyendo la respuesta cruda de `/events/total_by_company_players` y `/players/list`) sin hacer el upsert, para confirmar los nombres exactos de campo antes de escribir a `vturb_analytics`.

---

## 3. Métricas nuevas y fórmula de score

| Métrica | Nivel | Cómo se calcula |
|---|---|---|
| Vistas | VSL (`video_id`) | ya existe — eventos `viewed` de VTurb |
| Vistas únicas | VSL (`video_id`) | nueva — usuarios únicos en eventos `viewed` (sujeto a 2.3) |
| Reproducciones | VSL (`video_id`) | ya existe — eventos `started` de VTurb |
| Reproducciones únicas | VSL (`video_id`) | nueva — usuarios únicos en eventos `started` (sujeto a 2.3) |
| Tasa de reproducción | VSL (`video_id`) | ya existe — `reproducciones ÷ vistas × 100` |
| Engagement | VSL (`video_id`) | nueva — promedio de la curva de retención completa (0-100%) a lo largo de toda la duración del video |
| Audiencia del pitch | VSL (`video_id`) | nueva — % de retención en `vturb_analytics.pitch_second` (interpolado sobre la curva de `vturb_retention`, mismo patrón que el helper `getAt(pct)` ya usado en `getVSLRetention`) |
| Inversión, clicks, CAC, ROI, ventas, conv. rate | **Anuncio** (`ad_id`) | por anuncio individual, cruzando `ad_investment_data` + ventas atribuidas por `transactions.ad_id` |

**Nota de diseño:** engagement y audiencia del pitch son propiedades del VSL, no del anuncio. Dos anuncios distintos que comparten el mismo VSL mostrarán el mismo engagement/audiencia del pitch, pero pueden tener CAC/ROI/score muy distintos (esos sí son específicos del anuncio). La fila final de la tabla de ranking combina ambos niveles: eficiencia del anuncio + calidad del VSL que usa.

### Fórmula de score (reemplaza la actual `ROI×50% + conv.rate×50%` en `classifyAd`/scoring de `analytics.ts`)

```
score = ROI_norm × 0.30
      + conv_rate_norm × 0.20
      + audiencia_pitch_norm × 0.30
      + engagement_norm × 0.20
```

Pesos implementados como constantes nombradas (no mágicas) en `analytics.ts`, ajustables sin tocar la lógica una vez haya datos reales para calibrar.

---

## 4. UI / Componentes

### 4.1 `CampaignFunnelCard.tsx` — drill-down

Se agrega un chevron expandible. Al abrir, muestra debajo las filas de anuncios individuales de esa campaña (nombre del anuncio, VSL, CAC, ROI, ventas, score), usando `ad_vsl_mapping` + `ad_investment_data` filtrados por `campaignName`.

### 4.2 `AdRankingTable.tsx` (nuevo componente)

Bloque nuevo en `AnalyticsView.tsx`, ordenado por Score descendente. Columnas: Anuncio · VSL · Inversión · CAC · ROI · Vistas · Vistas únicas · Reproducciones · Reproducciones únicas · Tasa Repr. · Engagement · Audiencia Pitch · Score · Acción (reutiliza `classifyAd`). Cada fila tiene un control "ⓘ" que expande el detalle crudo (`ad_id`, `adset_name`/`adset_id`, `placement`) para diagnóstico, sin ensuciar la tabla principal.

### 4.3 `VSLIntelligencePanel.tsx` → pestaña "Fuente de tráfico"

`AdSourceView` hoy muestra campañas (heredado de cuando solo existía ese nivel de atribución, ver `docs/superpowers/specs/2026-07-04-vsl-ad-attribution-scale-kill-design.md`). Se actualiza para mostrar los anuncios reales atribuidos a ese VSL, con las mismas columnas de `AdRankingTable`. Las `KpiCard` existentes del panel (Hook/Retención/CTA) ganan tarjetas nuevas: **Engagement**, **Audiencia del pitch**, **Vistas/Vistas únicas**, **Reproducciones/Reproducciones únicas**.

### 4.4 `CampaignMappingModal.tsx` — 1 pestaña nueva

- **"Anuncio → VSL (override)"**: opcional, solo para anuncios cuyo VSL difiere del de su campaña. Sin override, se hereda el mapeo de campaña (comportamiento actual sin cambios).

No se agrega pestaña de "marca de pitch" — `pitch_second` se lee directamente de VTurb (ver 2.3), no se configura en este modal.

---

## 5. Testing y verificación

Sin suite de tests automatizados en el proyecto (Vite + `tsc -b`, sin Jest/Vitest) — la verificación sigue el patrón ya usado por los syncs existentes: endpoints de debug + backfill acotado + reconciliación contra las fuentes originales.

1. **Antes de escribir el parser de Hotmart:** confirmar el orden real de segmentos contra `raw_payload` de transacciones reales (ver advertencia en 2.1).
2. **Endpoints de debug:** `vturb-sync?debug`, `utmify-sync?debug-ads` — inspeccionar raw antes de escribir cualquier upsert nuevo.
3. **Backfill acotado:** correr cada sync extendido sobre 1-2 días antes del backfill histórico completo.
4. **Reconciliación:**
   - Suma de inversión por anuncio (`ad_investment_data`) de un día = suma de inversión por campaña (`campaign_investment_data`) del mismo día.
   - Suma de ventas atribuidas por `ad_id` en un período = total de ventas por `traffic_source` del mismo período (ningún anuncio "pierde" ventas en la migración).
   - Vistas/reproducciones (únicas y totales) de un VSL activo comparadas manualmente contra el dashboard propio de VTurb para el mismo rango.
5. **Checklist manual de UI:**
   - Expandir una `CampaignFunnelCard` con anuncios reales — las filas hijas deben sumar igual que la tarjeta padre.
   - El anuncio #1 de `AdRankingTable` debe coincidir con el de mejor CAC/ROI visible en Meta Ads Manager para ese período.
   - Comparar "Audiencia del pitch" de un VSL con `pitch_time` configurado en VTurb contra el número que muestra el propio dashboard de VTurb para ese mismo player, para confirmar que la interpolación sobre `vturb_retention` da un resultado coherente.
   - Guardar un override anuncio→VSL y confirmar que ese anuncio deja de heredar el VSL de su campaña.

---

## Archivos a crear

| Archivo | Tipo |
|---|---|
| `supabase/migrations/20260706170000_ad_level_attribution.sql` | Migración (`ad_investment_data`, `ad_vsl_mapping`, columnas nuevas en `transactions` y `vturb_analytics`) |
| `src/components/analytics/AdRankingTable.tsx` | Bloque 4.2 |

## Archivos a modificar

| Archivo | Cambio |
|---|---|
| `supabase/functions/hotmart-webhook/index.ts` | `extractTrackingSegments()` reemplaza `extractCampaignFromExternalCode()`; guarda `ad_id`/`ad_name`/`adset_id`/`adset_name`/`placement` |
| `supabase/functions/hotmart-sync/index.ts` | Mismo cambio de parseo (equivalente al webhook) |
| `supabase/functions/utmify-sync/index.ts` | Nueva `syncAds()` (nivel `ad`), endpoint `?debug-ads` |
| `supabase/functions/vturb-sync/index.ts` | Captura de `unique_views`/`unique_plays`/`pitch_second`, endpoint `?debug` |
| `src/services/analytics.ts` | Nuevos tipos (`AdVSLRow` o extensión de `AdRankRow`), nuevas funciones de query, fórmula de score actualizada con pesos nombrados |
| `src/components/analytics/CampaignFunnelCard.tsx` | Drill-down expandible |
| `src/components/analytics/VSLIntelligencePanel.tsx` | `AdSourceView` actualizado a nivel de anuncio, nuevas `KpiCard` |
| `src/components/analytics/CampaignMappingModal.tsx` | Pestaña "Anuncio → VSL (override)" |

## Consideraciones de seguridad

- `ad_investment_data`, `ad_vsl_mapping`: RLS habilitado, lectura solo con auth (mismo criterio que las tablas existentes de analytics).
- Las nuevas columnas de `transactions` (`ad_id`, `ad_name`, `adset_id`, `adset_name`, `placement`) no incluyen PII adicional — son identificadores de campaña publicitaria de Meta, no datos del comprador.
