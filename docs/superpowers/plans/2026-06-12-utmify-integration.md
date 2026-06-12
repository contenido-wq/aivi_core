# UTMify Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Agregar sync automático horario de inversión publicitaria desde UTMify y modo debug para verificar el mapeo de campos tras el primer deploy.

**Architecture:** Refactor de `utmify-sync/index.ts` para extraer la lógica a `runSync(debug)`, compartida por `Deno.cron` (ejecución automática cada hora) y `serve()` (trigger manual + `?debug=true`). Se agrega la migration faltante para la tabla `investment_data` que la función ya intenta escribir.

**Tech Stack:** Deno (Supabase Edge Functions), Supabase JS v2, SQL (PostgreSQL), Supabase CLI 2.x

---

## Archivos

| Acción | Archivo |
|--------|---------|
| Crear | `supabase/migrations/20260612000001_investment_data.sql` |
| Modificar | `supabase/functions/utmify-sync/index.ts` |

---

### Task 1: Migration — tabla `investment_data`

**Archivos:**
- Crear: `supabase/migrations/20260612000001_investment_data.sql`

**Contexto:** La edge function `utmify-sync` hace upsert en `investment_data` pero la tabla no tiene migration. Sin ella el deploy falla en producción silenciosamente (la función existe pero los writes fallan).

- [ ] **Step 1: Crear el archivo de migration**

Crear `supabase/migrations/20260612000001_investment_data.sql` con este contenido exacto:

```sql
-- Tabla de inversión publicitaria por plataforma y día.
-- La edge function utmify-sync escribe aquí cada vez que corre.
CREATE TABLE IF NOT EXISTS investment_data (
  id          uuid        DEFAULT gen_random_uuid() PRIMARY KEY,
  date        date        NOT NULL,
  platform    text        NOT NULL,  -- 'facebook' | 'google' | 'tiktok' | 'other'
  investment  numeric     DEFAULT 0,
  impressions numeric     DEFAULT 0,
  clicks      numeric     DEFAULT 0,
  raw_data    jsonb,
  synced_at   timestamptz,
  UNIQUE (date, platform)
);

ALTER TABLE investment_data ENABLE ROW LEVEL SECURITY;

-- Solo el service role (edge function) puede leer/escribir.
-- El frontend no necesita acceso directo a esta tabla.
CREATE POLICY "service role only"
  ON investment_data
  USING (false);
```

- [ ] **Step 2: Verificar que el archivo existe y tiene el contenido correcto**

```bash
cat supabase/migrations/20260612000001_investment_data.sql
```

Esperado: el SQL completo con `CREATE TABLE`, `ENABLE ROW LEVEL SECURITY` y `CREATE POLICY`.

- [ ] **Step 3: Commit**

```bash
git add supabase/migrations/20260612000001_investment_data.sql
git commit -m "feat: add investment_data table migration"
```

---

### Task 2: Refactor `utmify-sync` — `runSync()` + `Deno.cron` + `?debug=true`

**Archivos:**
- Modificar: `supabase/functions/utmify-sync/index.ts`

**Contexto:** El archivo actual tiene toda la lógica dentro de `serve(async (_req) => {...})`. El objetivo es extraerla a `runSync(debug: boolean)` para que `Deno.cron` y `serve()` compartan el mismo código. `?debug=true` incluye el JSON crudo de UTMify en la respuesta para verificar el mapeo de campos.

- [ ] **Step 1: Reemplazar el contenido completo del archivo**

Reemplazar `supabase/functions/utmify-sync/index.ts` con:

