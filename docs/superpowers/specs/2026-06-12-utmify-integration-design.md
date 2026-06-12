# UTMify Integration — Sync automático + verificación ROAS

**Fecha:** 2026-06-12  
**Estado:** Aprobado

## Objetivo

1. Hacer funcionar el sync de inversión publicitaria desde UTMify para que el ROAS se muestre correctamente en el dashboard.
2. Automatizar el sync cada hora sin intervención manual (además del botón que ya existe).

## Alcance

- Refactor de `supabase/functions/utmify-sync/index.ts` con `Deno.cron` y modo debug.
- Nueva migration para la tabla `investment_data` (no existe en la base de datos).
- Sin cambios en el frontend — el botón y el dashboard ya están conectados correctamente.

## Arquitectura

```
UTMify API (/api/v1/campaigns?date=YYYY-MM-DD)
   │
   ├──► investment_data  (por plataforma: facebook, google, tiktok, other)
   │         unique(date, platform)
   │
   └──► daily_metrics.investment  (total del día — upsert por date)
              │
              ├──► getKPIs()          → ROAS = grossRevenue / Σ investment histórico
              ├──► getDailyChartData() → gráfica Ingresos vs Inversión
              └──► getComparisonData() → inversión ayer / semana
```

Cada hora el sync sobreescribe el `investment` de hoy en `daily_metrics`. UTMify acumula el gasto del día internamente, así que cada ejecución trae el valor más actualizado del día.

## Cambios

### 1. `supabase/functions/utmify-sync/index.ts`

Refactor que extrae toda la lógica a `runSync(debug: boolean)`. Tanto el cron como el endpoint HTTP llaman a la misma función.

```
serve(req) ──► runSync(debug=req.searchParams.has("debug"))
Deno.cron   ──► runSync(false)
```

**`Deno.cron`:** `"0 * * * *"` — cada hora en el minuto 0, 24/7.

**`?debug=true`:** El endpoint devuelve el JSON crudo de UTMify junto con el resultado del sync. Sirve para verificar que los campos (`spend/cost/investment`) estén correctamente mapeados en el primer deploy.

**Deploy:** Requiere el flag `--no-verify-jwt` para que Supabase permita la ejecución del cron.

### 2. `supabase/migrations/20260612000001_investment_data.sql`

```sql
CREATE TABLE IF NOT EXISTS investment_data (
  id          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  date        date        NOT NULL,
  platform    text        NOT NULL,
  investment  numeric     DEFAULT 0,
  impressions numeric     DEFAULT 0,
  clicks      numeric     DEFAULT 0,
  raw_data    jsonb,
  synced_at   timestamptz,
  UNIQUE (date, platform)
);

ALTER TABLE investment_data ENABLE ROW LEVEL SECURITY;
CREATE POLICY "service role only" ON investment_data USING (false);
```

RLS habilitado con política restrictiva — solo el service role (edge function) puede escribir/leer.

## Comportamiento del ROAS

- `getKPIs()` en `dashboard.ts` suma `investment` de **todos los registros** de `daily_metrics` sin filtro de fecha. Esto da el ROAS total histórico. Comportamiento correcto, no se modifica.
- Cuando el filtro de producto no es "todos", `investment` devuelve `0`. Comportamiento existente, fuera de alcance.

## Verificación post-deploy

1. Llamar `GET /functions/v1/utmify-sync?debug=true` con el Bearer token.
2. Confirmar que el JSON de UTMify contiene campos de spend/inversión.
3. Verificar que `daily_metrics` tiene un registro para hoy con `investment > 0`.
4. Verificar que el ROAS en el dashboard muestra un valor distinto de 0.

## Fuera de alcance

- Atribución de órdenes (qué campaña generó cada venta).
- Cambios en el frontend (botón, dashboard, gráficas).
- Ajuste del ROAS por rango de fechas o por producto.
