// @ts-nocheck
import { serve }        from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

declare const Deno: {
  env:  { get(key: string): string | undefined };
  cron: (name: string, schedule: string, handler: () => Promise<void>) => void;
};

const MCP_BASE = "https://mcp.utmify.com.br/mcp";
const MCP_RESOURCES = "gm,gg,gt,gu,gwe,ga,gp,gwa,gr,gpc,gcs";

function toColombiaDate(d: Date): string {
  const local = new Date(d.getTime() - 5 * 60 * 60 * 1000);
  return local.toISOString().split("T")[0];
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

// Sincroniza un día específico consultando Meta Ads vía MCP
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

  const results      = data.results ?? [];
  // spend viene en centavos en la moneda del dashboard (USD)
  const totalSpend   = results.reduce((s, r) => s + (r.spend          ?? 0), 0) / 100;
  const totalImpres  = results.reduce((s, r) => s + (r.impressions     ?? 0), 0);
  const totalClicks  = results.reduce((s, r) => s + (r.inlineLinkClicks ?? 0), 0);

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

// Sync del día actual
async function runSync(): Promise<Response> {
  const supabase     = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  const mcpToken     = Deno.env.get("UTMIFY_MCP_TOKEN")!;
  const dashboardId  = Deno.env.get("UTMIFY_DASHBOARD_ID")!;
  const today        = toColombiaDate(new Date());

  try {
    const result = await syncDate(supabase, mcpToken, dashboardId, today);
    return new Response(JSON.stringify({ ok: true, ...result }), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    console.error("UTMify sync failed:", e);
    return new Response(JSON.stringify({ ok: false, error: String(e) }), {
      status: 500, headers: { "Content-Type": "application/json" },
    });
  }
}

// Backfill de un rango de fechas (?from=YYYY-MM-DD&to=YYYY-MM-DD)
async function runBackfill(from: string, to: string): Promise<Response> {
  const supabase    = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  const mcpToken    = Deno.env.get("UTMIFY_MCP_TOKEN")!;
  const dashboardId = Deno.env.get("UTMIFY_DASHBOARD_ID")!;

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
      const r = await syncDate(supabase, mcpToken, dashboardId, dateStr);
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
