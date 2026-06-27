# VSL Dashboard por Categorías — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Agregar navegación por tabs de dimensiones (Países, Dispositivos, S. Operativo, Navegadores, Fuente de tráfico) dentro del `VSLIntelligencePanel`, con sync automático desde VTurb API.

**Architecture:** 4 tablas nuevas en Supabase reciben datos de VTurb vía la Edge Function `vturb-sync` (ya existente, se extiende). El servicio de analytics expone 5 funciones nuevas que consultan esas tablas. `VSLIntelligencePanel` gestiona su propio estado de tabs + caché lazy — no requiere cambios en el hook principal salvo exponer `range`.

**Tech Stack:** Supabase PostgreSQL · Deno Edge Functions · TypeScript · React 19 · Recharts 2.x

## Global Constraints

- Dark mode obligatorio — colores desde `C` (tokens). Nunca hardcodear colores hex salvo los ya usados en el archivo.
- Español neutro latinoamericano en toda la UI.
- Recharts para todos los charts — ya instalado, seguir el patrón de imports existente en `VSLIntelligencePanel.tsx`.
- `tsc -b && vite build` debe pasar sin errores en cada commit.
- Supabase CLI disponible en `/opt/homebrew/bin/supabase`. Project ref: `jihyeeimmhfqlpzljrbu`.
- Cada `upsert` de Supabase usa `onConflict` con la unique constraint — idempotente.
- Fallo en una dimensión de VTurb no bloquea las otras (usar `Promise.allSettled`).

---

## Mapa de archivos

| Archivo | Acción |
|---|---|
| `supabase/migrations/20260627000001_vturb_dimensions.sql` | Crear |
| `supabase/functions/vturb-sync/index.ts` | Modificar — agregar `syncDimensions` |
| `src/services/analytics.ts` | Modificar — agregar `DimensionRow` + 5 funciones |
| `src/views/AnalyticsView.tsx` | Modificar — pasar prop `range` al panel |
| `src/components/analytics/VSLIntelligencePanel.tsx` | Modificar — tab bar + 5 vistas |

---

### Task 1: Migración SQL — 4 tablas de dimensiones

**Files:**
- Create: `supabase/migrations/20260627000001_vturb_dimensions.sql`

**Interfaces:**
- Produces: tablas `vturb_by_country`, `vturb_by_device`, `vturb_by_os`, `vturb_by_browser` — usadas en Tasks 2 y 3

- [ ] **Step 1: Crear archivo de migración**

```sql
-- supabase/migrations/20260627000001_vturb_dimensions.sql

-- ── vturb_by_country ──────────────────────────────────────────────────────────
create table if not exists public.vturb_by_country (
  id           uuid primary key default gen_random_uuid(),
  video_id     text not null,
  date         date not null,
  country_code text not null,
  country_name text,
  plays        integer default 0,
  views        integer default 0,
  created_at   timestamptz default now(),
  unique(video_id, date, country_code)
);
create index if not exists vturb_by_country_vid_date_idx
  on public.vturb_by_country(video_id, date);

alter table public.vturb_by_country enable row level security;
create policy "service_all_vturb_by_country" on public.vturb_by_country
  for all using (auth.role() = 'service_role');
create policy "auth_read_vturb_by_country" on public.vturb_by_country
  for select using (auth.role() = 'authenticated');

-- ── vturb_by_device ───────────────────────────────────────────────────────────
create table if not exists public.vturb_by_device (
  id          uuid primary key default gen_random_uuid(),
  video_id    text not null,
  date        date not null,
  device_type text not null,
  plays       integer default 0,
  views       integer default 0,
  created_at  timestamptz default now(),
  unique(video_id, date, device_type)
);
create index if not exists vturb_by_device_vid_date_idx
  on public.vturb_by_device(video_id, date);

alter table public.vturb_by_device enable row level security;
create policy "service_all_vturb_by_device" on public.vturb_by_device
  for all using (auth.role() = 'service_role');
create policy "auth_read_vturb_by_device" on public.vturb_by_device
  for select using (auth.role() = 'authenticated');

-- ── vturb_by_os ───────────────────────────────────────────────────────────────
create table if not exists public.vturb_by_os (
  id         uuid primary key default gen_random_uuid(),
  video_id   text not null,
  date       date not null,
  os_name    text not null,
  plays      integer default 0,
  views      integer default 0,
  created_at timestamptz default now(),
  unique(video_id, date, os_name)
);
create index if not exists vturb_by_os_vid_date_idx
  on public.vturb_by_os(video_id, date);

alter table public.vturb_by_os enable row level security;
create policy "service_all_vturb_by_os" on public.vturb_by_os
  for all using (auth.role() = 'service_role');
create policy "auth_read_vturb_by_os" on public.vturb_by_os
  for select using (auth.role() = 'authenticated');

-- ── vturb_by_browser ──────────────────────────────────────────────────────────
create table if not exists public.vturb_by_browser (
  id           uuid primary key default gen_random_uuid(),
  video_id     text not null,
  date         date not null,
  browser_name text not null,
  plays        integer default 0,
  views        integer default 0,
  created_at   timestamptz default now(),
  unique(video_id, date, browser_name)
);
create index if not exists vturb_by_browser_vid_date_idx
  on public.vturb_by_browser(video_id, date);

alter table public.vturb_by_browser enable row level security;
create policy "service_all_vturb_by_browser" on public.vturb_by_browser
  for all using (auth.role() = 'service_role');
create policy "auth_read_vturb_by_browser" on public.vturb_by_browser
  for select using (auth.role() = 'authenticated');
```

- [ ] **Step 2: Aplicar migración**

```bash
supabase db push
```

Resultado esperado: `Applying migration 20260627000001_vturb_dimensions.sql...` sin errores.

- [ ] **Step 3: Verificar en Supabase dashboard**

Abrir `https://supabase.com/dashboard/project/jihyeeimmhfqlpzljrbu/editor` y confirmar que existen las 4 tablas `vturb_by_*` con sus columnas.

