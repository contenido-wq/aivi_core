# Analytics Command Center — Plan de Implementación

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Construir una vista `/analytics` que cruza datos de VTurb, UTMify y Hotmart en un Command Center de 9 bloques para decisiones de pauta en revisiones mañana/noche.

**Architecture:** Vista React independiente (`AnalyticsView`) con su propio servicio (`analytics.ts`) y hook (`useAnalyticsData`). Los datos de VTurb se sincronizan cada hora via nueva edge function `vturb-sync`. UTMify se actualiza para capturar datos por campaña. Todo cruza por `utm_campaign` como campo de enlace.

**Tech Stack:** React 19 + TypeScript, Recharts 2.15, Supabase (Postgres + Edge Functions Deno), Anthropic Claude API, estilos inline con tokens `C` de `src/tokens.ts`.

## Global Constraints

- Español neutro latinoamericano en toda la UI
- Dark mode obligatorio — todos los fondos desde `C` tokens (`src/tokens.ts`)
- Estilos inline (no Tailwind, no CSS modules) — seguir exactamente el patrón de componentes existentes
- Edge functions: Deno runtime, `std@0.177.0`, `@supabase/supabase-js@2`
- Sin tests unitarios (no hay framework configurado) — verificación via TypeScript (`tsc --noEmit`) + browser manual
- Commits frecuentes con prefijos `feat:`, `fix:`, `chore:`
- `VTURB_API_KEY` solo en variables de entorno de Supabase Edge Functions, nunca en frontend

---

## Mapa de Archivos

| Archivo | Acción | Responsabilidad |
|---------|--------|-----------------|
| `supabase/migrations/20260622000001_vturb_tables.sql` | Crear | Tablas vturb_analytics, vturb_retention |
| `supabase/migrations/20260622000002_campaign_tables.sql` | Crear | Tablas campaign_investment_data, campaign_vsl_mapping |
| `supabase/functions/vturb-sync/index.ts` | Crear | Sync horario con VTurb API |
| `supabase/functions/utmify-sync/index.ts` | Modificar | Añadir sync de datos por campaña |
| `src/services/analytics.ts` | Crear | 8 funciones de consulta para los bloques del Command Center |
| `src/hooks/useAnalyticsData.ts` | Crear | Estado del período, loading por bloque, refresh manual |
| `src/types.ts` | Modificar | Añadir `"analytics"` a `AppView` |
| `src/App.tsx` | Modificar | Añadir ruta `view === "analytics"` |
| `src/components/dashboard/Sidebar.tsx` | Modificar | Añadir enlace a Analytics con navegación funcional |
| `src/views/AnalyticsView.tsx` | Crear | Vista principal — selector de período + 9 bloques |
| `src/components/analytics/AlertsPanel.tsx` | Crear | Bloque 8 — alertas automáticas |
| `src/components/analytics/KPISummary.tsx` | Crear | Bloque 2 — 8 KPIs con delta |
| `src/components/analytics/CampaignFunnelCard.tsx` | Crear | Bloque 3 — funnel por campaña+VSL |
| `src/components/analytics/VSLComparator.tsx` | Crear | Bloque 4 — curvas de retención superpuestas |
| `src/components/analytics/AdsRankingTable.tsx` | Crear | Bloque 5 — tabla rankeada por CAC |
| `src/components/analytics/HourlyHeatmap.tsx` | Crear | Bloque 6 — heatmap 24h×7días |
| `src/components/analytics/LTVTable.tsx` | Crear | Bloque 7 — LTV por fuente de tráfico |
| `src/components/analytics/CampaignMappingModal.tsx` | Crear | Modal configuración campaña↔VSL |
| `src/components/analytics/AIAnalyst.tsx` | Crear | Bloque 9 — análisis IA accionable |

---

## Task 1: Migraciones de Base de Datos

**Files:**
- Create: `supabase/migrations/20260622000001_vturb_tables.sql`
- Create: `supabase/migrations/20260622000002_campaign_tables.sql`

**Interfaces:**
- Produce: tablas `vturb_analytics`, `vturb_retention`, `campaign_investment_data`, `campaign_vsl_mapping` usadas por Tasks 2, 3 y 4.

- [ ] **Step 1: Crear migración de tablas VTurb**

```sql
-- supabase/migrations/20260622000001_vturb_tables.sql

create table if not exists public.vturb_analytics (
  id             uuid primary key default gen_random_uuid(),
  video_id       text not null,
  video_name     text,
  date           date not null,
  plays          integer default 0,
  views          integer default 0,
  play_rate      numeric(5,2),
  avg_watch_time integer,
  button_clicks  integer default 0,
  created_at     timestamptz default now(),
  unique(video_id, date)
);

create table if not exists public.vturb_retention (
  id         uuid primary key default gen_random_uuid(),
  video_id   text not null,
  date       date not null,
  second     integer not null,
  percentage numeric(5,2),
  created_at timestamptz default now(),
  unique(video_id, date, second)
);

alter table public.vturb_analytics enable row level security;
alter table public.vturb_retention  enable row level security;

create policy "service_all_vturb_analytics" on public.vturb_analytics
  for all using (auth.role() = 'service_role');

create policy "auth_read_vturb_analytics" on public.vturb_analytics
  for select using (auth.role() = 'authenticated');

create policy "service_all_vturb_retention" on public.vturb_retention
  for all using (auth.role() = 'service_role');

create policy "auth_read_vturb_retention" on public.vturb_retention
  for select using (auth.role() = 'authenticated');
```

- [ ] **Step 2: Crear migración de tablas de campaña**

```sql
-- supabase/migrations/20260622000002_campaign_tables.sql

create table if not exists public.campaign_investment_data (
  id            uuid primary key default gen_random_uuid(),
  campaign_id   text not null,
  campaign_name text,
  date          date not null,
  platform      text default 'facebook',
  investment    numeric(10,2) default 0,
  impressions   integer default 0,
  clicks        integer default 0,
  synced_at     timestamptz,
  created_at    timestamptz default now(),
  unique(campaign_id, date, platform)
);

create table if not exists public.campaign_vsl_mapping (
  campaign_name text primary key,
  video_id      text not null,
  video_name    text,
  created_at    timestamptz default now()
);

alter table public.campaign_investment_data enable row level security;
alter table public.campaign_vsl_mapping     enable row level security;

create policy "service_all_campaign_investment" on public.campaign_investment_data
  for all using (auth.role() = 'service_role');

create policy "auth_read_campaign_investment" on public.campaign_investment_data
  for select using (auth.role() = 'authenticated');

create policy "service_all_vsl_mapping" on public.campaign_vsl_mapping
  for all using (auth.role() = 'service_role');

create policy "auth_all_vsl_mapping" on public.campaign_vsl_mapping
  for all using (auth.role() = 'authenticated');
```

- [ ] **Step 3: Aplicar migraciones**

```bash
# Desde la raíz del proyecto
supabase db push
```

Verificar en el panel de Supabase > Table Editor que existen las 4 nuevas tablas.

- [ ] **Step 4: Commit**

```bash
git add supabase/migrations/20260622000001_vturb_tables.sql supabase/migrations/20260622000002_campaign_tables.sql
git commit -m "chore(db): tablas vturb_analytics, vturb_retention, campaign_investment_data, campaign_vsl_mapping"
```

---

## Task 2: Edge Function `vturb-sync`

**Files:**
- Create: `supabase/functions/vturb-sync/index.ts`

**Interfaces:**
- Consumes: tablas `vturb_analytics`, `vturb_retention` (Task 1). Variable de entorno `VTURB_API_KEY`.
- Produces: datos sincronizados en ambas tablas, leídos por `analytics.ts` (Task 4).

- [ ] **Step 1: Crear la edge function**

```typescript
// supabase/functions/vturb-sync/index.ts
// @ts-nocheck
import { serve }        from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

declare const Deno: {
  env:  { get(key: string): string | undefined };
  cron: (name: string, schedule: string, handler: () => Promise<void>) => void;
};

const VTURB_BASE = "https://api.vturb.com.br/v1/analytics";

function toColombiaDate(d: Date): string {
  const local = new Date(d.getTime() - 5 * 60 * 60 * 1000);
  return local.toISOString().split("T")[0];
}

async function fetchVturb(apiKey: string, path: string, params: Record<string, string>): Promise<unknown> {
  const url = new URL(`${VTURB_BASE}${path}`);
  for (const [k, v] of Object.entries(params)) url.searchParams.set(k, v);
  const res = await fetch(url.toString(), {
    headers: { "Authorization": `Bearer ${apiKey}`, "Accept": "application/json" },
  });
  if (!res.ok) throw new Error(`VTurb HTTP ${res.status} on ${path}: ${await res.text()}`);
  return res.json();
}

async function syncPlays(
  supabase: ReturnType<typeof createClient>,
  apiKey: string,
  from: string,
  to: string,
): Promise<void> {
  const data = await fetchVturb(apiKey, "/plays", { from, to }) as {
    data: Array<{
      videoId: string;
      videoName: string;
      date: string;
      plays: number;
      views: number;
      playRate: number;
      avgWatchTime: number;
      buttonClicks: number;
    }>;
  };

  const rows = (data.data ?? []).map((r) => ({
    video_id:       r.videoId,
    video_name:     r.videoName ?? null,
    date:           r.date,
    plays:          r.plays ?? 0,
    views:          r.views ?? 0,
    play_rate:      r.playRate ?? null,
    avg_watch_time: r.avgWatchTime ?? null,
    button_clicks:  r.buttonClicks ?? 0,
  }));

  if (rows.length === 0) { console.log(`VTurb plays: sin datos para ${from}→${to}`); return; }

  const { error } = await supabase
    .from("vturb_analytics")
    .upsert(rows, { onConflict: "video_id,date" });
  if (error) throw new Error(`vturb_analytics upsert: ${error.message}`);
  console.log(`✅ VTurb plays sync — ${rows.length} filas — ${from}→${to}`);
}

async function syncRetention(
  supabase: ReturnType<typeof createClient>,
  apiKey: string,
  from: string,
  to: string,
): Promise<void> {
  // Primero obtener lista de videos del período
  const playsData = await fetchVturb(apiKey, "/plays", { from, to }) as {
    data: Array<{ videoId: string }>;
  };
  const videoIds = [...new Set((playsData.data ?? []).map((r) => r.videoId))];

  for (const videoId of videoIds) {
    const retData = await fetchVturb(apiKey, "/retention", { videoId, from, to }) as {
      data: Array<{ second: number; percentage: number }>;
    };
    const rows = (retData.data ?? []).map((r) => ({
      video_id:   videoId,
      date:       from, // fecha de referencia (usa `from` para el período)
      second:     r.second,
      percentage: r.percentage,
    }));
    if (rows.length === 0) continue;
    const { error } = await supabase
      .from("vturb_retention")
      .upsert(rows, { onConflict: "video_id,date,second" });
    if (error) throw new Error(`vturb_retention upsert (${videoId}): ${error.message}`);
    console.log(`✅ VTurb retention sync — ${videoId} — ${rows.length} segundos`);
  }
}

async function runSync(from?: string, to?: string): Promise<Response> {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );
  const apiKey = Deno.env.get("VTURB_API_KEY")!;
  const today  = toColombiaDate(new Date());
  const dateFrom = from ?? today;
  const dateTo   = to   ?? today;

  const errors: string[] = [];

  try { await syncPlays(supabase, apiKey, dateFrom, dateTo); }
  catch (e) { console.error("syncPlays:", e); errors.push(String(e)); }

  try { await syncRetention(supabase, apiKey, dateFrom, dateTo); }
  catch (e) { console.error("syncRetention:", e); errors.push(String(e)); }

  return new Response(JSON.stringify({ ok: errors.length === 0, errors, from: dateFrom, to: dateTo }), {
    headers: { "Content-Type": "application/json" },
  });
}

// Cron horario (minuto 30 para no colisionar con utmify-sync en minuto 0)
if (typeof Deno.cron === "function") {
  Deno.cron("vturb-hourly", "30 * * * *", async () => { await runSync(); });
}

serve(async (req) => {
  const params = new URL(req.url).searchParams;
  const from = params.get("from") ?? undefined;
  const to   = params.get("to")   ?? undefined;
  return runSync(from, to);
});
```

