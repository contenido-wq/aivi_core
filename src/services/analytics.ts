import { supabase }  from "./supabase";
import { toUSD }     from "./currency";
import { FunctionsHttpError } from "@supabase/supabase-js";

// ── Períodos ──────────────────────────────────────────────────────────────────

export type PeriodKey =
  | "hoy" | "ayer" | "hoyAyer"
  | "7dias" | "14dias" | "28dias" | "30dias"
  | "estaSemana" | "semanaPasada"
  | "esteMes" | "mesPasado"
  | "maximo" | "custom";

export interface DateRange { from: string; to: string; fromTs: string; toTs: string }

const MESES_ES = ["ene", "feb", "mar", "abr", "may", "jun", "jul", "ago", "sep", "oct", "nov", "dic"];

export function formatDateEs(dateStr: string): string {
  const [y, m, d] = dateStr.split("-").map(Number);
  return `${d} ${MESES_ES[m - 1]} ${y}`;
}

export function buildRange(key: PeriodKey, custom?: { from: string; to: string }): DateRange {
  const now    = new Date();
  const colMs  = now.getTime() - 5 * 60 * 60 * 1000; // UTC → Colombia (UTC-5), sin depender del timezone del browser
  const col    = new Date(colMs);
  const pad    = (n: number) => String(n).padStart(2, "0");
  const ymd    = (d: Date) => `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`;
  const range  = (from: string, to: string): DateRange => ({ from, to, fromTs: `${from}T00:00:00`, toTs: `${to}T23:59:59` });

  const today     = ymd(col);
  const yesterday = ymd(new Date(col.getTime() - 86400000));

  if (key === "custom" && custom) return range(custom.from, custom.to);
  if (key === "ayer")    return range(yesterday, yesterday);
  if (key === "hoyAyer") return range(yesterday, today);
  if (key === "7dias")   return range(ymd(new Date(col.getTime() - 6  * 86400000)), today);
  if (key === "14dias")  return range(ymd(new Date(col.getTime() - 13 * 86400000)), today);
  if (key === "28dias")  return range(ymd(new Date(col.getTime() - 27 * 86400000)), today);
  if (key === "30dias")  return range(ymd(new Date(col.getTime() - 29 * 86400000)), today);
  if (key === "estaSemana" || key === "semanaPasada") {
    const dow          = col.getDay(); // 0=Dom..6=Sáb
    const diffToMonday = (dow + 6) % 7;
    const thisMonday   = new Date(col.getTime() - diffToMonday * 86400000);
    if (key === "estaSemana") return range(ymd(thisMonday), today);
    const lastMonday = new Date(thisMonday.getTime() - 7 * 86400000);
    const lastSunday  = new Date(thisMonday.getTime() - 1 * 86400000);
    return range(ymd(lastMonday), ymd(lastSunday));
  }
  if (key === "esteMes" || key === "mesPasado") {
    const firstOfThisMonth = new Date(col.getFullYear(), col.getMonth(), 1);
    if (key === "esteMes") return range(ymd(firstOfThisMonth), today);
    const firstOfLastMonth = new Date(col.getFullYear(), col.getMonth() - 1, 1);
    const lastOfLastMonth  = new Date(col.getFullYear(), col.getMonth(), 0);
    return range(ymd(firstOfLastMonth), ymd(lastOfLastMonth));
  }
  if (key === "maximo") return range("2020-01-01", today);
  // default: "hoy"
  return range(today, today);
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
  roi:         number;
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
  revenue:      number;
  cac:          number;
  roi:          number;
  investment:   number;
  topHour:      number | null;
  score:        number;
}

export interface VSLRetentionPoint { second: number; percentage: number }
export interface VSLData {
  videoId:       string;
  videoName:     string;
  plays:         number;
  ret25:         number;
  ret50:         number;
  ret75:         number;
  ctaClicks:     number;
  sales:         number;
  convRate:      number;
  retention:     VSLRetentionPoint[];
  dropSecond:    number | null;
  views:         number;
  uniqueViews:   number;
  uniquePlays:   number;
  engagement:    number;
  pitchAudience: number | null;
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
  roi:          number;
  videoId:      string | null;
  videoName:    string | null;
  score:        number;
}