```typescript
// @ts-nocheck
import { serve }        from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

declare const Deno: {
  env:  { get(key: string): string | undefined };
  cron: (name: string, schedule: string, handler: () => Promise<void>) => void;
};

const UTMIFY_BASE = "https://api.utmify.com.br";

function toColombiaDate(d: Date): string {
  const local = new Date(d.getTime() - 5 * 60 * 60 * 1000);
  return local.toISOString().split("T")[0];
}

function normalizePlatform(source: string): string {
  const s = source.toLowerCase();
  if (s.includes("facebook") || s.includes("meta") || s.includes("fb")) return "facebook";
  if (s.includes("google") || s.includes("gads"))                        return "google";
  if (s.includes("tiktok") || s.includes("tt"))                          return "tiktok";
  return "other";
}

async function runSync(debug: boolean): Promise<Response> {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const apiKey = Deno.env.get("UTMIFY_API_KEY")!;
  const today  = toColombiaDate(new Date());

  try {
    const res = await fetch(`${UTMIFY_BASE}/api/v1/campaigns?date=${today}`, {
      headers: { "x-api-key": apiKey, "Content-Type": "application/json" },
    });

    if (!res.ok) {
      const err = await res.text();
      console.error("UTMify API error:", res.status, err);
      return new Response(JSON.stringify({ ok: false, error: err }), {
        status: 502,
        headers: { "Content-Type": "application/json" },
      });
    }

    const data = await res.json();
    const platformMap: Record<string, { investment: number; impressions: number; clicks: number }> = {};

    for (const campaign of (data.campaigns ?? data.data ?? [])) {
      const platform    = normalizePlatform(campaign.source ?? campaign.platform ?? "other");
      const investment  = Number(campaign.spend ?? campaign.cost ?? campaign.investment ?? 0);
      const impressions = Number(campaign.impressions ?? 0);
      const clicks      = Number(campaign.clicks ?? 0);

      if (!platformMap[platform]) platformMap[platform] = { investment: 0, impressions: 0, clicks: 0 };
      platformMap[platform].investment  += investment;
      platformMap[platform].impressions += impressions;
      platformMap[platform].clicks      += clicks;
    }

    for (const [platform, metrics] of Object.entries(platformMap)) {
      await supabase.from("investment_data").upsert({
        date:        today,
        platform,
        investment:  metrics.investment,
        impressions: metrics.impressions,
        clicks:      metrics.clicks,
        raw_data:    debug ? data : null,
        synced_at:   new Date().toISOString(),
      }, { onConflict: "date,platform" });
    }

    const totalInvestment = Object.values(platformMap).reduce((s, m) => s + m.investment, 0);

    await supabase.from("daily_metrics").upsert({
      date:       today,
      investment: totalInvestment,
      updated_at: new Date().toISOString(),
    }, { onConflict: "date" });

    console.log(`✅ UTMify sync OK — ${today} — $${totalInvestment.toFixed(2)}`);

    const result: Record<string, unknown> = { ok: true, totalInvestment, platforms: platformMap };
    if (debug) result.rawUtmify = data;

    return new Response(JSON.stringify(result), {
      headers: { "Content-Type": "application/json" },
    });

  } catch (e) {
    console.error("UTMify sync failed:", e);
    return new Response(JSON.stringify({ ok: false, error: String(e) }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
}

// Sync automático — cada hora en el minuto 0
Deno.cron("utmify-hourly", "0 * * * *", async () => { await runSync(false); });

// Trigger manual (botón TopNav) o ?debug=true para inspeccionar respuesta de UTMify
serve(async (req) => {
  const debug = new URL(req.url).searchParams.has("debug");
  return runSync(debug);
});
```

- [ ] **Step 2: Verificar que el archivo tiene la estructura correcta**

```bash
grep -n "runSync\|Deno.cron\|serve\|debug" supabase/functions/utmify-sync/index.ts
```

Esperado (líneas aproximadas):
```
38:async function runSync(debug: boolean): Promise<Response> {
87:// Sync automático — cada hora en el minuto 0
88:Deno.cron("utmify-hourly", "0 * * * *", async () => { await runSync(false); });
91:serve(async (req) => {
92:  const debug = new URL(req.url).searchParams.has("debug");
93:  return runSync(debug);
```

- [ ] **Step 3: Commit**

```bash
git add supabase/functions/utmify-sync/index.ts
git commit -m "feat: add Deno.cron hourly sync and ?debug=true mode to utmify-sync"
```

---

### Task 3: Deploy y verificación

**Contexto:** Con los cambios anteriores commiteados, hacer el deploy a Supabase y verificar que el sync funciona y que el mapeo de campos de UTMify es correcto. El flag `--no-verify-jwt` es requerido para que Supabase ejecute el cron (las invocaciones programadas no tienen JWT).

- [ ] **Step 1: Aplicar la migration**

```bash
supabase db push --project-ref jihyeeimmhfqlpzljrbu
```

Esperado: output mostrando `20260612000001_investment_data` aplicada sin errores.

- [ ] **Step 2: Verificar que `UTMIFY_API_KEY` está seteada en Supabase Secrets**

```bash
supabase secrets list --project-ref jihyeeimmhfqlpzljrbu
```

Esperado: la lista incluye `UTMIFY_API_KEY`. Si no aparece, setearla:

```bash
supabase secrets set UTMIFY_API_KEY=<tu-api-key> --project-ref jihyeeimmhfqlpzljrbu
```

- [ ] **Step 3: Deploy de la edge function**

```bash
supabase functions deploy utmify-sync --project-ref jihyeeimmhfqlpzljrbu --no-verify-jwt
```

Esperado:
```
Deploying Function utmify-sync ...
Done.
```

- [ ] **Step 4: Llamar al endpoint con `?debug=true` y verificar la respuesta**

```bash
curl -s "https://jihyeeimmhfqlpzljrbu.supabase.co/functions/v1/utmify-sync?debug=true" \
  -H "Authorization: Bearer <SUPABASE_ANON_KEY>" | jq .
```

Esperado: JSON con `"ok": true` y `"rawUtmify"` mostrando la estructura real de la respuesta de UTMify. Buscar si las campañas tienen campos `spend`, `cost`, o `investment`.

Si `ok: false` con error 502: el endpoint o la API key de UTMify son incorrectos. Revisar `rawUtmify.error` para el mensaje exacto.

- [ ] **Step 5: Verificar datos en `daily_metrics`**

En el SQL Editor de Supabase:

```sql
SELECT date, investment, updated_at
FROM daily_metrics
WHERE date = CURRENT_DATE
ORDER BY updated_at DESC
LIMIT 1;
```

Esperado: un registro con `investment > 0` si UTMify tiene datos de hoy.

- [ ] **Step 6: Verificar ROAS en el dashboard**

Abrir el dashboard en el navegador. El valor de ROAS debe ser distinto de 0 si hay inversión histórica registrada.