- [ ] **Step 2: Registrar `VTURB_API_KEY` en Supabase**

En el panel de Supabase > Settings > Edge Functions > Secrets, añadir:
```
VTURB_API_KEY = <la api key regenerada de VTurb>
```

> Nota: regenerar la API key en VTurb antes de usarla (la que estaba en el chat fue comprometida).

- [ ] **Step 3: Deploy y verificar manualmente**

```bash
supabase functions deploy vturb-sync
# Invocar manualmente para hoy:
curl "https://<tu-proyecto>.supabase.co/functions/v1/vturb-sync" \
  -H "Authorization: Bearer <anon_key>"
# Verificar en Table Editor que vturb_analytics tiene filas
```

- [ ] **Step 4: Commit**

```bash
git add supabase/functions/vturb-sync/index.ts
git commit -m "feat(vturb): edge function vturb-sync con plays y retención horaria"
```

---

## Task 3: Actualizar `utmify-sync` para datos por campaña

**Files:**
- Modify: `supabase/functions/utmify-sync/index.ts`

**Interfaces:**
- Consumes: tabla `campaign_investment_data` (Task 1).
- Produces: datos por campaña en `campaign_investment_data`, leídos por `analytics.ts` (Task 4).

- [ ] **Step 1: Añadir función `syncCampaigns` y actualizar `syncDate`**

Añadir esta función **antes de `syncDate`** en el archivo existente:

```typescript
// Sincroniza gasto a nivel de campaña para un día
async function syncCampaigns(
  supabase: ReturnType<typeof createClient>,
  mcpToken: string,
  dashboardId: string,
  dateStr: string,
): Promise<void> {
  const data = await callMcp(mcpToken, "get_meta_ad_objects", {
    dashboardId,
    level:     "campaign",
    dateRange: { from: dateStr, to: dateStr },
  }) as { results: Array<{ campaignId: string; campaignName: string; spend: number; impressions: number; inlineLinkClicks: number; accountId: string }> };

  const campaigns = (data.results ?? []).filter((r: any) => r.accountId === META_ACCOUNT_ID);
  if (campaigns.length === 0) { console.log(`UTMify campaigns: sin datos para ${dateStr}`); return; }

  const rows = campaigns.map((c) => ({
    campaign_id:   c.campaignId,
    campaign_name: c.campaignName ?? c.campaignId,
    date:          dateStr,
    platform:      "facebook",
    investment:    (c.spend ?? 0) / 100,
    impressions:   c.impressions ?? 0,
    clicks:        c.inlineLinkClicks ?? 0,
    synced_at:     new Date().toISOString(),
  }));

  const { error } = await supabase
    .from("campaign_investment_data")
    .upsert(rows, { onConflict: "campaign_id,date,platform" });
  if (error) throw new Error(`campaign_investment_data upsert (${dateStr}): ${error.message}`);
  console.log(`✅ UTMify campaigns — ${rows.length} campañas — ${dateStr}`);
}
```

- [ ] **Step 2: Llamar `syncCampaigns` dentro de `runSync` y `runBackfill`**

En `runSync`, dentro del bloque `for (let i = 7; i >= 1; i--)`, después de `syncDate`:

```typescript
    try {
      await syncCampaigns(supabase, mcpToken, dashboardId, dateStr);
    } catch (e) {
      console.error(`Campaign sync error for ${dateStr}:`, e);
      errors.push({ date: dateStr, error: String(e) });
    }
```

Y después de `syncToday` (para el día actual), añadir el mismo bloque con `today`:

```typescript
  try {
    await syncCampaigns(supabase, mcpToken, dashboardId, today);
  } catch (e) {
    console.error(`Campaign sync error for today (${today}):`, e);
    errors.push({ date: today, error: String(e) });
  }
```

En `runBackfill`, dentro del `for (const dateStr of dates)`, después de cada sync:

```typescript
      try {
        await syncCampaigns(supabase, mcpToken, dashboardId, dateStr);
      } catch (e) {
        errors.push({ date: dateStr, error: String(e) });
      }
```

- [ ] **Step 3: Deploy y verificar**

```bash
supabase functions deploy utmify-sync
curl "https://<tu-proyecto>.supabase.co/functions/v1/utmify-sync" \
  -H "Authorization: Bearer <anon_key>"
# Verificar en Table Editor que campaign_investment_data tiene filas con nombres de campaña
```

- [ ] **Step 4: Commit**

```bash
git add supabase/functions/utmify-sync/index.ts
git commit -m "feat(utmify): añadir sync de datos por campaña a campaign_investment_data"
```

---

## Task 4: Servicio de Analytics

**Files:**
- Create: `src/services/analytics.ts`

**Interfaces:**
- Consumes: tablas `vturb_analytics`, `vturb_retention`, `campaign_investment_data`, `campaign_vsl_mapping`, `investment_data`, `transactions` (todas ya definidas).
- Produces: tipos y funciones exportadas usadas por `useAnalyticsData` (Task 5) y `AIAnalyst` (Task 15).

- [ ] **Step 1: Crear el archivo con tipos e imports**

```typescript
// src/services/analytics.ts
import { supabase } from "./supabase";

// ── Tipos de períodos ─────────────────────────────────────────────────────────

export type PeriodKey = "noche" | "dia" | "hoy" | "ayer" | "7dias" | "custom";

export interface DateRange { from: string; to: string; fromTs: string; toTs: string }

export function buildRange(key: PeriodKey, custom?: { from: string; to: string }): DateRange {
  const now    = new Date();
  const offset = -5 * 60; // Colombia UTC-5
  const col    = new Date(now.getTime() + (offset - now.getTimezoneOffset()) * 60000);
  const pad    = (n: number) => String(n).padStart(2, "0");
  const ymd    = (d: Date) => `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`;

  const today     = ymd(col);
  const yesterday = ymd(new Date(col.getTime() - 86400000));

  if (key === "custom" && custom) {
    return { from: custom.from, to: custom.to, fromTs: `${custom.from}T00:00:00`, toTs: `${custom.to}T23:59:59` };
  }
  if (key === "noche") {
    // De ayer 22:00 a hoy 08:00 (hora Colombia)
    return { from: yesterday, to: today, fromTs: `${yesterday}T22:00:00`, toTs: `${today}T08:00:00` };
  }
  if (key === "dia") {
    // De hoy 08:00 a hoy 22:00
    return { from: today, to: today, fromTs: `${today}T08:00:00`, toTs: `${today}T22:00:00` };
  }
  if (key === "ayer") {
    return { from: yesterday, to: yesterday, fromTs: `${yesterday}T00:00:00`, toTs: `${yesterday}T23:59:59` };
  }
  if (key === "7dias") {
    const from7 = ymd(new Date(col.getTime() - 6 * 86400000));
    return { from: from7, to: today, fromTs: `${from7}T00:00:00`, toTs: `${today}T23:59:59` };
  }
  // hoy (default)
  return { from: today, to: today, fromTs: `${today}T00:00:00`, toTs: `${today}T23:59:59` };
}

// Rango anterior con la misma duración (para deltas)
export function previousRange(r: DateRange): DateRange {
  const from  = new Date(`${r.from}T12:00:00Z`);
  const to    = new Date(`${r.to}T12:00:00Z`);
  const diffMs = to.getTime() - from.getTime() + 86400000;
  const prevTo   = new Date(from.getTime() - 86400000);
  const prevFrom = new Date(prevTo.getTime() - diffMs + 86400000);
  const fmt = (d: Date) => d.toISOString().split("T")[0];
  return buildRange("custom", { from: fmt(prevFrom), to: fmt(prevTo) });
}

// ── Tipos de datos ────────────────────────────────────────────────────────────

export interface AnalyticsSummary {
  investment:    number;
  revenue:       number;
  roas:          number;
  cac:           number;
  sales:         number;
  plays:         number;
  playRate:      number;
  costPerPlay:   number;
  prev?: Omit<AnalyticsSummary, "prev">;
}

export interface FunnelCampaign {
  campaignName: string;
  videoId:      string | null;
  videoName:    string | null;
  impressions:  number;
  clicks:       number;
  plays:        number;
  ret50:        number;
  ctaClicks:    number;
  sales:        number;
  cac:          number;
  roas:         number;
  investment:   number;
  topHour:      number | null;
  score:        number;
}

export interface VSLRetentionPoint { second: number; percentage: number }
export interface VSLData {
  videoId:   string;
  videoName: string;
  plays:     number;
  ret25:     number;
  ret50:     number;
  ret75:     number;
  ctaClicks: number;
  sales:     number;
  convRate:  number;
  retention: VSLRetentionPoint[];
  dropSecond: number | null;
}

export interface AdRankRow {
  campaignName: string;
  investment:   number;
  clicks:       number;
  cpm:          number;
  cpc:          number;
  plays:        number;
  playRate:     number;
  sales:        number;
  cac:          number;
  roas:         number;
  videoName:    string | null;
  score:        number;
  impressions:  number;
}

export interface HeatmapCell { hour: number; dow: number; value: number }

export interface LTVRow {
  campaignName:  string;
  customers:     number;
  ltv:           number;
  totalRevenue:  number;
  cac:           number;
  roiReal:       number;
}

export interface Alert {
  level:   "rojo" | "amarillo" | "verde";
  message: string;
}

export interface VSLMapping { campaignName: string; videoId: string; videoName: string }
```

- [ ] **Step 2: Añadir función `getAnalyticsSummary`**

```typescript
export async function getAnalyticsSummary(r: DateRange): Promise<AnalyticsSummary> {
  const [invRes, txRes, playsRes] = await Promise.all([
    supabase.from("campaign_investment_data")
      .select("investment")
      .gte("date", r.from).lte("date", r.to),
    supabase.from("transactions")
      .select("amount_usd, created_at")
      .gte("created_at", r.fromTs).lte("created_at", r.toTs)
      .eq("event_type", "PURCHASE_COMPLETE"),
    supabase.from("vturb_analytics")
      .select("plays, views, play_rate, button_clicks")
      .gte("date", r.from).lte("date", r.to),
  ]);

  const investment  = (invRes.data ?? []).reduce((s: number, x: any) => s + Number(x.investment), 0);
  const revenue     = (txRes.data ?? []).reduce((s: number, x: any) => s + Number(x.amount_usd), 0);
  const sales       = (txRes.data ?? []).length;
  const plays       = (playsRes.data ?? []).reduce((s: number, x: any) => s + Number(x.plays), 0);
  const views       = (playsRes.data ?? []).reduce((s: number, x: any) => s + Number(x.views), 0);
  const ctaClicks   = (playsRes.data ?? []).reduce((s: number, x: any) => s + Number(x.button_clicks), 0);

  const roas        = investment > 0 ? revenue / investment : 0;
  const cac         = sales > 0 ? investment / sales : 0;
  const playRate    = views > 0 ? (plays / views) * 100 : 0;
  const costPerPlay = plays > 0 ? investment / plays : 0;

  return { investment, revenue, roas, cac, sales, plays, playRate, costPerPlay };
}
```

