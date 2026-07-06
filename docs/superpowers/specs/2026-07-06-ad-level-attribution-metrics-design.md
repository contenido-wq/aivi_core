# Atribución y métricas a nivel de Anuncio (Anuncio × VSL)

**Fecha:** 2026-07-06
**Estado:** Aprobado (pendiente de plan de implementación)

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

### Nueva tabla: `vsl_pitch_marks`

Segundo del video donde arranca el pitch de venta, configurado manualmente por VSL (mismo patrón de configuración manual que `campaign_vsl_mapping`):

```sql
video_id      text primary key
pitch_second  integer not null
updated_at    timestamptz default now()
```

### Cambios en `vturb_analytics`

Nuevas columnas para las métricas únicas:

```sql
unique_views  integer default 0
unique_plays  integer default 0
```

---

## 2. Cambios de ingestión

### 2.1 `hotmart-webhook` / `hotmart-sync` — parsear todos los segmentos

Se reemplaza `extractCampaignFromExternalCode()` por `extractTrackingSegments()`, que devuelve los 4 segmentos (`campaign`, `adset`, `ad`, `placement`) con sus IDs. Se guardan en las nuevas columnas de `transactions`, y `traffic_source`/`sale_origin` no cambian (siguen siendo el campo de campaña que ya usa todo lo existente).

> ⚠️ **Validación requerida antes de escribir el parser (primer paso de la implementación):** solo `parts[1]` (campaña) está confirmado contra datos reales. Nunca se ha extraído ni verificado a qué posición corresponden adset/ad/placement dentro de `external_code`. Se debe leer `raw_payload` de 5-10 transacciones reales (`transactions.raw_payload`) y mapear manualmente cada segmento antes de escribir el parser completo — no se debe adivinar el formato ni asumir el orden textual del comentario existente sin verificarlo.

### 2.2 `utmify-sync` — nivel `ad`

Se agrega una función `syncAds()` análoga a `syncCampaigns()`, llamando `get_meta_ad_objects` con `level: "ad"`, poblando `ad_investment_data` con upsert por `(ad_id, date, platform)`. Mismo filtro por `META_ACCOUNT_ID` que ya usa `syncCampaigns`.

Se agrega un endpoint de debug `?debug-ads` (mismo patrón que el `?debug-campaigns` existente) para inspeccionar el raw de Meta a nivel `ad` antes de confiar en el upsert.

### 2.3 `vturb-sync` — vistas/reproducciones únicas

Se investiga qué endpoint o parámetro de la API de VTurb expone el conteo de usuarios únicos (el dashboard propio de VTurb ya distingue "vistas" de "vistas únicas", confirmado por el usuario) — probablemente un endpoint hermano de `/events/total_by_company_players` o un parámetro `unique=true`. Esta es una tarea de investigación técnica al inicio de la implementación: si la API no expone esto, se reporta como limitación antes de prometerlo en la UI, no se simula ni se aproxima.

Se agrega un endpoint de debug `?debug` que devuelve el raw de VTurb sin hacer el upsert, para confirmar el formato antes de escribir a `vturb_analytics.unique_views`/`unique_plays`.

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
| Audiencia del pitch | VSL (`video_id`) | nueva — % de retención en `vsl_pitch_marks.pitch_second` (interpolado sobre la curva de `vturb_retention`) |
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

### 4.4 `CampaignMappingModal.tsx` — 2 pestañas nuevas

- **"Marca de pitch"**: por VSL, campo para indicar el segundo (o mm:ss) donde arranca el pitch. Guarda en `vsl_pitch_marks`.
- **"Anuncio → VSL (override)"**: opcional, solo para anuncios cuyo VSL difiere del de su campaña. Sin override, se hereda el mapeo de campaña (comportamiento actual sin cambios).

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
   - Marcar el segundo de pitch de un VSL real y confirmar que "Audiencia del pitch" se mueve coherentemente al cambiar el segundo.
   - Guardar un override anuncio→VSL y confirmar que ese anuncio deja de heredar el VSL de su campaña.

---

## Archivos a crear

| Archivo | Tipo |
|---|---|
| `supabase/migrations/20260706000001_ad_level_attribution.sql` | Migración (`ad_investment_data`, `ad_vsl_mapping`, `vsl_pitch_marks`, columnas nuevas en `transactions` y `vturb_analytics`) |
| `src/components/analytics/AdRankingTable.tsx` | Bloque 4.2 |

## Archivos a modificar

| Archivo | Cambio |
|---|---|
| `supabase/functions/hotmart-webhook/index.ts` | `extractTrackingSegments()` reemplaza `extractCampaignFromExternalCode()`; guarda `ad_id`/`ad_name`/`adset_id`/`adset_name`/`placement` |
| `supabase/functions/hotmart-sync/index.ts` | Mismo cambio de parseo (equivalente al webhook) |
| `supabase/functions/utmify-sync/index.ts` | Nueva `syncAds()` (nivel `ad`), endpoint `?debug-ads` |
| `supabase/functions/vturb-sync/index.ts` | Captura de `unique_views`/`unique_plays` (sujeto a investigación de API), endpoint `?debug` |
| `src/services/analytics.ts` | Nuevos tipos (`AdVSLRow` o extensión de `AdRankRow`), nuevas funciones de query, fórmula de score actualizada con pesos nombrados |
| `src/components/analytics/CampaignFunnelCard.tsx` | Drill-down expandible |
| `src/components/analytics/VSLIntelligencePanel.tsx` | `AdSourceView` actualizado a nivel de anuncio, nuevas `KpiCard` |
| `src/components/analytics/CampaignMappingModal.tsx` | Pestañas "Marca de pitch" y "Anuncio → VSL (override)" |

## Consideraciones de seguridad

- `ad_investment_data`, `ad_vsl_mapping`, `vsl_pitch_marks`: RLS habilitado, lectura solo con auth (mismo criterio que las tablas existentes de analytics).
- Las nuevas columnas de `transactions` (`ad_id`, `ad_name`, `adset_id`, `adset_name`, `placement`) no incluyen PII adicional — son identificadores de campaña publicitaria de Meta, no datos del comprador.
