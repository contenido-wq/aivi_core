# Atribución y métricas a nivel de Anuncio (Anuncio × VSL) — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bajar la atribución de campaña a anuncio individual (cruzado con VSL), agregando vistas/reproducciones únicas, engagement y audiencia del pitch, para poder identificar exactamente qué anuncio es el ganador.

**Architecture:** Se extienden los 3 syncs existentes (`hotmart-webhook`/`hotmart-sync`, `utmify-sync`, `vturb-sync`) para dejar de descartar datos que Meta/VTurb ya envían, se agregan 2 tablas nuevas (`ad_investment_data`, `ad_vsl_mapping`) + columnas nuevas en `transactions` y `vturb_analytics`, y se agrega una capa de agregación en `analytics.ts` que cruza todo por `ad_id`. La UI gana una tabla de ranking por anuncio, drill-down en las tarjetas de campaña existentes, y la pestaña "Fuente de tráfico" del panel de VSL pasa de mostrar campañas a mostrar anuncios reales.

**Tech Stack:** Next.js/Vite + React 19 + TypeScript, Supabase (Postgres + Edge Functions Deno), Recharts. Sin suite de tests automatizados (`tsc -b` es la única verificación estática) — la verificación de este plan usa endpoints de debug + queries directas contra la base remota, mismo patrón que los syncs existentes.

## Global Constraints

- Proyecto Supabase vinculado: `--project-ref jihyeeimmhfqlpzljrbu` (usar en todo `supabase db push`/`supabase functions deploy`).
- `traffic_source`/`sale_origin` en `transactions` NO cambian de significado ni de cálculo — siguen siendo el campo de campaña ya usado por todo el código existente.
- Ningún dato nuevo de `transactions` (`ad_id`, `ad_name`, `adset_id`, `adset_name`, `placement`) es PII — son identificadores de campaña publicitaria de Meta.
- RLS en toda tabla nueva: `service_all_<tabla>` (`auth.role() = 'service_role'`, `FOR ALL`) + una de lectura/escritura para `authenticated` — mismo patrón que `campaign_investment_data`/`campaign_vsl_mapping` (ver `supabase/migrations/20260622000002_campaign_tables.sql`).
- Fórmula de score: `score = ROI_norm×0.30 + conv_rate_norm×0.20 + audiencia_pitch_norm×0.30 + engagement_norm×0.20`, como constantes nombradas, no mágicas.
- Spec de referencia: `docs/superpowers/specs/2026-07-06-ad-level-attribution-metrics-design.md` (incluye 2 revisiones ya incorporadas: sin tabla `vsl_pitch_marks` — se usa `pitch_time` nativo de VTurb — y sin `campaign_name` en `ad_investment_data` — se resuelve por join).

---

### Task 1: Migración de base de datos

**Files:**
- Create: `supabase/migrations/20260706170000_ad_level_attribution.sql`

**Interfaces:**
- Produces: tablas `public.ad_investment_data` (`ad_id, ad_name, campaign_id, date, platform, investment, impressions, clicks, synced_at`, unique `(ad_id, date, platform)`) y `public.ad_vsl_mapping` (`ad_id` PK, `video_id, video_name, created_at`); columnas nuevas `public.transactions.ad_id/ad_name/adset_id/adset_name/placement` (todas `text`, nullable); columnas nuevas `public.vturb_analytics.unique_views/unique_plays` (`integer default 0`) y `.pitch_second` (`integer`, nullable).

- [ ] **Step 1: Escribir la migración**

```sql
-- supabase/migrations/20260706170000_ad_level_attribution.sql

alter table public.transactions add column if not exists ad_id      text;
alter table public.transactions add column if not exists ad_name    text;
alter table public.transactions add column if not exists adset_id   text;
alter table public.transactions add column if not exists adset_name text;
alter table public.transactions add column if not exists placement  text;

alter table public.vturb_analytics add column if not exists unique_views  integer default 0;
alter table public.vturb_analytics add column if not exists unique_plays integer default 0;
alter table public.vturb_analytics add column if not exists pitch_second integer;

create table if not exists public.ad_investment_data (
  id            uuid primary key default gen_random_uuid(),
  ad_id         text not null,
  ad_name       text,
  campaign_id   text,
  date          date not null,
  platform      text default 'facebook',
  investment    numeric(10,2) default 0,
  impressions   integer default 0,
  clicks        integer default 0,
  synced_at     timestamptz default now(),
  unique(ad_id, date, platform)
);

create table if not exists public.ad_vsl_mapping (
  ad_id      text primary key,
  video_id   text not null,
  video_name text,
  created_at timestamptz default now()
);

alter table public.ad_investment_data enable row level security;
alter table public.ad_vsl_mapping     enable row level security;

create policy "service_all_ad_investment_data" on public.ad_investment_data
  for all using (auth.role() = 'service_role');

create policy "auth_read_ad_investment_data" on public.ad_investment_data
  for select using (auth.role() = 'authenticated');

create policy "service_all_ad_vsl_mapping" on public.ad_vsl_mapping
  for all using (auth.role() = 'service_role');

create policy "auth_all_ad_vsl_mapping" on public.ad_vsl_mapping
  for all using (auth.role() = 'authenticated');
```

- [ ] **Step 2: Aplicar la migración a producción**

Run: `supabase db push --project-ref jihyeeimmhfqlpzljrbu`
Expected: prompt de confirmación con `20260706170000_ad_level_attribution.sql` listado; tras confirmar, `Finished supabase db push.` sin errores.

- [ ] **Step 3: Verificar que las columnas y tablas existen**

Run:
```bash
supabase db query --linked "select table_name, column_name from information_schema.columns where table_name in ('transactions','vturb_analytics','ad_investment_data','ad_vsl_mapping') and column_name in ('ad_id','ad_name','adset_id','adset_name','placement','unique_views','unique_plays','pitch_second','campaign_id','video_id','video_name') order by table_name, column_name;"
```
Expected: filas para las 5 columnas nuevas de `transactions`, las 3 de `vturb_analytics`, y las columnas de `ad_investment_data`/`ad_vsl_mapping`.

- [ ] **Step 4: Verificar las políticas RLS**

Run:
```bash
supabase db query --linked "select tablename, policyname, roles, cmd from pg_policies where tablename in ('ad_investment_data','ad_vsl_mapping') order by tablename, policyname;"
```
Expected: 2 policies por tabla (`service_all_*` con `cmd: ALL`, y `auth_read_ad_investment_data`/`auth_all_ad_vsl_mapping` con `authenticated` en el `qual`).

- [ ] **Step 5: Commit**

```bash
git add supabase/migrations/20260706170000_ad_level_attribution.sql
git commit -m "feat(analytics): agregar tablas y columnas para atribución a nivel de anuncio"
```

---

### Task 2: Parser de tracking de Hotmart (`extractTrackingSegments`)

**Files:**
- Modify: `supabase/functions/hotmart-webhook/index.ts:24-35,118-165`
- Modify: `supabase/functions/hotmart-sync/index.ts:16-27,138-186`

**Interfaces:**
- Produces: función `extractTrackingSegments(externalCode: string | undefined | null): { campaignName: string | null; campaignId: string | null; adsetName: string | null; adsetId: string | null; adName: string | null; adId: string | null; placement: string | null }`, idéntica en ambos archivos.
- Consumes: nada de tasks anteriores (parsing puro).

**Contexto verificado con datos reales** (vía `curl` contra `transactions.raw_payload->purchase->tracking` en producción, dos ventas reales del mismo día):

```
Muestra A: "FBhQwK21wXxR⚪F0 (7) TESTEO DE Creativos AIVI - Venta | AD18_COL|02-07-2026|120249168864620193hQwK21wXxRLATAM - Open | 25-45 Prueba 21_V1|120249196337110193hQwK21wXxRAD21_V1|120249196337130193hQwK21wXxRInstagram_Reels"

Muestra B: "FBhQwK21wXxR⚪F0 (7) TESTEO DE Creativos AIVI - Venta | AD18_COL|02-07-2026|120249168864620193hQwK21wXxRLATAM - Open | 25-45 Prueba AD20_v3|120249196337100193hQwK21wXxRAD20_v3|120249196337120193hQwK21wXxRInstagram_Stories"
```

Separando por el delimitador `hQwK21wXxR`: `parts[0]` es un prefijo estático ("FB"), `parts[1]` = `{campaña}|{id}`, `parts[2]` = `{adset}|{id}`, `parts[3]` = `{ad}|{id}`, `parts[4]` = `{placement}` (sin id). `parts[1]` ya es exactamente lo que devuelve hoy `extractCampaignFromExternalCode`.

- [ ] **Step 1: Escribir el test de verificación (falla porque la función no existe aún)**

Crear `/tmp/test-extract-tracking-segments.mjs`:

```javascript
import assert from "node:assert/strict";

const SAMPLE_A = "FBhQwK21wXxR⚪F0 (7) TESTEO DE Creativos AIVI - Venta | AD18_COL|02-07-2026|120249168864620193hQwK21wXxRLATAM - Open | 25-45 Prueba 21_V1|120249196337110193hQwK21wXxRAD21_V1|120249196337130193hQwK21wXxRInstagram_Reels";
const SAMPLE_B = "FBhQwK21wXxR⚪F0 (7) TESTEO DE Creativos AIVI - Venta | AD18_COL|02-07-2026|120249168864620193hQwK21wXxRLATAM - Open | 25-45 Prueba AD20_v3|120249196337100193hQwK21wXxRAD20_v3|120249196337120193hQwK21wXxRInstagram_Stories";

const a = extractTrackingSegments(SAMPLE_A);
assert.equal(a.campaignName, "⚪F0 (7) TESTEO DE Creativos AIVI - Venta | AD18_COL|02-07-2026");
assert.equal(a.campaignId, "120249168864620193");
assert.equal(a.adsetName, "LATAM - Open | 25-45 Prueba 21_V1");
assert.equal(a.adsetId, "120249196337110193");
assert.equal(a.adName, "AD21_V1");
assert.equal(a.adId, "120249196337130193");
assert.equal(a.placement, "Instagram_Reels");

const b = extractTrackingSegments(SAMPLE_B);
assert.equal(b.campaignName, a.campaignName);
assert.equal(b.adsetName, "LATAM - Open | 25-45 Prueba AD20_v3");
assert.equal(b.adName, "AD20_v3");
assert.equal(b.adId, "120249196337120193");
assert.equal(b.placement, "Instagram_Stories");

const empty = extractTrackingSegments(null);
assert.equal(empty.campaignName, null);
assert.equal(empty.adId, null);

const noDelimiter = extractTrackingSegments("v1-vsl-solo-ads");
assert.equal(noDelimiter.campaignName, null);

console.log("✅ Todos los asserts pasaron");
```

- [ ] **Step 2: Ejecutar y confirmar que falla**

Run: `node /tmp/test-extract-tracking-segments.mjs`
Expected: `ReferenceError: extractTrackingSegments is not defined`

- [ ] **Step 3: Agregar la implementación al mismo archivo de test y confirmar que pasa**

Insertar al inicio de `/tmp/test-extract-tracking-segments.mjs` (antes de los asserts):

```javascript
const EXTERNAL_CODE_DELIMITER = "hQwK21wXxR";

function splitNameAndId(segment) {
  if (!segment) return { name: null, id: null };
  const match = segment.match(/^(.*)\|(\d+)$/);
  if (match) {
    const name = match[1].trim();
    return { name: name || null, id: match[2] };
  }
  const trimmed = segment.trim();
  return { name: trimmed || null, id: null };
}

function extractTrackingSegments(externalCode) {
  const empty = {
    campaignName: null, campaignId: null,
    adsetName: null, adsetId: null,
    adName: null, adId: null,
    placement: null,
  };
  if (!externalCode || !externalCode.includes(EXTERNAL_CODE_DELIMITER)) return empty;
  const parts = externalCode.split(EXTERNAL_CODE_DELIMITER);
  const campaign  = splitNameAndId(parts[1]);
  const adset     = splitNameAndId(parts[2]);
  const ad        = splitNameAndId(parts[3]);
  const placement = (parts[4] ?? "").trim() || null;
  return {
    campaignName: campaign.name, campaignId: campaign.id,
    adsetName:    adset.name,    adsetId:    adset.id,
    adName:       ad.name,       adId:       ad.id,
    placement,
  };
}
```

Run: `node /tmp/test-extract-tracking-segments.mjs`
Expected: `✅ Todos los asserts pasaron`

- [ ] **Step 4: Copiar la función verificada a `hotmart-webhook/index.ts`**

Reemplazar (líneas 24-35):
```typescript
// Meta/Utmify concatena campaña|adset|ad|placement en purchase.tracking.external_code
// separados por este token fijo (confirmado contra ~3000 transacciones históricas).
// Cada segmento de campaña/adset/ad termina en "|<id numérico>" que hay que descartar
// para que el nombre coincida exactamente con campaign_investment_data.campaign_name.
const EXTERNAL_CODE_DELIMITER = "hQwK21wXxR";

function extractCampaignFromExternalCode(externalCode: string | undefined | null): string | null {
  if (!externalCode || !externalCode.includes(EXTERNAL_CODE_DELIMITER)) return null;
  const parts = externalCode.split(EXTERNAL_CODE_DELIMITER);
  const raw = (parts[1] ?? "").replace(/\|\d+$/, "").trim();
  return raw || null;
}
```

por:
```typescript
// Meta/Utmify concatena {prefijo}|campaña|adset|ad|placement en
// purchase.tracking.external_code, separados por este token fijo (confirmado
// contra transacciones reales — ver docs/superpowers/specs/2026-07-06-ad-level-attribution-metrics-design.md).
// Cada segmento de campaña/adset/ad termina en "|<id numérico>" que hay que
// separar del nombre; placement no tiene id.
const EXTERNAL_CODE_DELIMITER = "hQwK21wXxR";

interface TrackingSegments {
  campaignName: string | null;
  campaignId:   string | null;
  adsetName:    string | null;
  adsetId:      string | null;
  adName:       string | null;
  adId:         string | null;
  placement:    string | null;
}

function splitNameAndId(segment: string | undefined): { name: string | null; id: string | null } {
  if (!segment) return { name: null, id: null };
  const match = segment.match(/^(.*)\|(\d+)$/);
  if (match) {
    const name = match[1].trim();
    return { name: name || null, id: match[2] };
  }
  const trimmed = segment.trim();
  return { name: trimmed || null, id: null };
}

function extractTrackingSegments(externalCode: string | undefined | null): TrackingSegments {
  const empty: TrackingSegments = {
    campaignName: null, campaignId: null,
    adsetName: null, adsetId: null,
    adName: null, adId: null,
    placement: null,
  };
  if (!externalCode || !externalCode.includes(EXTERNAL_CODE_DELIMITER)) return empty;
  const parts = externalCode.split(EXTERNAL_CODE_DELIMITER);
  const campaign  = splitNameAndId(parts[1]);
  const adset     = splitNameAndId(parts[2]);
  const ad        = splitNameAndId(parts[3]);
  const placement = (parts[4] ?? "").trim() || null;
  return {
    campaignName: campaign.name, campaignId: campaign.id,
    adsetName:    adset.name,    adsetId:    adset.id,
    adName:       ad.name,       adId:       ad.id,
    placement,
  };
}
```