export type AdAction = "ESCALAR" | "PAUSAR" | "MONITOREAR";

export interface ScoreableRow { sales: number; cac: number; roi: number; investment: number }

export function classifyAd(r: ScoreableRow, cacTarget: number, ticketMin: number): AdAction {
  const avgTicket = r.sales > 0 && r.investment > 0 ? (r.investment * (1 + r.roi)) / r.sales : 0;
  const ticketOk  = ticketMin === 0 || avgTicket >= ticketMin;
  if (r.sales >= 1 && r.cac > 0 && r.cac <= cacTarget && r.roi >= 1.0 && ticketOk) return "ESCALAR";
  if ((r.cac > 0 && r.cac > cacTarget * 1.5) || (r.roi < 0.0 && r.investment > 0)) return "PAUSAR";
  return "MONITOREAR";
}

export interface HeatmapCell {
  hour:     number;
  dow:      number;
  value:    number;
  bySource: { source: string; count: number }[];
  byVideo:  { videoId: string | null; value: number; bySource: { source: string; count: number }[] }[];
}

export interface LTVRow {
  campaignName: string;
  videoId:      string | null;
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

// Mapeo especial: captura todo el tráfico/ventas sin una campaña mapeada
// explícitamente, en vez de perderse como "Sin VSL asignado".
export const DEFAULT_VSL_CAMPAIGN = "__default__";

// ── Score compartido (campaña y anuncio) ────────────────────────────────────────

const SCORE_WEIGHTS = { roi: 0.30, convRate: 0.20, pitchAudience: 0.30, engagement: 0.20 } as const;

function computeScore(
  input: { roi: number; convRate: number; pitchAudience: number | null; engagement: number },
  maxRoi: number,
  maxConvRate: number,
): number {
  const roiNorm      = maxRoi > 0 ? Math.min(Math.max(input.roi / maxRoi, 0), 1) : 0;
  const convRateNorm = maxConvRate > 0 ? Math.min(Math.max(input.convRate / maxConvRate, 0), 1) : 0;
  const pitchNorm       = Math.min(Math.max((input.pitchAudience ?? 0) / 100, 0), 1);
  const engagementNorm  = Math.min(Math.max(input.engagement / 100, 0), 1);
  return Math.round((
    roiNorm * SCORE_WEIGHTS.roi +
    convRateNorm * SCORE_WEIGHTS.convRate +
    pitchNorm * SCORE_WEIGHTS.pitchAudience +
    engagementNorm * SCORE_WEIGHTS.engagement
  ) * 100);
}

function averageRetention(points: VSLRetentionPoint[]): number {
  return points.length > 0 ? points.reduce((s, p) => s + p.percentage, 0) / points.length : 0;
}

function retentionAt(points: VSLRetentionPoint[], second: number): number {
  if (points.length === 0) return 0;
  const pt = points.find(p => p.second >= second) ?? points[points.length - 1];
  return pt.percentage;
}

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
    roi:         investment > 0 ? (revenue - investment) / investment : 0,
    cac:         sales > 0 ? investment / sales : 0,
    sales,
    plays,
    playRate:    views > 0 ? (plays / views) * 100 : 0,
    costPerPlay: plays > 0 ? investment / plays : 0,
  };
}

