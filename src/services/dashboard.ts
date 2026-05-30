import { supabase } from "./supabase";
import { toUSD } from "./currency";

export type ProductFilter = "todos" | "AIVI" | "MV3";

export interface PlanRow {
  name:      string;
  active:    number;
  cancelled: number;
  delayed:   number;
}

export interface DailyData {
  revenue:       number;
  investment:    number;
  roas:          number;
  newUsers:      number;
  recurring:     number;
  trials:        number;
  refunds:       number;
  cancellations: number;
  delayed:       number;
  activeTotal:   number;
}

export interface Transaction {
  id:            string;
  hotmartId:     string;
  eventType:     string;
  buyerName:     string;
  buyerEmail:    string;
  buyerPhone:    string;
  buyerCountry:  string;
  offerCode:     string;
  saleOrigin:    string;
  trafficSource: string;
  planName:      string;
  amount:        number;
  currency:      string;
  amountUsd:     number;
  createdAt:     string;
}

export interface KPIData {
  mrr:          number;
  arr:          number;
  activeTotal:  number;
  cancelled:    number;
  delayed:      number;
  grossRevenue: number;
  investment:   number;
  roas:         number;
  monthsActive: number;
}

export interface CountryRow {
  country: string;
  flag:    string;
  sales:   number;
  total:   number;
}

export interface ComparisonData {
  yesterdayRevenue:    number;
  yesterdayInvestment: number;
  yesterdayNewUsers:   number;
  weekRevenue:         number;
  monthRevenue:        number;
  sparkline:           number[]; // revenue de los últimos 7 días
}

function localDateStr(d: Date): string {
  return `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,"0")}-${String(d.getDate()).padStart(2,"0")}`;
}

// Returns UTC ISO strings that bracket the LOCAL calendar day, not the UTC day.
// Colombia = UTC-5: local midnight → UTC 05:00, local 23:59 → UTC 04:59 next day.
function localDayRange(d: Date): { start: string; end: string } {
  const start = new Date(d);
  start.setHours(0, 0, 0, 0);
  const end = new Date(d);
  end.setHours(23, 59, 59, 999);
  return { start: start.toISOString(), end: end.toISOString() };
}

function matchesPlan(planName: string, filter: ProductFilter): boolean {
  if (filter === "todos") return true;
  if (filter === "AIVI")  return planName.startsWith("AIVI");
  if (filter === "MV3")   return planName.startsWith("Método V3") || planName.startsWith("MV3");
  return true;
}

export async function getKPIs(filter: ProductFilter = "todos"): Promise<KPIData> {
  // Traer todas las suscripciones con moneda
  const { data: allSubs } = await supabase
    .from("subscriptions")
    .select("amount, currency, status, plan_name")
    .limit(5000);

  const subs = (allSubs ?? []).filter((s: any) => matchesPlan(s.plan_name, filter));

  const active    = subs.filter((s: any) => s.status === "active" && !s.plan_name.includes("Trial"));
  const trials    = subs.filter((s: any) => s.status === "active" && s.plan_name.includes("Trial"));
  const cancelled = subs.filter((s: any) => s.status === "cancelled");
  const delayed   = subs.filter((s: any) => s.status === "delayed");

  const mrr = active.reduce((s: number, sub: any) => s + toUSD(Number(sub.amount), sub.currency), 0);

  // Revenue total histórico
  const { data: allTx } = await supabase
    .from("transactions")
    .select("amount, currency, status, created_at, plan_name")
    .limit(10000);

  const filteredTx = (allTx ?? []).filter((t: any) => matchesPlan(t.plan_name, filter));
  const grossRevenue = filteredTx
    .filter((t: any) => ["active", "delayed"].includes(t.status))
    .reduce((s: number, t: any) => s + toUSD(Number(t.amount), t.currency), 0);

  // Meses activos desde primera transacción
  const dates = filteredTx
    .filter((t: any) => t.created_at)
    .map((t: any) => new Date(t.created_at).getTime());
  const firstDate = dates.length > 0 ? new Date(Math.min(...dates)) : new Date();
  const now = new Date();
  const monthsActive = Math.max(1, Math.round(
    (now.getFullYear() - firstDate.getFullYear()) * 12 +
    (now.getMonth() - firstDate.getMonth())
  ));

  return {
    mrr,
    arr:          mrr * 12,
    activeTotal:  active.length + trials.length,
    cancelled:    cancelled.length,
    delayed:      delayed.length,
    grossRevenue,
    investment:   0,
    roas:         0,
    monthsActive,
  };
}