Reemplazar (líneas 118-120):
```typescript
  const tracking        = purchase?.tracking;
  const sale_origin     = tracking?.source_sck ?? tracking?.source ?? "";
  const traffic_source  = extractCampaignFromExternalCode(tracking?.external_code) ?? tracking?.source_sck ?? "";
```
por:
```typescript
  const tracking        = purchase?.tracking;
  const sale_origin     = tracking?.source_sck ?? tracking?.source ?? "";
  const segments        = extractTrackingSegments(tracking?.external_code);
  const traffic_source  = segments.campaignName ?? tracking?.source_sck ?? "";
```

Reemplazar el `upsert` de `transactions` (líneas 148-165):
```typescript
  await supabase.from("transactions").upsert({
    hotmart_id,
    event_type:        event,
    buyer_name,
    buyer_email,
    buyer_phone,
    buyer_country,
    offer_code,
    sale_origin,
    traffic_source,
    plan_name,
    amount,
    currency,
    status:            deriveStatus(event),
    cancellation_type,
    raw_payload:       payload,
    created_at:        new Date().toISOString(),
  }, { onConflict: "hotmart_id" });
```
por:
```typescript
  await supabase.from("transactions").upsert({
    hotmart_id,
    event_type:        event,
    buyer_name,
    buyer_email,
    buyer_phone,
    buyer_country,
    offer_code,
    sale_origin,
    traffic_source,
    ad_id:              segments.adId,
    ad_name:            segments.adName,
    adset_id:           segments.adsetId,
    adset_name:         segments.adsetName,
    placement:          segments.placement,
    plan_name,
    amount,
    currency,
    status:            deriveStatus(event),
    cancellation_type,
    raw_payload:       payload,
    created_at:        new Date().toISOString(),
  }, { onConflict: "hotmart_id" });
```

- [ ] **Step 5: Aplicar el mismo cambio en `hotmart-sync/index.ts`**

Reemplazar las líneas 16-27 (idéntico bloque de constantes/función) con el mismo bloque `TrackingSegments`/`splitNameAndId`/`extractTrackingSegments` del Step 4.

Reemplazar (líneas 138-140):
```typescript
        const tracking        = purchase.tracking;
        const sale_origin     = tracking?.source_sck ?? tracking?.source ?? "";
        const traffic_source  = extractCampaignFromExternalCode(tracking?.external_code) ?? tracking?.source_sck ?? "";
```
por:
```typescript
        const tracking        = purchase.tracking;
        const sale_origin     = tracking?.source_sck ?? tracking?.source ?? "";
        const segments        = extractTrackingSegments(tracking?.external_code);
        const traffic_source  = segments.campaignName ?? tracking?.source_sck ?? "";
```

Reemplazar el `txRecord` (líneas 170-186):
```typescript
        const txRecord: Record<string, any> = {
          hotmart_id,
          event_type,
          buyer_name,
          buyer_email,
          buyer_country,
          offer_code,
          sale_origin,
          traffic_source,
          plan_name,
          amount,
          currency,
          status,
          raw_payload: sale,
          created_at: order_date,
        };
        if (buyer_phone) txRecord.buyer_phone = buyer_phone;
```
por:
```typescript
        const txRecord: Record<string, any> = {
          hotmart_id,
          event_type,
          buyer_name,
          buyer_email,
          buyer_country,
          offer_code,
          sale_origin,
          traffic_source,
          ad_id:      segments.adId,
          ad_name:    segments.adName,
          adset_id:   segments.adsetId,
          adset_name: segments.adsetName,
          placement:  segments.placement,
          plan_name,
          amount,
          currency,
          status,
          raw_payload: sale,
          created_at: order_date,
        };
        if (buyer_phone) txRecord.buyer_phone = buyer_phone;
```

- [ ] **Step 6: Desplegar ambas funciones**

Run:
```bash
supabase functions deploy hotmart-webhook --project-ref jihyeeimmhfqlpzljrbu --no-verify-jwt
supabase functions deploy hotmart-sync    --project-ref jihyeeimmhfqlpzljrbu --no-verify-jwt
```
Expected: `Deployed Functions on project jihyeeimmhfqlpzljrbu: hotmart-webhook` / `hotmart-sync`, sin errores.

- [ ] **Step 7: Backfill acotado y verificación contra datos reales**

Correr `hotmart-sync` sobre una ventana de 1 día reciente que ya sabemos tiene ventas con `external_code` (usar timestamps epoch ms del día de la Muestra A/B, 2026-07-02):

```bash
source .env.local
curl -s "${VITE_SUPABASE_URL}/functions/v1/hotmart-sync?start=1751414400000&end=1751500799000" \
  -H "apikey: ${VITE_SUPABASE_ANON_KEY}"
```
Expected: JSON `{"ok":true, ...}` con `inserted > 0`.

Run:
```bash
supabase db query --linked "select hotmart_id, traffic_source, ad_id, ad_name, adset_name, placement from transactions where created_at >= '2026-07-02' and created_at < '2026-07-03' and ad_id is not null limit 5;"
```
Expected: filas con `ad_name` en (`AD21_V1`, `AD20_v3`, ...) y `placement` en (`Instagram_Reels`, `Instagram_Stories`, ...) — coincidiendo con las muestras reales usadas en el test.

- [ ] **Step 8: Commit**

```bash
git add supabase/functions/hotmart-webhook/index.ts supabase/functions/hotmart-sync/index.ts
git commit -m "feat(hotmart): parsear anuncio/adset/placement completos del tracking de Meta"
```

---

### Task 3: `utmify-sync` — inversión a nivel de anuncio

**Files:**
- Modify: `supabase/functions/utmify-sync/index.ts:56-89` (junto a `syncCampaigns`), y el handler `serve()` al final del archivo.

**Interfaces:**
- Consumes: tabla `ad_investment_data` (Task 1).
- Produces: función `syncAds(supabase, mcpToken, dashboardId, dateStr): Promise<void>`, poblando `ad_investment_data`. Endpoint `GET .../utmify-sync?debug-ads`.

**Contexto verificado:** `curl` directo contra la función `utmify-sync?debug-campaigns` ya desplegada confirma que el objeto de `get_meta_ad_objects` trae `campaignId`, `adsetId`, `adId` (los que no aplican al nivel pedido llegan `null`), un campo `name` contextual al nivel pedido, y **no** un campo `campaignName` separado — por eso `ad_investment_data` no lo guarda (se resuelve por join en Task 5).

- [ ] **Step 1: Agregar el endpoint de debug (antes de escribir el upsert)**

Modificar el bloque de `serve()` (donde ya existe `debug-campaigns`, cerca de la línea 301):

```typescript
  // Debug: retorna raw de UTMify a nivel campaña para inspección
  if (params.has("debug-campaigns")) {
    const mcpToken    = Deno.env.get("UTMIFY_MCP_TOKEN")!;
    const dashboardId = Deno.env.get("UTMIFY_DASHBOARD_ID")!;
    const today       = toColombiaDate(new Date());
    const raw = await callMcp(mcpToken, "get_meta_ad_objects", {
      dashboardId, level: "campaign",
      dateRange: { from: today, to: today },
    });
    return new Response(JSON.stringify(raw, null, 2), { headers: { "Content-Type": "application/json" } });
  }
```

Agregar justo debajo (mismo patrón, `level: "ad"`):

```typescript
  // Debug: retorna raw de UTMify a nivel anuncio para inspección
  if (params.has("debug-ads")) {
    const mcpToken    = Deno.env.get("UTMIFY_MCP_TOKEN")!;
    const dashboardId = Deno.env.get("UTMIFY_DASHBOARD_ID")!;
    const today       = toColombiaDate(new Date());
    const raw = await callMcp(mcpToken, "get_meta_ad_objects", {
      dashboardId, level: "ad",
      dateRange: { from: today, to: today },
    });
    return new Response(JSON.stringify(raw, null, 2), { headers: { "Content-Type": "application/json" } });
  }
```

- [ ] **Step 2: Desplegar solo con el debug endpoint y confirmar el shape real**

Run: `supabase functions deploy utmify-sync --project-ref jihyeeimmhfqlpzljrbu --no-verify-jwt`

Run:
```bash
source .env.local
curl -s "${VITE_SUPABASE_URL}/functions/v1/utmify-sync?debug-ads" -H "apikey: ${VITE_SUPABASE_ANON_KEY}" | head -c 1500
```
Expected: JSON con `"level": "ad"` y objetos que tienen `adId` **no nulo** (a diferencia de `debug-campaigns`, donde `adId` era `null`), `campaignId` no nulo, `name` = nombre del anuncio, `spend`/`impressions`/`inlineLinkClicks`/`accountId` presentes igual que a nivel campaña.

Si el nombre de algún campo difiere de lo asumido en el Step 3 (por ejemplo si `adId` no viene, o `name` no es el nombre del anuncio), ajustar el mapeo del Step 3 antes de continuar — no asumir silenciosamente.

- [ ] **Step 3: Implementar `syncAds()`**

Agregar después de `syncCampaigns()` (después de la línea 89):

```typescript
// Sincroniza gasto a nivel de anuncio individual para un día
async function syncAds(
  supabase: ReturnType<typeof createClient>,
  mcpToken: string,
  dashboardId: string,
  dateStr: string,
): Promise<void> {
  const data = await callMcp(mcpToken, "get_meta_ad_objects", {
    dashboardId,
    level:     "ad",
    dateRange: { from: dateStr, to: dateStr },
  }) as { results: Array<{ adId: string; campaignId: string; name: string; spend: number; impressions: number; inlineLinkClicks: number; accountId: string }> };

  const ads = (data.results ?? []).filter((r: any) => r.accountId === META_ACCOUNT_ID && r.adId);
  if (ads.length === 0) { console.log(`UTMify ads: sin datos para ${dateStr}`); return; }

  const rows = ads.map((a) => ({
    ad_id:       a.adId,
    ad_name:     a.name ?? a.adId,
    campaign_id: a.campaignId ?? null,
    date:        dateStr,
    platform:    "facebook",
    investment:  (a.spend ?? 0) / 100,
    impressions: a.impressions ?? 0,
    clicks:      a.inlineLinkClicks ?? 0,
    synced_at:   new Date().toISOString(),
  }));

  const { error } = await supabase
    .from("ad_investment_data")
    .upsert(rows, { onConflict: "ad_id,date,platform" });
  if (error) throw new Error(`ad_investment_data upsert (${dateStr}): ${error.message}`);
  console.log(`✅ UTMify ads — ${rows.length} anuncios — ${dateStr}`);
}
```

- [ ] **Step 4: Llamar `syncAds()` en `runSync` y `runBackfill`, junto a `syncCampaigns()`**

En `runSync()` (dentro del loop `for (let i = 7; i >= 1; i--)`, justo después del bloque `try { await syncCampaigns(...) }`):
```typescript
    try {
      await syncCampaigns(supabase, mcpToken, dashboardId, dateStr);
    } catch (e) {
      console.error(`Campaign sync error for ${dateStr}:`, e);
      errors.push({ date: dateStr, error: String(e) });
    }
    try {
      await syncAds(supabase, mcpToken, dashboardId, dateStr);
    } catch (e) {
      console.error(`Ad sync error for ${dateStr}:`, e);
      errors.push({ date: dateStr, error: String(e) });
    }
```
Y después del bloque de "hoy" (después del `syncCampaigns` para `today`):
```typescript
  try {
    await syncCampaigns(supabase, mcpToken, dashboardId, today);
  } catch (e) {
    console.error(`Campaign sync error for today (${today}):`, e);
    errors.push({ date: today, error: String(e) });
  }
  try {
    await syncAds(supabase, mcpToken, dashboardId, today);
  } catch (e) {
    console.error(`Ad sync error for today (${today}):`, e);
    errors.push({ date: today, error: String(e) });
  }
```

En `runBackfill()` (dentro del loop `for (const dateStr of dates)`, después del bloque `try { await syncCampaigns(...) }`):
```typescript
    try {
      await syncCampaigns(supabase, mcpToken, dashboardId, dateStr);
    } catch (e) {
      errors.push({ date: dateStr, error: String(e) });
    }
    try {
      await syncAds(supabase, mcpToken, dashboardId, dateStr);
    } catch (e) {
      errors.push({ date: dateStr, error: String(e) });
    }
```

- [ ] **Step 5: Desplegar y correr backfill acotado**

Run: `supabase functions deploy utmify-sync --project-ref jihyeeimmhfqlpzljrbu --no-verify-jwt`

Run:
```bash
source .env.local
curl -s "${VITE_SUPABASE_URL}/functions/v1/utmify-sync?from=2026-07-05&to=2026-07-06" -H "apikey: ${VITE_SUPABASE_ANON_KEY}"
```
Expected: `{"ok":true, "daysProcessed":2, ...}`.

- [ ] **Step 6: Verificar y reconciliar contra `campaign_investment_data`**

Run:
```bash
supabase db query --linked "select date, round(sum(investment),2) as ad_investment from ad_investment_data where date between '2026-07-05' and '2026-07-06' group by date order by date;"
supabase db query --linked "select date, round(sum(investment),2) as campaign_investment from campaign_investment_data where date between '2026-07-05' and '2026-07-06' group by date order by date;"
```
Expected: la suma de `ad_investment_data.investment` por fecha debe ser igual o muy cercana (redondeo) a la suma de `campaign_investment_data.investment` de la misma fecha — ningún anuncio "pierde" inversión frente a su campaña.

- [ ] **Step 7: Commit**

```bash
git add supabase/functions/utmify-sync/index.ts
git commit -m "feat(utmify): sincronizar inversión de Meta Ads a nivel de anuncio individual"
```

---

### Task 4: `vturb-sync` — vistas/reproducciones únicas + segundo del pitch

**Files:**
- Modify: `supabase/functions/vturb-sync/index.ts:43-146` (`syncAnalytics`), y el `serve()` final.

**Interfaces:**
- Consumes: columnas `unique_views`/`unique_plays`/`pitch_second` de `vturb_analytics` (Task 1).
- Produces: `vturb_analytics` con esas 3 columnas pobladas. Endpoint `GET .../vturb-sync?debug`.