- [ ] **Step 3: Añadir `getFunnelByCampaign`**

```typescript
export async function getFunnelByCampaign(r: DateRange): Promise<FunnelCampaign[]> {
  const [campRes, txRes, mappingRes, analyticsRes] = await Promise.all([
    supabase.from("campaign_investment_data")
      .select("campaign_name, investment, impressions, clicks")
      .gte("date", r.from).lte("date", r.to),
    supabase.from("transactions")
      .select("utm_campaign, amount_usd, created_at")
      .gte("created_at", r.fromTs).lte("created_at", r.toTs)
      .eq("event_type", "PURCHASE_COMPLETE"),
    supabase.from("campaign_vsl_mapping").select("*"),
    supabase.from("vturb_analytics")
      .select("video_id, plays, views, play_rate, button_clicks")
      .gte("date", r.from).lte("date", r.to),
  ]);

  // Agrupar inversión por campaña
  const invMap: Record<string, { investment: number; impressions: number; clicks: number }> = {};
  for (const row of (campRes.data ?? [])) {
    const k = row.campaign_name;
    if (!invMap[k]) invMap[k] = { investment: 0, impressions: 0, clicks: 0 };
    invMap[k].investment  += Number(row.investment);
    invMap[k].impressions += Number(row.impressions);
    invMap[k].clicks      += Number(row.clicks);
  }

  // Agrupar ventas + hora pico por campaña
  const salesMap: Record<string, { count: number; revenue: number; hours: number[] }> = {};
  for (const tx of (txRes.data ?? [])) {
    const k = tx.utm_campaign ?? "Sin UTM";
    if (!salesMap[k]) salesMap[k] = { count: 0, revenue: 0, hours: [] };
    salesMap[k].count++;
    salesMap[k].revenue += Number(tx.amount_usd);
    salesMap[k].hours.push(new Date(tx.created_at).getHours());
  }

  // Mapeo campaña → VSL
  const mappingMap: Record<string, { videoId: string; videoName: string }> = {};
  for (const m of (mappingRes.data ?? [])) {
    mappingMap[m.campaign_name] = { videoId: m.video_id, videoName: m.video_name ?? m.video_id };
  }

  // Analytics VTurb por video
  const vturlMap: Record<string, { plays: number; playRate: number; buttonClicks: number }> = {};
  for (const row of (analyticsRes.data ?? [])) {
    const k = row.video_id;
    if (!vturlMap[k]) vturlMap[k] = { plays: 0, playRate: 0, buttonClicks: 0 };
    vturlMap[k].plays       += Number(row.plays);
    vturlMap[k].buttonClicks += Number(row.button_clicks);
    vturlMap[k].playRate     = Number(row.play_rate) || vturlMap[k].playRate;
  }

  const allCampaigns = new Set([...Object.keys(invMap), ...Object.keys(salesMap)]);
  const maxRoas = Math.max(1, ...[...allCampaigns].map(c => {
    const inv = invMap[c]?.investment ?? 0;
    const rev = salesMap[c]?.revenue ?? 0;
    return inv > 0 ? rev / inv : 0;
  }));
  const maxPlayRate = Math.max(1, ...[...allCampaigns].map(c => {
    const vId = mappingMap[c]?.videoId;
    return vId ? (vturlMap[vId]?.playRate ?? 0) : 0;
  }));

  return [...allCampaigns].map(campaignName => {
    const inv   = invMap[campaignName] ?? { investment: 0, impressions: 0, clicks: 0 };
    const sales = salesMap[campaignName] ?? { count: 0, revenue: 0, hours: [] };
    const vsl   = mappingMap[campaignName] ?? null;
    const vData = vsl ? (vturlMap[vsl.videoId] ?? { plays: 0, playRate: 0, buttonClicks: 0 }) : null;

    const cac  = sales.count > 0 ? inv.investment / sales.count : 0;
    const roas = inv.investment > 0 ? sales.revenue / inv.investment : 0;

    // Hora pico
    const hourCount: Record<number, number> = {};
    for (const h of sales.hours) hourCount[h] = (hourCount[h] ?? 0) + 1;
    const topHour = sales.hours.length > 0
      ? Number(Object.entries(hourCount).sort((a, b) => b[1] - a[1])[0][0])
      : null;

    // Score de replicación (0–100)
    const roasNorm     = maxRoas > 0 ? Math.min(roas / maxRoas, 1) : 0;
    const playRateNorm = maxPlayRate > 0 ? Math.min((vData?.playRate ?? 0) / maxPlayRate, 1) : 0;
    const convRate     = vData && vData.plays > 0 ? sales.count / vData.plays : 0;
    const score = Math.round((roasNorm * 0.40 + playRateNorm * 0.30 + Math.min(convRate * 10, 1) * 0.30) * 100);

    return {
      campaignName,
      videoId:    vsl?.videoId ?? null,
      videoName:  vsl?.videoName ?? null,
      impressions: inv.impressions,
      clicks:     inv.clicks,
      plays:      vData?.plays ?? 0,
      ret50:      0, // se puede enriquecer con vturb_retention si se necesita
      ctaClicks:  vData?.buttonClicks ?? 0,
      sales:      sales.count,
      cac,
      roas,
      investment: inv.investment,
      topHour,
      score,
    };
  }).sort((a, b) => (a.cac || 999) - (b.cac || 999));
}
```

- [ ] **Step 4: Añadir `getVSLRetention`, `getAdsRanking`, `getHourlyHeatmap`**

```typescript
export async function getVSLRetention(r: DateRange): Promise<VSLData[]> {
  const [analyticsRes, retentionRes, txRes, mappingRes] = await Promise.all([
    supabase.from("vturb_analytics")
      .select("video_id, video_name, plays, button_clicks")
      .gte("date", r.from).lte("date", r.to),
    supabase.from("vturb_retention")
      .select("video_id, second, percentage")
      .gte("date", r.from).lte("date", r.to)
      .order("second", { ascending: true }),
    supabase.from("transactions")
      .select("utm_campaign, amount_usd")
      .gte("created_at", r.fromTs).lte("created_at", r.toTs)
      .eq("event_type", "PURCHASE_COMPLETE"),
    supabase.from("campaign_vsl_mapping").select("*"),
  ]);

  // Agrupar ventas por video_id via mapping
  const videoSales: Record<string, number> = {};
  const mappingByVideo: Record<string, string> = {};
  for (const m of (mappingRes.data ?? [])) mappingByVideo[m.campaign_name] = m.video_id;
  for (const tx of (txRes.data ?? [])) {
    const vid = mappingByVideo[tx.utm_campaign ?? ""] ?? null;
    if (vid) videoSales[vid] = (videoSales[vid] ?? 0) + 1;
  }

  // Agrupar analytics por video
  const analyticsMap: Record<string, { videoName: string; plays: number; ctaClicks: number }> = {};
  for (const row of (analyticsRes.data ?? [])) {
    const k = row.video_id;
    if (!analyticsMap[k]) analyticsMap[k] = { videoName: row.video_name ?? k, plays: 0, ctaClicks: 0 };
    analyticsMap[k].plays     += Number(row.plays);
    analyticsMap[k].ctaClicks += Number(row.button_clicks);
  }

  // Agrupar retención por video
  const retMap: Record<string, VSLRetentionPoint[]> = {};
  for (const row of (retentionRes.data ?? [])) {
    if (!retMap[row.video_id]) retMap[row.video_id] = [];
    retMap[row.video_id].push({ second: row.second, percentage: Number(row.percentage) });
  }

  return Object.entries(analyticsMap).map(([videoId, a]) => {
    const retention = retMap[videoId] ?? [];
    const getAt = (pct: number) => {
      const idx = Math.floor((pct / 100) * retention.length);
      return retention[idx]?.percentage ?? 0;
    };

    // Punto de caída: segundo donde se pierde >20% en 10s
    let dropSecond: number | null = null;
    for (let i = 0; i < retention.length - 10; i++) {
      if ((retention[i].percentage - retention[i + 10].percentage) > 20) {
        dropSecond = retention[i].second;
        break;
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
}

export async function getAdsRanking(r: DateRange): Promise<AdRankRow[]> {
  const funnel = await getFunnelByCampaign(r);
  return funnel.map(f => ({
    campaignName: f.campaignName,
    investment:   f.investment,
    clicks:       f.clicks,
    impressions:  f.impressions,
    cpm:          f.impressions > 0 ? (f.investment / f.impressions) * 1000 : 0,
    cpc:          f.clicks > 0 ? f.investment / f.clicks : 0,
    plays:        f.plays,
    playRate:     f.clicks > 0 ? (f.plays / f.clicks) * 100 : 0,
    sales:        f.sales,
    cac:          f.cac,
    roas:         f.roas,
    videoName:    f.videoName,
    score:        f.score,
  }));
}

export async function getHourlyHeatmap(r: DateRange): Promise<HeatmapCell[]> {
  const { data } = await supabase
    .from("transactions")
    .select("created_at")
    .gte("created_at", r.fromTs).lte("created_at", r.toTs)
    .eq("event_type", "PURCHASE_COMPLETE");

  const cells: Record<string, number> = {};
  for (const tx of (data ?? [])) {
    const d   = new Date(tx.created_at);
    const h   = d.getHours();
    const dow = d.getDay(); // 0=dom
    const k   = `${h}-${dow}`;
    cells[k] = (cells[k] ?? 0) + 1;
  }

  return Object.entries(cells).map(([k, value]) => {
    const [hour, dow] = k.split("-").map(Number);
    return { hour, dow, value };
  });
}
```

- [ ] **Step 5: Añadir `getLTVBySource`, `generateAlerts`, `getAIAnalysis`, `getVSLMappings`, `saveVSLMapping`**