- [ ] **Step 4: Commit**

```bash
git add supabase/migrations/20260627000001_vturb_dimensions.sql
git commit -m "feat(db): 4 tablas de dimensiones VTurb (country, device, os, browser)"
```

---

### Task 2: Extender vturb-sync con syncDimensions

**Files:**
- Modify: `supabase/functions/vturb-sync/index.ts`

**Interfaces:**
- Consumes: tablas `vturb_by_country`, `vturb_by_device`, `vturb_by_os`, `vturb_by_browser` del Task 1
- Consumes: función `vturb(apiKey, path, body)` ya existente en el mismo archivo
- Produces: datos en las 4 tablas cada hora vía cron `30 * * * *`

> **Nota sobre endpoints VTurb:** Los nombres exactos de los 4 endpoints nuevos deben verificarse contra la documentación de VTurb (`https://analytics.vturb.net/docs` o contactando soporte). Los nombres usados aquí siguen el patrón de la API existente y son los más probables. Si VTurb usa nombres distintos, cambiar solo las strings de path en `syncDimensions`.

- [ ] **Step 1: Agregar interfaces de tipos VTurb al inicio del archivo**

Abrir `supabase/functions/vturb-sync/index.ts`. Después de la interfaz `EngagementPoint` (línea ~57), agregar:

```typescript
interface DeviceEvent  { device: string; total: number }
interface CountryEvent { country_code: string; country_name: string; total: number }
interface BrowserEvent { browser: string; total: number }
interface OSEvent      { os: string; total: number }
```

- [ ] **Step 2: Agregar función syncDimensions**

Después de la función `syncRetention` (antes del bloque `// ── Runner ──`), agregar:

```typescript
async function syncDimensions(
  supabase: ReturnType<typeof createClient>,
  apiKey:   string,
  from:     string,
  to:       string,
): Promise<void> {
  const startDt = `${from} 00:00:00`;
  const endDt   = `${to} 23:59:59`;

  // Reutiliza el mismo patrón que syncRetention: primero obtener players activos
  const events = await vturb(apiKey, "/events/total_by_company_players", {
    start_date: startDt,
    end_date:   endDt,
    events:     ["started"],
  }) as Array<{ player_id: string; total: number }>;

  const activeIds = [...new Set((events ?? []).map((e) => e.player_id))];
  if (activeIds.length === 0) return;

  for (const pid of activeIds) {
    const body = { player_id: pid, start_date: startDt, end_date: endDt };

    // Las 4 dimensiones en paralelo — fallo en una no bloquea las otras
    const [devicesRes, countriesRes, browsersRes, osRes] = await Promise.allSettled([
      vturb(apiKey, "/events/total_by_device",  body) as Promise<DeviceEvent[]>,
      vturb(apiKey, "/events/total_by_country", body) as Promise<CountryEvent[]>,
      vturb(apiKey, "/events/total_by_browser", body) as Promise<BrowserEvent[]>,
      vturb(apiKey, "/events/total_by_os",      body) as Promise<OSEvent[]>,
    ]);

    if (devicesRes.status === "fulfilled" && devicesRes.value?.length) {
      const rows = devicesRes.value.map((d) => ({
        video_id: pid, date: from, device_type: d.device ?? "unknown",
        plays: Number(d.total) || 0, views: 0,
      }));
      const { error } = await supabase
        .from("vturb_by_device")
        .upsert(rows, { onConflict: "video_id,date,device_type" });
      if (error) console.error(`vturb_by_device upsert ${pid}:`, error.message);
    } else if (devicesRes.status === "rejected") {
      console.error(`VTurb device ${pid}:`, devicesRes.reason);
    }

    if (countriesRes.status === "fulfilled" && countriesRes.value?.length) {
      const rows = countriesRes.value.map((c) => ({
        video_id: pid, date: from,
        country_code: c.country_code ?? "XX",
        country_name: c.country_name ?? c.country_code ?? "Desconocido",
        plays: Number(c.total) || 0, views: 0,
      }));
      const { error } = await supabase
        .from("vturb_by_country")
        .upsert(rows, { onConflict: "video_id,date,country_code" });
      if (error) console.error(`vturb_by_country upsert ${pid}:`, error.message);
    } else if (countriesRes.status === "rejected") {
      console.error(`VTurb country ${pid}:`, countriesRes.reason);
    }

    if (browsersRes.status === "fulfilled" && browsersRes.value?.length) {
      const rows = browsersRes.value.map((b) => ({
        video_id: pid, date: from, browser_name: b.browser ?? "unknown",
        plays: Number(b.total) || 0, views: 0,
      }));
      const { error } = await supabase
        .from("vturb_by_browser")
        .upsert(rows, { onConflict: "video_id,date,browser_name" });
      if (error) console.error(`vturb_by_browser upsert ${pid}:`, error.message);
    } else if (browsersRes.status === "rejected") {
      console.error(`VTurb browser ${pid}:`, browsersRes.reason);
    }

    if (osRes.status === "fulfilled" && osRes.value?.length) {
      const rows = osRes.value.map((o) => ({
        video_id: pid, date: from, os_name: o.os ?? "unknown",
        plays: Number(o.total) || 0, views: 0,
      }));
      const { error } = await supabase
        .from("vturb_by_os")
        .upsert(rows, { onConflict: "video_id,date,os_name" });
      if (error) console.error(`vturb_by_os upsert ${pid}:`, error.message);
    } else if (osRes.status === "rejected") {
      console.error(`VTurb os ${pid}:`, osRes.reason);
    }

    console.log(`✅ VTurb dimensions — ${pid}`);
  }
}
```

- [ ] **Step 3: Llamar syncDimensions en runSync**

En la función `runSync`, después del bloque `try/catch` de `syncRetention` (línea ~219), agregar:

```typescript
  try { await syncDimensions(supabase, apiKey, dateFrom, dateTo); }
  catch (e) { console.error("syncDimensions:", e); errors.push(String(e)); }
```