export async function getFunnelByCampaign(r: DateRange): Promise<FunnelCampaign[]> {
  const [campRes, txRes, mappingRes, analyticsRes, retentionRes] = await Promise.all([
    supabase.from("campaign_investment_data").select("campaign_name, investment, impressions, clicks").gte("date", r.from).lte("date", r.to),
    // traffic_source es el campo donde Hotmart guarda el UTM (src/sck)
    supabase.from("transactions").select("traffic_source, amount, currency, created_at").gte("created_at", r.fromTs).lte("created_at", r.toTs).eq("status", "active"),
    supabase.from("campaign_vsl_mapping").select("*"),
    supabase.from("vturb_analytics").select("video_id, plays, button_clicks, pitch_second").gte("date", r.from).lte("date", r.to),
    supabase.from("vturb_retention").select("video_id, second, percentage").gte("date", r.from).lte("date", r.to),
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
    const k = tx.traffic_source || "Sin UTM";
    if (!salesMap[k]) salesMap[k] = { count: 0, revenue: 0, hours: [] };
    salesMap[k].count++;
    salesMap[k].revenue += toUSD(Number(tx.amount), tx.currency);
    salesMap[k].hours.push(new Date(tx.created_at).getHours());
  }

  const mappingMap: Record<string, { videoId: string; videoName: string }> = {};
  for (const m of (mappingRes.data ?? [])) {
    mappingMap[m.campaign_name] = { videoId: m.video_id, videoName: m.video_name ?? m.video_id };
  }
  const defaultVsl = mappingMap[DEFAULT_VSL_CAMPAIGN] ?? null;

  const vturlMap: Record<string, { plays: number; buttonClicks: number; pitchSecond: number | null }> = {};
  for (const row of (analyticsRes.data ?? [])) {
    const k = row.video_id;
    if (!vturlMap[k]) vturlMap[k] = { plays: 0, buttonClicks: 0, pitchSecond: null };
    vturlMap[k].plays        += Number(row.plays);
    vturlMap[k].buttonClicks += Number(row.button_clicks);
    if (row.pitch_second != null) vturlMap[k].pitchSecond = Number(row.pitch_second);
  }

  const retByVideo: Record<string, VSLRetentionPoint[]> = {};
  for (const row of (retentionRes.data ?? [])) {
    if (!retByVideo[row.video_id]) retByVideo[row.video_id] = [];
    retByVideo[row.video_id].push({ second: Number(row.second), percentage: Number(row.percentage) });
  }
  for (const points of Object.values(retByVideo)) points.sort((a, b) => a.second - b.second);

  const allCampaigns = new Set([...Object.keys(invMap), ...Object.keys(salesMap)]);

  const maxRoi = Math.max(1, ...[...allCampaigns].map(c => {
    const inv = invMap[c]?.investment ?? 0;
    const rev = salesMap[c]?.revenue ?? 0;
    return inv > 0 ? (rev - inv) / inv : 0;
  }));
  const maxConvRate = Math.max(0.0001, ...[...allCampaigns].map(c => {
    const vsl   = mappingMap[c] ?? defaultVsl;
    const vData = vsl ? vturlMap[vsl.videoId] : null;
    const sales = salesMap[c]?.count ?? 0;
    return vData && vData.plays > 0 ? sales / vData.plays : 0;
  }));

  return [...allCampaigns].map(campaignName => {
    const inv   = invMap[campaignName]  ?? { investment: 0, impressions: 0, clicks: 0 };
    const sales = salesMap[campaignName] ?? { count: 0, revenue: 0, hours: [] };
    const vsl   = mappingMap[campaignName] ?? defaultVsl;
    const vData = vsl ? (vturlMap[vsl.videoId] ?? { plays: 0, buttonClicks: 0, pitchSecond: null }) : null;
    const retention = vsl ? (retByVideo[vsl.videoId] ?? []) : [];

    const cac  = sales.count > 0 ? inv.investment / sales.count : 0;
    const roi  = inv.investment > 0 ? (sales.revenue - inv.investment) / inv.investment : 0;

    const hourCount: Record<number, number> = {};
    for (const h of sales.hours) hourCount[h] = (hourCount[h] ?? 0) + 1;
    const topHour = sales.hours.length > 0
      ? Number(Object.entries(hourCount).sort((a, b) => b[1] - a[1])[0][0])
      : null;

    const convRate     = vData && vData.plays > 0 ? sales.count / vData.plays : 0;
    const engagement   = averageRetention(retention);
    const pitchAudience = vData?.pitchSecond != null ? retentionAt(retention, vData.pitchSecond) : null;
    const score = computeScore({ roi, convRate, pitchAudience, engagement }, maxRoi, maxConvRate);

    return {
      campaignName, videoId: vsl?.videoId ?? null, videoName: vsl?.videoName ?? null,
      impressions: inv.impressions, clicks: inv.clicks,
      plays: vData?.plays ?? 0, ctaClicks: vData?.buttonClicks ?? 0,
      sales: sales.count, revenue: sales.revenue, cac, roi, investment: inv.investment, topHour, score,
    };
  }).sort((a, b) => (a.cac || 999) - (b.cac || 999));
}

export async function getVSLRetention(r: DateRange): Promise<VSLData[]> {
  const [analyticsRes, retentionRes, txRes, mappingRes] = await Promise.all([
    supabase.from("vturb_analytics").select("video_id, video_name, plays, views, unique_views, unique_plays, button_clicks, pitch_second").gte("date", r.from).lte("date", r.to),
    supabase.from("vturb_retention").select("video_id, second, percentage").gte("date", r.from).lte("date", r.to).order("second", { ascending: true }),
    supabase.from("transactions").select("traffic_source").gte("created_at", r.fromTs).lte("created_at", r.toTs).eq("status", "active"),
    supabase.from("campaign_vsl_mapping").select("*"),
  ]);

  const videoSales: Record<string, number> = {};
  const mappingBySource: Record<string, string> = {};
  for (const m of (mappingRes.data ?? [])) mappingBySource[m.campaign_name] = m.video_id;
  const defaultVideoId = mappingBySource[DEFAULT_VSL_CAMPAIGN] ?? null;
  for (const tx of (txRes.data ?? [])) {
    const vid = mappingBySource[tx.traffic_source ?? ""] ?? defaultVideoId;
    if (vid) videoSales[vid] = (videoSales[vid] ?? 0) + 1;
  }

  const analyticsMap: Record<string, { videoName: string; plays: number; views: number; uniqueViews: number; uniquePlays: number; ctaClicks: number; pitchSecond: number | null }> = {};
  for (const row of (analyticsRes.data ?? [])) {
    const k = row.video_id;
    if (!analyticsMap[k]) analyticsMap[k] = { videoName: row.video_name ?? k, plays: 0, views: 0, uniqueViews: 0, uniquePlays: 0, ctaClicks: 0, pitchSecond: null };
    analyticsMap[k].plays       += Number(row.plays);
    analyticsMap[k].views       += Number(row.views);
    analyticsMap[k].uniqueViews += Number(row.unique_views ?? 0);
    analyticsMap[k].uniquePlays += Number(row.unique_plays ?? 0);
    analyticsMap[k].ctaClicks   += Number(row.button_clicks);
    if (row.pitch_second != null) analyticsMap[k].pitchSecond = Number(row.pitch_second);
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
      views:         a.views,
      uniqueViews:   a.uniqueViews,
      uniquePlays:   a.uniquePlays,
      engagement:    averageRetention(retention),
      pitchAudience: a.pitchSecond != null ? retentionAt(retention, a.pitchSecond) : null,
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
    roi:          f.roi,
    videoId:      f.videoId,
    videoName:    f.videoName,
    score:        f.score,
  }));
}