export async function getPlansBreakdown(filter: ProductFilter = "todos"): Promise<PlanRow[]> {
  const { data } = await supabase
    .from("subscriptions")
    .select("plan_name, status");

  if (!data) return [];

  const map: Record<string, PlanRow> = {};
  for (const row of (data ?? [])) {
    if (!matchesPlan(row.plan_name, filter)) continue;
    if (!map[row.plan_name]) {
      map[row.plan_name] = { name: row.plan_name, active: 0, cancelled: 0, delayed: 0 };
    }
    if (row.status === "active")    map[row.plan_name].active++;
    if (row.status === "cancelled") map[row.plan_name].cancelled++;
    if (row.status === "delayed")   map[row.plan_name].delayed++;
  }
  return Object.values(map).sort((a, b) => b.active - a.active);
}

export async function getDailyMetrics(date: Date, filter: ProductFilter = "todos"): Promise<DailyData> {
  const { start, end } = localDayRange(date);

  const { data: txs } = await supabase
    .from("transactions")
    .select("amount, currency, status, plan_name, buyer_email")
    .gte("created_at", start)
    .lte("created_at", end);

  let revenue = 0, refunds = 0, cancellations = 0, delayed = 0, trials = 0;
  const salesEmails: string[] = [];

  for (const tx of (txs ?? [])) {
    if (!matchesPlan(tx.plan_name, filter)) continue;
    const amountUsd = toUSD(Number(tx.amount), tx.currency);
    if (tx.status === "active") {
      if (tx.plan_name.includes("Trial")) {
        trials++;
      } else {
        revenue += amountUsd;
        salesEmails.push(tx.buyer_email);
      }
    }
    if (tx.status === "refunded"  || tx.status === "chargeback") { refunds++;       revenue -= amountUsd; }
    if (tx.status === "cancelled")   cancellations++;
    if (tx.status === "delayed")     delayed++;
  }

  // Nuevos vs recurrentes: compara emails de hoy con transacciones previas
  let newUsers  = salesEmails.length;
  let recurring = 0;
  if (salesEmails.length > 0) {
    const { data: prevTxs } = await supabase
      .from("transactions")
      .select("buyer_email")
      .in("buyer_email", salesEmails)
      .lt("created_at", start)
      .eq("status", "active");
    const returningSet = new Set((prevTxs ?? []).map((t: any) => t.buyer_email as string));
    recurring = salesEmails.filter(e => returningSet.has(e)).length;
    newUsers   = salesEmails.length - recurring;
  }

  const { data: activeSubs } = await supabase
    .from("subscriptions")
    .select("id")
    .eq("status", "active");

  return {
    revenue:       Math.max(0, revenue),
    investment:    0,
    roas:          0,
    newUsers,
    recurring,
    trials,
    refunds,
    cancellations,
    delayed,
    activeTotal:   (activeSubs ?? []).length,
  };
}

export type TxTimeRange = "hoy" | "semana" | "mes" | "3meses" | "todos";