**Contexto verificado (documentación pública `vturb.gitbook.io/analytics-api/analytics`):** `POST /events/total_by_company_players` (ya se llama) trae métricas de unicidad (`total`, `total_uniq_sessions`, `total_uniq_device`) que el código actual descarta. `GET /players/list` (ya se llama) trae `pitch_time` por player. Los nombres exactos de campo en el JSON real de unicidad no están confirmados contra producción — se verifican con el endpoint de debug antes de confiar en el parseo.

- [ ] **Step 1: Agregar endpoint de debug (antes de tocar el upsert)**

Agregar antes del `serve()` final (reemplaza el `serve()` actual, líneas 343-348):

```typescript
serve(async (req) => {
  const params = new URL(req.url).searchParams;

  if (params.has("debug")) {
    const apiKey  = Deno.env.get("VTURB_API_KEY")!;
    const today   = toColombiaDate(new Date());
    const startDt = `${today} 00:00:00`;
    const endDt   = `${today} 23:59:59`;
    const events = await vturb(apiKey, "/events/total_by_company_players", {
      start_date: startDt, end_date: endDt, events: ["started", "viewed"],
    });
    const players = await vturb(apiKey, "/players/list");
    return new Response(JSON.stringify({ events, players }, null, 2), {
      headers: { "Content-Type": "application/json" },
    });
  }

  const from = params.get("from") ?? undefined;
  const to   = params.get("to")   ?? undefined;
  return runSync(from, to);
});
```

- [ ] **Step 2: Desplegar solo con el debug endpoint y confirmar los nombres de campo reales**

Run: `supabase functions deploy vturb-sync --project-ref jihyeeimmhfqlpzljrbu --no-verify-jwt`

Run:
```bash
source .env.local
curl -s "${VITE_SUPABASE_URL}/functions/v1/vturb-sync?debug" -H "apikey: ${VITE_SUPABASE_ANON_KEY}" | head -c 2000
```
Expected: JSON con `events` (array de objetos `{player_id, event, total, ...}` — anotar el nombre exacto del/los campo(s) de unicidad, ej. `total_uniq_sessions` o `unique_sessions`) y `players` (array con `pitch_time` visible por player que lo tenga configurado). Usar los nombres EXACTOS observados aquí en el Step 3 — si difieren de `total_uniq_sessions`/`pitch_time`, ajustar el código del Step 3 a lo real antes de continuar.

- [ ] **Step 3: Implementar la captura de únicos y `pitch_second`**

Reemplazar la interfaz `EventsByPlayer` (línea 47-51):
```typescript
interface EventsByPlayer {
  player_id: string;
  event:     string;
  total:     number;
}
```
por (ajustar el nombre del campo de unicidad al confirmado en el Step 2; se asume `total_uniq_sessions` según la documentación pública):
```typescript
interface EventsByPlayer {
  player_id:          string;
  event:              string;
  total:              number;
  total_uniq_sessions?: number;
}
```

Reemplazar la interfaz `VTurbPlayer` (línea 45):
```typescript
interface VTurbPlayer { id: string; name: string; duration: number }
```
por:
```typescript
interface VTurbPlayer { id: string; name: string; duration: number; pitch_time?: number | null }
```

Reemplazar el bloque de agregación por player dentro de `syncAnalytics` (líneas 88-94):
```typescript
    // Agrupar por player_id
    const byPlayer: Record<string, { plays: number; views: number }> = {};
    for (const e of (events ?? [])) {
      if (!byPlayer[e.player_id]) byPlayer[e.player_id] = { plays: 0, views: 0 };
      if (e.event === "started") byPlayer[e.player_id].plays += e.total;
      if (e.event === "viewed")  byPlayer[e.player_id].views += e.total;
    }
```
por:
```typescript
    // Agrupar por player_id
    const byPlayer: Record<string, { plays: number; views: number; uniquePlays: number; uniqueViews: number }> = {};
    for (const e of (events ?? [])) {
      if (!byPlayer[e.player_id]) byPlayer[e.player_id] = { plays: 0, views: 0, uniquePlays: 0, uniqueViews: 0 };
      const uniq = e.total_uniq_sessions ?? 0;
      if (e.event === "started") { byPlayer[e.player_id].plays += e.total; byPlayer[e.player_id].uniquePlays += uniq; }
      if (e.event === "viewed")  { byPlayer[e.player_id].views += e.total; byPlayer[e.player_id].uniqueViews += uniq; }
    }
```

Reemplazar el push a `allRows` (líneas 113-124):
```typescript
    for (const [pid, { plays, views }] of Object.entries(byPlayer)) {
      allRows.push({
        video_id:      pid,
        video_name:    null,
        date:          day,
        plays,
        views,
        play_rate:     views > 0 ? Math.round((plays / views) * 10000) / 100 : null,
        avg_watch_time: null,
        button_clicks: clicksByPlayer[pid] ?? 0,
      });
    }
```
por:
```typescript
    for (const [pid, { plays, views, uniquePlays, uniqueViews }] of Object.entries(byPlayer)) {
      allRows.push({
        video_id:      pid,
        video_name:    null,
        date:          day,
        plays,
        views,
        unique_plays:  uniquePlays,
        unique_views:  uniqueViews,
        play_rate:     views > 0 ? Math.round((plays / views) * 10000) / 100 : null,
        avg_watch_time: null,
        button_clicks: clicksByPlayer[pid] ?? 0,
        pitch_second:  null,
      });
    }
```

Reemplazar el bloque de enriquecimiento de `video_name` (líneas 129-139) para que también guarde `pitch_second`:
```typescript
  // Enriquecer video_name desde la lista de players
  try {
    const players = await vturb(apiKey, "/players/list") as VTurbPlayer[];
    const nameMap: Record<string, string> = {};
    for (const p of players) nameMap[p.id] = p.name;
    for (const r of allRows) {
      if (r.video_name === null && nameMap[r.video_id as string]) {
        r.video_name = nameMap[r.video_id as string];
      }
    }
  } catch { /* continuar sin nombres */ }
```
por:
```typescript
  // Enriquecer video_name y pitch_second desde la lista de players
  try {
    const players = await vturb(apiKey, "/players/list") as VTurbPlayer[];
    const nameMap:  Record<string, string> = {};
    const pitchMap: Record<string, number | null> = {};
    for (const p of players) {
      nameMap[p.id]  = p.name;
      pitchMap[p.id] = p.pitch_time ?? null;
    }
    for (const r of allRows) {
      if (r.video_name === null && nameMap[r.video_id as string]) {
        r.video_name = nameMap[r.video_id as string];
      }
      r.pitch_second = pitchMap[r.video_id as string] ?? null;
    }
  } catch { /* continuar sin nombres ni pitch_second */ }
```

- [ ] **Step 4: Desplegar y correr backfill acotado**

Run: `supabase functions deploy vturb-sync --project-ref jihyeeimmhfqlpzljrbu --no-verify-jwt`

Run:
```bash
source .env.local
curl -s "${VITE_SUPABASE_URL}/functions/v1/vturb-sync?from=2026-07-05&to=2026-07-06" -H "apikey: ${VITE_SUPABASE_ANON_KEY}"
```
Expected: `{"ok":true, ...}`.

- [ ] **Step 5: Verificar contra el dashboard de VTurb**

Run:
```bash
supabase db query --linked "select video_id, video_name, date, views, unique_views, plays, unique_plays, pitch_second from vturb_analytics where date between '2026-07-05' and '2026-07-06' and plays > 0 order by plays desc limit 5;"
```
Expected: `unique_views <= views` y `unique_plays <= plays` para cada fila (un usuario único no puede generar más eventos que el total). Comparar manualmente 1-2 filas contra el dashboard propio de VTurb para ese video/fecha — los números deben ser del mismo orden de magnitud (no exactos al 100% si VTurb usa una ventana de atribución distinta, pero no deben estar en órdenes de magnitud diferentes).

- [ ] **Step 6: Commit**

```bash
git add supabase/functions/vturb-sync/index.ts
git commit -m "feat(vturb): capturar vistas/reproducciones únicas y pitch_second nativo"
```

---

### Task 5: Capa de servicio — tipos, score compartido, `getAdVSLRanking`

**Files:**
- Modify: `src/services/analytics.ts`

**Interfaces:**
- Consumes: tablas `ad_investment_data`, `ad_vsl_mapping` (Task 1), columnas nuevas de `transactions`/`vturb_analytics` (Tasks 1-4).
- Produces:
  - `export interface AdVSLRow { adId, adName, adsetName: string|null, placement: string|null, campaignName, videoId: string|null, videoName: string|null, investment, clicks, impressions, sales, cac, roi, convRate, views, uniqueViews, plays, uniquePlays, playRate, engagement, pitchAudience: number|null, score }`
  - `export async function getAdVSLRanking(r: DateRange): Promise<AdVSLRow[]>`
  - `VSLData` extendido con `views, uniqueViews, uniquePlays, engagement, pitchAudience: number|null`
  - `SCORE_WEIGHTS` (constante) y `computeScore(input, maxRoi, maxConvRate): number` (helper compartido)

- [ ] **Step 1: Agregar constantes y helpers de score/retención compartidos**

Agregar después de la línea 172 (`export const DEFAULT_VSL_CAMPAIGN = "__default__";`):

```typescript
// ── Score compartido (campaña y anuncio) ────────────────────────────────────────

const SCORE_WEIGHTS = { roi: 0.30, convRate: 0.20, pitchAudience: 0.30, engagement: 0.20 } as const;

function computeScore(
  input: { roi: number; convRate: number; pitchAudience: number | null; engagement: number },
  maxRoi: number,
  maxConvRate: number,
): number {
  const roiNorm      = maxRoi > 0 ? Math.min(Math.max(input.roi / maxRoi, 0), 1) : 0;
  const convRateNorm = maxConvRate > 0 ? Math.min(Math.max(input.convRate / maxConvRate, 0), 1) : 0;
  const pitchNorm       = Math.min(Math.max((input.pitchAudience ?? 0) / 100, 0), 1);
  const engagementNorm  = Math.min(Math.max(input.engagement / 100, 0), 1);
  return Math.round((
    roiNorm * SCORE_WEIGHTS.roi +
    convRateNorm * SCORE_WEIGHTS.convRate +
    pitchNorm * SCORE_WEIGHTS.pitchAudience +
    engagementNorm * SCORE_WEIGHTS.engagement
  ) * 100);
}

function averageRetention(points: VSLRetentionPoint[]): number {
  return points.length > 0 ? points.reduce((s, p) => s + p.percentage, 0) / points.length : 0;
}

function retentionAt(points: VSLRetentionPoint[], second: number): number {
  if (points.length === 0) return 0;
  const pt = points.find(p => p.second >= second) ?? points[points.length - 1];
  return pt.percentage;
}
```

- [ ] **Step 1b: Ampliar `classifyAd` para aceptar tanto `AdRankRow` como el nuevo `AdVSLRow`**

`classifyAd` hoy tipa su parámetro como `AdRankRow` (líneas 135-143), que exige `cpm`/`cpc` — campos que el nuevo `AdVSLRow` no tiene (nunca se muestran en la tabla de anuncios). Como el cuerpo de la función solo usa `sales`, `investment`, `roi`, `cac`, se angosta el tipo a esos 4 campos para que ambos tipos sean compatibles sin agregar columnas no usadas a `AdVSLRow`.

Reemplazar (líneas 135-143):
```typescript
export type AdAction = "ESCALAR" | "PAUSAR" | "MONITOREAR";

export function classifyAd(r: AdRankRow, cacTarget: number, ticketMin: number): AdAction {
  const avgTicket = r.sales > 0 && r.investment > 0 ? (r.investment * (1 + r.roi)) / r.sales : 0;
  const ticketOk  = ticketMin === 0 || avgTicket >= ticketMin;
  if (r.sales >= 1 && r.cac > 0 && r.cac <= cacTarget && r.roi >= 1.0 && ticketOk) return "ESCALAR";
  if ((r.cac > 0 && r.cac > cacTarget * 1.5) || (r.roi < 0.0 && r.investment > 0)) return "PAUSAR";
  return "MONITOREAR";
}
```
por:
```typescript
export type AdAction = "ESCALAR" | "PAUSAR" | "MONITOREAR";

export interface ScoreableRow { sales: number; cac: number; roi: number; investment: number }

export function classifyAd(r: ScoreableRow, cacTarget: number, ticketMin: number): AdAction {
  const avgTicket = r.sales > 0 && r.investment > 0 ? (r.investment * (1 + r.roi)) / r.sales : 0;
  const ticketOk  = ticketMin === 0 || avgTicket >= ticketMin;
  if (r.sales >= 1 && r.cac > 0 && r.cac <= cacTarget && r.roi >= 1.0 && ticketOk) return "ESCALAR";
  if ((r.cac > 0 && r.cac > cacTarget * 1.5) || (r.roi < 0.0 && r.investment > 0)) return "PAUSAR";
  return "MONITOREAR";
}
```
`AdRankRow` y el `AdVSLRow` del Step 4 satisfacen `ScoreableRow` estructuralmente — ninguna otra llamada existente a `classifyAd` (`VSLIntelligencePanel.tsx`) requiere cambios.

- [ ] **Step 2: Extender `VSLData` y actualizar `getVSLRetention()` para poblar las métricas nuevas**

Reemplazar la interfaz (líneas 104-116):
```typescript
export interface VSLData {
  videoId:    string;
  videoName:  string;
  plays:      number;
  ret25:      number;
  ret50:      number;
  ret75:      number;
  ctaClicks:  number;
  sales:      number;
  convRate:   number;
  retention:  VSLRetentionPoint[];
  dropSecond: number | null;
}
```
por:
```typescript
export interface VSLData {
  videoId:       string;
  videoName:     string;
  plays:         number;
  ret25:         number;
  ret50:         number;
  ret75:         number;
  ctaClicks:     number;
  sales:         number;
  convRate:      number;
  retention:     VSLRetentionPoint[];
  dropSecond:    number | null;
  views:         number;
  uniqueViews:   number;
  uniquePlays:   number;
  engagement:    number;
  pitchAudience: number | null;
}
```

En `getVSLRetention()`, reemplazar el primer `select` de `vturb_analytics` (línea 280):
```typescript
    supabase.from("vturb_analytics").select("video_id, video_name, plays, button_clicks").gte("date", r.from).lte("date", r.to),
```
por:
```typescript
    supabase.from("vturb_analytics").select("video_id, video_name, plays, views, unique_views, unique_plays, button_clicks, pitch_second").gte("date", r.from).lte("date", r.to),
```