```typescript
export async function getLTVBySource(): Promise<LTVRow[]> {
  const [txRes, campRes] = await Promise.all([
    supabase.from("transactions")
      .select("utm_campaign, amount_usd, buyer_email, event_type"),
    supabase.from("campaign_investment_data")
      .select("campaign_name, investment"),
  ]);

  const invMap: Record<string, number> = {};
  for (const row of (campRes.data ?? [])) {
    invMap[row.campaign_name] = (invMap[row.campaign_name] ?? 0) + Number(row.investment);
  }

  const revenueMap: Record<string, number> = {};
  const customersMap: Record<string, Set<string>> = {};
  for (const tx of (txRes.data ?? []).filter((t: any) => t.event_type === "PURCHASE_COMPLETE")) {
    const k = tx.utm_campaign ?? "Sin UTM";
    revenueMap[k] = (revenueMap[k] ?? 0) + Number(tx.amount_usd);
    if (!customersMap[k]) customersMap[k] = new Set();
    customersMap[k].add(tx.buyer_email ?? "");
  }

  return Object.keys({ ...revenueMap, ...invMap }).map(campaignName => {
    const totalRevenue = revenueMap[campaignName] ?? 0;
    const customers    = customersMap[campaignName]?.size ?? 0;
    const ltv          = customers > 0 ? totalRevenue / customers : 0;
    const cac          = invMap[campaignName] ?? 0;
    const roiReal      = cac > 0 ? ltv / cac : 0;
    return { campaignName, customers, ltv, totalRevenue, cac, roiReal };
  }).sort((a, b) => b.roiReal - a.roiReal);
}

export function generateAlerts(
  summary: AnalyticsSummary,
  funnel: FunnelCampaign[],
  vsls: VSLData[],
): Alert[] {
  const alerts: Alert[] = [];

  // CAC subió >30% vs período anterior
  if (summary.prev && summary.prev.cac > 0) {
    const delta = (summary.cac - summary.prev.cac) / summary.prev.cac;
    if (delta > 0.30) {
      alerts.push({ level: "rojo", message: `CAC subió ${Math.round(delta*100)}% vs período anterior ($${summary.cac.toFixed(0)} vs $${summary.prev.cac.toFixed(0)})` });
    }
  }

  // ROAS bajo 1.5x
  if (summary.roas < 1.5 && summary.investment > 0) {
    alerts.push({ level: "rojo", message: `ROAS global en ${summary.roas.toFixed(2)}x — inversión no se está recuperando` });
  }

  // Retención de VSL cayó bajo 40% en segundo 120
  for (const vsl of vsls) {
    const pt120 = vsl.retention.find(p => p.second >= 120);
    if (pt120 && pt120.percentage < 40) {
      alerts.push({ level: "amarillo", message: `VSL "${vsl.videoName}" retiene solo ${pt120.percentage.toFixed(0)}% al minuto 2 — revisar gancho` });
    }
    if (vsl.dropSecond !== null) {
      alerts.push({ level: "amarillo", message: `VSL "${vsl.videoName}" pierde >20% de audiencia en el segundo ${vsl.dropSecond} — punto crítico de edición` });
    }
  }

  // Oportunidad: campaña con score >80
  for (const f of funnel) {
    if (f.score >= 80) {
      alerts.push({ level: "verde", message: `Campaña "${f.campaignName}" tiene Score ${f.score} — ROAS ${f.roas.toFixed(1)}x, candidata a escalar` });
    }
  }

  return alerts.slice(0, 5);
}

export async function getAIAnalysis(payload: {
  summary: AnalyticsSummary;
  funnel: FunnelCampaign[];
  vsls: VSLData[];
  period: string;
}): Promise<string> {
  const prompt = `Eres un analista de marketing experto. Analiza estos datos de rendimiento de anuncios y videos del período "${payload.period}" y responde SOLO con las 3 secciones indicadas, en español, directo y accionable.

DATOS:
Inversión: $${payload.summary.investment.toFixed(2)} | Ingresos: $${payload.summary.revenue.toFixed(2)} | ROAS: ${payload.summary.roas.toFixed(2)}x | CAC: $${payload.summary.cac.toFixed(2)} | Ventas: ${payload.summary.sales}

CAMPAÑAS (ordenadas por CAC):
${payload.funnel.map(f => `- ${f.campaignName}: CAC $${f.cac.toFixed(0)}, ROAS ${f.roas.toFixed(1)}x, Score ${f.score}, VSL: ${f.videoName ?? "Sin asignar"}`).join("\n")}

VSLs:
${payload.vsls.map(v => `- ${v.videoName}: ${v.plays} plays, Ret50% ${v.ret50.toFixed(0)}%, CTA ${v.ctaClicks} clicks, Conv ${v.convRate.toFixed(1)}%${v.dropSecond ? `, caída en segundo ${v.dropSecond}` : ""}`).join("\n")}

Responde exactamente con este formato:

## ¿Qué escalar ahora?
[2-3 combinaciones específicas con presupuesto sugerido y hora recomendada]

## ¿Qué corregir hoy?
[Lista de acciones específicas con el dato exacto que lo justifica]

## ¿Qué replicar?
[Patrones concretos del contenido ganador: tipo de hook, estructura, momento del CTA]`;

  const res = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "Content-Type":         "application/json",
      "x-api-key":            import.meta.env.VITE_ANTHROPIC_API_KEY ?? "",
      "anthropic-version":    "2023-06-01",
    },
    body: JSON.stringify({
      model:      "claude-sonnet-4-6",
      max_tokens: 1024,
      messages:   [{ role: "user", content: prompt }],
    }),
  });
  if (!res.ok) throw new Error(`Anthropic API error ${res.status}`);
  const data = await res.json();
  return data.content[0].text as string;
}

export async function getVSLMappings(): Promise<VSLMapping[]> {
  const { data, error } = await supabase.from("campaign_vsl_mapping").select("*");
  if (error) throw new Error(error.message);
  return (data ?? []).map((r: any) => ({ campaignName: r.campaign_name, videoId: r.video_id, videoName: r.video_name ?? r.video_id }));
}

export async function saveVSLMapping(m: VSLMapping): Promise<void> {
  const { error } = await supabase.from("campaign_vsl_mapping").upsert({
    campaign_name: m.campaignName, video_id: m.videoId, video_name: m.videoName,
  }, { onConflict: "campaign_name" });
  if (error) throw new Error(error.message);
}

export async function deleteVSLMapping(campaignName: string): Promise<void> {
  const { error } = await supabase.from("campaign_vsl_mapping").delete().eq("campaign_name", campaignName);
  if (error) throw new Error(error.message);
}
```

- [ ] **Step 6: Verificar tipos con TypeScript**

```bash
cd /Users/jheitrujillo/Proyectos/aivi_core
npx tsc --noEmit
```

Esperado: 0 errores en `src/services/analytics.ts`.

- [ ] **Step 7: Commit**

```bash
git add src/services/analytics.ts
git commit -m "feat(analytics): servicio con 8 funciones de consulta y tipos completos"
```

---

## Task 5: Hook `useAnalyticsData`

**Files:**
- Create: `src/hooks/useAnalyticsData.ts`

**Interfaces:**
- Consumes: todas las funciones de `src/services/analytics.ts` (Task 4). Tipos: `PeriodKey`, `DateRange`, `AnalyticsSummary`, `FunnelCampaign`, `VSLData`, `AdRankRow`, `HeatmapCell`, `LTVRow`, `Alert`.
- Produces: `useAnalyticsData()` → estado completo + `setPeriod()` + `setCustomRange()` + `refresh()`, consumido por `AnalyticsView` (Task 16).

- [ ] **Step 1: Crear el hook**

```typescript
// src/hooks/useAnalyticsData.ts
import { useState, useEffect, useCallback } from "react";
import {
  buildRange, previousRange,
  getAnalyticsSummary, getFunnelByCampaign, getVSLRetention,
  getAdsRanking, getHourlyHeatmap, getLTVBySource, generateAlerts,
  getVSLMappings,
} from "../services/analytics";
import type {
  PeriodKey, DateRange, AnalyticsSummary, FunnelCampaign, VSLData,
  AdRankRow, HeatmapCell, LTVRow, Alert, VSLMapping,
} from "../services/analytics";

export interface AnalyticsState {
  summary:  AnalyticsSummary | null;
  funnel:   FunnelCampaign[];
  vsls:     VSLData[];
  ranking:  AdRankRow[];
  heatmap:  HeatmapCell[];
  ltv:      LTVRow[];
  alerts:   Alert[];
  mappings: VSLMapping[];
  loading:  boolean;
  error:    string | null;
  range:    DateRange | null;
}

const EMPTY: AnalyticsState = {
  summary: null, funnel: [], vsls: [], ranking: [], heatmap: [],
  ltv: [], alerts: [], mappings: [], loading: true, error: null, range: null,
};

export function useAnalyticsData() {
  const [period, setPeriodKey]  = useState<PeriodKey>("hoy");
  const [custom, setCustom]     = useState<{ from: string; to: string } | undefined>();
  const [state, setState]       = useState<AnalyticsState>(EMPTY);
  const [aiResult, setAiResult] = useState<string | null>(null);
  const [aiLoading, setAiLoading] = useState(false);

  const load = useCallback(async () => {
    setState(s => ({ ...s, loading: true, error: null }));
    try {
      const r     = buildRange(period, custom);
      const rPrev = previousRange(r);

      const [summary, summaryPrev, funnel, vsls, ranking, heatmap, ltv, mappings] = await Promise.all([
        getAnalyticsSummary(r),
        getAnalyticsSummary(rPrev),
        getFunnelByCampaign(r),
        getVSLRetention(r),
        getAdsRanking(r),
        getHourlyHeatmap(r),
        getLTVBySource(),
        getVSLMappings(),
      ]);

      const summaryWithPrev: AnalyticsSummary = { ...summary, prev: summaryPrev };
      const alerts = generateAlerts(summaryWithPrev, funnel, vsls);

      setState({ summary: summaryWithPrev, funnel, vsls, ranking, heatmap, ltv, alerts, mappings, loading: false, error: null, range: r });
    } catch (e) {
      setState(s => ({ ...s, loading: false, error: String(e) }));
    }
  }, [period, custom]);

  useEffect(() => { load(); }, [load]);

  const setPeriod = (key: PeriodKey, c?: { from: string; to: string }) => {
    setCustom(c);
    setPeriodKey(key);
  };

  const runAIAnalysis = useCallback(async () => {
    if (!state.summary) return;
    setAiLoading(true);
    setAiResult(null);
    try {
      const { getAIAnalysis } = await import("../services/analytics");
      const label = { noche: "Noche", dia: "Día", hoy: "Hoy", ayer: "Ayer", "7dias": "Últimos 7 días", custom: "Rango custom" }[period];
      const result = await getAIAnalysis({ summary: state.summary, funnel: state.funnel, vsls: state.vsls, period: label });
      setAiResult(result);
    } catch (e) {
      setAiResult(`Error al generar análisis: ${String(e)}`);
    } finally {
      setAiLoading(false);
    }
  }, [state.summary, state.funnel, state.vsls, period]);

  return { ...state, period, setPeriod, refresh: load, aiResult, aiLoading, runAIAnalysis };
}
```

- [ ] **Step 2: Verificar tipos**

```bash
npx tsc --noEmit
```

Esperado: 0 errores.

- [ ] **Step 3: Commit**

```bash
git add src/hooks/useAnalyticsData.ts
git commit -m "feat(analytics): hook useAnalyticsData con estado completo y análisis IA"
```

---

## Task 6: Routing — AppView + App.tsx + Sidebar

**Files:**
- Modify: `src/types.ts`
- Modify: `src/App.tsx`
- Modify: `src/components/dashboard/Sidebar.tsx`

**Interfaces:**
- Consumes: `AnalyticsView` (Task 16, se importará en App.tsx).
- Produces: navegación funcional entre vistas existentes y la nueva `/analytics`.

- [ ] **Step 1: Actualizar `AppView` en `src/types.ts`**

Buscar la línea:
```typescript
export type AppView   = "dashboard" | "admin" | "usuarios" | "transacciones";
```
Reemplazar con:
```typescript
export type AppView   = "dashboard" | "admin" | "usuarios" | "transacciones" | "analytics";
```

- [ ] **Step 2: Añadir ruta en `App.tsx`**

Después del bloque `if (view === "transacciones") return (...)`, añadir:

```typescript
  // Vista Analytics Command Center
  if (view === "analytics") return (
    <AnalyticsView
      onDashboard={() => setView("dashboard")}
      onUsers={() => setView("usuarios")}
      onTransactions={() => setView("transacciones")}
      isAdmin={isAdmin}
      onSettings={() => setView("admin")}
      onSignOut={signOut}
      activeView={view}
    />
  );
```

