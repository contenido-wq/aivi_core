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
      const { error: invErr } = await supabase.from("investment_data").upsert({
        date:        today,
        platform,
        investment:  metrics.investment,
        impressions: metrics.impressions,
        clicks:      metrics.clicks,
        raw_data:    debug ? data : null,
        synced_at:   new Date().toISOString(),
      }, { onConflict: "date,platform" });
      if (invErr) throw new Error(`investment_data upsert failed: ${invErr.message}`);
    }

    const totalInvestment = Object.values(platformMap).reduce((s, m) => s + m.investment, 0);

    const { error: dmErr } = await supabase.from("daily_metrics").upsert({
      date:       today,
      investment: totalInvestment,
      updated_at: new Date().toISOString(),
    }, { onConflict: "date" });
    if (dmErr) throw new Error(`daily_metrics upsert failed: ${dmErr.message}`);

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
// El guard evita crash si la feature Cron no está habilitada en el proyecto de Supabase
if (typeof Deno.cron === "function") {
  Deno.cron("utmify-hourly", "0 * * * *", async () => { await runSync(false); });
}

// Trigger manual (botón TopNav) o ?debug=true para inspeccionar respuesta de UTMify
serve(async (req) => {
  const debug = new URL(req.url).searchParams.has("debug");
  return runSync(debug);
});