Reemplazar el bloque `analyticsMap` (líneas 295-301):
```typescript
  const analyticsMap: Record<string, { videoName: string; plays: number; ctaClicks: number }> = {};
  for (const row of (analyticsRes.data ?? [])) {
    const k = row.video_id;
    if (!analyticsMap[k]) analyticsMap[k] = { videoName: row.video_name ?? k, plays: 0, ctaClicks: 0 };
    analyticsMap[k].plays     += Number(row.plays);
    analyticsMap[k].ctaClicks += Number(row.button_clicks);
  }
```
por:
```typescript
  const analyticsMap: Record<string, { videoName: string; plays: number; views: number; uniqueViews: number; uniquePlays: number; ctaClicks: number; pitchSecond: number | null }> = {};
  for (const row of (analyticsRes.data ?? [])) {
    const k = row.video_id;
    if (!analyticsMap[k]) analyticsMap[k] = { videoName: row.video_name ?? k, plays: 0, views: 0, uniqueViews: 0, uniquePlays: 0, ctaClicks: 0, pitchSecond: null };
    analyticsMap[k].plays       += Number(row.plays);
    analyticsMap[k].views       += Number(row.views);
    analyticsMap[k].uniqueViews += Number(row.unique_views ?? 0);
    analyticsMap[k].uniquePlays += Number(row.unique_plays ?? 0);
    analyticsMap[k].ctaClicks   += Number(row.button_clicks);
    if (row.pitch_second != null) analyticsMap[k].pitchSecond = Number(row.pitch_second);
  }
```

Reemplazar el `return` final de `getVSLRetention()` (líneas 319-345, el `Object.entries(analyticsMap).map(...)`):
```typescript
  return Object.entries(analyticsMap).map(([videoId, a]) => {
    const retention = retMap[videoId] ?? [];
    // Busca el porcentaje en el segundo que corresponde al pct% de la duración total
    const getAt = (pct: number) => {
      if (retention.length === 0) return 0;
      const totalSec  = retention[retention.length - 1].second;
      const targetSec = (pct / 100) * totalSec;
      const pt = retention.find(p => p.second >= targetSec) ?? retention[retention.length - 1];
      return pt.percentage;
    };

    let dropSecond: number | null = null;
    for (let i = 0; i < retention.length - 10; i++) {
      if ((retention[i].percentage - retention[i + 10].percentage) > 20) {
        dropSecond = retention[i].second; break;
      }
    }

    const sales    = videoSales[videoId] ?? 0;
    const convRate = a.plays > 0 ? (sales / a.plays) * 100 : 0;

    return {
      videoId, videoName: a.videoName, plays: a.plays, ctaClicks: a.ctaClicks,
      ret25: getAt(25), ret50: getAt(50), ret75: getAt(75),
      sales, convRate, retention, dropSecond,
    };
  });
```
por:
```typescript
  return Object.entries(analyticsMap).map(([videoId, a]) => {
    const retention = retMap[videoId] ?? [];
    // Busca el porcentaje en el segundo que corresponde al pct% de la duración total
    const getAt = (pct: number) => {
      if (retention.length === 0) return 0;
      const totalSec  = retention[retention.length - 1].second;
      const targetSec = (pct / 100) * totalSec;
      const pt = retention.find(p => p.second >= targetSec) ?? retention[retention.length - 1];
      return pt.percentage;
    };

    let dropSecond: number | null = null;
    for (let i = 0; i < retention.length - 10; i++) {
      if ((retention[i].percentage - retention[i + 10].percentage) > 20) {
        dropSecond = retention[i].second; break;
      }
    }

    const sales    = videoSales[videoId] ?? 0;
    const convRate = a.plays > 0 ? (sales / a.plays) * 100 : 0;

    return {
      videoId, videoName: a.videoName, plays: a.plays, ctaClicks: a.ctaClicks,
      ret25: getAt(25), ret50: getAt(50), ret75: getAt(75),
      sales, convRate, retention, dropSecond,
      views:         a.views,
      uniqueViews:   a.uniqueViews,
      uniquePlays:   a.uniquePlays,
      engagement:    averageRetention(retention),
      pitchAudience: a.pitchSecond != null ? retentionAt(retention, a.pitchSecond) : null,
    };
  });
```

- [ ] **Step 3: Actualizar el score de `getFunnelByCampaign()` para usar `computeScore`**

Reemplazar el `select` de `vturb_analytics` en `getFunnelByCampaign()` (línea 207):
```typescript
    supabase.from("vturb_analytics").select("video_id, plays, button_clicks").gte("date", r.from).lte("date", r.to),
```
por:
```typescript
    supabase.from("vturb_analytics").select("video_id, plays, button_clicks, pitch_second").gte("date", r.from).lte("date", r.to),
```

Reemplazar el `select` de `vturb_retention` — hoy `getFunnelByCampaign()` NO lo consulta; agregarlo al `Promise.all` (línea 202-208), cambiando de 4 a 5 queries:
```typescript
  const [campRes, txRes, mappingRes, analyticsRes] = await Promise.all([
    supabase.from("campaign_investment_data").select("campaign_name, investment, impressions, clicks").gte("date", r.from).lte("date", r.to),
    // traffic_source es el campo donde Hotmart guarda el UTM (src/sck)
    supabase.from("transactions").select("traffic_source, amount, currency, created_at").gte("created_at", r.fromTs).lte("created_at", r.toTs).eq("status", "active"),
    supabase.from("campaign_vsl_mapping").select("*"),
    supabase.from("vturb_analytics").select("video_id, plays, button_clicks").gte("date", r.from).lte("date", r.to),
  ]);
```
por:
```typescript
  const [campRes, txRes, mappingRes, analyticsRes, retentionRes] = await Promise.all([
    supabase.from("campaign_investment_data").select("campaign_name, investment, impressions, clicks").gte("date", r.from).lte("date", r.to),
    // traffic_source es el campo donde Hotmart guarda el UTM (src/sck)
    supabase.from("transactions").select("traffic_source, amount, currency, created_at").gte("created_at", r.fromTs).lte("created_at", r.toTs).eq("status", "active"),
    supabase.from("campaign_vsl_mapping").select("*"),
    supabase.from("vturb_analytics").select("video_id, plays, button_clicks, pitch_second").gte("date", r.from).lte("date", r.to),
    supabase.from("vturb_retention").select("video_id, second, percentage").gte("date", r.from).lte("date", r.to),
  ]);
```

Reemplazar el bloque `vturlMap` (líneas 234-240):
```typescript
  const vturlMap: Record<string, { plays: number; buttonClicks: number }> = {};
  for (const row of (analyticsRes.data ?? [])) {
    const k = row.video_id;
    if (!vturlMap[k]) vturlMap[k] = { plays: 0, buttonClicks: 0 };
    vturlMap[k].plays        += Number(row.plays);
    vturlMap[k].buttonClicks += Number(row.button_clicks);
  }
```
por:
```typescript
  const vturlMap: Record<string, { plays: number; buttonClicks: number; pitchSecond: number | null }> = {};
  for (const row of (analyticsRes.data ?? [])) {
    const k = row.video_id;
    if (!vturlMap[k]) vturlMap[k] = { plays: 0, buttonClicks: 0, pitchSecond: null };
    vturlMap[k].plays        += Number(row.plays);
    vturlMap[k].buttonClicks += Number(row.button_clicks);
    if (row.pitch_second != null) vturlMap[k].pitchSecond = Number(row.pitch_second);
  }

  const retByVideo: Record<string, VSLRetentionPoint[]> = {};
  for (const row of (retentionRes.data ?? [])) {
    if (!retByVideo[row.video_id]) retByVideo[row.video_id] = [];
    retByVideo[row.video_id].push({ second: Number(row.second), percentage: Number(row.percentage) });
  }
  for (const points of Object.values(retByVideo)) points.sort((a, b) => a.second - b.second);
```

Reemplazar el cálculo de `maxRoi`/`score` al final de `getFunnelByCampaign()` (líneas 244-275):
```typescript
  const maxRoi = Math.max(1, ...[...allCampaigns].map(c => {
    const inv = invMap[c]?.investment ?? 0;
    const rev = salesMap[c]?.revenue ?? 0;
    return inv > 0 ? (rev - inv) / inv : 0;
  }));

  return [...allCampaigns].map(campaignName => {
    const inv   = invMap[campaignName]  ?? { investment: 0, impressions: 0, clicks: 0 };
    const sales = salesMap[campaignName] ?? { count: 0, revenue: 0, hours: [] };
    const vsl   = mappingMap[campaignName] ?? defaultVsl;
    const vData = vsl ? (vturlMap[vsl.videoId] ?? { plays: 0, buttonClicks: 0 }) : null;

    const cac  = sales.count > 0 ? inv.investment / sales.count : 0;
    const roi  = inv.investment > 0 ? (sales.revenue - inv.investment) / inv.investment : 0;

    const hourCount: Record<number, number> = {};
    for (const h of sales.hours) hourCount[h] = (hourCount[h] ?? 0) + 1;
    const topHour = sales.hours.length > 0
      ? Number(Object.entries(hourCount).sort((a, b) => b[1] - a[1])[0][0])
      : null;

    const roiNorm   = maxRoi > 0 ? Math.min(Math.max(roi / maxRoi, 0), 1) : 0;
    const convRate  = vData && vData.plays > 0 ? sales.count / vData.plays : 0;
    const score     = Math.round((roiNorm * 0.50 + Math.min(convRate * 10, 1) * 0.50) * 100);

    return {
      campaignName, videoId: vsl?.videoId ?? null, videoName: vsl?.videoName ?? null,
      impressions: inv.impressions, clicks: inv.clicks,
      plays: vData?.plays ?? 0, ctaClicks: vData?.buttonClicks ?? 0,
      sales: sales.count, revenue: sales.revenue, cac, roi, investment: inv.investment, topHour, score,
    };
  }).sort((a, b) => (a.cac || 999) - (b.cac || 999));
```
por:
```typescript
  const maxRoi = Math.max(1, ...[...allCampaigns].map(c => {
    const inv = invMap[c]?.investment ?? 0;
    const rev = salesMap[c]?.revenue ?? 0;
    return inv > 0 ? (rev - inv) / inv : 0;
  }));
  const maxConvRate = Math.max(0.0001, ...[...allCampaigns].map(c => {
    const vsl   = mappingMap[c] ?? defaultVsl;
    const vData = vsl ? vturlMap[vsl.videoId] : null;
    const sales = salesMap[c]?.count ?? 0;
    return vData && vData.plays > 0 ? sales / vData.plays : 0;
  }));

  return [...allCampaigns].map(campaignName => {
    const inv   = invMap[campaignName]  ?? { investment: 0, impressions: 0, clicks: 0 };
    const sales = salesMap[campaignName] ?? { count: 0, revenue: 0, hours: [] };
    const vsl   = mappingMap[campaignName] ?? defaultVsl;
    const vData = vsl ? (vturlMap[vsl.videoId] ?? { plays: 0, buttonClicks: 0, pitchSecond: null }) : null;
    const retention = vsl ? (retByVideo[vsl.videoId] ?? []) : [];

    const cac  = sales.count > 0 ? inv.investment / sales.count : 0;
    const roi  = inv.investment > 0 ? (sales.revenue - inv.investment) / inv.investment : 0;

    const hourCount: Record<number, number> = {};
    for (const h of sales.hours) hourCount[h] = (hourCount[h] ?? 0) + 1;
    const topHour = sales.hours.length > 0
      ? Number(Object.entries(hourCount).sort((a, b) => b[1] - a[1])[0][0])
      : null;

    const convRate     = vData && vData.plays > 0 ? sales.count / vData.plays : 0;
    const engagement   = averageRetention(retention);
    const pitchAudience = vData?.pitchSecond != null ? retentionAt(retention, vData.pitchSecond) : null;
    const score = computeScore({ roi, convRate, pitchAudience, engagement }, maxRoi, maxConvRate);

    return {
      campaignName, videoId: vsl?.videoId ?? null, videoName: vsl?.videoName ?? null,
      impressions: inv.impressions, clicks: inv.clicks,
      plays: vData?.plays ?? 0, ctaClicks: vData?.buttonClicks ?? 0,
      sales: sales.count, revenue: sales.revenue, cac, roi, investment: inv.investment, topHour, score,
    };
  }).sort((a, b) => (a.cac || 999) - (b.cac || 999));
```

- [ ] **Step 4: Agregar `getAdVSLRanking()`**

Agregar después de `getAdsRanking()` (después de la línea 366):

