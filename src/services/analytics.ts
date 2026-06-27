import { supabase }  from "./supabase";
import { toUSD }     from "./currency";

// ── Períodos ──────────────────────────────────────────────────────────────────

export type PeriodKey = "noche" | "dia" | "hoy" | "ayer" | "7dias" | "custom";

export interface DateRange { from: string; to: string; fromTs: string; toTs: string }

export function buildRange(key: PeriodKey, custom?: { from: string; to: string }): DateRange {
  const now    = new Date();
  const colMs  = now.getTime() - 5 * 60 * 60 * 1000; // UTC → Colombia (UTC-5), sin depender del timezone del browser
  const col    = new Date(colMs);
  const pad    = (n: number) => String(n).padStart(2, "0");
  const ymd    = (d: Date) => `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`;

  const today     = ymd(col);
  const yesterday = ymd(new Date(col.getTime() - 86400000));

  if (key === "custom" && custom) {
    return { from: custom.from, to: custom.to, fromTs: `${custom.from}T00:00:00`, toTs: `${custom.to}T23:59:59` };
  }
  if (key === "noche")  return { from: yesterday, to: today,     fromTs: `${yesterday}T22:00:00`, toTs: `${today}T08:00:00` };
  if (key === "dia")    return { from: today,     to: today,     fromTs: `${today}T08:00:00`,     toTs: `${today}T22:00:00` };
  if (key === "ayer")   return { from: yesterday, to: yesterday, fromTs: `${yesterday}T00:00:00`, toTs: `${yesterday}T23:59:59` };
  if (key === "7dias") {
    const from7 = ymd(new Date(col.getTime() - 6 * 86400000));
    return { from: from7, to: today, fromTs: `${from7}T00:00:00`, toTs: `${today}T23:59:59` };
  }
  return { from: today, to: today, fromTs: `${today}T00:00:00`, toTs: `${today}T23:59:59` };
}

export function previousRange(r: DateRange): DateRange {
  const from  = new Date(`${r.from}T12:00:00Z`);
  const to    = new Date(`${r.to}T12:00:00Z`);
  const diffMs = to.getTime() - from.getTime() + 86400000;
  const prevTo   = new Date(from.getTime() - 86400000);
  const prevFrom = new Date(prevTo.getTime() - diffMs + 86400000);
  const fmt = (d: Date) => d.toISOString().split("T")[0];
  return buildRange("custom", { from: fmt(prevFrom), to: fmt(prevTo) });
}

// ── Tipos ─────────────────────────────────────────────────────────────────────

export interface AnalyticsSummary {
  investment:  number;
  revenue:     number;
  roas:        number;
  cac:         number;
  sales:       number;
  plays:       number;
  playRate:    number;
  costPerPlay: number;
  prev?: Omit<AnalyticsSummary, "prev">;
}

export interface FunnelCampaign {
  campaignName: string;
  videoId:      string | null;
  videoName:    string | null;
  impressions:  number;
  clicks:       number;
  plays:        number;
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
  videoId:    string;
  videoName:  string;
  plays:      number;
  ret25:      number;
  ret50:      number;
  ret75:      number;
  ctaClicks:  number;
  sales:      number;
  convRate:   number;
  retention:  VSLRetentionPoint[];
  dropSecond: number | null;
}

export interface AdRankRow {
  campaignName: string;
  investment:   number;
  clicks:       number;
  impressions:  number;
  cpm:          number;
  cpc:          number;
  plays:        number;
  playRate:     number;
  sales:        number;
  cac:          number;
  roas:         number;
  videoId:      string | null;
  videoName:    string | null;
  score:        number;
}

export interface HeatmapCell { hour: number; dow: number; value: number }

export interface LTVRow {
  campaignName: string;
  customers:    number;
  ltv:          number;
  totalRevenue: number;
  cac:          number;
  roiReal:      number;
}

export interface Alert {
  level:   "rojo" | "amarillo" | "verde";
  message: string;
}