export async function getTransactions(
  date: Date,
  range: TxTimeRange = "hoy",
  filter: ProductFilter = "todos"
): Promise<Transaction[]> {
  let start: string;
  let end: string;

  if (range === "todos") {
    // Sin filtro de fecha — traer las últimas 200
    const { data } = await supabase
      .from("transactions")
      .select("id, hotmart_id, event_type, buyer_name, buyer_email, buyer_phone, buyer_country, offer_code, sale_origin, traffic_source, plan_name, amount, currency, created_at, status")
      .or("status.in.(active,refunded,delayed,trial,chargeback,unknown),status.is.null")
      .order("created_at", { ascending: false })
      .limit(200);

    return (data ?? [])
      .filter((r: any) => matchesPlan(r.plan_name, filter))
      .map(mapTransaction);
  }

  if (range === "hoy") {
    const dayRange = localDayRange(date);
    start = dayRange.start;
    end = dayRange.end;
  } else {
    const daysBack = range === "semana" ? 7 : range === "mes" ? 30 : 90;
    const startDate = new Date(date);
    startDate.setDate(startDate.getDate() - daysBack);
    const startRange = localDayRange(startDate);
    const endRange = localDayRange(date);
    start = startRange.start;
    end = endRange.end;
  }

  const { data } = await supabase
    .from("transactions")
    .select("id, hotmart_id, event_type, buyer_name, buyer_email, buyer_phone, buyer_country, offer_code, sale_origin, traffic_source, plan_name, amount, currency, created_at, status")
    .gte("created_at", start)
    .lte("created_at", end)
    .or("status.in.(active,refunded,delayed,trial,chargeback,unknown),status.is.null")
    .order("created_at", { ascending: false })
    .limit(200);

  return (data ?? [])
    .filter((r: any) => matchesPlan(r.plan_name, filter))
    .map(mapTransaction);
}

function mapTransaction(r: any): Transaction {
  return {
    id:            r.id,
    hotmartId:     r.hotmart_id     ?? "—",
    eventType:     r.event_type,
    buyerName:     r.buyer_name     ?? "—",
    buyerEmail:    r.buyer_email    ?? "—",
    buyerPhone:    r.buyer_phone    ?? "—",
    buyerCountry:  r.buyer_country  ?? "—",
    offerCode:     r.offer_code     ?? "—",
    saleOrigin:    r.sale_origin    ?? "—",
    trafficSource: r.traffic_source ?? "—",
    planName:      r.plan_name      ?? "—",
    amount:        Number(r.amount),
    currency:      r.currency       ?? "USD",
    amountUsd:     toUSD(Number(r.amount), r.currency),
    createdAt:     r.created_at,
  };
}

/**
 * Obtiene transacciones por un rango de fechas explícito (para calendario).
 */
export async function getTransactionsByDateRange(
  startDate: Date,
  endDate: Date,
  filter: ProductFilter = "todos"
): Promise<Transaction[]> {
  const { start } = localDayRange(startDate);
  const { end } = localDayRange(endDate);

  const { data } = await supabase
    .from("transactions")
    .select("id, hotmart_id, event_type, buyer_name, buyer_email, buyer_phone, buyer_country, offer_code, sale_origin, traffic_source, plan_name, amount, currency, created_at, status")
    .gte("created_at", start)
    .lte("created_at", end)
    .or("status.in.(active,refunded,delayed,trial,chargeback,unknown),status.is.null")
    .order("created_at", { ascending: false })
    .limit(500);

  return (data ?? [])
    .filter((r: any) => matchesPlan(r.plan_name, filter))
    .map(mapTransaction);
}

// Compatibilidad con el hook existente
export async function getDayTransactions(date: Date, filter: ProductFilter = "todos"): Promise<Transaction[]> {
  return getTransactions(date, "hoy", filter);
}

export async function getComparisonData(date: Date): Promise<ComparisonData> {
  const todayStr = localDateStr(date);
  const d30 = new Date(date); d30.setDate(d30.getDate() - 30);
  const d7  = new Date(date); d7.setDate(d7.getDate() - 7);
  const d1  = new Date(date); d1.setDate(d1.getDate() - 1);

  const { data } = await supabase
    .from("daily_metrics")
    .select("date, revenue, investment, new_users")
    .gte("date", localDateStr(d30))
    .lt("date", todayStr)
    .order("date", { ascending: true });

  const rows     = data ?? [];
  const yStr     = localDateStr(d1);
  const w7Str    = localDateStr(d7);
  const yesterday = rows.find((r: any) => r.date === yStr);
  const weekRows  = rows.filter((r: any) => r.date >= w7Str);

  return {
    yesterdayRevenue:    Number(yesterday?.revenue    ?? 0),
    yesterdayInvestment: Number(yesterday?.investment ?? 0),
    yesterdayNewUsers:   Number(yesterday?.new_users  ?? 0),
    weekRevenue:  weekRows.reduce((s: number, r: any) => s + Number(r.revenue), 0),
    monthRevenue: rows.reduce((s: number, r: any) => s + Number(r.revenue), 0),
    sparkline:    weekRows.map((r: any) => Number(r.revenue)),
  };
}

