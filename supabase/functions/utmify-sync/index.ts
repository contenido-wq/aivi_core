// @ts-nocheck
import { serve }        from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

declare const Deno: {
  env:  { get(key: string): string | undefined };
  cron: (name: string, schedule: string, handler: () => Promise<void>) => void;
};

const MCP_BASE = "https://mcp.utmify.com.br/mcp";
const MCP_RESOURCES = "gm,gg,gt,gu,gwe,ga,gp,gwa,gr,gpc,gcs";

// Cuenta de Meta Ads activa: "Status LAB LLC - (1) -"
const META_ACCOUNT_ID = "2058545347973455";

function toColombiaDate(d: Date): string {
  const local = new Date(d.getTime() - 5 * 60 * 60 * 1000);
  return local.toISOString().split("T")[0];
}

function addDays(dateStr: string, days: number): string {
  const d = new Date(`${dateStr}T12:00:00Z`);
  d.setDate(d.getDate() + days);
  return d.toISOString().split("T")[0];
}

// Llama a una tool del servidor MCP de UTMify vía JSON-RPC 2.0
async function callMcp(
  mcpToken: string,
  toolName: string,
  args: Record<string, unknown>,
): Promise<unknown> {
  const url = `${MCP_BASE}/?token=${mcpToken}&resources=${MCP_RESOURCES}`;
  const res = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Accept":       "application/json, text/event-stream",
    },
    body: JSON.stringify({
      jsonrpc: "2.0",
      method:  "tools/call",
      params:  { name: toolName, arguments: args },
      id:      1,
    }),
  });

  if (!res.ok) {
    throw new Error(`MCP HTTP ${res.status}: ${await res.text()}`);
  }

  const json = await res.json();
  if (json.error) throw new Error(`MCP error ${json.error.code}: ${json.error.message}`);
  return JSON.parse(json.result.content[0].text);
}

// Sincroniza un día pasado (completado) — Meta devuelve gasto diario exacto
async function syncDate(
  supabase: ReturnType<typeof createClient>,
  mcpToken: string,
  dashboardId: string,
  dateStr: string,
): Promise<{ date: string; totalInvestment: number; impressions: number; clicks: number }> {
  const data = await callMcp(mcpToken, "get_meta_ad_objects", {
    dashboardId,
    level:     "account",
    dateRange: { from: dateStr, to: dateStr },
  }) as { results: Array<{ spend: number; impressions: number; inlineLinkClicks: number }> };

  const results     = (data.results ?? []).filter((r: any) => r.accountId === META_ACCOUNT_ID);
  const totalSpend  = results.reduce((s, r) => s + (r.spend           ?? 0), 0) / 100;
  const totalImpres = results.reduce((s, r) => s + (r.impressions      ?? 0), 0);
  const totalClicks = results.reduce((s, r) => s + (r.inlineLinkClicks ?? 0), 0);

  const { error: invErr } = await supabase.from("investment_data").upsert({
    date:        dateStr,
    platform:    "facebook",
    investment:  totalSpend,
    impressions: totalImpres,
    clicks:      totalClicks,
    synced_at:   new Date().toISOString(),
  }, { onConflict: "date,platform" });
  if (invErr) throw new Error(`investment_data upsert (${dateStr}): ${invErr.message}`);

  console.log(`✅ UTMify sync OK — ${dateStr} — $${totalSpend.toFixed(2)}`);
  return { date: dateStr, totalInvestment: totalSpend, impressions: totalImpres, clicks: totalClicks };
}

// Sincroniza el día actual usando método delta:
// Meta devuelve acumulado del mes (MTD) para el día incompleto,
// así que restamos la suma de días ya guardados para aislar el gasto real de hoy.
async function syncToday(
  supabase: ReturnType<typeof createClient>,
  mcpToken: string,
  dashboardId: string,
  todayStr: string,
): Promise<{ date: string; totalInvestment: number; impressions: number; clicks: number }> {
  const monthStart = todayStr.slice(0, 8) + "01";

  // Consultar acumulado del mes hasta hoy
  const mtdData = await callMcp(mcpToken, "get_meta_ad_objects", {
    dashboardId,
    level:     "account",
    dateRange: { from: monthStart, to: todayStr },
  }) as { results: Array<{ spend: number; impressions: number; inlineLinkClicks: number }> };

  const mtdResults     = (mtdData.results ?? []).filter((r: any) => r.accountId === META_ACCOUNT_ID);
  const mtdSpend       = mtdResults.reduce((s, r) => s + (r.spend           ?? 0), 0) / 100;
  const mtdImpressions = mtdResults.reduce((s, r) => s + (r.impressions      ?? 0), 0);
  const mtdClicks      = mtdResults.reduce((s, r) => s + (r.inlineLinkClicks ?? 0), 0);

  // Sumar días ya guardados en este mes (excluyendo hoy)
  const { data: storedRows, error: fetchErr } = await supabase
    .from("investment_data")
    .select("investment, impressions, clicks")
    .eq("platform", "facebook")
    .gte("date", monthStart)
    .lt("date", todayStr);
  if (fetchErr) throw new Error(`investment_data fetch: ${fetchErr.message}`);

  const storedSpend       = (storedRows ?? []).reduce((s: number, r: any) => s + Number(r.investment  ?? 0), 0);
  const storedImpressions = (storedRows ?? []).reduce((s: number, r: any) => s + Number(r.impressions ?? 0), 0);
  const storedClicks      = (storedRows ?? []).reduce((s: number, r: any) => s + Number(r.clicks      ?? 0), 0);

  // Delta = MTD − días previos ya guardados = gasto real de hoy
  const dailySpend       = Math.max(0, mtdSpend       - storedSpend);
  const dailyImpressions = Math.max(0, mtdImpressions - storedImpressions);
  const dailyClicks      = Math.max(0, mtdClicks      - storedClicks);

  const { error: upsertErr } = await supabase.from("investment_data").upsert({
    date:        todayStr,
    platform:    "facebook",
    investment:  dailySpend,
    impressions: dailyImpressions,
    clicks:      dailyClicks,
    synced_at:   new Date().toISOString(),
  }, { onConflict: "date,platform" });
  if (upsertErr) throw new Error(`investment_data upsert today (${todayStr}): ${upsertErr.message}`);

  console.log(`✅ UTMify today delta — ${todayStr} — $${dailySpend.toFixed(2)} (MTD: $${mtdSpend.toFixed(2)}, previos: $${storedSpend.toFixed(2)})`);
  return { date: todayStr, totalInvestment: dailySpend, impressions: dailyImpressions, clicks: dailyClicks };
}