export interface AdVSLRow {
  adId:          string;
  adName:        string;
  adsetName:     string | null;
  placement:     string | null;
  campaignName:  string;
  videoId:       string | null;
  videoName:     string | null;
  investment:    number;
  clicks:        number;
  impressions:   number;
  sales:         number;
  cac:           number;
  roi:           number;
  convRate:      number;
  views:         number;
  uniqueViews:   number;
  plays:         number;
  uniquePlays:   number;
  playRate:      number;
  engagement:    number;
  pitchAudience: number | null;
  score:         number;
}

export async function getAdVSLRanking(r: DateRange): Promise<AdVSLRow[]> {
  const [adInvRes, campInvRes, txRes, adMappingRes, campMappingRes, vturbRes, retentionRes] = await Promise.all([
    supabase.from("ad_investment_data").select("ad_id, ad_name, campaign_id, investment, impressions, clicks").gte("date", r.from).lte("date", r.to),
    supabase.from("campaign_investment_data").select("campaign_id, campaign_name").gte("date", r.from).lte("date", r.to),
    supabase.from("transactions").select("ad_id, ad_name, adset_name, placement, traffic_source, amount, currency").gte("created_at", r.fromTs).lte("created_at", r.toTs).eq("status", "active"),
    supabase.from("ad_vsl_mapping").select("*"),
    supabase.from("campaign_vsl_mapping").select("*"),
    supabase.from("vturb_analytics").select("video_id, plays, views, unique_plays, unique_views, pitch_second").gte("date", r.from).lte("date", r.to),
    supabase.from("vturb_retention").select("video_id, second, percentage").gte("date", r.from).lte("date", r.to),
  ]);

  const campNameById: Record<string, string> = {};
  for (const row of (campInvRes.data ?? [])) if (row.campaign_id) campNameById[row.campaign_id] = row.campaign_name ?? row.campaign_id;

  const invMap: Record<string, { adName: string; campaignId: string | null; investment: number; impressions: number; clicks: number }> = {};
  for (const row of (adInvRes.data ?? [])) {
    const k = row.ad_id;
    if (!invMap[k]) invMap[k] = { adName: row.ad_name ?? k, campaignId: row.campaign_id ?? null, investment: 0, impressions: 0, clicks: 0 };
    invMap[k].investment  += Number(row.investment);
    invMap[k].impressions += Number(row.impressions);
    invMap[k].clicks      += Number(row.clicks);
  }

  const salesMap: Record<string, { count: number; revenue: number; adName: string | null; adsetName: string | null; placement: string | null; campaignName: string | null }> = {};
  for (const tx of (txRes.data ?? [])) {
    const k = tx.ad_id;
    if (!k) continue; // ventas sin ad_id (tráfico no atribuido a un anuncio) no entran al ranking por anuncio
    if (!salesMap[k]) salesMap[k] = { count: 0, revenue: 0, adName: tx.ad_name ?? null, adsetName: tx.adset_name ?? null, placement: tx.placement ?? null, campaignName: tx.traffic_source || null };
    salesMap[k].count++;
    salesMap[k].revenue += toUSD(Number(tx.amount), tx.currency);
  }

  const adVideoMap: Record<string, { videoId: string; videoName: string }> = {};
  for (const m of (adMappingRes.data ?? [])) adVideoMap[m.ad_id] = { videoId: m.video_id, videoName: m.video_name ?? m.video_id };
  const campVideoMap: Record<string, { videoId: string; videoName: string }> = {};
  for (const m of (campMappingRes.data ?? [])) campVideoMap[m.campaign_name] = { videoId: m.video_id, videoName: m.video_name ?? m.video_id };
  const defaultVideo = campVideoMap[DEFAULT_VSL_CAMPAIGN] ?? null;

  const vturbMap: Record<string, { plays: number; views: number; uniquePlays: number; uniqueViews: number; pitchSecond: number | null }> = {};
  for (const row of (vturbRes.data ?? [])) {
    const k = row.video_id;
    if (!vturbMap[k]) vturbMap[k] = { plays: 0, views: 0, uniquePlays: 0, uniqueViews: 0, pitchSecond: null };
    vturbMap[k].plays       += Number(row.plays);
    vturbMap[k].views       += Number(row.views);
    vturbMap[k].uniquePlays += Number(row.unique_plays ?? 0);
    vturbMap[k].uniqueViews += Number(row.unique_views ?? 0);
    if (row.pitch_second != null) vturbMap[k].pitchSecond = Number(row.pitch_second);
  }

  const retentionByVideo: Record<string, VSLRetentionPoint[]> = {};
  for (const row of (retentionRes.data ?? [])) {
    if (!retentionByVideo[row.video_id]) retentionByVideo[row.video_id] = [];
    retentionByVideo[row.video_id].push({ second: Number(row.second), percentage: Number(row.percentage) });
  }
  for (const points of Object.values(retentionByVideo)) points.sort((a, b) => a.second - b.second);

  const allAdIds = new Set([...Object.keys(invMap), ...Object.keys(salesMap)]);

  const resolveVideo = (adId: string, campaignName: string) =>
    adVideoMap[adId] ?? campVideoMap[campaignName] ?? defaultVideo;

  const maxRoi = Math.max(1, ...[...allAdIds].map(id => {
    const inv = invMap[id]?.investment ?? 0;
    const rev = salesMap[id]?.revenue ?? 0;
    return inv > 0 ? (rev - inv) / inv : 0;
  }));
  const maxConvRate = Math.max(0.0001, ...[...allAdIds].map(id => {
    const sale = salesMap[id];
    const campaignName = (invMap[id]?.campaignId ? campNameById[invMap[id].campaignId!] : null) ?? sale?.campaignName ?? "Sin campaña";
    const video = resolveVideo(id, campaignName);
    const plays = video ? (vturbMap[video.videoId]?.plays ?? 0) : 0;
    return plays > 0 ? (sale?.count ?? 0) / plays : 0;
  }));

  return [...allAdIds].map(adId => {
    const inv  = invMap[adId]  ?? { adName: adId, campaignId: null, investment: 0, impressions: 0, clicks: 0 };
    const sale = salesMap[adId] ?? { count: 0, revenue: 0, adName: null, adsetName: null, placement: null, campaignName: null };
    const campaignName = (inv.campaignId ? campNameById[inv.campaignId] : null) ?? sale.campaignName ?? "Sin campaña";
    const video = resolveVideo(adId, campaignName);
    const vturb = video ? (vturbMap[video.videoId] ?? null) : null;
    const retention = video ? (retentionByVideo[video.videoId] ?? []) : [];

    const cac = sale.count > 0 ? inv.investment / sale.count : 0;
    const roi = inv.investment > 0 ? (sale.revenue - inv.investment) / inv.investment : 0;
    const convRate = vturb && vturb.plays > 0 ? sale.count / vturb.plays : 0;
    const engagement = averageRetention(retention);
    const pitchAudience = vturb?.pitchSecond != null ? retentionAt(retention, vturb.pitchSecond) : null;
    const playRate = vturb && vturb.views > 0 ? (vturb.plays / vturb.views) * 100 : 0;
    const score = computeScore({ roi, convRate, pitchAudience, engagement }, maxRoi, maxConvRate);

    return {
      adId,
      adName:       inv.adName ?? sale.adName ?? adId,
      adsetName:    sale.adsetName,
      placement:    sale.placement,
      campaignName,
      videoId:      video?.videoId ?? null,
      videoName:    video?.videoName ?? null,
      investment:   inv.investment,
      clicks:       inv.clicks,
      impressions:  inv.impressions,
      sales:        sale.count,
      cac, roi, convRate,
      views:        vturb?.views ?? 0,
      uniqueViews:  vturb?.uniqueViews ?? 0,
      plays:        vturb?.plays ?? 0,
      uniquePlays:  vturb?.uniquePlays ?? 0,
      playRate,
      engagement,
      pitchAudience,
      score,
    };
  }).sort((a, b) => b.score - a.score);
}