const FLAGS: Record<string, string> = {
  "Colombia": "🇨🇴", "México": "🇲🇽", "Mexico": "🇲🇽",
  "Argentina": "🇦🇷", "Perú": "🇵🇪", "Peru": "🇵🇪",
  "Chile": "🇨🇱", "Ecuador": "🇪🇨", "España": "🇪🇸",
  "Estados Unidos": "🇺🇸", "Venezuela": "🇻🇪", "Panamá": "🇵🇦",
  "Costa Rica": "🇨🇷", "Bolivia": "🇧🇴", "Uruguay": "🇺🇾",
  "Paraguay": "🇵🇾", "Guatemala": "🇬🇹", "Canadá": "🇨🇦",
  "Australia": "🇦🇺", "Reino Unido": "🇬🇧",
};

export async function getTopCountries(filter: ProductFilter = "todos"): Promise<CountryRow[]> {
  const { data } = await supabase
    .from("transactions")
    .select("plan_name, amount, currency, raw_payload")
    .eq("status", "active");

  if (!data) return [];

  const map: Record<string, { sales: number; total: number }> = {};

  for (const row of data) {
    if (!matchesPlan(row.plan_name, filter)) continue;
    let country = "Otro";
    try {
      const rp = typeof row.raw_payload === "string"
        ? JSON.parse(row.raw_payload)
        : row.raw_payload;
      country = rp?.pais ?? rp?.data?.buyer?.address?.country ?? "Otro";
      if (!country || country === "null" || country === "") country = "Otro";
    } catch { country = "Otro"; }

    if (!map[country]) map[country] = { sales: 0, total: 0 };
    map[country].sales++;
    map[country].total += toUSD(Number(row.amount ?? 0), row.currency);
  }

  return Object.entries(map)
    .map(([country, v]) => ({
      country,
      flag:  FLAGS[country] ?? "🌎",
      sales: v.sales,
      total: Math.round(v.total * 100) / 100,
    }))
    .sort((a, b) => b.sales - a.sales);
}

// ─── Chart Data (real) ───────────────────────────────────────────────
export type ChartTimeRange = "hoy" | "semana" | "mes";

export interface ChartPoint {
  t:         string;   // "08:00" (hoy) o "2026-05-10" (semana/mes)
  ingresos:  number;
  inversion: number;
}

export interface ChartDataResult {
  points:       ChartPoint[];
  peakHour:     string;
  bestHour:     string;
  margin:       number; // porcentaje
}

export async function getChartData(
  date: Date,
  range: ChartTimeRange,
  filter: ProductFilter = "todos"
): Promise<ChartDataResult> {
  if (range === "hoy") {
    return getHourlyChartData(date, filter);
  }
  return getDailyChartData(date, range, filter);
}