export interface VSLMapping { campaignName: string; videoId: string; videoName: string }

// ── Funciones ─────────────────────────────────────────────────────────────────

export async function getAnalyticsSummary(r: DateRange): Promise<AnalyticsSummary> {
  const [invRes, txRes, playsRes] = await Promise.all([
    supabase.from("campaign_investment_data").select("investment").gte("date", r.from).lte("date", r.to),
    supabase.from("transactions").select("amount, currency").gte("created_at", r.fromTs).lte("created_at", r.toTs).eq("status", "active"),
    supabase.from("vturb_analytics").select("plays, views, button_clicks").gte("date", r.from).lte("date", r.to),
  ]);

  const investment = (invRes.data ?? []).reduce((s: number, x: any) => s + Number(x.investment), 0);
  const revenue    = (txRes.data ?? []).reduce((s: number, x: any) => s + toUSD(Number(x.amount), x.currency), 0);
  const sales      = (txRes.data ?? []).length;
  const plays      = (playsRes.data ?? []).reduce((s: number, x: any) => s + Number(x.plays), 0);
  const views      = (playsRes.data ?? []).reduce((s: number, x: any) => s + Number(x.views), 0);

  return {
    investment,
    revenue,
    roas:        investment > 0 ? revenue / investment : 0,
    cac:         sales > 0 ? investment / sales : 0,
    sales,
    plays,
    playRate:    views > 0 ? (plays / views) * 100 : 0,
    costPerPlay: plays > 0 ? investment / plays : 0,
  };
}

export async function getFunnelByCampaign(r: DateRange): Promise<FunnelCampaign[]> {
  const [campRes, txRes, mappingRes, analyticsRes] = await Promise.all([
    supabase.from("campaign_investment_data").select("campaign_name, investment, impressions, clicks").gte("date", r.from).lte("date", r.to),
    // traffic_source es el campo donde Hotmart guarda el UTM (src/sck)
    supabase.from("transactions").select("traffic_source, amount, currency, created_at").gte("created_at", r.fromTs).lte("created_at", r.toTs).eq("status", "active"),
    supabase.from("campaign_vsl_mapping").select("*"),
    supabase.from("vturb_analytics").select("video_id, plays, button_clicks").gte("date", r.from).lte("date", r.to),
  ]);

  const invMap: Record<string, { investment: number; impressions: number; clicks: number }> = {};
  for (const row of (campRes.data ?? [])) {
    const k = row.campaign_name ?? "Sin campaña";
    if (!invMap[k]) invMap[k] = { investment: 0, impressions: 0, clicks: 0 };
    invMap[k].investment  += Number(row.investment);
    invMap[k].impressions += Number(row.impressions);
    invMap[k].clicks      += Number(row.clicks);
  }

  const salesMap: Record<string, { count: number; revenue: number; hours: number[] }> = {};
  for (const tx of (txRes.data ?? [])) {
    const k = tx.traffic_source ?? "Sin UTM";
    if (!salesMap[k]) salesMap[k] = { count: 0, revenue: 0, hours: [] };
    salesMap[k].count++;
    salesMap[k].revenue += toUSD(Number(tx.amount), tx.currency);
    salesMap[k].hours.push(new Date(tx.created_at).getHours());
  }

  const mappingMap: Record<string, { videoId: string; videoName: string }> = {};
  for (const m of (mappingRes.data ?? [])) {
    mappingMap[m.campaign_name] = { videoId: m.video_id, videoName: m.video_name ?? m.video_id };
  }

  const vturlMap: Record<string, { plays: number; buttonClicks: number }> = {};
  for (const row of (analyticsRes.data ?? [])) {
    const k = row.video_id;
    if (!vturlMap[k]) vturlMap[k] = { plays: 0, buttonClicks: 0 };
    vturlMap[k].plays        += Number(row.plays);
    vturlMap[k].buttonClicks += Number(row.button_clicks);
  }

  const allCampaigns = new Set([...Object.keys(invMap), ...Object.keys(salesMap)]);

  const maxRoas = Math.max(1, ...[...allCampaigns].map(c => {
    const inv = invMap[c]?.investment ?? 0;
    const rev = salesMap[c]?.revenue ?? 0;
    return inv > 0 ? rev / inv : 0;
  }));

  return [...allCampaigns].map(campaignName => {
    const inv   = invMap[campaignName]  ?? { investment: 0, impressions: 0, clicks: 0 };
    const sales = salesMap[campaignName] ?? { count: 0, revenue: 0, hours: [] };
    const vsl   = mappingMap[campaignName] ?? null;
    const vData = vsl ? (vturlMap[vsl.videoId] ?? { plays: 0, buttonClicks: 0 }) : null;

    const cac  = sales.count > 0 ? inv.investment / sales.count : 0;
    const roas = inv.investment > 0 ? sales.revenue / inv.investment : 0;

    const hourCount: Record<number, number> = {};
    for (const h of sales.hours) hourCount[h] = (hourCount[h] ?? 0) + 1;
    const topHour = sales.hours.length > 0
      ? Number(Object.entries(hourCount).sort((a, b) => b[1] - a[1])[0][0])
      : null;

    const roasNorm  = maxRoas > 0 ? Math.min(roas / maxRoas, 1) : 0;
    const convRate  = vData && vData.plays > 0 ? sales.count / vData.plays : 0;
    const score     = Math.round((roasNorm * 0.50 + Math.min(convRate * 10, 1) * 0.50) * 100);

    return {
      campaignName, videoId: vsl?.videoId ?? null, videoName: vsl?.videoName ?? null,
      impressions: inv.impressions, clicks: inv.clicks,
      plays: vData?.plays ?? 0, ctaClicks: vData?.buttonClicks ?? 0,
      sales: sales.count, cac, roas, investment: inv.investment, topHour, score,
    };
  }).sort((a, b) => (a.cac || 999) - (b.cac || 999));
}