export async function getHourlyHeatmap(r: DateRange): Promise<HeatmapCell[]> {
  const [txRes, mappingRes] = await Promise.all([
    supabase
      .from("transactions")
      .select("created_at, traffic_source")
      .gte("created_at", r.fromTs).lte("created_at", r.toTs)
      .eq("status", "active"),
    supabase.from("campaign_vsl_mapping").select("campaign_name, video_id"),
  ]);

  const videoByCampaign: Record<string, string> = {};
  for (const m of (mappingRes.data ?? [])) videoByCampaign[m.campaign_name] = m.video_id;
  const defaultVideoId = videoByCampaign[DEFAULT_VSL_CAMPAIGN] ?? null;

  const cells:         Record<string, number> = {};
  const bySources:     Record<string, Record<string, number>> = {};
  const byVideoCount:  Record<string, Record<string, number>> = {};
  const byVideoSource: Record<string, Record<string, Record<string, number>>> = {};

  const NO_VSL = "__sin_vsl__";

  for (const tx of (txRes.data ?? [])) {
    const d = new Date(tx.created_at);
    const k = `${d.getHours()}-${d.getDay()}`;
    cells[k] = (cells[k] ?? 0) + 1;

    const source = tx.traffic_source || "Sin UTM";
    if (!bySources[k]) bySources[k] = {};
    bySources[k][source] = (bySources[k][source] ?? 0) + 1;

    const videoKey = videoByCampaign[tx.traffic_source] ?? defaultVideoId ?? NO_VSL;
    if (!byVideoCount[k]) byVideoCount[k] = {};
    byVideoCount[k][videoKey] = (byVideoCount[k][videoKey] ?? 0) + 1;
    if (!byVideoSource[k]) byVideoSource[k] = {};
    if (!byVideoSource[k][videoKey]) byVideoSource[k][videoKey] = {};
    byVideoSource[k][videoKey][source] = (byVideoSource[k][videoKey][source] ?? 0) + 1;
  }

  return Object.entries(cells).map(([k, value]) => {
    const [hour, dow] = k.split("-").map(Number);
    const bySource = Object.entries(bySources[k] ?? {})
      .map(([source, count]) => ({ source, count }))
      .sort((a, b) => b.count - a.count);
    const byVideo = Object.entries(byVideoCount[k] ?? {}).map(([videoKey, count]) => ({
      videoId: videoKey === NO_VSL ? null : videoKey,
      value:   count,
      bySource: Object.entries(byVideoSource[k]?.[videoKey] ?? {})
        .map(([source, c]) => ({ source, count: c }))
        .sort((a, b) => b.count - a.count),
    }));
    return { hour, dow, value, bySource, byVideo };
  });
}