async function getHourlyChartData(date: Date, filter: ProductFilter): Promise<ChartDataResult> {
  const { start, end } = localDayRange(date);

  const { data: txs } = await supabase
    .from("transactions")
    .select("amount, currency, status, plan_name, created_at")
    .gte("created_at", start)
    .lte("created_at", end);

  // Agrupar ingresos por hora (convertidos a USD)
  const hourlyMap: Record<string, number> = {};
  for (let h = 0; h < 24; h++) {
    hourlyMap[String(h).padStart(2, "0")] = 0;
  }

  for (const tx of (txs ?? [])) {
    if (!matchesPlan(tx.plan_name, filter)) continue;
    if (tx.status !== "active" && tx.status !== "delayed") continue;
    const hour = new Date(tx.created_at).getHours();
    const key = String(hour).padStart(2, "0");
    hourlyMap[key] += toUSD(Number(tx.amount), tx.currency);
  }

  const points: ChartPoint[] = Object.entries(hourlyMap).map(([h, ingresos]) => ({
    t: `${h}:00`,
    ingresos: Math.round(ingresos * 100) / 100,
    inversion: 0, // No hay inversión por hora en las tablas actuales
  }));

  // Calcular insights
  const peakEntry = points.reduce((max, p) => p.ingresos > max.ingresos ? p : max, points[0]);
  const totalIngresos = points.reduce((s, p) => s + p.ingresos, 0);
  const totalInversion = points.reduce((s, p) => s + p.inversion, 0);
  const margin = totalIngresos > 0 ? ((totalIngresos - totalInversion) / totalIngresos) * 100 : 0;

  return {
    points,
    peakHour: peakEntry?.t ?? "—",
    bestHour: peakEntry?.t ?? "—",
    margin: Math.round(margin * 10) / 10,
  };
}

async function getDailyChartData(date: Date, range: ChartTimeRange, filter: ProductFilter): Promise<ChartDataResult> {
  const days = range === "semana" ? 7 : 30;
  const startDate = new Date(date);
  startDate.setDate(startDate.getDate() - days);

  const { data: metrics } = await supabase
    .from("daily_metrics")
    .select("date, revenue, investment")
    .gte("date", localDateStr(startDate))
    .lte("date", localDateStr(date))
    .order("date", { ascending: true });

  // Si hay filtro por producto, necesitamos calcular desde transactions
  let points: ChartPoint[];

  if (filter !== "todos") {
    // Obtener transacciones del rango y filtrar por producto
    const { start } = localDayRange(startDate);
    const { end } = localDayRange(date);

    const { data: txs } = await supabase
      .from("transactions")
      .select("amount, currency, status, plan_name, created_at")
      .gte("created_at", start)
      .lte("created_at", end);

    const dailyMap: Record<string, number> = {};
    for (const tx of (txs ?? [])) {
      if (!matchesPlan(tx.plan_name, filter)) continue;
      if (tx.status !== "active" && tx.status !== "delayed") continue;
      const dayKey = localDateStr(new Date(tx.created_at));
      dailyMap[dayKey] = (dailyMap[dayKey] ?? 0) + toUSD(Number(tx.amount), tx.currency);
    }

    points = Object.entries(dailyMap)
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([d, ingresos]) => ({
        t: d.slice(5), // "05-10" formato corto
        ingresos: Math.round(ingresos * 100) / 100,
        inversion: 0,
      }));
  } else {
    points = (metrics ?? []).map((r: any) => ({
      t: (r.date as string).slice(5), // "05-10"
      ingresos: Math.round(Number(r.revenue) * 100) / 100,
      inversion: Math.round(Number(r.investment ?? 0) * 100) / 100,
    }));
  }

  const peakEntry = points.reduce((max, p) => p.ingresos > max.ingresos ? p : max, points[0] ?? { t: "—", ingresos: 0, inversion: 0 });
  const totalIngresos = points.reduce((s, p) => s + p.ingresos, 0);
  const totalInversion = points.reduce((s, p) => s + p.inversion, 0);
  const margin = totalIngresos > 0 ? ((totalIngresos - totalInversion) / totalIngresos) * 100 : 0;

  return {
    points,
    peakHour: peakEntry?.t ?? "—",
    bestHour: peakEntry?.t ?? "—",
    margin: Math.round(margin * 10) / 10,
  };
}

// ─── Usuarios en riesgo (primeros 7 días) ────────────────────────────
export interface AtRiskUser {
  email:       string;
  name:        string;
  planName:    string;
  purchaseDate: string;   // ISO string de la primera compra
  daysActive:  number;    // días desde la compra
  daysLeft:    number;    // días restantes del periodo crítico (7 - daysActive)
  amountUsd:   number;
  riskLevel:   "alto" | "medio" | "bajo";  // alto: 0-2d, medio: 3-5d, bajo: 6-7d
}

