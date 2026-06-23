import { useState } from "react";
import { C, FONT } from "../tokens";
import { useAnalyticsData } from "../hooks/useAnalyticsData";
import { Sidebar }              from "../components/layout/Sidebar";
import { AlertsPanel }          from "../components/analytics/AlertsPanel";
import { KPISummary }           from "../components/analytics/KPISummary";
import { CampaignFunnelCard }   from "../components/analytics/CampaignFunnelCard";
import { VSLComparator }        from "../components/analytics/VSLComparator";
import { AdsRankingTable }      from "../components/analytics/AdsRankingTable";
import { HourlyHeatmap }        from "../components/analytics/HourlyHeatmap";
import { LTVTable }             from "../components/analytics/LTVTable";
import { CampaignMappingModal } from "../components/analytics/CampaignMappingModal";
import { AIAnalyst }            from "../components/analytics/AIAnalyst";
import type { AppView }         from "../types";
import type { PeriodKey }       from "../services/analytics";

interface Props {
  onDashboard:    () => void;
  onUsers:        () => void;
  onTransactions: () => void;
  onSettings:     () => void;
  onSignOut:      () => void;
  activeView:     AppView;
  isAdmin:        boolean;
}

const PERIOD_LABELS: Record<PeriodKey, string> = {
  noche:  "Noche",
  dia:    "Día",
  hoy:    "Hoy",
  ayer:   "Ayer",
  "7dias": "7 días",
  custom: "Custom",
};

export function AnalyticsView({ onDashboard, onUsers, onTransactions, onSettings, onSignOut, activeView, isAdmin }: Props) {
  const {
    summary, funnel, vsls, ranking, heatmap, ltv, alerts, mappings,
    loading, error, period, setPeriod, refresh, aiResult, aiLoading, runAIAnalysis,
  } = useAnalyticsData();

  const [cacTarget,   setCacTarget]   = useState(50);
  const [mappingOpen, setMappingOpen] = useState(false);

  const SIDEBAR_W = 220;

  return (
    <div style={{ display: "flex", height: "100vh", background: C.bg, fontFamily: FONT, color: C.white, overflow: "hidden" }}>
      <Sidebar
        filter="todos"
        onFilter={() => {}}
        onSettings={onSettings}
        onSignOut={onSignOut}
        onDashboard={onDashboard}
        onUsers={onUsers}
        onTransactions={onTransactions}
        onAnalytics={() => {}}
        activeView={activeView}
        mrr={0}
        arr={0}
        isAdmin={isAdmin}
        width={SIDEBAR_W}
      />

      <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden", marginLeft: SIDEBAR_W }}>
        {/* Header simple */}
        <div style={{
          display: "flex", alignItems: "center", justifyContent: "space-between",
          padding: "0 24px", height: 56, borderBottom: `1px solid ${C.border}`,
          background: C.nav, flexShrink: 0,
        }}>
          <div style={{ fontSize: 15, fontWeight: 700, color: C.white }}>Analytics Command Center</div>
          <div style={{ display: "flex", gap: 8, alignItems: "center" }}>
            {/* Selector de período */}
            {(["noche", "dia", "hoy", "ayer", "7dias"] as PeriodKey[]).map(key => (
              <button key={key} onClick={() => setPeriod(key)} style={{
                background: period === key ? C.orange : "transparent",
                border: `1px solid ${period === key ? C.orange : C.border}`,
                borderRadius: 20, padding: "4px 14px", fontSize: 12,
                fontWeight: period === key ? 600 : 400,
                color: period === key ? C.white : C.mutedLight, cursor: "pointer",
              }}>
                {PERIOD_LABELS[key]}
              </button>
            ))}
            <button onClick={refresh} style={{
              background: "transparent", border: `1px solid ${C.border}`,
              borderRadius: 20, padding: "4px 12px", fontSize: 12, color: C.mutedMid, cursor: "pointer",
            }}>↺</button>
          </div>
        </div>

        {/* Contenido principal */}
        <main style={{ flex: 1, overflowY: "auto", padding: "20px 24px", display: "flex", flexDirection: "column", gap: 20 }}>

          {error && (
            <div style={{ background: "rgba(255,65,59,0.1)", border: "1px solid #FF413B", borderRadius: 10, padding: 14, fontSize: 13, color: "#FF413B" }}>
              Error al cargar datos: {error}
            </div>
          )}

          {/* Bloque 8 — Alertas (primero para verlas de inmediato) */}
          {alerts.length > 0 && <AlertsPanel alerts={alerts} />}

          {/* Bloque 2 — KPIs */}
          <KPISummary summary={summary} loading={loading} />

          {/* Bloque 3 — Funnels por campaña */}
          {(loading || funnel.length > 0) && (
            <section>
              <div style={{ fontSize: 13, fontWeight: 600, color: C.white, marginBottom: 12 }}>Funnels por Campaña</div>
              {loading ? (
                <div style={{ height: 180, background: C.card, border: `1px solid ${C.border}`, borderRadius: 14 }} />
              ) : (
                <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(340px, 1fr))", gap: 16 }}>
                  {funnel.map(f => <CampaignFunnelCard key={f.campaignName} campaign={f} />)}
                </div>
              )}
            </section>
          )}

          {/* Bloque 4 — Comparador de VSLs */}
          <VSLComparator vsls={vsls} />

          {/* Bloque 5 — Tabla de anuncios */}
          <AdsRankingTable
            rows={ranking}
            cacTarget={cacTarget}
            onCacTargetChange={setCacTarget}
            onOpenMapping={() => setMappingOpen(true)}
          />

          {/* Bloque 6 — Heatmap horario */}
          <HourlyHeatmap cells={heatmap} />

          {/* Bloque 7 — LTV por fuente */}
          <LTVTable rows={ltv} />

          {/* Bloque 9 — IA Analyst */}
          <AIAnalyst result={aiResult} loading={aiLoading} onAnalyze={runAIAnalysis} />

        </main>
      </div>

      <CampaignMappingModal
        open={mappingOpen}
        onClose={() => setMappingOpen(false)}
        mappings={mappings}
        campaigns={funnel.map(f => f.campaignName)}
        onSaved={() => { setMappingOpen(false); refresh(); }}
      />
    </div>
  );
}