export async function getLTVBySource(r: DateRange): Promise<LTVRow[]> {
  const [txRes, campRes, mappingRes] = await Promise.all([
    supabase
      .from("transactions")
      .select("traffic_source, amount, buyer_email, event_type")
      .gte("created_at", r.fromTs).lte("created_at", r.toTs)
      .eq("status", "active"),
    supabase
      .from("campaign_investment_data")
      .select("campaign_name, investment")
      .gte("date", r.from).lte("date", r.to),
    supabase.from("campaign_vsl_mapping").select("campaign_name, video_id"),
  ]);

  const videoByCampaign: Record<string, string> = {};
  for (const m of (mappingRes.data ?? [])) videoByCampaign[m.campaign_name] = m.video_id;
  const defaultVideoId = videoByCampaign[DEFAULT_VSL_CAMPAIGN] ?? null;

  const invMap: Record<string, number> = {};
  for (const row of (campRes.data ?? [])) {
    invMap[row.campaign_name] = (invMap[row.campaign_name] ?? 0) + Number(row.investment);
  }

  const revenueMap: Record<string, number> = {};
  const customersMap: Record<string, Set<string>> = {};
  for (const tx of (txRes.data ?? [])) {
    const k = tx.traffic_source || "Sin UTM";
    revenueMap[k] = (revenueMap[k] ?? 0) + Number(tx.amount);
    if (!customersMap[k]) customersMap[k] = new Set();
    if (tx.buyer_email) customersMap[k].add(tx.buyer_email);
  }

  return Object.keys({ ...revenueMap, ...invMap }).map(campaignName => {
    const totalRevenue = revenueMap[campaignName] ?? 0;
    const customers    = customersMap[campaignName]?.size ?? 0;
    const ltv          = customers > 0 ? totalRevenue / customers : 0;
    const investment   = invMap[campaignName] ?? 0;
    const cac          = customers > 0 ? investment / customers : 0;
    const roiReal      = cac > 0 ? ltv / cac : 0;
    const videoId      = videoByCampaign[campaignName] ?? defaultVideoId;
    return { campaignName, videoId, customers, ltv, totalRevenue, cac, roiReal };
  }).sort((a, b) => b.roiReal - a.roiReal);
}