Y añadir el import en la parte superior del archivo:
```typescript
import { AnalyticsView } from "./views/AnalyticsView";
```

- [ ] **Step 3: Hacer la Sidebar funcional con navegación**

Reemplazar el contenido completo de `src/components/dashboard/Sidebar.tsx`:

```typescript
import {
  LayoutDashboard, DollarSign, Users, CreditCard,
  ArrowRightLeft, Globe, Settings, BarChart2,
} from "lucide-react";
import { C } from "../../tokens";
import type { AppView } from "../../types";

interface SidebarProps {
  activeView:   AppView;
  onNavigate:   (view: AppView) => void;
}

const NAV: Array<{ icon: React.ElementType; label: string; view: AppView }> = [
  { icon: LayoutDashboard, label: "Resumen",       view: "dashboard"     },
  { icon: BarChart2,       label: "Analytics",     view: "analytics"     },
  { icon: Users,           label: "Usuarios",      view: "usuarios"      },
  { icon: ArrowRightLeft,  label: "Transacciones", view: "transacciones" },
];

export function Sidebar({ activeView, onNavigate }: SidebarProps) {
  return (
    <aside style={{
      width: 72, background: C.sidebar, borderRight: `1px solid ${C.border}`,
      display: "flex", flexDirection: "column", alignItems: "center",
      padding: "16px 8px", flexShrink: 0, gap: 4,
    }}>
      <div style={{
        width: 36, height: 36, borderRadius: 10, background: C.orange,
        display: "flex", alignItems: "center", justifyContent: "center",
        marginBottom: 24, flexShrink: 0,
      }}>
        <img src="/logo.png" alt="AIVI" style={{ height: 22, width: "auto", objectFit: "contain" }} />
      </div>

      <nav style={{ flex: 1, width: "100%", display: "flex", flexDirection: "column", gap: 2 }}>
        {NAV.map(({ icon: Icon, label, view }) => {
          const active = activeView === view;
          return (
            <button
              key={view}
              className="sidebar-btn"
              aria-current={active ? "page" : undefined}
              title={label}
              onClick={() => onNavigate(view)}
              style={{
                width: "100%", background: active ? `${C.orange}18` : "transparent",
                border: "none", borderRadius: 10, padding: "10px 0",
                display: "flex", flexDirection: "column", alignItems: "center",
                gap: 4, cursor: "pointer", color: active ? C.orange : C.mutedMid,
                transition: "all 0.15s",
              }}
            >
              <Icon size={18} strokeWidth={active ? 2 : 1.6} />
              <span style={{ fontSize: 9, fontWeight: active ? 600 : 400, letterSpacing: "0.01em", whiteSpace: "nowrap" }}>
                {label}
              </span>
            </button>
          );
        })}
      </nav>
    </aside>
  );
}
```

- [ ] **Step 4: Actualizar los usos de `Sidebar` en las vistas existentes**

Las vistas `DashboardView`, `TransactionsView`, `UsersView` usan `<Sidebar>`. Cada una necesita recibir `activeView` y `onNavigate`. Buscar en cada vista el uso de `<Sidebar` y añadir las props:

En `DashboardView`:
```typescript
// Añadir en props de DashboardView:
activeView: AppView;
// Y en el render:
<Sidebar activeView={activeView} onNavigate={(v) => { if (v === "usuarios") onUsers(); else if (v === "transacciones") onTransactions(); else if (v === "analytics") onNavigate?.("analytics"); }} />
```

> Nota: en las vistas que no tengan `onNavigate` prop aún, simplemente pasar `onNavigate={() => {}}` como fallback. El routing real de analytics solo se necesita en `DashboardView` inicialmente.

- [ ] **Step 5: Verificar compilación**

```bash
npx tsc --noEmit
```

- [ ] **Step 6: Commit**

```bash
git add src/types.ts src/App.tsx src/components/dashboard/Sidebar.tsx
git commit -m "feat(routing): añadir vista analytics al router y sidebar con navegación funcional"
```

---

## Task 7: Componente `AlertsPanel`

**Files:**
- Create: `src/components/analytics/AlertsPanel.tsx`

**Interfaces:**
- Consumes: `Alert[]` de `src/services/analytics.ts`.
- Produces: `<AlertsPanel alerts={Alert[]} />`.

- [ ] **Step 1: Crear el componente**

```typescript
// src/components/analytics/AlertsPanel.tsx
import { C } from "../../tokens";
import type { Alert } from "../../services/analytics";

const COLOR = {
  rojo:     { bg: "rgba(255,65,59,0.12)",  border: "#FF413B", icon: "🔴" },
  amarillo: { bg: "rgba(255,194,82,0.12)", border: "#FFC252", icon: "🟡" },
  verde:    { bg: "rgba(254,128,63,0.12)", border: C.orange,  icon: "🟢" },
};

interface Props { alerts: Alert[] }

export function AlertsPanel({ alerts }: Props) {
  if (alerts.length === 0) return null;
  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
      {alerts.map((a, i) => {
        const style = COLOR[a.level];
        return (
          <div key={i} style={{
            background: style.bg, border: `1px solid ${style.border}`,
            borderRadius: 10, padding: "10px 14px",
            display: "flex", alignItems: "center", gap: 10,
          }}>
            <span style={{ fontSize: 14 }}>{style.icon}</span>
            <span style={{ fontSize: 13, color: C.white, lineHeight: 1.4 }}>{a.message}</span>
          </div>
        );
      })}
    </div>
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add src/components/analytics/AlertsPanel.tsx
git commit -m "feat(analytics): AlertsPanel — alertas automáticas por nivel"
```

---

## Task 8: Componente `KPISummary`

**Files:**
- Create: `src/components/analytics/KPISummary.tsx`

**Interfaces:**
- Consumes: `AnalyticsSummary` de `src/services/analytics.ts`.
- Produces: `<KPISummary summary={AnalyticsSummary} loading={boolean} />`.

- [ ] **Step 1: Crear el componente**

```typescript
// src/components/analytics/KPISummary.tsx
import { C } from "../../tokens";
import type { AnalyticsSummary } from "../../services/analytics";

function delta(curr: number, prev: number | undefined): string | null {
  if (prev == null || prev === 0) return null;
  const pct = ((curr - prev) / prev) * 100;
  return `${pct >= 0 ? "+" : ""}${pct.toFixed(1)}%`;
}

function fmt(value: number, type: "usd" | "pct" | "num" | "x"): string {
  if (type === "usd")  return `$${value.toLocaleString("es", { minimumFractionDigits: 0, maximumFractionDigits: 0 })}`;
  if (type === "pct")  return `${value.toFixed(1)}%`;
  if (type === "x")    return `${value.toFixed(2)}x`;
  return value.toLocaleString("es");
}

interface KPI { label: string; value: number; prevValue?: number; type: "usd" | "pct" | "num" | "x" }

interface Props { summary: AnalyticsSummary | null; loading: boolean }

export function KPISummary({ summary, loading }: Props) {
  const kpis: KPI[] = summary ? [
    { label: "Inversión",       value: summary.investment,  prevValue: summary.prev?.investment,  type: "usd" },
    { label: "Ingresos",        value: summary.revenue,     prevValue: summary.prev?.revenue,     type: "usd" },
    { label: "ROAS",            value: summary.roas,        prevValue: summary.prev?.roas,        type: "x"   },
    { label: "CAC Promedio",    value: summary.cac,         prevValue: summary.prev?.cac,         type: "usd" },
    { label: "Ventas",          value: summary.sales,       prevValue: summary.prev?.sales,       type: "num" },
    { label: "Plays Totales",   value: summary.plays,       prevValue: summary.prev?.plays,       type: "num" },
    { label: "Play Rate",       value: summary.playRate,    prevValue: summary.prev?.playRate,     type: "pct" },
    { label: "Costo por Play",  value: summary.costPerPlay, prevValue: summary.prev?.costPerPlay, type: "usd" },
  ] : Array(8).fill({ label: "—", value: 0, type: "num" });

  return (
    <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 12 }}>
      {kpis.map((kpi, i) => {
        const d = !loading && summary ? delta(kpi.value, kpi.prevValue) : null;
        const isPositive = d ? !d.startsWith("-") : false;
        // CAC: positivo es malo (subió), negativo es bueno (bajó)
        const isCAC = kpi.label === "CAC Promedio" || kpi.label === "Costo por Play";
        const dColor = d ? (isCAC ? (isPositive ? "#FF413B" : "#4ADE80") : (isPositive ? "#4ADE80" : "#FF413B")) : C.mutedMid;

        return (
          <div key={i} style={{
            background: C.card, border: `1px solid ${C.border}`,
            borderRadius: 12, padding: "16px 18px",
          }}>
            <div style={{ fontSize: 11, color: C.mutedMid, marginBottom: 6, textTransform: "uppercase", letterSpacing: "0.05em" }}>
              {kpi.label}
            </div>
            {loading ? (
              <div style={{ height: 28, background: C.cardHover, borderRadius: 6, width: "70%" }} />
            ) : (
              <div style={{ display: "flex", alignItems: "baseline", gap: 8 }}>
                <span style={{ fontSize: 22, fontWeight: 700, color: C.white }}>
                  {fmt(kpi.value, kpi.type)}
                </span>
                {d && (
                  <span style={{ fontSize: 11, color: dColor, fontWeight: 600 }}>{d}</span>
                )}
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add src/components/analytics/KPISummary.tsx
git commit -m "feat(analytics): KPISummary — 8 KPIs con deltas vs período anterior"
```

---

## Task 9: Componente `CampaignFunnelCard`

**Files:**
- Create: `src/components/analytics/CampaignFunnelCard.tsx`

**Interfaces:**
- Consumes: `FunnelCampaign` de `src/services/analytics.ts`.
- Produces: `<CampaignFunnelCard campaign={FunnelCampaign} />`.

- [ ] **Step 1: Crear el componente**

