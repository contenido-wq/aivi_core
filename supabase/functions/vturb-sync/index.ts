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
      date:       from,
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
  const apiKey   = Deno.env.get("VTURB_API_KEY")!;
  const today    = toColombiaDate(new Date());
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

// Cron horario en minuto 30 (no colisiona con utmify-sync en minuto 0)
if (typeof Deno.cron === "function") {
  Deno.cron("vturb-hourly", "30 * * * *", async () => { await runSync(); });
}

serve(async (req) => {
  const params = new URL(req.url).searchParams;
  const from = params.get("from") ?? undefined;
  const to   = params.get("to")   ?? undefined;
  return runSync(from, to);
});