- [ ] **Step 4: Deploy**

```bash
supabase functions deploy vturb-sync
```

Resultado esperado: `Deployed Function vturb-sync` sin errores.

- [ ] **Step 5: Test manual**

```bash
supabase functions invoke vturb-sync --data '{"from":"2026-06-26","to":"2026-06-27"}'
```

Revisar los logs en `https://supabase.com/dashboard/project/jihyeeimmhfqlpzljrbu/functions/vturb-sync/logs`. Debe verse `✅ VTurb dimensions — <player_id>` para cada player activo. Si aparecen errores 404 en los endpoints de dimensiones, verificar los path strings con la documentación de VTurb.

- [ ] **Step 6: Commit**

```bash
git add supabase/functions/vturb-sync/index.ts
git commit -m "feat(sync): agregar syncDimensions a vturb-sync (country, device, os, browser)"
```

---

### Task 3: DimensionRow + 5 funciones en analytics.ts

**Files:**
- Modify: `src/services/analytics.ts`

**Interfaces:**
- Consumes: tablas `vturb_by_country`, `vturb_by_device`, `vturb_by_os`, `vturb_by_browser`, `vturb_analytics`, `transactions`, `campaign_vsl_mapping` — todas vía `supabase` (ya importado)
- Consumes: `DateRange` — ya definido en el mismo archivo
- Produces:
  ```typescript
  export interface DimensionRow {
    label: string; code?: string; plays: number; views: number; pct: number; conversions: number;
  }
  export async function getVSLByCountry(r: DateRange, videoId: string): Promise<DimensionRow[]>
  export async function getVSLByDevice (r: DateRange, videoId: string): Promise<DimensionRow[]>
  export async function getVSLByOS     (r: DateRange, videoId: string): Promise<DimensionRow[]>
  export async function getVSLByBrowser(r: DateRange, videoId: string): Promise<DimensionRow[]>
  export async function getVSLBySource (r: DateRange, videoId: string): Promise<DimensionRow[]>
  ```

- [ ] **Step 1: Agregar DimensionRow y helper toDimensionRows al final de analytics.ts**

Agregar después de `deleteVSLMapping`:

```typescript
// ── Dimensiones ───────────────────────────────────────────────────────────────

export interface DimensionRow {
  label:       string;
  code?:       string;
  plays:       number;
  views:       number;
  pct:         number;
  conversions: number;
}

function toDimensionRows(
  rows:    { label: string; code?: string; plays: number; views: number }[],
  convMap: Record<string, number> = {},
): DimensionRow[] {
  const sorted = [...rows].sort((a, b) => b.plays - a.plays);
  const top    = sorted.slice(0, 8);
  const rest   = sorted.slice(8);
  const total  = sorted.reduce((s, r) => s + r.plays, 0) || 1;

  const result: DimensionRow[] = top.map(r => ({
    ...r,
    pct:         Math.round((r.plays / total) * 1000) / 10,
    conversions: convMap[r.code ?? r.label] ?? 0,
  }));

  if (rest.length > 0) {
    const otherPlays = rest.reduce((s, r) => s + r.plays, 0);
    const otherViews = rest.reduce((s, r) => s + r.views, 0);
    result.push({
      label: "Otros", plays: otherPlays, views: otherViews,
      pct: Math.round((otherPlays / total) * 1000) / 10,
      conversions: 0,
    });
  }

  return result;
}

export async function getVSLByCountry(r: DateRange, videoId: string): Promise<DimensionRow[]> {
  const [vturbRes, txRes] = await Promise.all([
    supabase
      .from("vturb_by_country")
      .select("country_code, country_name, plays, views")
      .eq("video_id", videoId)
      .gte("date", r.from)
      .lte("date", r.to),
    supabase
      .from("transactions")
      .select("buyer_country")
      .gte("created_at", r.fromTs)
      .lte("created_at", r.toTs)
      .eq("status", "active")
      .not("buyer_country", "is", null),
  ]);

  const convMap: Record<string, number> = {};
  for (const tx of (txRes.data ?? [])) {
    const k = tx.buyer_country as string;
    convMap[k] = (convMap[k] ?? 0) + 1;
  }

  const agg: Record<string, { country_name: string; plays: number; views: number }> = {};
  for (const row of (vturbRes.data ?? [])) {
    if (!agg[row.country_code]) {
      agg[row.country_code] = { country_name: row.country_name ?? row.country_code, plays: 0, views: 0 };
    }
    agg[row.country_code].plays += Number(row.plays);
    agg[row.country_code].views += Number(row.views);
  }

  return toDimensionRows(
    Object.entries(agg).map(([code, v]) => ({ label: v.country_name, code, plays: v.plays, views: v.views })),
    convMap,
  );
}

export async function getVSLByDevice(r: DateRange, videoId: string): Promise<DimensionRow[]> {
  const { data } = await supabase
    .from("vturb_by_device")
    .select("device_type, plays, views")
    .eq("video_id", videoId)
    .gte("date", r.from)
    .lte("date", r.to);

  const agg: Record<string, { plays: number; views: number }> = {};
  for (const row of (data ?? [])) {
    if (!agg[row.device_type]) agg[row.device_type] = { plays: 0, views: 0 };
    agg[row.device_type].plays += Number(row.plays);
    agg[row.device_type].views += Number(row.views);
  }

  return toDimensionRows(
    Object.entries(agg).map(([label, v]) => ({ label, plays: v.plays, views: v.views })),
  );
}

export async function getVSLByOS(r: DateRange, videoId: string): Promise<DimensionRow[]> {
  const { data } = await supabase
    .from("vturb_by_os")
    .select("os_name, plays, views")
    .eq("video_id", videoId)
    .gte("date", r.from)
    .lte("date", r.to);

  const agg: Record<string, { plays: number; views: number }> = {};
  for (const row of (data ?? [])) {
    if (!agg[row.os_name]) agg[row.os_name] = { plays: 0, views: 0 };
    agg[row.os_name].plays += Number(row.plays);
    agg[row.os_name].views += Number(row.views);
  }

  return toDimensionRows(
    Object.entries(agg).map(([label, v]) => ({ label, plays: v.plays, views: v.views })),
  );
}

export async function getVSLByBrowser(r: DateRange, videoId: string): Promise<DimensionRow[]> {
  const { data } = await supabase
    .from("vturb_by_browser")
    .select("browser_name, plays, views")
    .eq("video_id", videoId)
    .gte("date", r.from)
    .lte("date", r.to);

  const agg: Record<string, { plays: number; views: number }> = {};
  for (const row of (data ?? [])) {
    if (!agg[row.browser_name]) agg[row.browser_name] = { plays: 0, views: 0 };
    agg[row.browser_name].plays += Number(row.plays);
    agg[row.browser_name].views += Number(row.views);
  }

  return toDimensionRows(
    Object.entries(agg).map(([label, v]) => ({ label, plays: v.plays, views: v.views })),
  );
}

export async function getVSLBySource(r: DateRange, videoId: string): Promise<DimensionRow[]> {
  const [mappingRes, txRes] = await Promise.all([
    supabase
      .from("campaign_vsl_mapping")
      .select("campaign_name")
      .eq("video_id", videoId),
    supabase
      .from("transactions")
      .select("traffic_source")
      .gte("created_at", r.fromTs)
      .lte("created_at", r.toTs)
      .eq("status", "active"),
  ]);

  const mapped = new Set((mappingRes.data ?? []).map((m: any) => m.campaign_name as string));

  const convMap: Record<string, number> = {};
  for (const tx of (txRes.data ?? [])) {
    const src = (tx.traffic_source ?? "Sin UTM") as string;
    if (mapped.has(src)) convMap[src] = (convMap[src] ?? 0) + 1;
  }

  const totalConv = Object.values(convMap).reduce((s, n) => s + n, 0) || 1;

  return Object.entries(convMap)
    .map(([label, conversions]) => ({
      label,
      plays: 0,
      views: 0,
      pct:   Math.round((conversions / totalConv) * 1000) / 10,
      conversions,
    }))
    .sort((a, b) => b.conversions - a.conversions);
}
```