export interface ProductRevenueRow {
  product:   string;
  revenue:   number;
  sales:     number;
  avgTicket: number;
}

const PRODUCT_GROUPS: Record<string, string[]> = {
  "AIVI": [
    "AIVI",
    "AIVI — Creator Lite Semestral",
  ],
  "Contenido que Vende con IA": [
    "Taller: Contenido que V3NDE con Inteligencia Artificial (Marzo 9, 10, 11 y 12)",
    "Taller: Contenido que V3NDE con Inteligencia Artificial (Enero 19, 20, 21 y 22)",
  ],
  "MV3": [
    "Método V3 - [Viralidad, Comunidad y Ventas]",
    "Master Creator - MV3",
    "Master Creator",
  ],
};

export async function getProductRevenue(): Promise<ProductRevenueRow[]> {
  const now   = new Date();
  const colMs = now.getTime() - 5 * 60 * 60 * 1000; // UTC → Colombia (UTC-5), mismo criterio que buildRange
  const today = new Date(colMs).toISOString().split("T")[0];
  const from  = "2025-10-01";

  const { data } = await supabase
    .from("transactions")
    .select("plan_name, amount, currency")
    .gte("created_at", `${from}T00:00:00`)
    .lte("created_at", `${today}T23:59:59`)
    .eq("status", "active");

  return Object.entries(PRODUCT_GROUPS).map(([product, planNames]) => {
    const rows    = (data ?? []).filter((tx: any) => planNames.includes(tx.plan_name));
    const revenue = rows.reduce((s: number, tx: any) => s + toUSD(Number(tx.amount), tx.currency), 0);
    const sales   = rows.length;
    return { product, revenue, sales, avgTicket: sales > 0 ? revenue / sales : 0 };
  });
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

  if (summary.roi < 0.5 && summary.investment > 0) {
    alerts.push({ level: "rojo", message: `ROI global en ${summary.roi.toFixed(2)}x — la inversión no se está recuperando` });
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
    if (f.score >= 80) alerts.push({ level: "verde", message: `Campaña "${f.campaignName}" tiene Score ${f.score} — ROI ${f.roi.toFixed(1)}x, candidata a escalar` });
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
Inversión: $${payload.summary.investment.toFixed(2)} | Ingresos: $${payload.summary.revenue.toFixed(2)} | ROI: ${payload.summary.roi.toFixed(2)}x | CAC: $${payload.summary.cac.toFixed(2)} | Ventas: ${payload.summary.sales}

CAMPAÑAS (ordenadas por CAC):
${payload.funnel.map(f => `- ${f.campaignName}: CAC $${f.cac.toFixed(0)}, ROI ${f.roi.toFixed(1)}x, Score ${f.score}, VSL: ${f.videoName ?? "Sin asignar"}, Ventas: ${f.sales}`).join("\n")}

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
  if (error) {
    if (error instanceof FunctionsHttpError) {
      const body = await error.context.json().catch(() => null);
      throw new Error(body?.error ?? error.message);
    }
    throw new Error(error.message);
  }
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

// ── Mapeo Anuncio → VSL (override opcional) ─────────────────────────────────────

export interface AdVSLMapping { adId: string; videoId: string; videoName: string }

export async function getAdVSLMappings(): Promise<AdVSLMapping[]> {
  const { data, error } = await supabase.from("ad_vsl_mapping").select("*");
  if (error) throw new Error(error.message);
  return (data ?? []).map((r: any) => ({ adId: r.ad_id, videoId: r.video_id, videoName: r.video_name ?? r.video_id }));
}

export async function saveAdVSLMapping(m: AdVSLMapping): Promise<void> {
  const { error } = await supabase.from("ad_vsl_mapping").upsert(
    { ad_id: m.adId, video_id: m.videoId, video_name: m.videoName },
    { onConflict: "ad_id" },
  );
  if (error) throw new Error(error.message);
}

export async function deleteAdVSLMapping(adId: string): Promise<void> {
  const { error } = await supabase.from("ad_vsl_mapping").delete().eq("ad_id", adId);
  if (error) throw new Error(error.message);
}

export interface AvailableAd { adId: string; adName: string }

export async function getAvailableAds(): Promise<AvailableAd[]> {
  const { data } = await supabase
    .from("ad_investment_data")
    .select("ad_id, ad_name")
    .not("ad_id", "is", null);

  const seen = new Set<string>();
  const result: AvailableAd[] = [];
  for (const row of (data ?? [])) {
    if (!seen.has(row.ad_id)) {
      seen.add(row.ad_id);
      result.push({ adId: row.ad_id, adName: row.ad_name ?? row.ad_id });
    }
  }
  return result.sort((a, b) => a.adName.localeCompare(b.adName));
}

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
