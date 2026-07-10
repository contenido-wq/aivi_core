import { useState, useEffect, useCallback, useRef } from "react";
import { supabase } from "../services/supabase";
import { ensureRatesLoaded } from "../services/currency";
import {
  getKPIs, getPlansBreakdown, getDailyMetrics, getDayTransactions, getComparisonData, getTopCountries, getChartData, getTransactionsByDateRange, getAtRiskUsers, getDelayedUsers, getCancelledUsers, getCancelledByDay, getRenewalSummary,
} from "../services/dashboard";
import type { KPIData, PlanRow, DailyData, Transaction, ProductFilter, ComparisonData, CountryRow, ChartDataResult, ChartTimeRange, AtRiskUser, DelayedUser, CancelledUser, CancelledByDay, RenewalSummary } from "../services/dashboard";

export interface DashboardState {
  kpis:          KPIData        | null;
  plans:         PlanRow[];
  daily:         DailyData      | null;
  transactions:  Transaction[];
  comparison:    ComparisonData | null;
  countries:     CountryRow[];
  chartData:     ChartDataResult | null;
  atRiskUsers:     AtRiskUser[];
  delayedUsers:    DelayedUser[];
  cancelledUsers:  CancelledUser[];
  cancelledByDay:  CancelledByDay[];
  renewalSummary:  RenewalSummary | null;
  loading:         boolean;
  error:         string | null;
  lastRefresh:   Date | null;
}

const EMPTY: DashboardState = {
  kpis: null, plans: [], daily: null, transactions: [], comparison: null, countries: [],
  chartData: null, atRiskUsers: [], delayedUsers: [], cancelledUsers: [], cancelledByDay: [], renewalSummary: null, loading: true, error: null, lastRefresh: null,
};

export function useDashboardData(date: Date, filter: ProductFilter = "todos") {
  const [state, setState] = useState<DashboardState>(EMPTY);
  const [chartRange, setChartRange] = useState<ChartTimeRange>("hoy");
  // Evita que una carga vieja (p. ej. disparada por un cambio de Realtime)
  // sobrescriba con datos obsoletos el resultado de una carga más nueva que
  // resolvió primero — los números "saltaban" al llegar fuera de orden.
  const requestIdRef = useRef(0);

  const load = useCallback(async () => {
    const requestId = ++requestIdRef.current;
    setState(s => ({ ...s, loading: true, error: null }));
    try {
      // Esperar a que las tasas de cambio estén cargadas antes de convertir
      await ensureRatesLoaded();
      const [kpis, plans, daily, transactions, comparison, countries, chartData, atRiskUsers, delayedUsers, cancelledUsers, cancelledByDay, renewalSummary] = await Promise.all([
        getKPIs(filter),
        getPlansBreakdown(filter),
        getDailyMetrics(date, filter),
        getDayTransactions(date, filter),
        getComparisonData(date),
        getTopCountries(filter),
        getChartData(date, "hoy", filter),
        getAtRiskUsers(filter),
        getDelayedUsers(filter),
        getCancelledUsers(filter),
        getCancelledByDay(filter),
        getRenewalSummary(filter),
      ]);
      if (requestId !== requestIdRef.current) return;
      setState({ kpis, plans, daily, transactions, comparison, countries, chartData, atRiskUsers, delayedUsers, cancelledUsers, cancelledByDay, renewalSummary, loading: false, error: null, lastRefresh: new Date() });
    } catch (e) {
      if (requestId !== requestIdRef.current) return;
      setState(s => ({ ...s, loading: false, error: String(e) }));
    }
  }, [date, filter]);

  // Cambiar rango del chart sin recargar todo (solo recarga chart)
  const loadChart = useCallback(async (range: ChartTimeRange) => {
    setChartRange(range);
    try {
      const chartData = await getChartData(date, range, filter);
      setState(s => ({ ...s, chartData }));
    } catch { /* silently fail, will show empty */ }
  }, [date, filter]);

  // Cargar transacciones por rango de fechas (para calendario)
  const loadTransactionsByRange = useCallback(async (startDate: Date, endDate: Date) => {
    try {
      await ensureRatesLoaded();
      const transactions = await getTransactionsByDateRange(startDate, endDate, filter);
      setState(s => ({ ...s, transactions }));
    } catch { /* silently fail */ }
  }, [filter]);

  useEffect(() => { load(); }, [load]);

  useEffect(() => {
    // Varios cambios seguidos (p. ej. Hotmart reintentando webhooks) disparaban
    // una recarga completa por cada evento; se agrupan en una sola recarga
    // 800ms después del último evento para evitar el parpadeo del dashboard.
    let debounceTimer: ReturnType<typeof setTimeout> | undefined;
    const scheduleReload = () => {
      clearTimeout(debounceTimer);
      debounceTimer = setTimeout(load, 800);
    };
    const channel = supabase
      .channel("aivi-realtime")
      .on("postgres_changes", { event: "*", schema: "public", table: "transactions"  }, scheduleReload)
      .on("postgres_changes", { event: "*", schema: "public", table: "daily_metrics"  }, scheduleReload)
      .on("postgres_changes", { event: "*", schema: "public", table: "subscriptions"  }, scheduleReload)
      .subscribe();
    return () => { clearTimeout(debounceTimer); supabase.removeChannel(channel); };
  }, [load]);

  return { ...state, refresh: load, loadChart, chartRange, loadTransactionsByRange };
}