export async function getVSLRetention(r: DateRange): Promise<VSLData[]> {
  const [analyticsRes, retentionRes, txRes, mappingRes] = await Promise.all([
    supabase.from("vturb_analytics").select("video_id, video_name, plays, button_clicks").gte("date", r.from).lte("date", r.to),
    supabase.from("vturb_retention").select("video_id, second, percentage").gte("date", r.from).lte("date", r.to).order("second", { ascending: true }),
    supabase.from("transactions").select("traffic_source").gte("created_at", r.fromTs).lte("created_at", r.toTs).eq("event_type", "PURCHASE_COMPLETE"),
    supabase.from("campaign_vsl_mapping").select("*"),
  ]);

  const videoSales: Record<string, number> = {};
  const mappingBySource: Record<string, string> = {};
  for (const m of (mappingRes.data ?? [])) mappingBySource[m.campaign_name] = m.video_id;
  for (const tx of (txRes.data ?? [])) {
    const vid = mappingBySource[tx.traffic_source ?? ""] ?? null;
    if (vid) videoSales[vid] = (videoSales[vid] ?? 0) + 1;
  }

  const analyticsMap: Record<string, { videoName: string; plays: number; ctaClicks: number }> = {};
  for (const row of (analyticsRes.data ?? [])) {
    const k = row.video_id;
    if (!analyticsMap[k]) analyticsMap[k] = { videoName: row.video_name ?? k, plays: 0, ctaClicks: 0 };
    analyticsMap[k].plays     += Number(row.plays);
    analyticsMap[k].ctaClicks += Number(row.button_clicks);
  }

  // Promedia los puntos de retención por segundo cuando hay múltiples fechas en el rango
  const retAccum: Record<string, Record<number, { sum: number; count: number }>> = {};
  for (const row of (retentionRes.data ?? [])) {
    if (!retAccum[row.video_id]) retAccum[row.video_id] = {};
    const sec = Number(row.second);
    if (!retAccum[row.video_id][sec]) retAccum[row.video_id][sec] = { sum: 0, count: 0 };
    retAccum[row.video_id][sec].sum   += Number(row.percentage);
    retAccum[row.video_id][sec].count += 1;
  }
  const retMap: Record<string, VSLRetentionPoint[]> = {};
  for (const [vid, secMap] of Object.entries(retAccum)) {
    retMap[vid] = Object.entries(secMap)
      .map(([s, { sum, count }]) => ({ second: Number(s), percentage: sum / count }))
      .sort((a, b) => a.second - b.second);
  }

  return Object.entries(analyticsMap).map(([videoId, a]) => {
    const retention = retMap[videoId] ?? [];
    // Busca el porcentaje en el segundo que corresponde al pct% de la duración total
    const getAt = (pct: number) => {
      if (retention.length === 0) return 0;
      const totalSec  = retention[retention.length - 1].second;
      const targetSec = (pct / 100) * totalSec;
      const pt = retention.find(p => p.second >= targetSec) ?? retention[retention.length - 1];
      return pt.percentage;
    };

    let dropSecond: number | null = null;
    for (let i = 0; i < retention.length - 10; i++) {
      if ((retention[i].percentage - retention[i + 10].percentage) > 20) {
        dropSecond = retention[i].second; break;
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
    videoId:      f.videoId,
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
    const d = new Date(tx.created_at);
    const k = `${d.getHours()}-${d.getDay()}`;
    cells[k] = (cells[k] ?? 0) + 1;
  }

  return Object.entries(cells).map(([k, value]) => {
    const [hour, dow] = k.split("-").map(Number);
    return { hour, dow, value };
  });
}

export async function getLTVBySource(): Promise<LTVRow[]> {
  const [txRes, campRes] = await Promise.all([
    supabase.from("transactions").select("traffic_source, amount, buyer_email, event_type"),
    supabase.from("campaign_investment_data").select("campaign_name, investment"),
  ]);

  const invMap: Record<string, number> = {};
  for (const row of (campRes.data ?? [])) {
    invMap[row.campaign_name] = (invMap[row.campaign_name] ?? 0) + Number(row.investment);
  }

  const revenueMap: Record<string, number> = {};
  const customersMap: Record<string, Set<string>> = {};
  for (const tx of (txRes.data ?? []).filter((t: any) => t.event_type === "PURCHASE_COMPLETE")) {
    const k = tx.traffic_source ?? "Sin UTM";
    revenueMap[k] = (revenueMap[k] ?? 0) + Number(tx.amount);
    if (!customersMap[k]) customersMap[k] = new Set();
    if (tx.buyer_email) customersMap[k].add(tx.buyer_email);
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

  if (summary.prev && summary.prev.cac > 0 && summary.cac > 0) {
    const delta = (summary.cac - summary.prev.cac) / summary.prev.cac;
    if (delta > 0.30) alerts.push({ level: "rojo", message: `CAC subió ${Math.round(delta*100)}% vs período anterior ($${summary.cac.toFixed(0)} vs $${summary.prev.cac.toFixed(0)})` });
  }

  if (summary.roas < 1.5 && summary.investment > 0) {
    alerts.push({ level: "rojo", message: `ROAS global en ${summary.roas.toFixed(2)}x — la inversión no se está recuperando` });
  }

  for (const vsl of vsls) {
    const pt120 = vsl.retention.find(p => p.second >= 120);
    if (pt120 && pt120.percentage < 40) {
      alerts.push({ level: "amarillo", message: `VSL "${vsl.videoName}" retiene solo ${pt120.percentage.toFixed(0)}% al minuto 2 — revisar gancho` });
    }
    if (vsl.dropSecond !== null) {
      alerts.push({ level: "amarillo", message: `VSL "${vsl.videoName}" pierde >20% de audiencia en el segundo ${vsl.dropSecond} — punto crítico de edición` });
    }
  }

  for (const f of funnel) {
    if (f.score >= 80) alerts.push({ level: "verde", message: `Campaña "${f.campaignName}" tiene Score ${f.score} — ROAS ${f.roas.toFixed(1)}x, candidata a escalar` });
  }

  return alerts.slice(0, 5);
}

export async function getAIAnalysis(payload: {
  summary: AnalyticsSummary;
  funnel:  FunnelCampaign[];
  vsls:    VSLData[];
  period:  string;
}): Promise<string> {
  const prompt = `Eres un analista de marketing experto. Analiza estos datos del período "${payload.period}" y responde SOLO con las 3 secciones indicadas, en español latinoamericano, directo y accionable.

DATOS DEL PERÍODO:
Inversión: $${payload.summary.investment.toFixed(2)} | Ingresos: $${payload.summary.revenue.toFixed(2)} | ROAS: ${payload.summary.roas.toFixed(2)}x | CAC: $${payload.summary.cac.toFixed(2)} | Ventas: ${payload.summary.sales}

CAMPAÑAS (ordenadas por CAC):
${payload.funnel.map(f => `- ${f.campaignName}: CAC $${f.cac.toFixed(0)}, ROAS ${f.roas.toFixed(1)}x, Score ${f.score}, VSL: ${f.videoName ?? "Sin asignar"}, Ventas: ${f.sales}`).join("\n")}

VSLs:
${payload.vsls.map(v => `- ${v.videoName}: ${v.plays} plays, Ret50% ${v.ret50.toFixed(0)}%, CTA ${v.ctaClicks} clicks, Conv ${v.convRate.toFixed(1)}%${v.dropSecond ? `, caída en segundo ${v.dropSecond}` : ""}`).join("\n")}

Responde exactamente con este formato:

## ¿Qué escalar ahora?
[2-3 combinaciones específicas con presupuesto sugerido y hora recomendada]

## ¿Qué corregir hoy?
[Lista de acciones específicas con el dato exacto que lo justifica]

## ¿Qué replicar?
[Patrones concretos del contenido ganador: tipo de hook, estructura, momento del CTA]`;

  const { data, error } = await supabase.functions.invoke("ai-analyst", {
    body: { prompt },
  });
  if (error) throw new Error(error.message);
  return data.text as string;
}

export async function getVSLMappings(): Promise<VSLMapping[]> {
  const { data, error } = await supabase.from("campaign_vsl_mapping").select("*");
  if (error) throw new Error(error.message);
  return (data ?? []).map((r: any) => ({ campaignName: r.campaign_name, videoId: r.video_id, videoName: r.video_name ?? r.video_id }));
}

export interface VTurbVideo { videoId: string; videoName: string }

export async function getAvailableVideos(): Promise<VTurbVideo[]> {
  const { data } = await supabase
    .from("vturb_analytics")
    .select("video_id, video_name")
    .not("video_id", "is", null);

  const seen = new Set<string>();
  const result: VTurbVideo[] = [];
  for (const row of (data ?? [])) {
    if (!seen.has(row.video_id)) {
      seen.add(row.video_id);
      result.push({ videoId: row.video_id, videoName: row.video_name ?? row.video_id });
    }
  }
  return result.sort((a, b) => a.videoName.localeCompare(b.videoName));
}

export async function saveVSLMapping(m: VSLMapping): Promise<void> {
  const { error } = await supabase.from("campaign_vsl_mapping").upsert(
    { campaign_name: m.campaignName, video_id: m.videoId, video_name: m.videoName },
    { onConflict: "campaign_name" },
  );
  if (error) throw new Error(error.message);
}

export async function deleteVSLMapping(campaignName: string): Promise<void> {
  const { error } = await supabase.from("campaign_vsl_mapping").delete().eq("campaign_name", campaignName);
  if (error) throw new Error(error.message);
}