export async function getAtRiskUsers(filter: ProductFilter = "todos"): Promise<AtRiskUser[]> {
  const now = new Date();
  const sevenDaysAgo = new Date(now);
  sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

  // Obtener transacciones activas de los últimos 7 días
  const { data: recentTx } = await supabase
    .from("transactions")
    .select("buyer_email, buyer_name, plan_name, amount, currency, created_at, status")
    .eq("status", "active")
    .gte("created_at", sevenDaysAgo.toISOString())
    .order("created_at", { ascending: true });

  if (!recentTx || recentTx.length === 0) return [];

  // Agrupar por email — tomar la primera compra
  const userMap: Record<string, AtRiskUser> = {};

  for (const tx of recentTx) {
    if (!matchesPlan(tx.plan_name, filter)) continue;
    if (tx.plan_name.includes("Trial")) continue; // excluir trials

    const email = tx.buyer_email;
    if (userMap[email]) continue; // ya procesamos este usuario (primera compra primero)

    const purchaseDate = new Date(tx.created_at);
    const daysActive = Math.floor((now.getTime() - purchaseDate.getTime()) / (1000 * 60 * 60 * 24));
    const daysLeft = Math.max(0, 7 - daysActive);

    let riskLevel: "alto" | "medio" | "bajo";
    if (daysActive <= 2) riskLevel = "alto";
    else if (daysActive <= 5) riskLevel = "medio";
    else riskLevel = "bajo";

    userMap[email] = {
      email,
      name: tx.buyer_name ?? "—",
      planName: tx.plan_name,
      purchaseDate: tx.created_at,
      daysActive,
      daysLeft,
      amountUsd: toUSD(Number(tx.amount), tx.currency),
      riskLevel,
    };
  }

  // Verificar si alguno de estos usuarios ya tenía compras anteriores (recurrentes)
  const emails = Object.keys(userMap);
  if (emails.length > 0) {
    const { data: prevTx } = await supabase
      .from("transactions")
      .select("buyer_email")
      .in("buyer_email", emails)
      .lt("created_at", sevenDaysAgo.toISOString())
      .eq("status", "active");

    // Remover recurrentes — no son "nuevos" en riesgo
    const returningEmails = new Set((prevTx ?? []).map((t: any) => t.buyer_email));
    for (const email of returningEmails) {
      delete userMap[email];
    }
  }

  // Ordenar por riesgo (alto primero) y luego por días
  return Object.values(userMap).sort((a, b) => {
    const riskOrder = { alto: 0, medio: 1, bajo: 2 };
    if (riskOrder[a.riskLevel] !== riskOrder[b.riskLevel]) {
      return riskOrder[a.riskLevel] - riskOrder[b.riskLevel];
    }
    return a.daysActive - b.daysActive;
  });
}

// ─── Trazabilidad de usuarios ─────────────────────────────────────────────────

export interface UserTx {
  id:        string;
  eventType: string;
  planName:  string;
  amount:    number;
  currency:  string;
  amountUsd: number;
  createdAt: string;
  status:    string;
}

export interface UserProfile {
  email:             string;
  name:              string;
  status:            "active" | "cancelled" | "delayed" | "trial";
  planName:          string;
  amountUsd:         number;
  ltv:               number;
  firstPurchaseDate: string;
  lastPurchaseDate:  string;
  country:           string;
  channel:           string;
  phone:             string | null;
  transactions:      UserTx[];
  daysActive:        number;
  renewalsCount:     number;   // número de renovaciones (transacciones activas - 1)
}