- [ ] **Step 2: Verificar tipos**

```bash
tsc -b --noEmit
```

Resultado esperado: sin errores de TypeScript.

- [ ] **Step 3: Commit**

```bash
git add src/services/analytics.ts
git commit -m "feat(analytics): DimensionRow + 5 funciones de dimensiones por VSL"
```

---

### Task 4: Tab UI en VSLIntelligencePanel + wiring en AnalyticsView

**Files:**
- Modify: `src/views/AnalyticsView.tsx`
- Modify: `src/components/analytics/VSLIntelligencePanel.tsx`

**Interfaces:**
- Consumes (de Task 3):
  ```typescript
  import type { DateRange, DimensionRow } from "../../services/analytics";
  import { getVSLByCountry, getVSLByDevice, getVSLByOS, getVSLByBrowser, getVSLBySource } from "../../services/analytics";
  ```
- Consumes (de hook existente): `range: DateRange | null` — ya en el state del hook, spreadeado en el return de `useAnalyticsData`

- [ ] **Step 1: Exponer range en AnalyticsView.tsx**

En `src/views/AnalyticsView.tsx`, agregar `range` a la destructuración del hook (línea ~40):

```typescript
  const {
    summary, funnel, vsls, ranking, heatmap, ltv, alerts, mappings,
    loading, error, period, setPeriod, refresh, aiResult, aiLoading, runAIAnalysis,
    selectedVslId, compareVslId, setSelectedVsl, setCompareVsl,
    range,   // ← agregar
  } = useAnalyticsData();
```

Luego en el JSX donde se renderiza `VSLIntelligencePanel` (línea ~162), agregar la prop `range`:

```typescript
          <VSLIntelligencePanel primary={selectedVsl} compare={compareVsl} range={range} />
```

- [ ] **Step 2: Reemplazar completamente VSLIntelligencePanel.tsx**

Reemplazar el contenido completo del archivo con:

```typescript
import { useState, useEffect, useCallback } from "react";
import {
  AreaChart, Area, XAxis, YAxis, Tooltip,
  ReferenceLine, ReferenceDot, ResponsiveContainer,
  BarChart, Bar, PieChart, Pie, Cell,
} from "recharts";
import { C, FONT } from "../../tokens";
import type { VSLData, DateRange, DimensionRow } from "../../services/analytics";
import {
  getVSLByCountry, getVSLByDevice, getVSLByOS,
  getVSLByBrowser, getVSLBySource,
} from "../../services/analytics";

// ── Tipos ─────────────────────────────────────────────────────────────────────

type DimensionTab = "general" | "country" | "device" | "os" | "browser" | "source";
type Level        = "high" | "mid" | "low";

// ── Helpers ───────────────────────────────────────────────────────────────────

function scoreLevel(value: number, hi: number, mid: number): Level {
  if (value >= hi)  return "high";
  if (value >= mid) return "mid";
  return "low";
}

const LEVEL_COLOR: Record<Level, string> = { high: "#22c55e", mid: C.yellow, low: C.red };
const LEVEL_LABEL: Record<Level, string> = { high: "Bueno", mid: "Regular", low: "Mejorar" };

function fmtSec(s: number) {
  const m   = Math.floor(Number(s) / 60);
  const sec = Number(s) % 60;
  return `${m}:${String(sec).padStart(2, "0")}`;
}

function flagEmoji(code: string): string {
  if (!code || code.length !== 2) return "🌐";
  return code.toUpperCase().split("").map(c =>
    String.fromCodePoint(c.charCodeAt(0) + 127397)
  ).join("");
}

function buildChartData(primary: VSLData, compare?: VSLData | null) {
  const maxSec = Math.max(
    primary.retention[primary.retention.length - 1]?.second ?? 0,
    compare ? (compare.retention[compare.retention.length - 1]?.second ?? 0) : 0,
  );
  if (maxSec === 0) return [];
  const step = maxSec > 600 ? 10 : 5;
  const data: Record<string, number | null>[] = [];
  for (let s = 0; s <= maxSec; s += step) {
    const pt: Record<string, number | null> = { s };
    pt["primary"] = primary.retention.find(p => p.second >= s)?.percentage ?? null;
    if (compare) pt["compare"] = compare.retention.find(p => p.second >= s)?.percentage ?? null;
    data.push(pt);
  }
  return data;
}

// ── Sub-componentes ───────────────────────────────────────────────────────────

function KpiCard({ label, value, color, sub }: { label: string; value: string; color?: string; sub?: string }) {
  return (
    <div style={{
      background: "rgba(255,255,255,0.04)", borderRadius: 10,
      padding: "12px 16px", flex: 1, minWidth: 100,
    }}>
      <div style={{ fontSize: 10, color: C.mutedMid, fontWeight: 600, textTransform: "uppercase", letterSpacing: "0.06em", marginBottom: 4 }}>{label}</div>
      <div style={{ fontSize: 18, fontWeight: 800, color: color ?? C.white }}>{value}</div>
      {sub && <div style={{ fontSize: 10, color: C.muted, marginTop: 2 }}>{sub}</div>}
    </div>
  );
}

function DimSkeleton() {
  return (
    <div style={{
      height: 240, background: "rgba(255,255,255,0.03)",
      borderRadius: 8, margin: "0 4px",
      animation: "pulse 1.5s ease-in-out infinite",
    }} />
  );
}

function DimEmpty() {
  return (
    <div style={{
      height: 240, display: "flex", alignItems: "center", justifyContent: "center",
      flexDirection: "column", gap: 6,
      background: "rgba(255,255,255,0.02)", borderRadius: 8, margin: "0 4px",
      border: `1px dashed ${C.border}`,
    }}>
      <div style={{ fontSize: 12, color: C.mutedMid }}>Sin datos para este período</div>
      <div style={{ fontSize: 11, color: C.muted }}>El sync de VTurb traerá datos la próxima hora</div>
    </div>
  );
}

// Vista: Países
function CountryView({ rows, showConversions }: { rows: DimensionRow[]; showConversions: boolean }) {
  if (rows.length === 0) return <DimEmpty />;
  return (
    <div style={{ padding: "8px 20px 12px", display: "flex", flexDirection: "column", gap: 6 }}>
      {rows.map(r => (
        <div key={r.label} style={{ display: "flex", alignItems: "center", gap: 10 }}>
          <span style={{ fontSize: 16, width: 22, flexShrink: 0 }}>{r.code ? flagEmoji(r.code) : "🌐"}</span>
          <div style={{ fontSize: 12, color: C.mutedLight, width: 110, flexShrink: 0, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{r.label}</div>
          <div style={{ flex: 1, height: 6, background: "rgba(255,255,255,0.08)", borderRadius: 3, overflow: "hidden" }}>
            <div style={{ height: "100%", width: `${r.pct}%`, background: C.orange, borderRadius: 3, transition: "width 0.4s ease" }} />
          </div>
          <div style={{ fontSize: 11, color: C.mutedMid, width: 38, textAlign: "right", flexShrink: 0 }}>{r.pct}%</div>
          {showConversions && (
            <div style={{ fontSize: 11, color: "#22c55e", width: 60, textAlign: "right", flexShrink: 0 }}>
              {r.conversions > 0 ? `${r.conversions} conv.` : ""}
            </div>
          )}
        </div>
      ))}
    </div>
  );
}

// Vista: Dispositivos (donut + cards)
const DEVICE_PALETTE = [C.orange, "#8b5cf6", C.yellow, C.mutedMid];

function DeviceView({ rows }: { rows: DimensionRow[] }) {
  if (rows.length === 0) return <DimEmpty />;
  const top3 = rows.slice(0, 3);
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 24, padding: "12px 20px 16px", flexWrap: "wrap" }}>
      <PieChart width={130} height={130}>
        <Pie data={rows} cx={60} cy={60} innerRadius={36} outerRadius={56} dataKey="pct" startAngle={90} endAngle={-270}>
          {rows.map((_, i) => <Cell key={i} fill={DEVICE_PALETTE[i] ?? C.muted} />)}
        </Pie>
      </PieChart>
      <div style={{ display: "flex", gap: 10, flex: 1, flexWrap: "wrap" }}>
        {top3.map((r, i) => (
          <div key={r.label} style={{ background: "rgba(255,255,255,0.04)", borderRadius: 10, padding: "12px 16px", flex: 1, minWidth: 90 }}>
            <div style={{ fontSize: 10, color: DEVICE_PALETTE[i], fontWeight: 600, textTransform: "uppercase", letterSpacing: "0.06em", marginBottom: 4 }}>{r.label}</div>
            <div style={{ fontSize: 20, fontWeight: 800, color: C.white }}>{r.pct}%</div>
            <div style={{ fontSize: 10, color: C.muted, marginTop: 2 }}>{r.plays.toLocaleString("es")} plays</div>
          </div>
        ))}
      </div>
    </div>
  );
}

// Vista genérica: BarChart horizontal (OS y Browser)
function HBarView({ rows, label }: { rows: DimensionRow[]; label: string }) {
  if (rows.length === 0) return <DimEmpty />;
  return (
    <div style={{ padding: "8px 4px 12px" }}>
      <ResponsiveContainer width="100%" height={Math.max(180, rows.length * 28)}>
        <BarChart data={rows} layout="vertical" margin={{ top: 4, right: 48, left: 8, bottom: 4 }}>
          <XAxis type="number" domain={[0, 100]} hide />
          <YAxis
            type="category" dataKey="label" width={110}
            tick={{ fontSize: 11, fill: C.mutedLight, fontFamily: FONT }}
            tickLine={false} axisLine={false}
          />
          <Tooltip
            contentStyle={{ background: "#1a1a2e", border: `1px solid ${C.border}`, borderRadius: 8, fontSize: 11, color: C.white }}
            formatter={(v: number) => [`${v}%`, label]}
            cursor={{ fill: "rgba(255,255,255,0.04)" }}
          />
          <Bar dataKey="pct" fill={C.orange} radius={[0, 3, 3, 0]}>
            {rows.map((r, i) => <Cell key={i} fill={i === 0 ? C.orange : `${C.orange}99`} />)}
          </Bar>
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}

// Vista: Fuente de tráfico (conversiones por campaña/UTM)
function SourceView({ rows }: { rows: DimensionRow[] }) {
  if (rows.length === 0) return (
    <div style={{
      height: 200, display: "flex", alignItems: "center", justifyContent: "center",
      flexDirection: "column", gap: 6,
      background: "rgba(255,255,255,0.02)", borderRadius: 8, margin: "0 4px",
      border: `1px dashed ${C.border}`,
    }}>
      <div style={{ fontSize: 12, color: C.mutedMid }}>Sin ventas atribuidas a este VSL en el período</div>
      <div style={{ fontSize: 11, color: C.muted }}>Configura el mapeo campaña→VSL para ver fuentes</div>
    </div>
  );
  return (
    <div style={{ padding: "8px 20px 12px", display: "flex", flexDirection: "column", gap: 6 }}>
      {rows.map(r => (
        <div key={r.label} style={{ display: "flex", alignItems: "center", gap: 10 }}>
          <div style={{ fontSize: 12, color: C.mutedLight, width: 150, flexShrink: 0, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{r.label}</div>
          <div style={{ flex: 1, height: 6, background: "rgba(255,255,255,0.08)", borderRadius: 3, overflow: "hidden" }}>
            <div style={{ height: "100%", width: `${r.pct}%`, background: "#22c55e", borderRadius: 3, transition: "width 0.4s ease" }} />
          </div>
          <div style={{ fontSize: 11, color: "#22c55e", width: 60, textAlign: "right", flexShrink: 0 }}>{r.conversions} ventas</div>
        </div>
      ))}
    </div>
  );
}

// ── Configuración de tabs ─────────────────────────────────────────────────────

const TABS: { key: DimensionTab; label: string }[] = [
  { key: "general",  label: "Retención general" },
  { key: "country",  label: "Países"            },
  { key: "device",   label: "Dispositivos"      },
  { key: "os",       label: "S. Operativo"      },
  { key: "browser",  label: "Navegadores"       },
  { key: "source",   label: "Fuente de tráfico" },
];

// ── Props ─────────────────────────────────────────────────────────────────────

interface Props {
  primary:  VSLData | null;
  compare?: VSLData | null;
  range:    DateRange | null;
}

// ── Componente principal ──────────────────────────────────────────────────────

export function VSLIntelligencePanel({ primary, compare, range }: Props) {
  const [activeTab,       setActiveTabState] = useState<DimensionTab>("general");
  const [dimCache,        setDimCache]       = useState<Partial<Record<DimensionTab, DimensionRow[]>>>({});
  const [dimLoading,      setDimLoading]     = useState(false);
  const [showConversions, setShowConversions] = useState(false);

  // Invalida caché cuando cambia el rango o el video seleccionado
  useEffect(() => {
    setDimCache({});
    setActiveTabState("general");
  }, [range?.from, range?.to, primary?.videoId]);

  const fetchTab = useCallback(async (tab: DimensionTab) => {
    if (!primary || !range || tab === "general" || dimCache[tab]) return;
    setDimLoading(true);
    try {
      const fetchers: Record<Exclude<DimensionTab, "general">, () => Promise<DimensionRow[]>> = {
        country: () => getVSLByCountry(range, primary.videoId),
        device:  () => getVSLByDevice(range, primary.videoId),
        os:      () => getVSLByOS(range, primary.videoId),
        browser: () => getVSLByBrowser(range, primary.videoId),
        source:  () => getVSLBySource(range, primary.videoId),
      };
      const data = await fetchers[tab as Exclude<DimensionTab, "general">]();
      setDimCache(prev => ({ ...prev, [tab]: data }));
    } catch (e) {
      console.error(`fetchTab ${tab}:`, e);
      setDimCache(prev => ({ ...prev, [tab]: [] }));
    } finally {
      setDimLoading(false);
    }
  }, [primary, range, dimCache]);

  const handleTabClick = (tab: DimensionTab) => {
    setActiveTabState(tab);
    fetchTab(tab);
  };

  // ── Sin video seleccionado ──────────────────────────────────────────────────
  if (!primary) return (
    <div style={{
      background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 32,
      display: "flex", alignItems: "center", justifyContent: "center",
      flexDirection: "column", gap: 8, minHeight: 120,
    }}>
      <div style={{ fontSize: 13, color: C.mutedMid }}>Sin datos de retención para este período</div>
      <div style={{ fontSize: 11, color: C.muted }}>Selecciona un VSL o espera a que lleguen datos de VTurb</div>
    </div>
  );

  const hasRetention = primary.retention.length > 2;
  const chartData    = buildChartData(primary, compare);
  const ctaRate      = primary.plays > 0 ? (primary.ctaClicks / primary.plays) * 100 : 0;
  const hookLevel    = scoreLevel(primary.ret25, 60, 40);
  const retLevel     = scoreLevel(primary.ret50, 40, 25);
  const ctaLevel     = scoreLevel(ctaRate, 8, 4);
  const dropPt       = primary.dropSecond != null
    ? primary.retention.find(p => p.second >= primary.dropSecond!)
    : null;
  const videoDuration = primary.retention.length > 0
    ? primary.retention[primary.retention.length - 1].second
    : null;

  // ── Render ──────────────────────────────────────────────────────────────────
  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, overflow: "hidden" }}>

      {/* Header: nombre + badges */}
      <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: "16px 20px 0", flexWrap: "wrap", gap: 10 }}>
        <div>
          <div style={{ fontSize: 15, fontWeight: 700, color: C.white }}>{primary.videoName}</div>
          {videoDuration && (
            <div style={{ fontSize: 11, color: C.mutedMid, marginTop: 2 }}>
              Duración: {fmtSec(videoDuration)} · {primary.plays.toLocaleString("es")} plays
            </div>
          )}
        </div>
        <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
          {([
            { label: "Hook",      level: hookLevel },
            { label: "Retención", level: retLevel  },
            { label: "CTA",       level: ctaLevel  },
          ] as { label: string; level: Level }[]).map(({ label, level }) => (
            <div key={label} style={{
              padding: "4px 12px", borderRadius: 20, fontSize: 11, fontWeight: 600,
              background: `${LEVEL_COLOR[level]}18`, border: `1px solid ${LEVEL_COLOR[level]}40`,
              color: LEVEL_COLOR[level],
            }}>
              {label}: {LEVEL_LABEL[level]}
            </div>
          ))}
        </div>
      </div>

      {/* Tab bar */}
      <div style={{
        display: "flex", alignItems: "center", justifyContent: "space-between",
        padding: "12px 20px 0", gap: 8, flexWrap: "wrap",
      }}>
        <div style={{ display: "flex", gap: 4, flexWrap: "wrap" }}>
          {TABS.map(t => (
            <button
              key={t.key}
              onClick={() => handleTabClick(t.key)}
              style={{
                background:    activeTab === t.key ? C.orange : "transparent",
                border:        `1px solid ${activeTab === t.key ? C.orange : C.border}`,
                borderRadius:  20,
                padding:       "4px 12px",
                fontSize:      11,
                fontWeight:    activeTab === t.key ? 600 : 400,
                color:         activeTab === t.key ? C.white : C.mutedLight,
                cursor:        "pointer",
                fontFamily:    FONT,
                transition:    "all 0.15s ease",
              }}
            >
              {t.label}
            </button>
          ))}
        </div>

        {/* Toggle Conversiones */}
        <label style={{ display: "flex", alignItems: "center", gap: 8, cursor: "pointer", userSelect: "none" }}>
          <div
            onClick={() => setShowConversions(v => !v)}
            style={{
              width: 32, height: 18, borderRadius: 9,
              background: showConversions ? C.orange : "rgba(255,255,255,0.12)",
              position: "relative", transition: "background 0.2s ease", cursor: "pointer",
            }}
          >
            <div style={{
              position: "absolute", top: 2,
              left: showConversions ? 16 : 2,
              width: 14, height: 14, borderRadius: "50%",
              background: C.white, transition: "left 0.2s ease",
            }} />
          </div>
          <span style={{ fontSize: 11, color: C.mutedLight }}>Conversiones</span>
        </label>
      </div>

      {/* Contenido del tab activo */}
      <div style={{ padding: "12px 4px 0" }}>
        {activeTab === "general" && (
          <>
            {!hasRetention ? (
              <div style={{
                height: 240, display: "flex", alignItems: "center", justifyContent: "center",
                flexDirection: "column", gap: 6, margin: "0 16px",
                background: "rgba(255,255,255,0.02)", borderRadius: 8, border: `1px dashed ${C.border}`,
              }}>
                <div style={{ fontSize: 12, color: C.mutedMid }}>Sin suficientes datos de retención</div>
                <div style={{ fontSize: 11, color: C.muted }}>El sync de VTurb necesita más historial</div>
              </div>
            ) : (
              <ResponsiveContainer width="100%" height={240}>
                <AreaChart data={chartData} margin={{ top: 8, right: 20, left: 0, bottom: 0 }}>
                  <defs>
                    <linearGradient id="gradPrimary" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%"  stopColor={C.orange} stopOpacity={0.4} />
                      <stop offset="95%" stopColor={C.orange} stopOpacity={0.03} />
                    </linearGradient>
                    <linearGradient id="gradCompare" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%"  stopColor={C.yellow} stopOpacity={0.25} />
                      <stop offset="95%" stopColor={C.yellow} stopOpacity={0.02} />
                    </linearGradient>
                  </defs>
                  <XAxis
                    dataKey="s"
                    tick={{ fontSize: 10, fill: C.mutedMid, fontFamily: FONT }}
                    tickFormatter={fmtSec} tickLine={false}
                    axisLine={{ stroke: C.border }} interval="preserveStartEnd"
                  />
                  <YAxis
                    domain={[0, 100]}
                    tick={{ fontSize: 10, fill: C.mutedMid, fontFamily: FONT }}
                    tickFormatter={v => `${v}%`} tickLine={false} axisLine={false} width={36}
                  />
                  <Tooltip
                    contentStyle={{ background: "#1a1a2e", border: `1px solid ${C.border}`, borderRadius: 8, fontSize: 11, color: C.white }}
                    labelFormatter={s => `⏱ ${fmtSec(Number(s))}`}
                    formatter={(v: number, name: string) => [
                      `${Number(v).toFixed(1)}%`,
                      name === "primary" ? primary.videoName : (compare?.videoName ?? ""),
                    ]}
                  />
                  <ReferenceLine y={50} stroke={C.border} strokeDasharray="4 4" />
                  {dropPt && (
                    <ReferenceDot
                      x={primary.dropSecond!} y={dropPt.percentage}
                      r={6} fill={C.red} stroke="#fff" strokeWidth={1.5}
                      label={{ value: "Drop", position: "top", fontSize: 9, fill: C.red }}
                    />
                  )}
                  <Area type="monotone" dataKey="primary" name="primary"
                    stroke={C.orange} strokeWidth={2.5} fill="url(#gradPrimary)" connectNulls dot={false}
                  />
                  {compare && (
                    <Area type="monotone" dataKey="compare" name="compare"
                      stroke={C.yellow} strokeWidth={2} fill="url(#gradCompare)"
                      connectNulls dot={false} strokeDasharray="6 3"
                    />
                  )}
                </AreaChart>
              </ResponsiveContainer>
            )}

            {hasRetention && compare && (
              <div style={{ display: "flex", gap: 16, padding: "4px 20px 0" }}>
                <span style={{ display: "flex", alignItems: "center", gap: 6, fontSize: 11, color: C.mutedLight }}>
                  <span style={{ width: 18, height: 2.5, background: C.orange, display: "inline-block", borderRadius: 2 }} />
                  {primary.videoName}
                </span>
                <span style={{ display: "flex", alignItems: "center", gap: 6, fontSize: 11, color: C.mutedLight }}>
                  <span style={{ width: 18, height: 0, borderTop: `2px dashed ${C.yellow}`, display: "inline-block" }} />
                  {compare.videoName}
                </span>
              </div>
            )}
          </>
        )}

        {activeTab !== "general" && dimLoading && <DimSkeleton />}

        {activeTab === "country"  && !dimLoading && <CountryView rows={dimCache.country  ?? []} showConversions={showConversions} />}
        {activeTab === "device"   && !dimLoading && <DeviceView  rows={dimCache.device   ?? []} />}
        {activeTab === "os"       && !dimLoading && <HBarView    rows={dimCache.os       ?? []} label="S. Operativo" />}
        {activeTab === "browser"  && !dimLoading && <HBarView    rows={dimCache.browser  ?? []} label="Navegadores"  />}
        {activeTab === "source"   && !dimLoading && <SourceView  rows={dimCache.source   ?? []} />}
      </div>

      {/* KPIs — siempre visibles independiente del tab */}
      <div style={{ display: "flex", gap: 10, padding: "16px 20px 20px", flexWrap: "wrap" }}>
        <KpiCard label="Plays" value={primary.plays.toLocaleString("es")} />
        <KpiCard label="Hook (25%)"      value={`${primary.ret25.toFixed(0)}%`} color={LEVEL_COLOR[hookLevel]} sub="Retención al cuarto" />
        <KpiCard label="Ret. media (50%)" value={`${primary.ret50.toFixed(0)}%`} color={LEVEL_COLOR[retLevel]}  sub="Mitad del video" />
        <KpiCard label="Cierre (75%)"    value={`${primary.ret75.toFixed(0)}%`}
          color={primary.ret75 >= 20 ? "#22c55e" : primary.ret75 >= 10 ? C.yellow : C.red}
          sub="Tres cuartos" />
        <KpiCard label="CTA Click Rate"  value={`${ctaRate.toFixed(1)}%`} color={LEVEL_COLOR[ctaLevel]} sub={`${primary.ctaClicks.toLocaleString("es")} clicks`} />
        <KpiCard label="Conv. Rate"      value={`${primary.convRate.toFixed(1)}%`}
          color={primary.convRate >= 3 ? "#22c55e" : primary.convRate >= 1 ? C.yellow : C.red}
          sub={`${primary.sales} ventas`} />
        {primary.dropSecond != null && (
          <KpiCard label="Drop crítico" value={fmtSec(primary.dropSecond)} color={C.red} sub="Revisar guión aquí" />
        )}
      </div>
    </div>
  );
}
```

