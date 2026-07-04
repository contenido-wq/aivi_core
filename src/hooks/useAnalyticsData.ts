import { useState, useEffect, useCallback } from "react";
import {
  buildRange, previousRange,
  getAnalyticsSummary, getFunnelByCampaign, getVSLRetention,
  getAdsRanking, getHourlyHeatmap, getLTVBySource, generateAlerts,
  getVSLMappings,
} from "../services/analytics";
import type {
  PeriodKey, DateRange, AnalyticsSummary, FunnelCampaign, VSLData,
  AdRankRow, HeatmapCell, LTVRow, Alert, VSLMapping,
} from "../services/analytics";

export interface AnalyticsState {
  summary:  AnalyticsSummary | null;
  funnel:   FunnelCampaign[];
  vsls:     VSLData[];
  ranking:  AdRankRow[];
  heatmap:  HeatmapCell[];
  ltv:      LTVRow[];
  alerts:   Alert[];
  mappings: VSLMapping[];
  loading:  boolean;
  error:    string | null;
  range:    DateRange | null;
}

const EMPTY: AnalyticsState = {
  summary: null, funnel: [], vsls: [], ranking: [], heatmap: [],
  ltv: [], alerts: [], mappings: [], loading: true, error: null, range: null,
};

export function useAnalyticsData() {
  const [period,    setPeriodKey] = useState<PeriodKey>("hoy");
  const [custom,    setCustom]   = useState<{ from: string; to: string } | undefined>();
  const [state,     setState]    = useState<AnalyticsState>(EMPTY);
  const [aiResult,     setAiResult]    = useState<string | null>(null);
  const [aiLoading,    setAiLoading]   = useState(false);
  const [selectedVslId, setSelectedVslId] = useState<string | null>(null);
  const [compareVslId,  setCompareVslId]  = useState<string | null>(null);

  const load = useCallback(async () => {
    setState(s => ({ ...s, loading: true, error: null }));
    try {
      const r     = buildRange(period, custom);
      const rPrev = previousRange(r);

      const [summary, summaryPrev, funnel, vsls, ranking, heatmap, ltv, mappings] = await Promise.all([
        getAnalyticsSummary(r),
        getAnalyticsSummary(rPrev),
        getFunnelByCampaign(r),
        getVSLRetention(r),
        getAdsRanking(r),
        getHourlyHeatmap(r),
        getLTVBySource(),
        getVSLMappings(),
      ]);

      const summaryWithPrev: AnalyticsSummary = { ...summary, prev: summaryPrev };
      const alerts = generateAlerts(summaryWithPrev, funnel, vsls);

      setState({ summary: summaryWithPrev, funnel, vsls, ranking, heatmap, ltv, alerts, mappings, loading: false, error: null, range: r });
      setSelectedVslId(prev => prev ?? (vsls[0]?.videoId ?? null));
    } catch (e) {
      setState(s => ({ ...s, loading: false, error: String(e) }));
    }
  }, [period, custom]);

  useEffect(() => { load(); }, [load]);

  const setPeriod = useCallback((key: PeriodKey, c?: { from: string; to: string }) => {
    setCustom(c);
    setPeriodKey(key);
  }, []);

  const runAIAnalysis = useCallback(async () => {
    if (!state.summary) return;
    setAiLoading(true);
    setAiResult(null);
    try {
      const { getAIAnalysis } = await import("../services/analytics");
      const labels: Record<PeriodKey, string> = {
        hoy: "Hoy", ayer: "Ayer", hoyAyer: "Hoy y ayer",
        "7dias": "Últimos 7 días", "14dias": "Últimos 14 días", "28dias": "Últimos 28 días", "30dias": "Últimos 30 días",
        estaSemana: "Esta semana", semanaPasada: "La semana pasada",
        esteMes: "Este mes", mesPasado: "El mes pasado",
        maximo: "Máximo", custom: "Rango personalizado",
      };
      const result = await getAIAnalysis({ summary: state.summary, funnel: state.funnel, vsls: state.vsls, period: labels[period] });
      setAiResult(result);
    } catch (e) {
      setAiResult(`Error al generar análisis: ${String(e)}`);
    } finally {
      setAiLoading(false);
    }
  }, [state.summary, state.funnel, state.vsls, period]);

  return {
    ...state,
    period, setPeriod, refresh: load,
    aiResult, aiLoading, runAIAnalysis,
    selectedVslId, compareVslId,
    setSelectedVsl: setSelectedVslId,
    setCompareVsl:  setCompareVslId,
  };
}
