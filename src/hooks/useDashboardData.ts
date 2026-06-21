import { useState, useEffect, useCallback } from "react";
import { supabase } from "../services/supabase";
import { ensureRatesLoaded } from "../services/currency";
import {
  getKPIs, getPlansBreakdown, getDailyMetrics, getDayTransactions, getComparisonData, getTopCountries, getChartData, getTransactionsByDateRange, getAtRiskUsers, getDelayedUsers, getCancelledUsers, getCancelledByDay,
} from "../services/dashboard";
import type { KPIData, PlanRow, DailyData, Transaction, ProductFilter, ComparisonData, CountryRow, ChartDataResult, ChartTimeRange, AtRiskUser, DelayedUser, CancelledUser, CancelledByDay } from "../services/dashboard";

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
  loading:         boolean;
  error:         string | null;
  lastRefresh:   Date | null;
}

const EMPTY: DashboardState = {
  kpis: null, plans: [], daily: null, transactions: [], comparison: null, countries: [],
  chartData: null, atRiskUsers: [], delayedUsers: [], cancelledUsers: [], cancelledByDay: [], loading: true, error: null, lastRefresh: null,
};

export function useDashboardData(date: Date, filter: ProductFilter = "todos") {
  const [state, setState] = useState<DashboardState>(EMPTY);
  const [chartRange, setChartRange] = useState<ChartTimeRange>("hoy");

  const load = useCallback(async () => {
    setState(s => ({ ...s, loading: true, error: null }));
    try {
      // Esperar a que las tasas de cambio estén cargadas antes de convertir
      await ensureRatesLoaded();
      const [kpis, plans, daily, transactions, comparison, countries, chartData, atRiskUsers, delayedUsers, cancelledUsers, cancelledByDay] = await Promise.all([
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
      ]);
      setState({ kpis, plans, daily, transactions, comparison, countries, chartData, atRiskUsers, delayedUsers, cancelledUsers, cancelledByDay, loading: false, error: null, lastRefresh: new Date() });
    } catch (e) {
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
    const channel = supabase
      .channel("aivi-realtime")
      .on("postgres_changes", { event: "*", schema: "public", table: "transactions"  }, () => { load(); })
      .on("postgres_changes", { event: "*", schema: "public", table: "daily_metrics"  }, () => { load(); })
      .on("postgres_changes", { event: "*", schema: "public", table: "subscriptions"  }, () => { load(); })
      .subscribe();
    return () => { supabase.removeChannel(channel); };
  }, [load]);

  return { ...state, refresh: load, loadChart, chartRange, loadTransactionsByRange };
}