- [ ] **Step 3: Verificar tipos**

```bash
tsc -b --noEmit
```

Resultado esperado: sin errores. Si hay error en `C.yellow` / `C.red` / `C.mutedMid` — verificar que esos tokens existen en `src/tokens.ts` (o el archivo equivalente); si el nombre es distinto, ajustarlo para que coincida con los ya usados en el archivo original.

- [ ] **Step 4: Build completo**

```bash
tsc -b && vite build
```

Resultado esperado: build exitoso sin warnings de TypeScript.

- [ ] **Step 5: Verificación visual**

Levantar el dev server (`npm run dev` o `vite`), ir a la vista Analytics, seleccionar un VSL y verificar:
- Los 6 tabs aparecen encima del gráfico
- "Retención general" muestra la curva existente sin cambios
- Click en "Países" → loading skeleton → datos (o mensaje de vacío si aún no hay sync)
- Click en "Dispositivos" → donut + cards
- Click en "S. Operativo" / "Navegadores" → bar chart horizontal
- Click en "Fuente de tráfico" → lista de fuentes con barras verdes
- Toggle "Conversiones" aparece/desaparece la columna de conversiones en Países
- Cambiar el período (Hoy/Ayer/7días) → los tabs vuelven a "Retención general" y la caché se limpia