```typescript
// src/components/analytics/CampaignFunnelCard.tsx
import { C } from "../../tokens";
import type { FunnelCampaign } from "../../services/analytics";

function pct(a: number, b: number) { return b > 0 ? `${((a/b)*100).toFixed(1)}%` : "—"; }
function scoreColor(s: number) {
  if (s >= 80) return "#4ADE80";
  if (s >= 50) return C.yellow;
  return "#FF413B";
}

interface Props { campaign: FunnelCampaign }

export function CampaignFunnelCard({ campaign: c }: Props) {
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
      {/* Header */}
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 16 }}>
        <div>
          <div style={{ fontSize: 13, fontWeight: 600, color: C.white, marginBottom: 2 }}>{c.campaignName}</div>
          <div style={{ fontSize: 11, color: C.mutedMid }}>{c.videoName ?? "Sin VSL asignado"}</div>
        </div>
        <div style={{ display: "flex", gap: 8, alignItems: "center" }}>
          <span style={{
            background: `${scoreColor(c.score)}20`, color: scoreColor(c.score),
            border: `1px solid ${scoreColor(c.score)}`, borderRadius: 20,
            fontSize: 11, fontWeight: 700, padding: "2px 10px",
          }}>Score {c.score}</span>
        </div>
      </div>

      {/* Funnel */}
      <div style={{ display: "flex", gap: 4, alignItems: "flex-end", marginBottom: 16 }}>
        {stages.map((s, i) => {
          const h = Math.max(8, (s.value / maxVal) * 64);
          return (
            <div key={i} style={{ flex: 1, textAlign: "center" }}>
              <div style={{ fontSize: 10, color: C.mutedMid, marginBottom: 4 }}>{s.label}</div>
              <div style={{
                height: h, background: `${C.orange}${i === 0 ? "FF" : i === stages.length-1 ? "FF" : "80"}`,
                borderRadius: 4, marginBottom: 4,
              }} />
              <div style={{ fontSize: 11, fontWeight: 600, color: C.white }}>
                {s.value.toLocaleString("es")}
              </div>
              {s.conv && <div style={{ fontSize: 10, color: C.mutedMid }}>{s.conv}</div>}
            </div>
          );
        })}
      </div>

      {/* Métricas adicionales */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 8, borderTop: `1px solid ${C.border}`, paddingTop: 14 }}>
        <div>
          <div style={{ fontSize: 10, color: C.mutedMid }}>CAC</div>
          <div style={{ fontSize: 14, fontWeight: 700, color: C.white }}>${c.cac.toFixed(0)}</div>
        </div>
        <div>
          <div style={{ fontSize: 10, color: C.mutedMid }}>ROAS</div>
          <div style={{ fontSize: 14, fontWeight: 700, color: c.roas >= 2 ? "#4ADE80" : C.yellow }}>{c.roas.toFixed(2)}x</div>
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
    </div>
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add src/components/analytics/CampaignFunnelCard.tsx
git commit -m "feat(analytics): CampaignFunnelCard — funnel visual por combinación anuncio+VSL"
```

---

## Task 10: Componente `VSLComparator`

**Files:**
- Create: `src/components/analytics/VSLComparator.tsx`

**Interfaces:**
- Consumes: `VSLData[]` de `src/services/analytics.ts`. Usa `LineChart` de `recharts`.
- Produces: `<VSLComparator vsls={VSLData[]} />`.

- [ ] **Step 1: Crear el componente**

```typescript
// src/components/analytics/VSLComparator.tsx
import { LineChart, Line, XAxis, YAxis, Tooltip, Legend, ResponsiveContainer, ReferenceDot } from "recharts";
import { C } from "../../tokens";
import type { VSLData } from "../../services/analytics";

const COLORS = [C.orange, "#60A5FA", "#4ADE80", "#F472B6", "#A78BFA", "#FB923C"];

interface Props { vsls: VSLData[] }

export function VSLComparator({ vsls }: Props) {
  if (vsls.length === 0) return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 24 }}>
      <div style={{ fontSize: 13, color: C.mutedMid, textAlign: "center" }}>Sin datos de retención en el período</div>
    </div>
  );

  // Alinear curvas por segundo (samplear cada 5 segundos para rendimiento)
  const maxSeconds = Math.max(...vsls.map(v => v.retention.length > 0 ? v.retention[v.retention.length-1].second : 0));
  const chartData: Record<number, any>[] = [];
  for (let s = 0; s <= maxSeconds; s += 5) {
    const point: Record<string, any> = { second: s };
    for (const vsl of vsls) {
      const pt = vsl.retention.find(p => p.second === s) ?? vsl.retention.find(p => p.second >= s);
      point[vsl.videoId] = pt ? pt.percentage : null;
    }
    chartData.push(point);
  }

  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 20 }}>
      <div style={{ fontSize: 14, fontWeight: 600, color: C.white, marginBottom: 16 }}>Comparador de Retención</div>

      <ResponsiveContainer width="100%" height={240}>
        <LineChart data={chartData}>
          <XAxis dataKey="second" tick={{ fontSize: 10, fill: C.mutedMid }}
            tickFormatter={(s) => `${Math.floor(s/60)}:${String(s%60).padStart(2,"0")}`} />
          <YAxis domain={[0, 100]} tick={{ fontSize: 10, fill: C.mutedMid }}
            tickFormatter={(v) => `${v}%`} />
          <Tooltip
            contentStyle={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 8, fontSize: 12 }}
            labelFormatter={(s) => `Segundo ${s}`}
            formatter={(v: any) => [`${Number(v).toFixed(1)}%`, ""]}
          />
          <Legend wrapperStyle={{ fontSize: 11 }} />
          {vsls.map((vsl, i) => (
            <Line key={vsl.videoId} type="monotone" dataKey={vsl.videoId} name={vsl.videoName}
              stroke={COLORS[i % COLORS.length]} dot={false} strokeWidth={2} />
          ))}
          {/* Puntos de caída */}
          {vsls.flatMap((vsl, i) =>
            vsl.dropSecond !== null ? [
              <ReferenceDot key={`drop-${vsl.videoId}`} x={vsl.dropSecond} y={
                vsl.retention.find(p => p.second >= vsl.dropSecond!)?.percentage ?? 0
              } r={5} fill="#FF413B" stroke="none" />
            ] : []
          )}
        </LineChart>
      </ResponsiveContainer>

      {/* Tabla de VSLs */}
      <table style={{ width: "100%", borderCollapse: "collapse", marginTop: 20, fontSize: 12 }}>
        <thead>
          <tr style={{ borderBottom: `1px solid ${C.border}` }}>
            {["VSL", "Plays", "Ret. 25%", "Ret. 50%", "Ret. 75%", "CTA Clicks", "Conv.", "Conv. Rate"].map(h => (
              <th key={h} style={{ padding: "6px 8px", color: C.mutedMid, fontWeight: 500, textAlign: "left" }}>{h}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {vsls.map(vsl => (
            <tr key={vsl.videoId} style={{ borderBottom: `1px solid ${C.border}` }}>
              <td style={{ padding: "8px", color: C.white, fontWeight: 500 }}>{vsl.videoName}</td>
              <td style={{ padding: "8px", color: C.mutedLight }}>{vsl.plays.toLocaleString("es")}</td>
              <td style={{ padding: "8px", color: C.mutedLight }}>{vsl.ret25.toFixed(0)}%</td>
              <td style={{ padding: "8px", color: C.mutedLight }}>{vsl.ret50.toFixed(0)}%</td>
              <td style={{ padding: "8px", color: C.mutedLight }}>{vsl.ret75.toFixed(0)}%</td>
              <td style={{ padding: "8px", color: C.mutedLight }}>{vsl.ctaClicks.toLocaleString("es")}</td>
              <td style={{ padding: "8px", color: C.mutedLight }}>{vsl.sales}</td>
              <td style={{ padding: "8px", color: C.orange, fontWeight: 600 }}>{vsl.convRate.toFixed(1)}%</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add src/components/analytics/VSLComparator.tsx
git commit -m "feat(analytics): VSLComparator — curvas de retención superpuestas con Recharts"
```

---

## Task 11: Componente `AdsRankingTable`

**Files:**
- Create: `src/components/analytics/AdsRankingTable.tsx`

**Interfaces:**
- Consumes: `AdRankRow[]` de `src/services/analytics.ts`. Recibe `cacTarget: number` y `onCacTargetChange: (n: number) => void`.
- Produces: `<AdsRankingTable rows={AdRankRow[]} cacTarget={number} onCacTargetChange={fn} />`.

- [ ] **Step 1: Crear el componente**

```typescript
// src/components/analytics/AdsRankingTable.tsx
import { C } from "../../tokens";
import type { AdRankRow } from "../../services/analytics";

function rowBg(cac: number, target: number) {
  if (cac === 0 || target === 0) return "transparent";
  if (cac <= target)             return "rgba(74,222,128,0.06)";
  if (cac <= target * 1.5)       return "rgba(255,194,82,0.06)";
  return "rgba(255,65,59,0.06)";
}

interface Props {
  rows:            AdRankRow[];
  cacTarget:       number;
  onCacTargetChange: (n: number) => void;
  onOpenMapping:   () => void;
}

export function AdsRankingTable({ rows, cacTarget, onCacTargetChange, onOpenMapping }: Props) {
  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 20 }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
        <div style={{ fontSize: 14, fontWeight: 600, color: C.white }}>Anuncios por CAC</div>
        <div style={{ display: "flex", gap: 12, alignItems: "center" }}>
          <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
            <span style={{ fontSize: 12, color: C.mutedMid }}>CAC objetivo $</span>
            <input
              type="number"
              value={cacTarget}
              onChange={e => onCacTargetChange(Number(e.target.value))}
              style={{
                width: 64, background: C.bgSecondary, border: `1px solid ${C.border}`,
                borderRadius: 6, padding: "4px 8px", color: C.white, fontSize: 12,
              }}
            />
          </div>
          <button onClick={onOpenMapping} style={{
            background: `${C.orange}18`, border: `1px solid ${C.orange}40`,
            color: C.orange, borderRadius: 8, padding: "4px 12px", fontSize: 12, cursor: "pointer",
          }}>
            Configurar VSLs
          </button>
        </div>
      </div>

      <div style={{ overflowX: "auto" }}>
        <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 12 }}>
          <thead>
            <tr style={{ borderBottom: `1px solid ${C.border}` }}>
              {["Campaña", "Inversión", "Clicks", "CPM", "CPC", "Plays", "Play%", "Ventas", "CAC", "ROAS", "VSL", "Score"].map(h => (
                <th key={h} style={{ padding: "6px 10px", color: C.mutedMid, fontWeight: 500, textAlign: "left", whiteSpace: "nowrap" }}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {rows.map((r, i) => (
              <tr key={i} style={{ background: rowBg(r.cac, cacTarget), borderBottom: `1px solid ${C.border}` }}>
                <td style={{ padding: "9px 10px", color: C.white, fontWeight: 500, maxWidth: 160, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{r.campaignName}</td>
                <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.investment.toFixed(0)}</td>
                <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.clicks.toLocaleString("es")}</td>
                <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.cpm.toFixed(2)}</td>
                <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.cpc.toFixed(2)}</td>
                <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.plays.toLocaleString("es")}</td>
                <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.playRate.toFixed(1)}%</td>
                <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.sales}</td>
                <td style={{ padding: "9px 10px", color: r.cac > 0 && r.cac <= cacTarget ? "#4ADE80" : r.cac <= cacTarget*1.5 ? C.yellow : "#FF413B", fontWeight: 700 }}>
                  {r.cac > 0 ? `$${r.cac.toFixed(0)}` : "—"}
                </td>
                <td style={{ padding: "9px 10px", color: r.roas >= 2 ? "#4ADE80" : C.yellow, fontWeight: 600 }}>
                  {r.roas > 0 ? `${r.roas.toFixed(2)}x` : "—"}
                </td>
                <td style={{ padding: "9px 10px", color: C.mutedMid, maxWidth: 120, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                  {r.videoName ?? <span style={{ color: C.muted }}>Sin VSL</span>}
                </td>
                <td style={{ padding: "9px 10px" }}>
                  <span style={{
                    background: r.score >= 80 ? "rgba(74,222,128,0.15)" : r.score >= 50 ? "rgba(255,194,82,0.15)" : "rgba(255,65,59,0.15)",
                    color: r.score >= 80 ? "#4ADE80" : r.score >= 50 ? C.yellow : "#FF413B",
                    borderRadius: 12, padding: "2px 8px", fontSize: 11, fontWeight: 700,
                  }}>{r.score}</span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add src/components/analytics/AdsRankingTable.tsx
git commit -m "feat(analytics): AdsRankingTable — tabla rankeada por CAC con semáforo de colores"
```

---

## Task 12: Componente `HourlyHeatmap`

