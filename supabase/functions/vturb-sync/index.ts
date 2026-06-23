// @ts-nocheck
import { serve }        from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

declare const Deno: {
  env:  { get(key: string): string | undefined };
  cron: (name: string, schedule: string, handler: () => Promise<void>) => void;
};

const VTURB_BASE = "https://analytics.vturb.net";

function toColombiaDate(d: Date): string {
  const local = new Date(d.getTime() - 5 * 60 * 60 * 1000);
  return local.toISOString().split("T")[0];
}

function dayRange(from: string, to: string): string[] {
  const days: string[] = [];
  const cur = new Date(`${from}T12:00:00Z`);
  const end = new Date(`${to}T12:00:00Z`);
  while (cur <= end) {
    days.push(cur.toISOString().split("T")[0]);
    cur.setDate(cur.getDate() + 1);
  }
  return days;
}

async function vturb(apiKey: string, path: string, body?: unknown): Promise<unknown> {
  const res = await fetch(`${VTURB_BASE}${path}`, {
    method:  body ? "POST" : "GET",
    headers: {
      "X-Api-Token":   apiKey,
      "X-Api-Version": "v1",
      "Content-Type":  "application/json",
      "Accept":        "application/json",
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  if (!res.ok) throw new Error(`VTurb ${path} → HTTP ${res.status}: ${await res.text()}`);
  return res.json();
}

// ── Tipos ─────────────────────────────────────────────────────────────────────

interface VTurbPlayer { id: string; name: string; duration: number }

interface EventsByPlayer {
  player_id: string;
  event:     string;
  total:     number;
}

interface ClicksByDay {
  events_by_day: Array<{ day: string; total: number }>;
}

interface EngagementPoint { timed: number; total_users: number }

// ── Sync analytics diario ──────────────────────────────────────────────────────
// Estrategia: por cada día, 1 llamada para todos los players (events/total_by_company_players)
// + 1 llamada por player ACTIVO para clicks. Muy eficiente con muchos players.

async function syncAnalytics(
  supabase: ReturnType<typeof createClient>,
  apiKey:   string,
  from:     string,
  to:       string,
): Promise<void> {
  const days = dayRange(from, to);
  const allRows: Record<string, unknown>[] = [];

  for (const day of days) {
    const startDt = `${day} 00:00:00`;
    const endDt   = `${day} 23:59:59`;

    // 1 sola llamada para todos los players activos ese día
    const events = await vturb(apiKey, "/events/total_by_company_players", {
      start_date: startDt,
      end_date:   endDt,
      events:     ["started", "viewed"],
    }) as EventsByPlayer[];

    // Agrupar por player_id
    const byPlayer: Record<string, { plays: number; views: number }> = {};
    for (const e of (events ?? [])) {
      if (!byPlayer[e.player_id]) byPlayer[e.player_id] = { plays: 0, views: 0 };
      if (e.event === "started") byPlayer[e.player_id].plays += e.total;
      if (e.event === "viewed")  byPlayer[e.player_id].views += e.total;
    }

    const activeIds = Object.keys(byPlayer);
    if (activeIds.length === 0) continue;

    // Clicks: 1 llamada por player activo (no hay endpoint multi-player sin player_id)
    const clicksByPlayer: Record<string, number> = {};
    await Promise.all(activeIds.map(async (pid) => {
      try {
        const c = await vturb(apiKey, "/clicks/total_by_company_day", {
          player_id:  pid,
          start_date: startDt,
          end_date:   endDt,
        }) as ClicksByDay;
        const clicks = (c?.events_by_day ?? []).find((d) => d.day === day)?.total ?? 0;
        clicksByPlayer[pid] = clicks;
      } catch { clicksByPlayer[pid] = 0; }
    }));

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
  }

  if (allRows.length === 0) { console.log(`VTurb analytics: sin datos ${from}→${to}`); return; }

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

  const { error } = await supabase
    .from("vturb_analytics")
    .upsert(allRows, { onConflict: "video_id,date" });
  if (error) throw new Error(`vturb_analytics upsert: ${error.message}`);
  console.log(`✅ VTurb analytics — ${allRows.length} filas — ${from}→${to}`);
}

// ── Sync retention ─────────────────────────────────────────────────────────────
// Solo para players con actividad en el período (no todos los 80+)

async function syncRetention(
  supabase: ReturnType<typeof createClient>,
  apiKey:   string,
  from:     string,
  to:       string,
): Promise<void> {
  const startDt = `${from} 00:00:00`;
  const endDt   = `${to} 23:59:59`;

  // Obtener solo players activos en el período
  const events = await vturb(apiKey, "/events/total_by_company_players", {
    start_date: startDt,
    end_date:   endDt,
    events:     ["started"],
  }) as Array<{ player_id: string; total: number }>;

  const activeIds = [...new Set((events ?? []).map((e) => e.player_id))];
  if (activeIds.length === 0) return;

  const players = await vturb(apiKey, "/players/list") as VTurbPlayer[];
  const playerMap: Record<string, VTurbPlayer> = {};
  for (const p of players) playerMap[p.id] = p;

  for (const pid of activeIds) {
    const player = playerMap[pid];
    if (!player?.duration) continue;

    try {
      const data = await vturb(apiKey, "/times/user_engagement", {
        player_id:      pid,
        start_date:     startDt,
        end_date:       endDt,
        video_duration: player.duration,
      }) as { grouped_timed: EngagementPoint[] };

      const points = data?.grouped_timed ?? [];
      if (points.length === 0) continue;

      const maxUsers = Math.max(...points.map((p) => p.total_users), 1);
      const rows = points.map((p) => ({
        video_id:   pid,
        date:       from,
        second:     p.timed,
        percentage: Math.round((p.total_users / maxUsers) * 10000) / 100,
      }));

      const { error } = await supabase
        .from("vturb_retention")
        .upsert(rows, { onConflict: "video_id,date,second" });
      if (error) throw new Error(`vturb_retention upsert ${pid}: ${error.message}`);
      console.log(`✅ VTurb retention — ${player.name} — ${rows.length} puntos`);
    } catch (e) {
      console.error(`VTurb retention ${pid}:`, e);
    }
  }
}

// ── Runner ─────────────────────────────────────────────────────────────────────

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

  try { await syncAnalytics(supabase, apiKey, dateFrom, dateTo); }
  catch (e) { console.error("syncAnalytics:", e); errors.push(String(e)); }

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