- [ ] **Step 6: Commit**

```bash
git add src/views/AnalyticsView.tsx src/components/analytics/VSLIntelligencePanel.tsx
git commit -m "feat(ui): tab bar de dimensiones en VSLIntelligencePanel (países, dispositivos, OS, navegadores, fuente)"
```

---

## Self-Review

**Spec coverage:**
- ✅ 4 tablas nuevas con unique constraints + índices + RLS (Task 1)
- ✅ syncDimensions extiende vturb-sync sin tocar syncAnalytics/syncRetention (Task 2)
- ✅ Cron sin cambios — usa el mismo ciclo horario (Task 2)
- ✅ `DimensionRow` + 5 funciones en analytics.ts (Task 3)
- ✅ getVSLByCountry cruza con buyer_country de transactions (Task 3)
- ✅ Top 8 + agrupación "Otros" (Task 3)
- ✅ Lazy load con caché por tab (Task 4)
- ✅ Caché se invalida al cambiar período o video (Task 4)
- ✅ Tab bar con 6 tabs + toggle Conversiones a la derecha (Task 4)
- ✅ Skeleton del mismo alto que el chart (Task 4)
- ✅ Sin datos → mensaje inline, no error (Task 4)
- ✅ KPIs siempre visibles independiente del tab activo (Task 4)
- ✅ fallo en dimensión VTurb no bloquea las otras (Task 2 — Promise.allSettled)
- ✅ Los endpoints de VTurb para dimensiones siguen el mismo patrón de body que los existentes