**Files:**
- Create: `src/components/analytics/HourlyHeatmap.tsx`

**Interfaces:**
- Consumes: `HeatmapCell[]` de `src/services/analytics.ts`.
- Produces: `<HourlyHeatmap cells={HeatmapCell[]} />`.

- [ ] **Step 1: Crear el componente**

```typescript
// src/components/analytics/HourlyHeatmap.tsx
import { C } from "../../tokens";
import type { HeatmapCell } from "../../services/analytics";

const DAYS  = ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb"];
const HOURS = Array.from({ length: 24 }, (_, i) => i);

interface Props { cells: HeatmapCell[] }

export function HourlyHeatmap({ cells }: Props) {
  const maxVal = Math.max(1, ...cells.map(c => c.value));
  const lookup: Record<string, number> = {};
  for (const c of cells) lookup[`${c.hour}-${c.dow}`] = c.value;

  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 20 }}>
      <div style={{ fontSize: 14, fontWeight: 600, color: C.white, marginBottom: 16 }}>Conversiones por Hora y Día</div>

      <div style={{ overflowX: "auto" }}>
        <table style={{ borderCollapse: "collapse", fontSize: 10 }}>
          <thead>
            <tr>
              <th style={{ width: 28, color: C.mutedMid, fontWeight: 400, textAlign: "right", paddingRight: 6 }} />
              {DAYS.map(d => (
                <th key={d} style={{ width: 36, color: C.mutedMid, fontWeight: 400, textAlign: "center", paddingBottom: 6 }}>{d}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {HOURS.map(h => (
              <tr key={h}>
                <td style={{ color: C.mutedMid, textAlign: "right", paddingRight: 6, whiteSpace: "nowrap" }}>{h}h</td>
                {Array.from({ length: 7 }, (_, dow) => {
                  const val   = lookup[`${h}-${dow}`] ?? 0;
                  const alpha = val > 0 ? 0.15 + (val / maxVal) * 0.85 : 0;
                  return (
                    <td key={dow} title={val > 0 ? `${val} conversiones` : "0"} style={{
                      width: 36, height: 24,
                      background: val > 0 ? `rgba(254,128,63,${alpha.toFixed(2)})` : C.bgSecondary,
                      border: `1px solid ${C.bg}`,
                      borderRadius: 3,
                      textAlign: "center",
                      color: alpha > 0.5 ? C.white : "transparent",
                      fontWeight: 600,
                      cursor: "default",
                    }}>
                      {val > 0 ? val : ""}
                    </td>
                  );
                })}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add src/components/analytics/HourlyHeatmap.tsx
git commit -m "feat(analytics): HourlyHeatmap — heatmap de conversiones 24h×7días"
```

---

## Task 13: Componente `LTVTable`

**Files:**
- Create: `src/components/analytics/LTVTable.tsx`

**Interfaces:**
- Consumes: `LTVRow[]` de `src/services/analytics.ts`.
- Produces: `<LTVTable rows={LTVRow[]} />`.

- [ ] **Step 1: Crear el componente**

```typescript
// src/components/analytics/LTVTable.tsx
import { C } from "../../tokens";
import type { LTVRow } from "../../services/analytics";

interface Props { rows: LTVRow[] }

export function LTVTable({ rows }: Props) {
  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 20 }}>
      <div style={{ fontSize: 14, fontWeight: 600, color: C.white, marginBottom: 6 }}>LTV por Fuente de Tráfico</div>
      <div style={{ fontSize: 12, color: C.mutedMid, marginBottom: 16 }}>
        ROI Real = LTV Promedio ÷ CAC — revela el valor a largo plazo de cada fuente
      </div>

      <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 12 }}>
        <thead>
          <tr style={{ borderBottom: `1px solid ${C.border}` }}>
            {["Campaña", "Clientes", "LTV Prom.", "Ingresos Totales", "CAC", "ROI Real"].map(h => (
              <th key={h} style={{ padding: "6px 10px", color: C.mutedMid, fontWeight: 500, textAlign: "left" }}>{h}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((r, i) => (
            <tr key={i} style={{ borderBottom: `1px solid ${C.border}` }}>
              <td style={{ padding: "9px 10px", color: C.white, fontWeight: 500 }}>{r.campaignName}</td>
              <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.customers}</td>
              <td style={{ padding: "9px 10px", color: C.white, fontWeight: 600 }}>${r.ltv.toFixed(0)}</td>
              <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.totalRevenue.toFixed(0)}</td>
              <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.cac.toFixed(0)}</td>
              <td style={{ padding: "9px 10px" }}>
                <span style={{
                  color: r.roiReal >= 5 ? "#4ADE80" : r.roiReal >= 2 ? C.yellow : "#FF413B",
                  fontWeight: 700, fontSize: 13,
                }}>{r.roiReal.toFixed(1)}x</span>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add src/components/analytics/LTVTable.tsx
git commit -m "feat(analytics): LTVTable — LTV y ROI real por fuente de tráfico"
```

---

## Task 14: Componente `CampaignMappingModal`

**Files:**
- Create: `src/components/analytics/CampaignMappingModal.tsx`

**Interfaces:**
- Consumes: `VSLMapping[]`, `saveVSLMapping`, `deleteVSLMapping` de `src/services/analytics.ts`. `FunnelCampaign[]` para listar campañas conocidas.
- Produces: `<CampaignMappingModal open={boolean} onClose={fn} mappings={VSLMapping[]} campaigns={string[]} onSaved={fn} />`.

- [ ] **Step 1: Crear el componente**

```typescript
// src/components/analytics/CampaignMappingModal.tsx
import { useState } from "react";
import { C } from "../../tokens";
import { saveVSLMapping, deleteVSLMapping } from "../../services/analytics";
import type { VSLMapping } from "../../services/analytics";

interface Props {
  open:       boolean;
  onClose:    () => void;
  mappings:   VSLMapping[];
  campaigns:  string[];
  onSaved:    () => void;
}

export function CampaignMappingModal({ open, onClose, mappings, campaigns, onSaved }: Props) {
  const [newCampaign, setNewCampaign] = useState("");
  const [newVideoId,  setNewVideoId]  = useState("");
  const [newVideoName, setNewVideoName] = useState("");
  const [saving,      setSaving]      = useState(false);

  if (!open) return null;

  const handleSave = async () => {
    if (!newCampaign || !newVideoId) return;
    setSaving(true);
    try {
      await saveVSLMapping({ campaignName: newCampaign, videoId: newVideoId, videoName: newVideoName || newVideoId });
      setNewCampaign(""); setNewVideoId(""); setNewVideoName("");
      onSaved();
    } finally { setSaving(false); }
  };

  const handleDelete = async (campaignName: string) => {
    await deleteVSLMapping(campaignName);
    onSaved();
  };

  return (
    <div style={{
      position: "fixed", inset: 0, background: "rgba(0,0,0,0.7)",
      display: "flex", alignItems: "center", justifyContent: "center", zIndex: 100,
    }} onClick={onClose}>
      <div style={{
        background: C.panel, border: `1px solid ${C.border}`, borderRadius: 16,
        width: 560, maxHeight: "80vh", overflow: "auto", padding: 28,
      }} onClick={e => e.stopPropagation()}>
        <div style={{ fontSize: 16, fontWeight: 700, color: C.white, marginBottom: 20 }}>Configurar Campaña → VSL</div>

        {/* Mappings existentes */}
        <div style={{ marginBottom: 20 }}>
          {mappings.map(m => (
            <div key={m.campaignName} style={{
              display: "flex", justifyContent: "space-between", alignItems: "center",
              padding: "10px 12px", background: C.card, borderRadius: 8, marginBottom: 6,
            }}>
              <div>
                <div style={{ fontSize: 13, color: C.white }}>{m.campaignName}</div>
                <div style={{ fontSize: 11, color: C.mutedMid }}>{m.videoName} ({m.videoId})</div>
              </div>
              <button onClick={() => handleDelete(m.campaignName)} style={{
                background: "rgba(255,65,59,0.12)", border: "none", color: "#FF413B",
                borderRadius: 6, padding: "4px 10px", fontSize: 11, cursor: "pointer",
              }}>Eliminar</button>
            </div>
          ))}
          {mappings.length === 0 && (
            <div style={{ fontSize: 12, color: C.mutedMid, textAlign: "center", padding: 16 }}>Sin mapeos configurados</div>
          )}
        </div>

        {/* Añadir nuevo */}
        <div style={{ borderTop: `1px solid ${C.border}`, paddingTop: 16 }}>
          <div style={{ fontSize: 13, color: C.mutedLight, marginBottom: 12 }}>Añadir nuevo mapeo</div>
          <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
            <select value={newCampaign} onChange={e => setNewCampaign(e.target.value)} style={{
              background: C.bgSecondary, border: `1px solid ${C.border}`, borderRadius: 8,
              padding: "8px 12px", color: C.white, fontSize: 12,
            }}>
              <option value="">Selecciona campaña...</option>
              {campaigns.filter(c => !mappings.find(m => m.campaignName === c)).map(c => (
                <option key={c} value={c}>{c}</option>
              ))}
            </select>
            <input placeholder="Video ID de VTurb" value={newVideoId} onChange={e => setNewVideoId(e.target.value)}
              style={{ background: C.bgSecondary, border: `1px solid ${C.border}`, borderRadius: 8, padding: "8px 12px", color: C.white, fontSize: 12 }} />
            <input placeholder="Nombre del VSL (opcional)" value={newVideoName} onChange={e => setNewVideoName(e.target.value)}
              style={{ background: C.bgSecondary, border: `1px solid ${C.border}`, borderRadius: 8, padding: "8px 12px", color: C.white, fontSize: 12 }} />
            <button onClick={handleSave} disabled={saving || !newCampaign || !newVideoId} style={{
              background: C.orange, border: "none", borderRadius: 8, padding: "10px 0",
              color: C.white, fontSize: 13, fontWeight: 600, cursor: "pointer",
              opacity: !newCampaign || !newVideoId ? 0.5 : 1,
            }}>
              {saving ? "Guardando..." : "Guardar Mapeo"}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add src/components/analytics/CampaignMappingModal.tsx
git commit -m "feat(analytics): CampaignMappingModal — configuración de mapeo campaña↔VSL"
```

---

## Task 15: Componente `AIAnalyst`

**Files:**
- Create: `src/components/analytics/AIAnalyst.tsx`

**Interfaces:**
- Consumes: `aiResult: string | null`, `aiLoading: boolean`, `onAnalyze: () => void` del hook.
- Produces: `<AIAnalyst result={string|null} loading={boolean} onAnalyze={fn} />`.

- [ ] **Step 1: Verificar que `VITE_ANTHROPIC_API_KEY` está en `.env.local`**

```bash
# En .env.local (nunca commitear)
VITE_ANTHROPIC_API_KEY=<tu_api_key_de_anthropic>
```

- [ ] **Step 2: Crear el componente**