```typescript
export interface AdVSLRow {
  adId:          string;
  adName:        string;
  adsetName:     string | null;
  placement:     string | null;
  campaignName:  string;
  videoId:       string | null;
  videoName:     string | null;
  investment:    number;
  clicks:        number;
  impressions:   number;
  sales:         number;
  cac:           number;
  roi:           number;
  convRate:      number;
  views:         number;
  uniqueViews:   number;
  plays:         number;
  uniquePlays:   number;
  playRate:      number;
  engagement:    number;
  pitchAudience: number | null;
  score:         number;
}

export async function getAdVSLRanking(r: DateRange): Promise<AdVSLRow[]> {
  const [adInvRes, campInvRes, txRes, adMappingRes, campMappingRes, vturbRes, retentionRes] = await Promise.all([
    supabase.from("ad_investment_data").select("ad_id, ad_name, campaign_id, investment, impressions, clicks").gte("date", r.from).lte("date", r.to),
    supabase.from("campaign_investment_data").select("campaign_id, campaign_name").gte("date", r.from).lte("date", r.to),
    supabase.from("transactions").select("ad_id, ad_name, adset_name, placement, traffic_source, amount, currency").gte("created_at", r.fromTs).lte("created_at", r.toTs).eq("status", "active"),
    supabase.from("ad_vsl_mapping").select("*"),
    supabase.from("campaign_vsl_mapping").select("*"),
    supabase.from("vturb_analytics").select("video_id, plays, views, unique_plays, unique_views, pitch_second").gte("date", r.from).lte("date", r.to),
    supabase.from("vturb_retention").select("video_id, second, percentage").gte("date", r.from).lte("date", r.to),
  ]);

  const campNameById: Record<string, string> = {};
  for (const row of (campInvRes.data ?? [])) if (row.campaign_id) campNameById[row.campaign_id] = row.campaign_name ?? row.campaign_id;

  const invMap: Record<string, { adName: string; campaignId: string | null; investment: number; impressions: number; clicks: number }> = {};
  for (const row of (adInvRes.data ?? [])) {
    const k = row.ad_id;
    if (!invMap[k]) invMap[k] = { adName: row.ad_name ?? k, campaignId: row.campaign_id ?? null, investment: 0, impressions: 0, clicks: 0 };
    invMap[k].investment  += Number(row.investment);
    invMap[k].impressions += Number(row.impressions);
    invMap[k].clicks      += Number(row.clicks);
  }

  const salesMap: Record<string, { count: number; revenue: number; adName: string | null; adsetName: string | null; placement: string | null; campaignName: string | null }> = {};
  for (const tx of (txRes.data ?? [])) {
    const k = tx.ad_id;
    if (!k) continue; // ventas sin ad_id (tráfico no atribuido a un anuncio) no entran al ranking por anuncio
    if (!salesMap[k]) salesMap[k] = { count: 0, revenue: 0, adName: tx.ad_name ?? null, adsetName: tx.adset_name ?? null, placement: tx.placement ?? null, campaignName: tx.traffic_source || null };
    salesMap[k].count++;
    salesMap[k].revenue += toUSD(Number(tx.amount), tx.currency);
  }

  const adVideoMap: Record<string, { videoId: string; videoName: string }> = {};
  for (const m of (adMappingRes.data ?? [])) adVideoMap[m.ad_id] = { videoId: m.video_id, videoName: m.video_name ?? m.video_id };
  const campVideoMap: Record<string, { videoId: string; videoName: string }> = {};
  for (const m of (campMappingRes.data ?? [])) campVideoMap[m.campaign_name] = { videoId: m.video_id, videoName: m.video_name ?? m.video_id };
  const defaultVideo = campVideoMap[DEFAULT_VSL_CAMPAIGN] ?? null;

  const vturbMap: Record<string, { plays: number; views: number; uniquePlays: number; uniqueViews: number; pitchSecond: number | null }> = {};
  for (const row of (vturbRes.data ?? [])) {
    const k = row.video_id;
    if (!vturbMap[k]) vturbMap[k] = { plays: 0, views: 0, uniquePlays: 0, uniqueViews: 0, pitchSecond: null };
    vturbMap[k].plays       += Number(row.plays);
    vturbMap[k].views       += Number(row.views);
    vturbMap[k].uniquePlays += Number(row.unique_plays ?? 0);
    vturbMap[k].uniqueViews += Number(row.unique_views ?? 0);
    if (row.pitch_second != null) vturbMap[k].pitchSecond = Number(row.pitch_second);
  }

  const retentionByVideo: Record<string, VSLRetentionPoint[]> = {};
  for (const row of (retentionRes.data ?? [])) {
    if (!retentionByVideo[row.video_id]) retentionByVideo[row.video_id] = [];
    retentionByVideo[row.video_id].push({ second: Number(row.second), percentage: Number(row.percentage) });
  }
  for (const points of Object.values(retentionByVideo)) points.sort((a, b) => a.second - b.second);

  const allAdIds = new Set([...Object.keys(invMap), ...Object.keys(salesMap)]);

  const resolveVideo = (adId: string, campaignName: string) =>
    adVideoMap[adId] ?? campVideoMap[campaignName] ?? defaultVideo;

  const maxRoi = Math.max(1, ...[...allAdIds].map(id => {
    const inv = invMap[id]?.investment ?? 0;
    const rev = salesMap[id]?.revenue ?? 0;
    return inv > 0 ? (rev - inv) / inv : 0;
  }));
  const maxConvRate = Math.max(0.0001, ...[...allAdIds].map(id => {
    const sale = salesMap[id];
    const campaignName = (invMap[id]?.campaignId ? campNameById[invMap[id].campaignId!] : null) ?? sale?.campaignName ?? "Sin campaña";
    const video = resolveVideo(id, campaignName);
    const plays = video ? (vturbMap[video.videoId]?.plays ?? 0) : 0;
    return plays > 0 ? (sale?.count ?? 0) / plays : 0;
  }));

  return [...allAdIds].map(adId => {
    const inv  = invMap[adId]  ?? { adName: adId, campaignId: null, investment: 0, impressions: 0, clicks: 0 };
    const sale = salesMap[adId] ?? { count: 0, revenue: 0, adName: null, adsetName: null, placement: null, campaignName: null };
    const campaignName = (inv.campaignId ? campNameById[inv.campaignId] : null) ?? sale.campaignName ?? "Sin campaña";
    const video = resolveVideo(adId, campaignName);
    const vturb = video ? (vturbMap[video.videoId] ?? null) : null;
    const retention = video ? (retentionByVideo[video.videoId] ?? []) : [];

    const cac = sale.count > 0 ? inv.investment / sale.count : 0;
    const roi = inv.investment > 0 ? (sale.revenue - inv.investment) / inv.investment : 0;
    const convRate = vturb && vturb.plays > 0 ? sale.count / vturb.plays : 0;
    const engagement = averageRetention(retention);
    const pitchAudience = vturb?.pitchSecond != null ? retentionAt(retention, vturb.pitchSecond) : null;
    const playRate = vturb && vturb.views > 0 ? (vturb.plays / vturb.views) * 100 : 0;
    const score = computeScore({ roi, convRate, pitchAudience, engagement }, maxRoi, maxConvRate);

    return {
      adId,
      adName:       inv.adName ?? sale.adName ?? adId,
      adsetName:    sale.adsetName,
      placement:    sale.placement,
      campaignName,
      videoId:      video?.videoId ?? null,
      videoName:    video?.videoName ?? null,
      investment:   inv.investment,
      clicks:       inv.clicks,
      impressions:  inv.impressions,
      sales:        sale.count,
      cac, roi, convRate,
      views:        vturb?.views ?? 0,
      uniqueViews:  vturb?.uniqueViews ?? 0,
      plays:        vturb?.plays ?? 0,
      uniquePlays:  vturb?.uniquePlays ?? 0,
      playRate,
      engagement,
      pitchAudience,
      score,
    };
  }).sort((a, b) => b.score - a.score);
}
```

- [ ] **Step 5: Verificar tipos con `tsc`**

Run: `npm run build`
Expected: compila sin errores de tipos. Si aparecen errores en `getFunnelByCampaign`/`getVSLRetention` por los cambios de Steps 2-3, corregir antes de continuar (revisar que todo objeto que construye `retention`/`pitchSecond` tenga los tipos declarados arriba).

- [ ] **Step 6: Reconciliar contra datos reales**

Run:
```bash
supabase db query --linked "select coalesce(sum(amount),0) as total_by_ad from transactions t where t.status='active' and t.ad_id is not null and t.created_at >= '2026-07-05' and t.created_at < '2026-07-07';"
supabase db query --linked "select coalesce(sum(amount),0) as total_by_campaign from transactions t where t.status='active' and t.traffic_source is not null and t.traffic_source != '' and t.created_at >= '2026-07-05' and t.created_at < '2026-07-07';"
```
Expected: `total_by_ad` ≤ `total_by_campaign` (todo lo atribuido a un anuncio también está atribuido a una campaña; puede haber ventas con campaña pero sin `ad_id` si el `external_code` no traía el segmento — no debería haber al revés).

- [ ] **Step 7: Commit**

```bash
git add src/services/analytics.ts
git commit -m "feat(analytics): agregar getAdVSLRanking y fórmula de score compartida con audiencia del pitch"
```

---

### Task 6: `AdRankingTable.tsx` — tabla de ranking por anuncio

**Files:**
- Create: `src/components/analytics/AdRankingTable.tsx`
- Modify: `src/hooks/useAnalyticsData.ts`
- Modify: `src/views/AnalyticsView.tsx`

**Interfaces:**
- Consumes: `AdVSLRow`, `classifyAd`, `AdAction` de `src/services/analytics.ts` (Task 5).
- Produces: componente `AdRankingTable({ rows: AdVSLRow[]; cacTarget: number; ticketMin: number })`; `useAnalyticsData()` expone `adRanking: AdVSLRow[]`.

- [ ] **Step 1: Agregar `adRanking` al hook**

En `src/hooks/useAnalyticsData.ts`, agregar el import (línea 4-7):
```typescript
import {
  buildRange, previousRange,
  getAnalyticsSummary, getFunnelByCampaign, getVSLRetention,
  getAdsRanking, getHourlyHeatmap, getLTVBySource, generateAlerts,
  getVSLMappings, getProductRevenue,
} from "../services/analytics";
```
por:
```typescript
import {
  buildRange, previousRange,
  getAnalyticsSummary, getFunnelByCampaign, getVSLRetention,
  getAdsRanking, getAdVSLRanking, getHourlyHeatmap, getLTVBySource, generateAlerts,
  getVSLMappings, getProductRevenue,
} from "../services/analytics";
```

Agregar `AdVSLRow` al import de tipos (línea 8-11):
```typescript
import type {
  PeriodKey, DateRange, AnalyticsSummary, FunnelCampaign, VSLData,
  AdRankRow, HeatmapCell, LTVRow, Alert, VSLMapping, ProductRevenueRow,
} from "../services/analytics";
```
por:
```typescript
import type {
  PeriodKey, DateRange, AnalyticsSummary, FunnelCampaign, VSLData,
  AdRankRow, AdVSLRow, HeatmapCell, LTVRow, Alert, VSLMapping, ProductRevenueRow,
} from "../services/analytics";
```

Agregar `adRanking` a la interfaz `AnalyticsState` (línea 13-26) y a `EMPTY` (línea 28-31):
```typescript
export interface AnalyticsState {
  summary:        AnalyticsSummary | null;
  funnel:         FunnelCampaign[];
  vsls:           VSLData[];
  ranking:        AdRankRow[];
  heatmap:        HeatmapCell[];
  ltv:            LTVRow[];
  alerts:         Alert[];
  mappings:       VSLMapping[];
  productRevenue: ProductRevenueRow[];
  loading:        boolean;
  error:          string | null;
  range:          DateRange | null;
}

const EMPTY: AnalyticsState = {
  summary: null, funnel: [], vsls: [], ranking: [], heatmap: [],
  ltv: [], alerts: [], mappings: [], productRevenue: [], loading: true, error: null, range: null,
};
```
por:
```typescript
export interface AnalyticsState {
  summary:        AnalyticsSummary | null;
  funnel:         FunnelCampaign[];
  vsls:           VSLData[];
  ranking:        AdRankRow[];
  adRanking:      AdVSLRow[];
  heatmap:        HeatmapCell[];
  ltv:            LTVRow[];
  alerts:         Alert[];
  mappings:       VSLMapping[];
  productRevenue: ProductRevenueRow[];
  loading:        boolean;
  error:          string | null;
  range:          DateRange | null;
}

const EMPTY: AnalyticsState = {
  summary: null, funnel: [], vsls: [], ranking: [], adRanking: [], heatmap: [],
  ltv: [], alerts: [], mappings: [], productRevenue: [], loading: true, error: null, range: null,
};
```

En `load()`, agregar `getAdVSLRanking(r)` al `Promise.all` (líneas 48-58):
```typescript
      const [summary, summaryPrev, funnel, vsls, ranking, heatmap, ltv, mappings, productRevenue] = await Promise.all([
        getAnalyticsSummary(r),
        getAnalyticsSummary(rPrev),
        getFunnelByCampaign(r),
        getVSLRetention(r),
        getAdsRanking(r),
        getHourlyHeatmap(r),
        getLTVBySource(r),
        getVSLMappings(),
        getProductRevenue(),
      ]);

      const summaryWithPrev: AnalyticsSummary = { ...summary, prev: summaryPrev };
      const alerts = generateAlerts(summaryWithPrev, funnel, vsls);

      setState({ summary: summaryWithPrev, funnel, vsls, ranking, heatmap, ltv, alerts, mappings, productRevenue, loading: false, error: null, range: r });
```
por:
```typescript
      const [summary, summaryPrev, funnel, vsls, ranking, adRanking, heatmap, ltv, mappings, productRevenue] = await Promise.all([
        getAnalyticsSummary(r),
        getAnalyticsSummary(rPrev),
        getFunnelByCampaign(r),
        getVSLRetention(r),
        getAdsRanking(r),
        getAdVSLRanking(r),
        getHourlyHeatmap(r),
        getLTVBySource(r),
        getVSLMappings(),
        getProductRevenue(),
      ]);

      const summaryWithPrev: AnalyticsSummary = { ...summary, prev: summaryPrev };
      const alerts = generateAlerts(summaryWithPrev, funnel, vsls);

      setState({ summary: summaryWithPrev, funnel, vsls, ranking, adRanking, heatmap, ltv, alerts, mappings, productRevenue, loading: false, error: null, range: r });
```

- [ ] **Step 2: Crear `AdRankingTable.tsx`**

