import { serve }        from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const UTMIFY_BASE = "https://api.utmify.com.br";

serve(async (_req) => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const apiKey = Deno.env.get("UTMIFY_API_KEY")!;
  const today  = new Date().toISOString().split("T")[0];

  try {
    const res = await fetch(`${UTMIFY_BASE}/api/v1/campaigns?date=${today}`, {
      headers: { "x-api-key": apiKey, "Content-Type": "application/json" },
    });

    if (!res.ok) {
      const err = await res.text();
      console.error("UTMify API error:", res.status, err);
      return new Response(JSON.stringify({ ok: false, error: err }), { status: 502 });
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
        raw_data:    data,
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
    return new Response(JSON.stringify({ ok: true, totalInvestment, platforms: platformMap }), {
      headers: { "Content-Type": "application/json" },
    });

  } catch (e) {
    console.error("UTMify sync failed:", e);
    return new Response(JSON.stringify({ ok: false, error: String(e) }), { status: 500 });
  }
});

function normalizePlatform(source: string): string {
  const s = source.toLowerCase();
  if (s.includes("facebook") || s.includes("meta") || s.includes("fb")) return "facebook";
  if (s.includes("google") || s.includes("gads"))                        return "google";
  if (s.includes("tiktok") || s.includes("tt"))                          return "tiktok";
  return "other";
}