// Sync completo: rellena los últimos 7 días (para cubrir huecos) y luego calcula hoy con delta
async function runSync(): Promise<Response> {
  const supabase    = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  const mcpToken    = Deno.env.get("UTMIFY_MCP_TOKEN")!;
  const dashboardId = Deno.env.get("UTMIFY_DASHBOARD_ID")!;
  const today       = toColombiaDate(new Date());

  const results: Array<{ date: string; totalInvestment: number }> = [];
  const errors:  Array<{ date: string; error: string }> = [];

  // Sincronizar últimos 7 días completados (rellena huecos automáticamente)
  for (let i = 7; i >= 1; i--) {
    const d = new Date();
    d.setDate(d.getDate() - i);
    const dateStr = toColombiaDate(d);
    try {
      const r = await syncDate(supabase, mcpToken, dashboardId, dateStr);
      results.push({ date: r.date, totalInvestment: r.totalInvestment });
    } catch (e) {
      console.error(`Sync error for ${dateStr}:`, e);
      errors.push({ date: dateStr, error: String(e) });
    }
  }

  // Calcular hoy con método delta (evita el acumulado del mes)
  try {
    const r = await syncToday(supabase, mcpToken, dashboardId, today);
    results.push({ date: r.date, totalInvestment: r.totalInvestment });
  } catch (e) {
    console.error(`Sync error for today (${today}):`, e);
    errors.push({ date: today, error: String(e) });
  }

  return new Response(JSON.stringify({
    ok:      errors.length === 0,
    results,
    errors,
  }), { headers: { "Content-Type": "application/json" } });
}

// Backfill de un rango de fechas (?from=YYYY-MM-DD&to=YYYY-MM-DD)
// Para fechas históricas usa syncDate directamente (Meta devuelve datos exactos)
async function runBackfill(from: string, to: string): Promise<Response> {
  const supabase    = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  const mcpToken    = Deno.env.get("UTMIFY_MCP_TOKEN")!;
  const dashboardId = Deno.env.get("UTMIFY_DASHBOARD_ID")!;
  const today       = toColombiaDate(new Date());

  const dates: string[] = [];
  const cur = new Date(`${from}T12:00:00Z`);
  const end = new Date(`${to}T12:00:00Z`);
  while (cur <= end) {
    dates.push(cur.toISOString().split("T")[0]);
    cur.setDate(cur.getDate() + 1);
  }

  if (dates.length === 0) {
    return new Response(JSON.stringify({ ok: false, error: "Rango vacío o inválido" }), {
      status: 400, headers: { "Content-Type": "application/json" },
    });
  }

  const results: Array<{ date: string; totalInvestment: number }> = [];
  const errors:  Array<{ date: string; error: string }> = [];

  for (const dateStr of dates) {
    try {
      // Si el dateStr es hoy, usar método delta; si es pasado, usar syncDate normal
      const r = dateStr === today
        ? await syncToday(supabase, mcpToken, dashboardId, dateStr)
        : await syncDate(supabase, mcpToken, dashboardId, dateStr);
      results.push({ date: r.date, totalInvestment: r.totalInvestment });
    } catch (e) {
      console.error(`Backfill error for ${dateStr}:`, e);
      errors.push({ date: dateStr, error: String(e) });
    }
  }

  const totalInvestment = results.reduce((s, r) => s + r.totalInvestment, 0);
  console.log(`✅ Backfill completo — ${results.length} días — $${totalInvestment.toFixed(2)} total`);

  return new Response(JSON.stringify({
    ok:             errors.length === 0,
    daysProcessed:  results.length,
    daysWithErrors: errors.length,
    totalInvestment,
    results,
    errors,
  }), { headers: { "Content-Type": "application/json" } });
}

// Sync automático — cada hora en el minuto 0
if (typeof Deno.cron === "function") {
  Deno.cron("utmify-hourly", "0 * * * *", async () => { await runSync(); });
}

// HTTP handler
serve(async (req) => {
  const params = new URL(req.url).searchParams;
  const from   = params.get("from");
  const to     = params.get("to");
  if (from && to) return runBackfill(from, to);
  return runSync();
});