```typescript
// src/components/analytics/AdRankingTable.tsx
import { useState } from "react";
import { C } from "../../tokens";
import { InfoTooltip } from "./InfoTooltip";
import { classifyAd } from "../../services/analytics";
import type { AdVSLRow, AdAction } from "../../services/analytics";

const AD_ACTION_STYLE: Record<AdAction, { color: string; bg: string; border: string }> = {
  ESCALAR:    { color: C.green,  bg: C.greenSoft,             border: "rgba(48,209,88,0.3)"  },
  PAUSAR:     { color: C.red,    bg: "rgba(255,65,59,0.12)",  border: "rgba(255,65,59,0.3)"  },
  MONITOREAR: { color: C.yellow, bg: "rgba(255,194,82,0.12)", border: "rgba(255,194,82,0.3)" },
};

function scoreColor(s: number) { return s >= 80 ? C.green : s >= 50 ? C.yellow : C.red; }
function cacColor(cac: number, target: number) {
  if (cac === 0 || target === 0) return C.mutedMid;
  if (cac <= target)       return C.green;
  if (cac <= target * 1.5) return C.yellow;
  return C.red;
}

interface Props {
  rows:      AdVSLRow[];
  cacTarget: number;
  ticketMin: number;
}

export function AdRankingTable({ rows, cacTarget, ticketMin }: Props) {
  const [expanded, setExpanded] = useState<Set<string>>(new Set());

  const toggle = (adId: string) => {
    setExpanded(prev => {
      const next = new Set(prev);
      if (next.has(adId)) next.delete(adId); else next.add(adId);
      return next;
    });
  };

  if (rows.length === 0) return null;

  return (
    <section>
      <div style={{ fontSize: 13, fontWeight: 600, color: C.white, marginBottom: 12 }}>
        Ranking de Anuncios
        <InfoTooltip text="Cada fila es un anuncio individual de Meta cruzado con el VSL que usa. Ordenado por Score descendente — el de arriba es el candidato más fuerte a escalar." />
      </div>
      <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, overflow: "hidden" }}>
        <div style={{ overflowX: "auto" }}>
          <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 12 }}>
            <thead>
              <tr style={{ borderBottom: `1px solid ${C.border}` }}>
                {["", "Anuncio", "VSL", "Inv.", "CAC", "ROI", "Vistas", "Vistas Ún.", "Repr.", "Repr. Ún.", "Tasa Repr.", "Engagement", "Aud. Pitch", "Score", "Acción"].map(h => (
                  <th key={h} style={{ padding: "8px", color: C.mutedMid, fontWeight: 500, textAlign: "left", whiteSpace: "nowrap" }}>{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {rows.map(r => {
                const action  = classifyAd(r, cacTarget, ticketMin);
                const acStyle = AD_ACTION_STYLE[action];
                const isOpen  = expanded.has(r.adId);
                return (
                  <>
                    <tr key={r.adId} style={{ borderBottom: `1px solid ${C.border}` }}>
                      <td style={{ padding: "8px" }}>
                        <button onClick={() => toggle(r.adId)} style={{ background: "transparent", border: "none", color: C.mutedMid, cursor: "pointer", fontSize: 11 }}>
                          {isOpen ? "▾" : "▸"}
                        </button>
                      </td>
                      <td style={{ padding: "8px", color: C.white, fontWeight: 500, maxWidth: 160, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{r.adName}</td>
                      <td style={{ padding: "8px", color: C.mutedLight, maxWidth: 120, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{r.videoName ?? "Sin VSL"}</td>
                      <td style={{ padding: "8px", color: C.mutedLight }}>${r.investment.toFixed(0)}</td>
                      <td style={{ padding: "8px", color: cacColor(r.cac, cacTarget), fontWeight: 700 }}>{r.cac > 0 ? `$${r.cac.toFixed(0)}` : "—"}</td>
                      <td style={{ padding: "8px", color: r.roi >= 1 ? C.green : r.roi >= 0 ? C.yellow : C.red, fontWeight: 600 }}>{r.investment > 0 ? `${r.roi.toFixed(2)}x` : "—"}</td>
                      <td style={{ padding: "8px", color: C.mutedLight }}>{r.views.toLocaleString("es")}</td>
                      <td style={{ padding: "8px", color: C.mutedLight }}>{r.uniqueViews.toLocaleString("es")}</td>
                      <td style={{ padding: "8px", color: C.mutedLight }}>{r.plays.toLocaleString("es")}</td>
                      <td style={{ padding: "8px", color: C.mutedLight }}>{r.uniquePlays.toLocaleString("es")}</td>
                      <td style={{ padding: "8px", color: C.mutedLight }}>{r.playRate.toFixed(1)}%</td>
                      <td style={{ padding: "8px", color: C.mutedLight }}>{r.engagement.toFixed(0)}%</td>
                      <td style={{ padding: "8px", color: C.mutedLight }}>{r.pitchAudience != null ? `${r.pitchAudience.toFixed(0)}%` : "—"}</td>
                      <td style={{ padding: "8px" }}>
                        <span style={{ background: `${scoreColor(r.score)}20`, color: scoreColor(r.score), borderRadius: 12, padding: "2px 8px", fontSize: 11, fontWeight: 700 }}>{r.score}</span>
                      </td>
                      <td style={{ padding: "8px" }}>
                        <span style={{ background: acStyle.bg, border: `1px solid ${acStyle.border}`, color: acStyle.color, borderRadius: 12, padding: "2px 10px", fontSize: 10, fontWeight: 700, whiteSpace: "nowrap" }}>{action}</span>
                      </td>
                    </tr>
                    {isOpen && (
                      <tr key={`${r.adId}-detail`} style={{ borderBottom: `1px solid ${C.border}`, background: "rgba(255,255,255,0.02)" }}>
                        <td colSpan={15} style={{ padding: "8px 16px", fontSize: 11, color: C.mutedMid }}>
                          <strong>ad_id:</strong> {r.adId} · <strong>adset:</strong> {r.adsetName ?? "—"} · <strong>placement:</strong> {r.placement ?? "—"} · <strong>campaña:</strong> {r.campaignName}
                        </td>
                      </tr>
                    )}
                  </>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>
    </section>
  );
}
```

- [ ] **Step 3: Renderizar en `AnalyticsView.tsx`**

Agregar el import (después de la línea 7):
```typescript
import { CampaignFunnelCard }         from "../components/analytics/CampaignFunnelCard";
```
por:
```typescript
import { CampaignFunnelCard }         from "../components/analytics/CampaignFunnelCard";
import { AdRankingTable }             from "../components/analytics/AdRankingTable";
```

Agregar `adRanking` a la desestructuración del hook (línea 32):
```typescript
    summary, funnel, vsls, ranking, heatmap, ltv, alerts, mappings, productRevenue,
```
por:
```typescript
    summary, funnel, vsls, ranking, adRanking, heatmap, ltv, alerts, mappings, productRevenue,
```

Agregar un `filteredAdRanking` memo (después de `filteredFunnel`, línea 43-46):
```typescript
  const filteredAdRanking = useMemo(
    () => selectedVslId ? adRanking.filter(a => a.videoId === selectedVslId) : adRanking,
    [adRanking, selectedVslId],
  );
```

Renderizar la tabla justo antes de la sección "Funnels por Campaña" (antes de la línea 202 `{(loading || filteredFunnel.length > 0) && (`):
```typescript
          <AdRankingTable rows={filteredAdRanking} cacTarget={cacTarget} ticketMin={ticketMin} />

          {(loading || filteredFunnel.length > 0) && (
```

- [ ] **Step 4: Verificar tipos y compilación**

Run: `npm run build`
Expected: compila sin errores.

- [ ] **Step 5: Verificación manual en navegador**

Run: `npm run dev`
Abrir la URL local, entrar a Analytics, confirmar que aparece el bloque "Ranking de Anuncios" con filas reales (o el bloque no se renderiza si `adRanking` está vacío — comportamiento esperado si aún no hay datos sincronizados de anuncios para el período seleccionado). Expandir una fila y confirmar que el detalle crudo (`ad_id`, `adset`, `placement`, `campaña`) se muestra.

- [ ] **Step 6: Commit**

```bash
git add src/components/analytics/AdRankingTable.tsx src/hooks/useAnalyticsData.ts src/views/AnalyticsView.tsx
git commit -m "feat(analytics): agregar tabla de ranking de anuncios (anuncio × VSL)"
```

---

### Task 7: `CampaignFunnelCard.tsx` — drill-down a anuncios

**Files:**
- Modify: `src/components/analytics/CampaignFunnelCard.tsx`
- Modify: `src/views/AnalyticsView.tsx`

**Interfaces:**
- Consumes: `AdVSLRow` (Task 5), `filteredAdRanking` computado en `AnalyticsView` (Task 6).
- Produces: `CampaignFunnelCard` acepta prop nueva `ads: AdVSLRow[]`.

- [ ] **Step 1: Agregar el drill-down expandible a `CampaignFunnelCard.tsx`**

Reemplazar todo el archivo:
```typescript
import { useState } from "react";
import { C } from "../../tokens";
import { InfoTooltip } from "./InfoTooltip";
import type { FunnelCampaign, AdVSLRow } from "../../services/analytics";

function pct(a: number, b: number) { return b > 0 ? `${((a / b) * 100).toFixed(1)}%` : "—"; }
function scoreColor(s: number) { return s >= 80 ? "#FE803F" : s >= 50 ? "#FFC252" : "#FF413B"; }

interface Props { campaign: FunnelCampaign; ads: AdVSLRow[] }

export function CampaignFunnelCard({ campaign: c, ads }: Props) {
  const [expanded, setExpanded] = useState(false);

  const stages = [
    { label: "Impresiones", value: c.impressions, conv: null },
    { label: "Clicks",      value: c.clicks,      conv: pct(c.clicks, c.impressions) },
    { label: "Plays",       value: c.plays,        conv: pct(c.plays, c.clicks) },
    { label: "CTA Click",   value: c.ctaClicks,    conv: pct(c.ctaClicks, c.plays) },
    { label: "Compras",     value: c.sales,        conv: pct(c.sales, c.ctaClicks) },
  ];
  const maxVal = Math.max(...stages.map(s => s.value), 1);

  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 20 }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 16 }}>
        <div style={{ display: "flex", alignItems: "flex-start", gap: 8 }}>
          {ads.length > 0 && (
            <button onClick={() => setExpanded(v => !v)} style={{ background: "transparent", border: "none", color: C.mutedMid, cursor: "pointer", fontSize: 12, padding: "2px 0" }}>
              {expanded ? "▾" : "▸"}
            </button>
          )}
          <div>
            <div style={{ fontSize: 13, fontWeight: 600, color: C.white, marginBottom: 2 }}>{c.campaignName}</div>
            <div style={{ fontSize: 11, color: C.mutedMid }}>{c.videoName ?? "Sin VSL asignado"}</div>
          </div>
        </div>
        <span style={{
          display: "inline-flex", alignItems: "center",
          background: `${scoreColor(c.score)}20`, color: scoreColor(c.score),
          border: `1px solid ${scoreColor(c.score)}`, borderRadius: 20,
          fontSize: 11, fontWeight: 700, padding: "2px 10px",
        }}>
          Score {c.score}
          <InfoTooltip text="Combina ROI (30%), tasa de conversión (20%), audiencia del pitch (30%) y engagement (20%) en un puntaje de 0 a 100." align="right" />
        </span>
      </div>

      <div style={{ display: "flex", gap: 4, alignItems: "flex-end", marginBottom: 16 }}>
        {stages.map((s, i) => {
          const h = Math.max(8, (s.value / maxVal) * 64);
          const opacity = i === 0 || i === stages.length - 1 ? "FF" : "80";
          return (
            <div key={i} style={{ flex: 1, textAlign: "center" }}>
              <div style={{ fontSize: 10, color: C.mutedMid, marginBottom: 4 }}>{s.label}</div>
              <div style={{ height: h, background: `${C.orange}${opacity}`, borderRadius: 4, marginBottom: 4 }} />
              <div style={{ fontSize: 11, fontWeight: 600, color: C.white }}>{s.value.toLocaleString("es")}</div>
              {s.conv && <div style={{ fontSize: 10, color: C.mutedMid }}>{s.conv}</div>}
            </div>
          );
        })}
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 8, borderTop: `1px solid ${C.border}`, paddingTop: 14 }}>
        <div>
          <div style={{ fontSize: 10, color: C.mutedMid }}>CAC</div>
          <div style={{ fontSize: 14, fontWeight: 700, color: C.white }}>${c.cac.toFixed(0)}</div>
        </div>
        <div>
          <div style={{ fontSize: 10, color: C.mutedMid }}>ROI</div>
          <div style={{ fontSize: 14, fontWeight: 700, color: c.roi >= 1 ? "#FE803F" : "#FFC252" }}>{c.roi.toFixed(2)}x</div>
        </div>
        <div>
          <div style={{ fontSize: 10, color: C.mutedMid }}>Inversión</div>
          <div style={{ fontSize: 14, fontWeight: 700, color: C.white }}>${c.investment.toFixed(0)}</div>
        </div>
        {c.topHour !== null && (
          <div>
            <div style={{ fontSize: 10, color: C.mutedMid }}>Hora pico</div>
            <div style={{ fontSize: 13, fontWeight: 600, color: C.mutedLight }}>{c.topHour}:00h</div>
          </div>
        )}
      </div>

      {expanded && ads.length > 0 && (
        <div style={{ borderTop: `1px solid ${C.border}`, marginTop: 14, paddingTop: 12, display: "flex", flexDirection: "column", gap: 8 }}>
          {ads.map(a => (
            <div key={a.adId} style={{ display: "flex", justifyContent: "space-between", alignItems: "center", background: "rgba(255,255,255,0.03)", borderRadius: 8, padding: "8px 10px" }}>
              <div style={{ minWidth: 0 }}>
                <div style={{ fontSize: 12, color: C.white, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{a.adName}</div>
                <div style={{ fontSize: 10, color: C.mutedMid }}>{a.videoName ?? "Sin VSL"}</div>
              </div>
              <div style={{ display: "flex", gap: 12, flexShrink: 0, fontSize: 11 }}>
                <span style={{ color: C.mutedLight }}>CAC ${a.cac.toFixed(0)}</span>
                <span style={{ color: a.roi >= 1 ? "#FE803F" : "#FFC252" }}>{a.roi.toFixed(2)}x</span>
                <span style={{ color: C.mutedLight }}>{a.sales} ventas</span>
                <span style={{ color: scoreColor(a.score), fontWeight: 700 }}>{a.score}</span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
```

- [ ] **Step 2: Pasar `ads` desde `AnalyticsView.tsx`**

Reemplazar el render de las tarjetas (línea 217):
```typescript
                  {filteredFunnel.map(f => <CampaignFunnelCard key={f.campaignName} campaign={f} />)}
```
por:
```typescript
                  {filteredFunnel.map(f => (
                    <CampaignFunnelCard
                      key={f.campaignName}
                      campaign={f}
                      ads={filteredAdRanking.filter(a => a.campaignName === f.campaignName)}
                    />
                  ))}
```

- [ ] **Step 3: Verificar y probar**

Run: `npm run build`
Expected: sin errores de tipos.

Run: `npm run dev` — abrir Analytics, expandir una `CampaignFunnelCard` que tenga anuncios reales atribuidos, confirmar que las filas hijas aparecen y que sus valores de CAC/ROI/ventas son coherentes con la tarjeta padre (la suma de ventas de los anuncios hijos no debería superar las ventas totales de la campaña).

- [ ] **Step 4: Commit**

```bash
git add src/components/analytics/CampaignFunnelCard.tsx src/views/AnalyticsView.tsx
git commit -m "feat(analytics): drill-down de campaña a anuncios individuales en CampaignFunnelCard"
```

---

### Task 8: `VSLIntelligencePanel.tsx` — anuncios reales + KPIs nuevos

**Files:**
- Modify: `src/components/analytics/VSLIntelligencePanel.tsx`
- Modify: `src/views/AnalyticsView.tsx`

**Interfaces:**
- Consumes: `AdVSLRow` (Task 5), `filteredAdRanking`/`adRanking` (Task 6), `VSLData` extendido (Task 5, campos `views/uniqueViews/uniquePlays/engagement/pitchAudience`).
- Produces: `VSLIntelligencePanel` recibe prop nueva `adRanking: AdVSLRow[]` (reemplaza el uso de `ranking: AdRankRow[]` dentro de la pestaña "Fuente de tráfico").

- [ ] **Step 1: Actualizar `AdSourceView` para recibir `AdVSLRow[]`**