```typescript
// src/components/analytics/AIAnalyst.tsx
import { C } from "../../tokens";

interface Props {
  result:    string | null;
  loading:   boolean;
  onAnalyze: () => void;
}

export function AIAnalyst({ result, loading, onAnalyze }: Props) {
  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 20 }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
        <div>
          <div style={{ fontSize: 14, fontWeight: 600, color: C.white }}>Inteligencia Accionable</div>
          <div style={{ fontSize: 12, color: C.mutedMid, marginTop: 2 }}>Claude analiza el período y te dice exactamente qué hacer</div>
        </div>
        <button onClick={onAnalyze} disabled={loading} style={{
          background: loading ? C.cardHover : C.orange,
          border: "none", borderRadius: 10, padding: "10px 20px",
          color: C.white, fontSize: 13, fontWeight: 600, cursor: loading ? "default" : "pointer",
          opacity: loading ? 0.7 : 1, transition: "all 0.15s",
        }}>
          {loading ? "Analizando..." : "Analizar período"}
        </button>
      </div>

      {loading && (
        <div style={{ display: "flex", alignItems: "center", gap: 10, padding: 16 }}>
          <div style={{
            width: 20, height: 20, borderRadius: "50%",
            border: `2px solid ${C.border}`, borderTopColor: C.orange,
            animation: "spin 0.8s linear infinite",
          }} />
          <span style={{ fontSize: 13, color: C.mutedMid }}>Claude está analizando tus datos...</span>
          <style>{`@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`}</style>
        </div>
      )}

      {result && !loading && (
        <div style={{ position: "relative" }}>
          <pre style={{
            fontFamily: "inherit", whiteSpace: "pre-wrap", fontSize: 13, lineHeight: 1.7,
            color: C.mutedLight, margin: 0, padding: 16,
            background: C.bgSecondary, borderRadius: 10,
          }}>
            {result.split("##").filter(Boolean).map((section, i) => {
              const [title, ...body] = section.split("\n");
              return (
                <div key={i} style={{ marginBottom: 20 }}>
                  <div style={{ fontSize: 14, fontWeight: 700, color: C.orange, marginBottom: 8 }}>## {title.trim()}</div>
                  <div style={{ color: C.mutedLight }}>{body.join("\n").trim()}</div>
                </div>
              );
            })}
          </pre>
          <button onClick={() => navigator.clipboard.writeText(result)} style={{
            position: "absolute", top: 10, right: 10,
            background: C.card, border: `1px solid ${C.border}`,
            borderRadius: 6, padding: "4px 10px", fontSize: 11, color: C.mutedMid, cursor: "pointer",
          }}>Copiar</button>
        </div>
      )}

      {!result && !loading && (
        <div style={{ fontSize: 13, color: C.muted, textAlign: "center", padding: "20px 0" }}>
          Presiona "Analizar período" para obtener recomendaciones basadas en tus datos
        </div>
      )}
    </div>
  );
}
```

- [ ] **Step 3: Commit**

```bash
git add src/components/analytics/AIAnalyst.tsx
git commit -m "feat(analytics): AIAnalyst — análisis accionable con Claude (escalar/corregir/replicar)"
```

---

## Task 16: Vista Principal `AnalyticsView`

**Files:**
- Create: `src/views/AnalyticsView.tsx`

**Interfaces:**
- Consumes: todos los componentes de `src/components/analytics/` (Tasks 7–15). `useAnalyticsData` (Task 5). Props: `onDashboard`, `onUsers`, `onTransactions`, `onSettings`, `onSignOut`, `activeView`, `isAdmin`.
- Produces: vista completa exportada, importada en `App.tsx` (Task 6).

- [ ] **Step 1: Crear la vista**

```typescript
// src/views/AnalyticsView.tsx
import { useState } from "react";
import { C, FONT } from "../tokens";
import { useAnalyticsData } from "../hooks/useAnalyticsData";
import { Sidebar }             from "../components/dashboard/Sidebar";
import { TopNav }              from "../components/dashboard/TopNav";
import { AlertsPanel }         from "../components/analytics/AlertsPanel";
import { KPISummary }          from "../components/analytics/KPISummary";
import { CampaignFunnelCard }  from "../components/analytics/CampaignFunnelCard";
import { VSLComparator }       from "../components/analytics/VSLComparator";
import { AdsRankingTable }     from "../components/analytics/AdsRankingTable";
import { HourlyHeatmap }       from "../components/analytics/HourlyHeatmap";
import { LTVTable }            from "../components/analytics/LTVTable";
import { CampaignMappingModal } from "../components/analytics/CampaignMappingModal";
import { AIAnalyst }           from "../components/analytics/AIAnalyst";
import type { AppView }        from "../types";
import type { PeriodKey }      from "../services/analytics";

interface Props {
  onDashboard:    () => void;
  onUsers:        () => void;
  onTransactions: () => void;
  onSettings:     () => void;
  onSignOut:      () => void;
  activeView:     AppView;
  isAdmin:        boolean;
}

const PERIOD_LABELS: Record<PeriodKey, string> = {
  noche:  "Noche",
  dia:    "Día",
  hoy:    "Hoy",
  ayer:   "Ayer",
  "7dias": "7 días",
  custom: "Custom",
};

export function AnalyticsView({ onDashboard, onUsers, onTransactions, onSettings, onSignOut, activeView, isAdmin }: Props) {
  const {
    summary, funnel, vsls, ranking, heatmap, ltv, alerts, mappings,
    loading, error, period, setPeriod, refresh, aiResult, aiLoading, runAIAnalysis,
  } = useAnalyticsData();

  const [cacTarget,     setCacTarget]     = useState(50);
  const [mappingOpen,   setMappingOpen]   = useState(false);

  const navigate = (v: AppView) => {
    if (v === "dashboard")    onDashboard();
    else if (v === "usuarios") onUsers();
    else if (v === "transacciones") onTransactions();
  };

  return (
    <div style={{ display: "flex", height: "100vh", background: C.bg, fontFamily: FONT, color: C.white, overflow: "hidden" }}>
      <Sidebar activeView={activeView} onNavigate={navigate} />

      <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
        <TopNav
          onSettings={onSettings}
          onSignOut={onSignOut}
          activeView={activeView}
          isAdmin={isAdmin}
        />

        <main style={{ flex: 1, overflowY: "auto", padding: "24px 28px", display: "flex", flexDirection: "column", gap: 20 }}>

          {/* Bloque 1 — Selector de período */}
          <div style={{ display: "flex", gap: 8, flexWrap: "wrap", alignItems: "center" }}>
            {(["noche", "dia", "hoy", "ayer", "7dias"] as PeriodKey[]).map(key => (
              <button key={key} onClick={() => setPeriod(key)} style={{
                background: period === key ? C.orange : C.card,
                border: `1px solid ${period === key ? C.orange : C.border}`,
                borderRadius: 20, padding: "6px 16px", fontSize: 13, fontWeight: period === key ? 600 : 400,
                color: period === key ? C.white : C.mutedLight, cursor: "pointer",
              }}>
                {PERIOD_LABELS[key]}
              </button>
            ))}
            <button onClick={refresh} style={{
              background: "transparent", border: `1px solid ${C.border}`,
              borderRadius: 20, padding: "6px 14px", fontSize: 12, color: C.mutedMid, cursor: "pointer", marginLeft: "auto",
            }}>
              ↺ Actualizar
            </button>
          </div>

          {error && (
            <div style={{ background: "rgba(255,65,59,0.1)", border: "1px solid #FF413B", borderRadius: 10, padding: 14, fontSize: 13, color: "#FF413B" }}>
              Error al cargar datos: {error}
            </div>
          )}

          {/* Bloque 8 — Alertas (van arriba para verlas primero) */}
          {alerts.length > 0 && <AlertsPanel alerts={alerts} />}

          {/* Bloque 2 — KPIs */}
          <KPISummary summary={summary} loading={loading} />

          {/* Bloque 3 — Funnels por campaña */}
          {funnel.length > 0 && (
            <div>
              <div style={{ fontSize: 14, fontWeight: 600, color: C.white, marginBottom: 12 }}>Funnels por Campaña</div>
              <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(340px, 1fr))", gap: 16 }}>
                {funnel.map(f => <CampaignFunnelCard key={f.campaignName} campaign={f} />)}
              </div>
            </div>
          )}

          {/* Bloque 4 — Comparador de VSLs */}
          <VSLComparator vsls={vsls} />

          {/* Bloque 5 — Tabla de anuncios */}
          <AdsRankingTable
            rows={ranking}
            cacTarget={cacTarget}
            onCacTargetChange={setCacTarget}
            onOpenMapping={() => setMappingOpen(true)}
          />

          {/* Bloque 6 — Heatmap horario */}
          <HourlyHeatmap cells={heatmap} />

          {/* Bloque 7 — LTV por fuente */}
          <LTVTable rows={ltv} />

          {/* Bloque 9 — IA Analyst */}
          <AIAnalyst result={aiResult} loading={aiLoading} onAnalyze={runAIAnalysis} />

        </main>
      </div>

      <CampaignMappingModal
        open={mappingOpen}
        onClose={() => setMappingOpen(false)}
        mappings={mappings}
        campaigns={funnel.map(f => f.campaignName)}
        onSaved={() => { setMappingOpen(false); refresh(); }}
      />
    </div>
  );
}
```

- [ ] **Step 2: Verificar compilación completa**

```bash
npx tsc --noEmit
```

Esperado: 0 errores.

- [ ] **Step 3: Levantar el servidor de desarrollo y verificar en browser**

```bash
npm run dev
```

Navegar a `http://localhost:5173`, hacer login, clicar "Analytics" en el sidebar. Verificar:
- El selector de período cambia los datos
- Los 9 bloques se renderizan sin errores de consola
- El botón "Analizar período" llama a la API de Claude y muestra el resultado
- El modal de "Configurar VSLs" abre, permite agregar y eliminar mapeos

- [ ] **Step 4: Commit final**

```bash
git add src/views/AnalyticsView.tsx
git commit -m "feat(analytics): AnalyticsView — Command Center completo con 9 bloques"
```

---

## Notas de Implementación

- **`TopNav` props:** Al implementar Task 16, verificar la firma exacta de `TopNav` leyendo `src/components/dashboard/TopNav.tsx` antes de pasar las props. Las vistas existentes (DashboardView, TransactionsView) muestran el patrón correcto.
- **Columna `utm_campaign` en `transactions`:** Antes de implementar Task 4, verificar en el panel de Supabase > Table Editor que la tabla `transactions` tiene una columna `utm_campaign` (o encontrar el nombre real). Si se llama diferente (ej: `traffic_source`), actualizar todas las referencias en `analytics.ts`.
- **VTurb API base URL:** La URL `https://api.vturb.com.br/v1/analytics` es la inferida de la documentación. Verificar en el panel de VTurb > Analytics API > Documentación antes de hacer el deploy de `vturb-sync`.
- **`VTURB_API_KEY` comprometida:** Regenerar la API key en VTurb antes de usarla en Supabase Secrets.

---

## Checklist de Verificación Final

Antes de considerar la implementación completa:

- [ ] Las 4 tablas nuevas existen en Supabase con RLS habilitado
- [ ] `vturb-sync` deployada y corriendo sin errores con la API key correcta de VTurb
- [ ] `utmify-sync` actualizado: `campaign_investment_data` tiene filas con nombres de campaña reales
- [ ] La ruta `/analytics` es accesible desde el sidebar
- [ ] Los 8 KPIs del Bloque 2 muestran valores reales (no ceros)
- [ ] Al menos una tarjeta de Bloque 3 aparece con datos de funnel
- [ ] El Bloque 9 genera análisis coherente con los datos del período
- [ ] `npx tsc --noEmit` pasa sin errores
- [ ] `npm run build` completa sin errores

---

*Plan generado el 2026-06-22. Spec en: `docs/superpowers/specs/2026-06-22-analytics-command-center-design.md`*