export async function getUsersTraceability(filter: ProductFilter = "todos"): Promise<UserProfile[]> {
  // Traer todas las transacciones
  const { data: allTx } = await supabase
    .from("transactions")
    .select("id, event_type, buyer_name, buyer_email, plan_name, amount, currency, created_at, status, raw_payload")
    .order("created_at", { ascending: false });

  if (!allTx) return [];

  // Traer suscripciones para obtener el estado actual
  const { data: allSubs } = await supabase
    .from("subscriptions")
    .select("buyer_email, buyer_name, plan_name, status, amount, currency");

  // Mapa email → suscripción vigente
  const subsMap: Record<string, any> = {};
  for (const sub of (allSubs ?? [])) {
    if (!matchesPlan(sub.plan_name, filter)) continue;
    // Dar preferencia al estado activo
    if (!subsMap[sub.buyer_email] || sub.status === "active") {
      subsMap[sub.buyer_email] = sub;
    }
  }

  // Agrupar transacciones por email
  const txMap: Record<string, any[]> = {};
  for (const tx of allTx) {
    const email = tx.buyer_email;
    if (!email || email === "—") continue;
    if (!matchesPlan(tx.plan_name, filter)) continue;
    if (!txMap[email]) txMap[email] = [];
    txMap[email].push(tx);
  }

  // Combinar emails de ambas fuentes
  const emailSet = new Set([...Object.keys(subsMap), ...Object.keys(txMap)]);
  const users: UserProfile[] = [];

  for (const email of emailSet) {
    const sub  = subsMap[email];
    const txs  = txMap[email] ?? [];
    if (!email) continue;

    // Cálculo LTV (transacciones activas en USD)
    const activeTxs = txs.filter((t: any) => t.status === "active" || t.status === "delayed");
    const ltv = Math.round(
      activeTxs.reduce((s: number, t: any) => s + toUSD(Number(t.amount), t.currency), 0) * 100
    ) / 100;

    // Fechas
    const sorted = [...txs].sort((a: any, b: any) =>
      new Date(a.created_at).getTime() - new Date(b.created_at).getTime()
    );
    const firstPurchaseDate = sorted[0]?.created_at ?? "";
    const lastPurchaseDate  = sorted[sorted.length - 1]?.created_at ?? "";

    const now = new Date();
    const firstDate = firstPurchaseDate ? new Date(firstPurchaseDate) : now;
    const daysActive = Math.floor((now.getTime() - firstDate.getTime()) / (1000 * 60 * 60 * 24));

    // País y canal desde raw_payload
    let country = "—";
    let channel = "Orgánico";
    for (const tx of sorted) {
      try {
        const rp = typeof tx.raw_payload === "string" ? JSON.parse(tx.raw_payload) : tx.raw_payload;
        if (country === "—") {
          const c = rp?.pais ?? rp?.data?.buyer?.address?.country;
          if (c && c !== "null" && c !== "") country = c;
        }
        if (channel === "Orgánico") {
          const utm = rp?.utm_source ?? rp?.tracking?.source_sck;
          if (utm && utm !== "null" && utm !== "") channel = utm;
        }
      } catch { /* ignore */ }
      if (country !== "—" && channel !== "Orgánico") break;
    }

    // Teléfono: recorrer todos los payloads hasta encontrar uno
    let phone: string | null = null;
    for (const tx of sorted) {
      try {
        const rp = typeof tx.raw_payload === "string" ? JSON.parse(tx.raw_payload) : tx.raw_payload;
        const p = rp?.data?.buyer?.checkout_phone ?? rp?.data?.buyer?.phone ?? null;
        if (p && String(p).trim() !== "") { phone = String(p).trim(); break; }
      } catch { /* ignore */ }
    }

    const rawStatus = sub?.status ?? (activeTxs.length > 0 ? "active" : "cancelled");
    const status: UserProfile["status"] =
      ["active", "cancelled", "delayed", "trial"].includes(rawStatus)
        ? (rawStatus as UserProfile["status"])
        : "cancelled";

    users.push({
      email,
      name: sub?.buyer_name ?? sorted[0]?.buyer_name ?? "—",
      status,
      planName:          sub?.plan_name ?? sorted[0]?.plan_name ?? "—",
      amountUsd:         toUSD(Number(sub?.amount ?? 0), sub?.currency ?? "USD"),
      ltv,
      firstPurchaseDate,
      lastPurchaseDate,
      country,
      channel,
      phone,
      transactions: [...txs]
        .sort((a: any, b: any) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
        .map((t: any): UserTx => ({
          id:        t.id,
          eventType: t.event_type ?? "purchase",
          planName:  t.plan_name,
          amount:    Number(t.amount),
          currency:  t.currency ?? "USD",
          amountUsd: toUSD(Number(t.amount), t.currency),
          createdAt: t.created_at,
          status:    t.status,
        })),
      daysActive,
      renewalsCount: Math.max(0, activeTxs.length - 1),
    });
  }

  return users.sort((a, b) => b.ltv - a.ltv);
}

export type TxCategory =
  | "compras"
  | "solicitudes_reembolso"
  | "reembolsos"
  | "cancelaciones"
  | "atrasados"
  | "chargeback";

const STATUS_BY_CATEGORY: Record<TxCategory, string[]> = {
  compras:               ["active"],
  solicitudes_reembolso: ["refund_request"],
  reembolsos:            ["refunded"],
  cancelaciones:         ["cancelled"],
  atrasados:             ["delayed"],
  chargeback:            ["chargeback"],
};

export async function getFullTransactions(
  category: TxCategory,
  startDate: Date | null,
  endDate: Date | null,
  search: string = "",
  productFilter: ProductFilter = "todos",
  page: number = 1,
  pageSize: number = 50
): Promise<Transaction[]> {
  const statuses = STATUS_BY_CATEGORY[category];
  const from     = (page - 1) * pageSize;
  const to       = from + pageSize - 1;

  let query = supabase
    .from("transactions")
    .select("id, hotmart_id, event_type, buyer_name, buyer_email, buyer_phone, buyer_country, offer_code, sale_origin, traffic_source, plan_name, amount, currency, created_at, status")
    .in("status", statuses)
    .order("created_at", { ascending: false })
    .range(from, to);

  if (startDate) {
    const { start } = localDayRange(startDate);
    query = query.gte("created_at", start);
  }
  if (endDate) {
    const { end } = localDayRange(endDate);
    query = query.lte("created_at", end);
  }
  if (productFilter === "AIVI") {
    query = query.ilike("plan_name", "AIVI%");
  } else if (productFilter === "MV3") {
    query = query.or('plan_name.ilike."Método V3%",plan_name.ilike.MV3%');
  }

  const { data } = await query;
  const rows = (data ?? []) as any[];

  const lowerSearch = search.toLowerCase().trim();
  const filtered = lowerSearch
    ? rows.filter((r) =>
        (r.buyer_name  ?? "").toLowerCase().includes(lowerSearch) ||
        (r.buyer_email ?? "").toLowerCase().includes(lowerSearch) ||
        (r.buyer_phone ?? "").toLowerCase().includes(lowerSearch)
      )
    : rows;

  return filtered.map(mapTransaction);
}

export async function getTransactionCount(
  category: TxCategory,
  startDate: Date | null,
  endDate: Date | null,
  productFilter: ProductFilter = "todos"
): Promise<number> {
  const statuses = STATUS_BY_CATEGORY[category];

  let query = supabase
    .from("transactions")
    .select("*", { count: "exact", head: true })
    .in("status", statuses);

  if (startDate) {
    const { start } = localDayRange(startDate);
    query = query.gte("created_at", start);
  }
  if (endDate) {
    const { end } = localDayRange(endDate);
    query = query.lte("created_at", end);
  }
  if (productFilter === "AIVI") {
    query = query.ilike("plan_name", "AIVI%");
  } else if (productFilter === "MV3") {
    query = query.or('plan_name.ilike."Método V3%",plan_name.ilike.MV3%');
  }

  const { count } = await query;
  return count ?? 0;
}

export async function syncToday(): Promise<{ ok: boolean; inserted?: number; total?: number; errors?: number; dias?: number; error?: string }> {
  const now   = Date.now();
  const start = now - 24 * 60 * 60 * 1000; // últimas 24h
  const url   = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/hotmart-sync?start=${start}&end=${now}`;
  try {
    const res = await fetch(url, {
      headers: { Authorization: `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}` },
    });
    if (!res.ok) {
      const text = await res.text().catch(() => "");
      return { ok: false, error: `HTTP ${res.status}: ${text.slice(0, 200)}` };
    }
    return res.json();
  } catch (e) {
    return { ok: false, error: String(e) };
  }
}