Reemplazar la función `AdSourceView` completa (líneas 194-251):
```typescript
function AdSourceView({ rows, cacTarget, ticketMin }: { rows: AdRankRow[]; cacTarget: number; ticketMin: number }) {
  if (rows.length === 0) return (
    <DimEmpty msg="Sin anuncios atribuidos a este VSL en el período. Verifica el mapeo campaña→VSL arriba." />
  );
  return (
    <div style={{ padding: "8px 16px 12px", overflowX: "auto" }}>
      <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 12 }}>
        <thead>
          <tr style={{ borderBottom: `1px solid ${C.border}` }}>
            {[
              { h: "Campaña" }, { h: "Inv." }, { h: "Ventas" },
              { h: "CAC",    help: "Inversión ÷ Ventas de esta campaña. Más bajo es mejor." },
              { h: "ROI",    help: "(Ingresos − Inversión) ÷ Inversión de esta campaña. 1.0x = recuperaste el doble de lo invertido." },
              { h: "Score",  help: "Combina el ROI relativo (50%) y la conversión ventas/plays (50%) en un puntaje de 0 a 100 para comparar campañas de un vistazo." },
              { h: "Acción", help: "ESCALAR: cumple el CAC objetivo, ROI ≥ 1x y el ticket mínimo — sube presupuesto. PAUSAR: CAC muy por encima del objetivo o ROI negativo. MONITOREAR: aún no cumple ninguno de los dos criterios." },
            ].map(({ h, help }) => (
              <th key={h} style={{ padding: "6px 8px", color: C.mutedMid, fontWeight: 500, textAlign: "left", whiteSpace: "nowrap" }}>
                {h}
                {help && <InfoTooltip text={help} />}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((r, i) => {
            const action  = classifyAd(r, cacTarget, ticketMin);
            const acStyle = AD_ACTION_STYLE[action];
            return (
              <tr key={`${r.campaignName}-${i}`} style={{ borderBottom: `1px solid ${C.border}` }}>
                <td style={{ padding: "9px 8px", color: C.white, fontWeight: 500, maxWidth: 160, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                  {r.campaignName}
                </td>
                <td style={{ padding: "9px 8px", color: C.mutedLight }}>${r.investment.toFixed(0)}</td>
                <td style={{ padding: "9px 8px", color: C.mutedLight }}>{r.sales}</td>
                <td style={{ padding: "9px 8px", color: adCacColor(r.cac, cacTarget), fontWeight: 700 }}>
                  {r.cac > 0 ? `$${r.cac.toFixed(0)}` : "—"}
                </td>
                <td style={{ padding: "9px 8px", color: r.roi >= 1 ? C.green : r.roi >= 0 ? C.yellow : C.red, fontWeight: 600 }}>
                  {r.investment > 0 ? `${r.roi.toFixed(2)}x` : "—"}
                </td>
                <td style={{ padding: "9px 8px" }}>
                  <span style={{ background: `${adScoreColor(r.score)}20`, color: adScoreColor(r.score), borderRadius: 12, padding: "2px 8px", fontSize: 11, fontWeight: 700 }}>
                    {r.score}
                  </span>
                </td>
                <td style={{ padding: "9px 8px" }}>
                  <span style={{ background: acStyle.bg, border: `1px solid ${acStyle.border}`, color: acStyle.color, borderRadius: 12, padding: "2px 10px", fontSize: 10, fontWeight: 700, whiteSpace: "nowrap" }}>
                    {action}
                  </span>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
```
por:
```typescript
function AdSourceView({ rows, cacTarget, ticketMin }: { rows: AdVSLRow[]; cacTarget: number; ticketMin: number }) {
  if (rows.length === 0) return (
    <DimEmpty msg="Sin anuncios atribuidos a este VSL en el período. Verifica el mapeo anuncio→VSL o campaña→VSL arriba." />
  );
  return (
    <div style={{ padding: "8px 16px 12px", overflowX: "auto" }}>
      <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 12 }}>
        <thead>
          <tr style={{ borderBottom: `1px solid ${C.border}` }}>
            {[
              { h: "Anuncio" }, { h: "Inv." }, { h: "Ventas" },
              { h: "CAC",    help: "Inversión ÷ Ventas de este anuncio. Más bajo es mejor." },
              { h: "ROI",    help: "(Ingresos − Inversión) ÷ Inversión de este anuncio. 1.0x = recuperaste el doble de lo invertido." },
              { h: "Score",  help: "Combina ROI (30%), conversión (20%), audiencia del pitch (30%) y engagement (20%) en un puntaje de 0 a 100." },
              { h: "Acción", help: "ESCALAR: cumple el CAC objetivo, ROI ≥ 1x y el ticket mínimo — sube presupuesto. PAUSAR: CAC muy por encima del objetivo o ROI negativo. MONITOREAR: aún no cumple ninguno de los dos criterios." },
            ].map(({ h, help }) => (
              <th key={h} style={{ padding: "6px 8px", color: C.mutedMid, fontWeight: 500, textAlign: "left", whiteSpace: "nowrap" }}>
                {h}
                {help && <InfoTooltip text={help} />}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((r) => {
            const action  = classifyAd(r, cacTarget, ticketMin);
            const acStyle = AD_ACTION_STYLE[action];
            return (
              <tr key={r.adId} style={{ borderBottom: `1px solid ${C.border}` }}>
                <td style={{ padding: "9px 8px", color: C.white, fontWeight: 500, maxWidth: 160, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                  {r.adName}
                </td>
                <td style={{ padding: "9px 8px", color: C.mutedLight }}>${r.investment.toFixed(0)}</td>
                <td style={{ padding: "9px 8px", color: C.mutedLight }}>{r.sales}</td>
                <td style={{ padding: "9px 8px", color: adCacColor(r.cac, cacTarget), fontWeight: 700 }}>
                  {r.cac > 0 ? `$${r.cac.toFixed(0)}` : "—"}
                </td>
                <td style={{ padding: "9px 8px", color: r.roi >= 1 ? C.green : r.roi >= 0 ? C.yellow : C.red, fontWeight: 600 }}>
                  {r.investment > 0 ? `${r.roi.toFixed(2)}x` : "—"}
                </td>
                <td style={{ padding: "9px 8px" }}>
                  <span style={{ background: `${adScoreColor(r.score)}20`, color: adScoreColor(r.score), borderRadius: 12, padding: "2px 8px", fontSize: 11, fontWeight: 700 }}>
                    {r.score}
                  </span>
                </td>
                <td style={{ padding: "9px 8px" }}>
                  <span style={{ background: acStyle.bg, border: `1px solid ${acStyle.border}`, color: acStyle.color, borderRadius: 12, padding: "2px 10px", fontSize: 10, fontWeight: 700, whiteSpace: "nowrap" }}>
                    {action}
                  </span>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
```

Actualizar el import de tipos (línea 9):
```typescript
import type { VSLData, DateRange, DimensionRow, AdRankRow, AdAction } from "../../services/analytics";
```
por:
```typescript
import type { VSLData, DateRange, DimensionRow, AdVSLRow, AdAction } from "../../services/analytics";
```

- [ ] **Step 2: Actualizar `Props` y el filtro `adsForThisVsl`**

Reemplazar (líneas 264-286):
```typescript
interface Props {
  primary:   VSLData | null;
  compare?:  VSLData | null;
  range:     DateRange | null;
  ranking:   AdRankRow[];
  cacTarget: number;
  ticketMin: number;
}

// ── Componente principal ──────────────────────────────────────────────────────

export function VSLIntelligencePanel({ primary, compare, range, ranking, cacTarget, ticketMin }: Props) {
  const [activeTab,       setActiveTabState] = useState<DimensionTab>("general");
  const [dimCache,        setDimCache]       = useState<Partial<Record<DimensionTab, DimensionRow[]>>>({});
  const [dimLoading,      setDimLoading]     = useState(false);
  const [showConversions, setShowConversions] = useState(false);

  const adsForThisVsl = useMemo(
    () => ranking.filter(r => r.videoId === primary?.videoId),
    [ranking, primary?.videoId],
  );
```
por:
```typescript
interface Props {
  primary:   VSLData | null;
  compare?:  VSLData | null;
  range:     DateRange | null;
  adRanking: AdVSLRow[];
  cacTarget: number;
  ticketMin: number;
}

// ── Componente principal ──────────────────────────────────────────────────────

export function VSLIntelligencePanel({ primary, compare, range, adRanking, cacTarget, ticketMin }: Props) {
  const [activeTab,       setActiveTabState] = useState<DimensionTab>("general");
  const [dimCache,        setDimCache]       = useState<Partial<Record<DimensionTab, DimensionRow[]>>>({});
  const [dimLoading,      setDimLoading]     = useState(false);
  const [showConversions, setShowConversions] = useState(false);

  const adsForThisVsl = useMemo(
    () => adRanking.filter(r => r.videoId === primary?.videoId),
    [adRanking, primary?.videoId],
  );
```

- [ ] **Step 3: Agregar las `KpiCard` nuevas al final del panel**

Reemplazar el bloque de KPIs (líneas 516-530):
```typescript
      {/* KPIs — siempre visibles */}
      <div style={{ display: "flex", gap: 10, padding: "16px 20px 20px", flexWrap: "wrap" }}>
        <KpiCard label="Plays" value={primary.plays.toLocaleString("es")} />
        <KpiCard label="Hook (25%)"       value={`${primary.ret25.toFixed(0)}%`} color={LEVEL_COLOR[hookLevel]} sub="Retención al cuarto" />
        <KpiCard label="Ret. media (50%)" value={`${primary.ret50.toFixed(0)}%`} color={LEVEL_COLOR[retLevel]}  sub="Mitad del video" />
        <KpiCard label="Cierre (75%)"     value={`${primary.ret75.toFixed(0)}%`}
          color={primary.ret75 >= 20 ? "#22c55e" : primary.ret75 >= 10 ? C.yellow : C.red}
          sub="Tres cuartos" />
        <KpiCard label="CTA Click Rate"   value={`${ctaRate.toFixed(1)}%`} color={LEVEL_COLOR[ctaLevel]} sub={`${primary.ctaClicks.toLocaleString("es")} clicks`} />
        <KpiCard label="Conv. Rate"       value={`${primary.convRate.toFixed(1)}%`}
          color={primary.convRate >= 3 ? "#22c55e" : primary.convRate >= 1 ? C.yellow : C.red}
          sub={`${primary.sales} ventas`} />
        {primary.dropSecond != null && (
          <KpiCard label="Drop crítico" value={fmtSec(primary.dropSecond)} color={C.red} sub="Revisar guión aquí" />
        )}
      </div>
```
por:
```typescript
      {/* KPIs — siempre visibles */}
      <div style={{ display: "flex", gap: 10, padding: "16px 20px 20px", flexWrap: "wrap" }}>
        <KpiCard label="Plays" value={primary.plays.toLocaleString("es")} sub={`${primary.uniquePlays.toLocaleString("es")} únicas`} />
        <KpiCard label="Vistas" value={primary.views.toLocaleString("es")} sub={`${primary.uniqueViews.toLocaleString("es")} únicas`} />
        <KpiCard label="Hook (25%)"       value={`${primary.ret25.toFixed(0)}%`} color={LEVEL_COLOR[hookLevel]} sub="Retención al cuarto" />
        <KpiCard label="Ret. media (50%)" value={`${primary.ret50.toFixed(0)}%`} color={LEVEL_COLOR[retLevel]}  sub="Mitad del video" />
        <KpiCard label="Cierre (75%)"     value={`${primary.ret75.toFixed(0)}%`}
          color={primary.ret75 >= 20 ? "#22c55e" : primary.ret75 >= 10 ? C.yellow : C.red}
          sub="Tres cuartos" />
        <KpiCard label="Engagement" value={`${primary.engagement.toFixed(0)}%`} sub="Promedio de toda la curva" />
        <KpiCard label="Audiencia del pitch" value={primary.pitchAudience != null ? `${primary.pitchAudience.toFixed(0)}%` : "—"} sub={primary.pitchAudience != null ? "Configurado en VTurb" : "Sin pitch_time en VTurb"} />
        <KpiCard label="CTA Click Rate"   value={`${ctaRate.toFixed(1)}%`} color={LEVEL_COLOR[ctaLevel]} sub={`${primary.ctaClicks.toLocaleString("es")} clicks`} />
        <KpiCard label="Conv. Rate"       value={`${primary.convRate.toFixed(1)}%`}
          color={primary.convRate >= 3 ? "#22c55e" : primary.convRate >= 1 ? C.yellow : C.red}
          sub={`${primary.sales} ventas`} />
        {primary.dropSecond != null && (
          <KpiCard label="Drop crítico" value={fmtSec(primary.dropSecond)} color={C.red} sub="Revisar guión aquí" />
        )}
      </div>
```

- [ ] **Step 4: Pasar `adRanking` desde `AnalyticsView.tsx` en vez de `ranking`**

Reemplazar (líneas 193-200):
```typescript
          <VSLIntelligencePanel
            primary={selectedVsl}
            compare={compareVsl}
            range={range}
            ranking={ranking}
            cacTarget={cacTarget}
            ticketMin={ticketMin}
          />
```
por:
```typescript
          <VSLIntelligencePanel
            primary={selectedVsl}
            compare={compareVsl}
            range={range}
            adRanking={adRanking}
            cacTarget={cacTarget}
            ticketMin={ticketMin}
          />
```

`ranking` (el `AdRankRow[]` a nivel de campaña) queda sin ningún otro uso en este archivo tras este cambio — con `noUnusedLocals: true` en `tsconfig.app.json`, dejarlo destructurado del hook rompe `tsc -b`. Quitarlo de la desestructuración (línea 32):
```typescript
    summary, funnel, vsls, ranking, adRanking, heatmap, ltv, alerts, mappings, productRevenue,
```
por:
```typescript
    summary, funnel, vsls, adRanking, heatmap, ltv, alerts, mappings, productRevenue,
```
(`ranking` sigue existiendo en `AnalyticsState`/`useAnalyticsData` — Task 6 no lo toca — simplemente ya no se lee en este componente. No se elimina `getAdsRanking`/`AdRankRow` del servicio: siguen siendo exports públicos usados potencialmente por otros consumidores futuros, y `noUnusedLocals` no aplica a exports de módulo.)

- [ ] **Step 5: Verificar y probar**

Run: `npm run build`
Expected: sin errores de tipos (si `ranking` (el `AdRankRow[]` original) ya no se usa en `AnalyticsView.tsx` fuera de `AdRankingTable`... nota: `ranking` se sigue usando para `getAdsRanking` a nivel de campaña en otros lugares si existieran — confirmar con `tsc` que no queda ninguna referencia rota).

Run: `npm run dev` — seleccionar un VSL en la barra superior, abrir la pestaña "Fuente de tráfico", confirmar que ahora lista anuncios (no campañas) y que las nuevas `KpiCard` (Vistas, Engagement, Audiencia del pitch) muestran valores.

- [ ] **Step 6: Commit**

```bash
git add src/components/analytics/VSLIntelligencePanel.tsx src/views/AnalyticsView.tsx
git commit -m "feat(analytics): VSLIntelligencePanel muestra anuncios reales y KPIs de audiencia del pitch"
```

---

### Task 9: `CampaignMappingModal.tsx` — override Anuncio → VSL

**Files:**
- Modify: `src/services/analytics.ts`
- Modify: `src/components/analytics/CampaignMappingModal.tsx`
- Modify: `src/views/AnalyticsView.tsx`

**Interfaces:**
- Produces (en `analytics.ts`): `export interface AdVSLMapping { adId: string; videoId: string; videoName: string }`, `getAdVSLMappings(): Promise<AdVSLMapping[]>`, `saveAdVSLMapping(m: AdVSLMapping): Promise<void>`, `deleteAdVSLMapping(adId: string): Promise<void>`, `getAvailableAds(): Promise<{ adId: string; adName: string }[]>`.

- [ ] **Step 1: Agregar funciones de mapeo anuncio→VSL en `analytics.ts`**

Agregar después de `deleteVSLMapping()` (después de la línea 620):

```typescript
// ── Mapeo Anuncio → VSL (override opcional) ─────────────────────────────────────

export interface AdVSLMapping { adId: string; videoId: string; videoName: string }

export async function getAdVSLMappings(): Promise<AdVSLMapping[]> {
  const { data, error } = await supabase.from("ad_vsl_mapping").select("*");
  if (error) throw new Error(error.message);
  return (data ?? []).map((r: any) => ({ adId: r.ad_id, videoId: r.video_id, videoName: r.video_name ?? r.video_id }));
}

export async function saveAdVSLMapping(m: AdVSLMapping): Promise<void> {
  const { error } = await supabase.from("ad_vsl_mapping").upsert(
    { ad_id: m.adId, video_id: m.videoId, video_name: m.videoName },
    { onConflict: "ad_id" },
  );
  if (error) throw new Error(error.message);
}

export async function deleteAdVSLMapping(adId: string): Promise<void> {
  const { error } = await supabase.from("ad_vsl_mapping").delete().eq("ad_id", adId);
  if (error) throw new Error(error.message);
}

export interface AvailableAd { adId: string; adName: string }

export async function getAvailableAds(): Promise<AvailableAd[]> {
  const { data } = await supabase
    .from("ad_investment_data")
    .select("ad_id, ad_name")
    .not("ad_id", "is", null);

  const seen = new Set<string>();
  const result: AvailableAd[] = [];
  for (const row of (data ?? [])) {
    if (!seen.has(row.ad_id)) {
      seen.add(row.ad_id);
      result.push({ adId: row.ad_id, adName: row.ad_name ?? row.ad_id });
    }
  }
  return result.sort((a, b) => a.adName.localeCompare(b.adName));
}
```

- [ ] **Step 2: Agregar la pestaña "Anuncio → VSL" a `CampaignMappingModal.tsx`**

Reemplazar todo el archivo:
```typescript
import { useState, useEffect } from "react";
import { C } from "../../tokens";
import {
  saveVSLMapping, deleteVSLMapping, getAvailableVideos, DEFAULT_VSL_CAMPAIGN,
  getAdVSLMappings, saveAdVSLMapping, deleteAdVSLMapping, getAvailableAds,
} from "../../services/analytics";
import type { VSLMapping, VTurbVideo, AdVSLMapping, AvailableAd } from "../../services/analytics";

interface Props {
  open:      boolean;
  onClose:   () => void;
  mappings:  VSLMapping[];
  campaigns: string[];
  onSaved:   () => void;
}

type Tab = "campaign" | "ad";

export function CampaignMappingModal({ open, onClose, mappings, campaigns, onSaved }: Props) {
  const [tab, setTab] = useState<Tab>("campaign");

  const [newCampaign, setNewCampaign] = useState("");
  const [newVideoId,  setNewVideoId]  = useState("");
  const [saving,       setSaving]      = useState(false);
  const [videos,       setVideos]      = useState<VTurbVideo[]>([]);
  const [videosState,  setVideosState] = useState<"idle" | "loading" | "ready" | "error">("idle");
  const [filterVideoId, setFilterVideoId] = useState("");

  const [adMappings, setAdMappings] = useState<AdVSLMapping[]>([]);
  const [availableAds, setAvailableAds] = useState<AvailableAd[]>([]);
  const [newAdId, setNewAdId] = useState("");
  const [newAdVideoId, setNewAdVideoId] = useState("");
  const [adSaving, setAdSaving] = useState(false);

  useEffect(() => {
    if (open) {
      setVideosState("loading");
      getAvailableVideos()
        .then(v => { setVideos(v); setVideosState("ready"); })
        .catch(() => { setVideos([]); setVideosState("error"); });
      getAdVSLMappings().then(setAdMappings).catch(() => setAdMappings([]));
      getAvailableAds().then(setAvailableAds).catch(() => setAvailableAds([]));
    } else {
      setFilterVideoId("");
      setTab("campaign");
    }
  }, [open]);

  if (!open) return null;

  const unmapped        = campaigns.filter(c => !mappings.find(m => m.campaignName === c));
  const selectedName    = videos.find(v => v.videoId === newVideoId)?.videoName ?? newVideoId;
  const visibleMappings = filterVideoId ? mappings.filter(m => m.videoId === filterVideoId) : mappings;

  const unmappedAds     = availableAds.filter(a => !adMappings.find(m => m.adId === a.adId));
  const selectedAdVideoName = videos.find(v => v.videoId === newAdVideoId)?.videoName ?? newAdVideoId;

  const handleSave = async () => {
    if (!newCampaign || !newVideoId) return;
    setSaving(true);
    try {
      await saveVSLMapping({ campaignName: newCampaign, videoId: newVideoId, videoName: selectedName });
      setNewCampaign(""); setNewVideoId("");
      onSaved();
    } finally { setSaving(false); }
  };

  const handleDelete = async (campaignName: string) => {
    await deleteVSLMapping(campaignName);
    onSaved();
  };

  const handleSaveAd = async () => {
    if (!newAdId || !newAdVideoId) return;
    setAdSaving(true);
    try {
      await saveAdVSLMapping({ adId: newAdId, videoId: newAdVideoId, videoName: selectedAdVideoName });
      const refreshed = await getAdVSLMappings();
      setAdMappings(refreshed);
      setNewAdId(""); setNewAdVideoId("");
    } finally { setAdSaving(false); }
  };

  const handleDeleteAd = async (adId: string) => {
    await deleteAdVSLMapping(adId);
    setAdMappings(await getAdVSLMappings());
  };

  const sel = {
    background: C.bgSecondary, border: `1px solid ${C.border}`,
    borderRadius: 8, padding: "8px 12px", color: C.white, fontSize: 12, width: "100%",
  } as const;

  const tabBtn = (t: Tab, label: string) => (
    <button
      onClick={() => setTab(t)}
      style={{
        background: tab === t ? C.orange : "transparent",
        border: `1px solid ${tab === t ? C.orange : C.border}`,
        borderRadius: 20, padding: "4px 14px", fontSize: 12,
        color: tab === t ? C.white : C.mutedLight, cursor: "pointer",
      }}
    >
      {label}
    </button>
  );

  return (
    <div style={{ position: "fixed", inset: 0, background: "rgba(0,0,0,0.7)", display: "flex", alignItems: "center", justifyContent: "center", zIndex: 200 }}
      onClick={onClose}>
      <div style={{ background: C.panel, border: `1px solid ${C.border}`, borderRadius: 16, width: 560, maxHeight: "80vh", overflowY: "auto", padding: 28 }}
        onClick={e => e.stopPropagation()}>
        <div style={{ fontSize: 16, fontWeight: 700, color: C.white, marginBottom: 16 }}>Configurar VSLs</div>

        <div style={{ display: "flex", gap: 8, marginBottom: 20 }}>
          {tabBtn("campaign", "Campaña → VSL")}
          {tabBtn("ad", "Anuncio → VSL (override)")}
        </div>

        {tab === "campaign" && (
          <>
            <select value={filterVideoId} onChange={e => setFilterVideoId(e.target.value)} style={{ ...sel, marginBottom: 16 }}>
              <option value="">Todos los VSLs</option>
              {videos.map(v => (
                <option key={v.videoId} value={v.videoId}>{v.videoName}</option>
              ))}
            </select>

            {visibleMappings.map(m => (
              <div key={m.campaignName} style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "10px 12px", background: C.card, borderRadius: 8, marginBottom: 6 }}>
                <div>
                  <div style={{ fontSize: 13, color: C.white }}>
                    {m.campaignName === DEFAULT_VSL_CAMPAIGN ? "🔹 VSL por defecto (todo el tráfico sin mapear)" : m.campaignName}
                  </div>
                  <div style={{ fontSize: 11, color: C.mutedMid }}>{m.videoName}</div>
                </div>
                <button onClick={() => handleDelete(m.campaignName)} style={{ background: "rgba(255,65,59,0.12)", border: "none", color: "#FF413B", borderRadius: 6, padding: "4px 10px", fontSize: 11, cursor: "pointer" }}>
                  Eliminar
                </button>
              </div>
            ))}
            {visibleMappings.length === 0 && (
              <div style={{ fontSize: 12, color: C.mutedMid, textAlign: "center", padding: 16 }}>
                {filterVideoId ? "Sin campañas mapeadas a este VSL" : "Sin mapeos configurados"}
              </div>
            )}

            <div style={{ borderTop: `1px solid ${C.border}`, paddingTop: 16, marginTop: 8 }}>
              <div style={{ fontSize: 13, color: C.mutedLight, marginBottom: 12 }}>Añadir nuevo mapeo</div>
              <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
                <select value={newCampaign} onChange={e => setNewCampaign(e.target.value)} style={sel}>
                  <option value="">Selecciona campaña...</option>
                  {!mappings.find(m => m.campaignName === DEFAULT_VSL_CAMPAIGN) && (
                    <option value={DEFAULT_VSL_CAMPAIGN}>— VSL por defecto (todo el tráfico sin mapear) —</option>
                  )}
                  {unmapped.map(c => <option key={c} value={c}>{c}</option>)}
                </select>

                <select value={newVideoId} onChange={e => setNewVideoId(e.target.value)} style={sel}>
                  <option value="">Selecciona video VSL...</option>
                  {videos.map(v => (
                    <option key={v.videoId} value={v.videoId}>{v.videoName}</option>
                  ))}
                </select>
                {videosState === "loading" && (
                  <div style={{ fontSize: 11, color: C.mutedMid }}>Cargando videos disponibles…</div>
                )}
                {videosState === "error" && (
                  <div style={{ fontSize: 11, color: C.red }}>No se pudieron cargar los videos de VTurb</div>
                )}
                {videosState === "ready" && videos.length === 0 && (
                  <div style={{ fontSize: 11, color: C.mutedMid }}>Sin videos registrados en VTurb aún</div>
                )}

                <button onClick={handleSave} disabled={saving || !newCampaign || !newVideoId}
                  style={{ background: C.orange, border: "none", borderRadius: 8, padding: "10px 0", color: C.white, fontSize: 13, fontWeight: 600, cursor: "pointer", opacity: !newCampaign || !newVideoId ? 0.5 : 1 }}>
                  {saving ? "Guardando..." : "Guardar Mapeo"}
                </button>
              </div>
            </div>
          </>
        )}

        {tab === "ad" && (
          <>
            <div style={{ fontSize: 11, color: C.mutedMid, marginBottom: 14, lineHeight: 1.5 }}>
              Opcional — solo para anuncios cuyo VSL difiere del de su campaña. Sin override, el anuncio hereda el VSL mapeado a su campaña.
            </div>

            {adMappings.map(m => (
              <div key={m.adId} style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "10px 12px", background: C.card, borderRadius: 8, marginBottom: 6 }}>
                <div>
                  <div style={{ fontSize: 13, color: C.white }}>{availableAds.find(a => a.adId === m.adId)?.adName ?? m.adId}</div>
                  <div style={{ fontSize: 11, color: C.mutedMid }}>{m.videoName}</div>
                </div>
                <button onClick={() => handleDeleteAd(m.adId)} style={{ background: "rgba(255,65,59,0.12)", border: "none", color: "#FF413B", borderRadius: 6, padding: "4px 10px", fontSize: 11, cursor: "pointer" }}>
                  Eliminar
                </button>
              </div>
            ))}
            {adMappings.length === 0 && (
              <div style={{ fontSize: 12, color: C.mutedMid, textAlign: "center", padding: 16 }}>
                Sin overrides configurados
              </div>
            )}

            <div style={{ borderTop: `1px solid ${C.border}`, paddingTop: 16, marginTop: 8 }}>
              <div style={{ fontSize: 13, color: C.mutedLight, marginBottom: 12 }}>Añadir override</div>
              <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
                <select value={newAdId} onChange={e => setNewAdId(e.target.value)} style={sel}>
                  <option value="">Selecciona anuncio...</option>
                  {unmappedAds.map(a => <option key={a.adId} value={a.adId}>{a.adName}</option>)}
                </select>

                <select value={newAdVideoId} onChange={e => setNewAdVideoId(e.target.value)} style={sel}>
                  <option value="">Selecciona video VSL...</option>
                  {videos.map(v => (
                    <option key={v.videoId} value={v.videoId}>{v.videoName}</option>
                  ))}
                </select>

                <button onClick={handleSaveAd} disabled={adSaving || !newAdId || !newAdVideoId}
                  style={{ background: C.orange, border: "none", borderRadius: 8, padding: "10px 0", color: C.white, fontSize: 13, fontWeight: 600, cursor: "pointer", opacity: !newAdId || !newAdVideoId ? 0.5 : 1 }}>
                  {adSaving ? "Guardando..." : "Guardar Override"}
                </button>
              </div>
            </div>
          </>
        )}
      </div>
    </div>
  );
}
```

- [ ] **Step 3: Verificar y probar**

Run: `npm run build`
Expected: sin errores de tipos.

Run: `npm run dev` — abrir "Configurar VSLs", cambiar a la pestaña "Anuncio → VSL (override)", guardar un override para un anuncio real, cerrar y reabrir el modal, confirmar que el override persiste y que ese anuncio deja de heredar el VSL de su campaña (verificar en `AdRankingTable`/`CampaignFunnelCard` que su columna VSL cambió).

- [ ] **Step 4: Commit**

```bash
git add src/services/analytics.ts src/components/analytics/CampaignMappingModal.tsx
git commit -m "feat(analytics): agregar override de mapeo anuncio → VSL en el modal de configuración"
```

---

## Self-Review (spec coverage)

- **Sección 1 (arquitectura de datos):** Task 1 cubre `transactions`, `vturb_analytics`, `ad_investment_data`, `ad_vsl_mapping`. ✅ (sin `vsl_pitch_marks`, según revisión del spec).
- **Sección 2.1 (Hotmart):** Task 2. ✅
- **Sección 2.2 (UTMify nivel ad):** Task 3. ✅
- **Sección 2.3 (VTurb únicos + pitch_second):** Task 4. ✅ (según revisión del spec, sin tabla manual).
- **Sección 3 (métricas + score):** Task 5 (`computeScore`, `VSLData` extendido, `getAdVSLRanking`). ✅
- **Sección 4.1 (drill-down):** Task 7. ✅
- **Sección 4.2 (AdRankingTable):** Task 6. ✅
- **Sección 4.3 (VSLIntelligencePanel):** Task 8. ✅
- **Sección 4.4 (override anuncio→VSL):** Task 9. ✅ (sin pestaña de "marca de pitch", según revisión del spec).
- **Sección 5 (testing):** cada task incluye sus pasos de verificación equivalentes (debug endpoints, backfill acotado, reconciliación, checklist manual).
