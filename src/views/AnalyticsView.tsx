import { useState, useMemo }          from "react";
import { Menu }                       from "lucide-react";
import { C, FONT }                    from "../tokens";
import { useAnalyticsData }           from "../hooks/useAnalyticsData";
import { useResponsive }              from "../hooks/useResponsive";
import { Sidebar }                    from "../components/layout/Sidebar";
import { MobileBottomNav }            from "../components/layout/MobileBottomNav";
import { AlertsPanel }                from "../components/analytics/AlertsPanel";
import { KPISummary }                 from "../components/analytics/KPISummary";
import { CampaignFunnelCard }         from "../components/analytics/CampaignFunnelCard";
import { AdRankingTable }             from "../components/analytics/AdRankingTable";
import { VSLSelectorBar }             from "../components/analytics/VSLSelectorBar";
import { VSLIntelligencePanel }       from "../components/analytics/VSLIntelligencePanel";
import { HourlyHeatmap }              from "../components/analytics/HourlyHeatmap";
import { LTVTable }                   from "../components/analytics/LTVTable";
import { ProductRevenueTable }        from "../components/analytics/ProductRevenueTable";
import { CampaignMappingModal }       from "../components/analytics/CampaignMappingModal";
import { AIAnalyst }                  from "../components/analytics/AIAnalyst";
import { DateRangePicker }            from "../components/analytics/DateRangePicker";
import { InfoTooltip }                from "../components/analytics/InfoTooltip";
import type { AppView }               from "../types";
import type { AnalyticsSummary } from "../services/analytics";

interface Props {
  onDashboard:    () => void;
  onUsers:        () => void;
  onTransactions: () => void;
  onSettings:     () => void;
  onSignOut:      () => void;
  onEventos?:     () => void;
  activeView:     AppView;
  isAdmin:        boolean;
  allowedSections?: AppView[];
}

export function AnalyticsView({ onDashboard, onUsers, onTransactions, onSettings, onSignOut, onEventos, activeView, isAdmin, allowedSections = [] }: Props) {
  const {
    summary, funnel, vsls, adRanking, heatmap, ltv, alerts, mappings, productRevenue,
    loading, error, period, setPeriod, refresh, aiResult, aiLoading, runAIAnalysis,
    selectedVslId, compareVslId, setSelectedVsl, setCompareVsl, range,
  } = useAnalyticsData();

  const [cacTarget,    setCacTarget]    = useState(50);
  const [ticketMin,    setTicketMin]    = useState(0);
  const [mappingOpen,  setMappingOpen]  = useState(false);
  const [sidebarOpen,  setSidebarOpen]  = useState(false);

  const { isMobile, isTablet } = useResponsive();
  const isMobileLayout = isMobile || isTablet;

  const SIDEBAR_W = 220;
  const sidebarWidth = isMobileLayout ? 0 : SIDEBAR_W;
  const px = isMobile ? 12 : 24;

  const filteredFunnel  = useMemo(
    () => selectedVslId ? funnel.filter(f => f.videoId === selectedVslId) : funnel,
    [funnel, selectedVslId],
  );

  const filteredAdRanking = useMemo(
    () => selectedVslId ? adRanking.filter(a => a.videoId === selectedVslId) : adRanking,
    [adRanking, selectedVslId],
  );

  const selectedVsl = useMemo(
    () => vsls.find(v => v.videoId === selectedVslId) ?? null,
    [vsls, selectedVslId],
  );

  const compareVsl = useMemo(
    () => compareVslId ? vsls.find(v => v.videoId === compareVslId) ?? null : null,
    [vsls, compareVslId],
  );

  const filteredSummary = useMemo((): AnalyticsSummary | null => {
    if (!selectedVslId || !summary) return summary;
    const investment = filteredFunnel.reduce((s, f) => s + f.investment, 0);
    const revenue    = filteredFunnel.reduce((s, f) => s + f.revenue, 0);
    const salesCount = filteredFunnel.reduce((s, f) => s + f.sales, 0);
    const plays      = filteredFunnel.reduce((s, f) => s + f.plays, 0);
    return {
      investment,
      revenue,
      roi:         investment > 0 ? (revenue - investment) / investment : 0,
      cac:         salesCount > 0 ? investment / salesCount : 0,
      sales:       salesCount,
      plays,
      playRate:    summary.playRate,
      costPerPlay: plays > 0 ? investment / plays : 0,
    };
  }, [selectedVslId, filteredFunnel, summary]);

  const filteredLtv = useMemo(
    () => selectedVslId ? ltv.filter(l => l.videoId === selectedVslId) : ltv,
    [ltv, selectedVslId],
  );

  const filteredHeatmap = useMemo(() => {
    if (!selectedVslId) return heatmap;
    return heatmap
      .map(c => {
        const match = c.byVideo.find(v => v.videoId === selectedVslId);
        return { ...c, value: match?.value ?? 0, bySource: match?.bySource ?? [] };
      })
      .filter(c => c.value > 0);
  }, [heatmap, selectedVslId]);

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
        onEventos={onEventos}
        activeView={activeView}
        mrr={0} arr={0}
        isAdmin={isAdmin}
        allowedSections={allowedSections}
        width={sidebarWidth || undefined}
        open={sidebarOpen}
        onClose={() => setSidebarOpen(false)}
        isMobile={isMobileLayout}
      />

      <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden", marginLeft: sidebarWidth }}>

        <div style={{
          display: "flex", alignItems: "center", justifyContent: "space-between",
          padding: `10px ${px}px`, minHeight: 56, borderBottom: `1px solid ${C.border}`,
          background: C.nav, flexShrink: 0, flexWrap: "wrap", gap: 12,
        }}>
          <div style={{ display: "flex", alignItems: "center", gap: 10, minWidth: 0 }}>
            {isMobileLayout && (
              <button
                onClick={() => setSidebarOpen(true)}
                aria-label="Abrir menú"
                style={{
                  background: "none", border: "none", color: C.mutedLight,
                  padding: 4, display: "flex", alignItems: "center",
                  justifyContent: "center", borderRadius: 8, flexShrink: 0,
                }}
              >
                <Menu size={20} />
              </button>
            )}
            <div style={{ fontSize: 15, fontWeight: 700, color: C.white }}>Analytics Command Center</div>
          </div>
          <div style={{ display: "flex", gap: 16, alignItems: "center", flexWrap: "wrap" }}>
            <div style={{ display: "flex", gap: 12, alignItems: "center" }}>
              <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
                <span style={{ fontSize: 11, color: C.mutedMid }}>CAC objetivo $</span>
                <input
                  type="number" value={cacTarget}
                  onChange={e => setCacTarget(Number(e.target.value))}
                  style={{
                    width: 64, background: C.bgSecondary,
                    border: `1px solid ${C.border}`, borderRadius: 6,
                    padding: "4px 8px", color: C.white, fontSize: 12,
                    fontFamily: "inherit",
                  }}
                />
              </div>
              <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
                <span style={{ fontSize: 11, color: C.mutedMid }}>Ticket mín. $</span>
                <input
                  type="number" value={ticketMin}
                  onChange={e => setTicketMin(Number(e.target.value))}
                  style={{
                    width: 64, background: C.bgSecondary,
                    border: `1px solid ${C.border}`, borderRadius: 6,
                    padding: "4px 8px", color: C.white, fontSize: 12,
                    fontFamily: "inherit",
                  }}
                />
              </div>
              <button
                onClick={() => setMappingOpen(true)}
                style={{
                  background: `rgba(254,128,63,0.12)`, border: `1px solid rgba(254,128,63,0.30)`,
                  color: C.orange, borderRadius: 8, padding: "4px 12px", fontSize: 12, cursor: "pointer",
                }}
              >
                Configurar VSLs
              </button>
            </div>
            <div style={{ display: "flex", gap: 8, alignItems: "center" }}>
              <DateRangePicker period={period} range={range} onSelect={setPeriod} />
              <button onClick={refresh} style={{
                background: "transparent", border: `1px solid ${C.border}`,
                borderRadius: 20, padding: "4px 12px", fontSize: 12, color: C.mutedMid, cursor: "pointer",
              }}>↺</button>
            </div>
          </div>
        </div>

        {vsls.length > 0 && (
          <VSLSelectorBar
            vsls={vsls}
            selectedId={selectedVslId}
            compareId={compareVslId}
            onSelect={setSelectedVsl}
            onCompare={setCompareVsl}
          />
        )}

        <main style={{ flex: 1, overflowY: "auto", padding: `20px ${px}px`, paddingBottom: isMobile ? 64 : 20, display: "flex", flexDirection: "column", gap: 20 }}>

          {error && (
            <div style={{ background: "rgba(255,65,59,0.1)", border: "1px solid #FF413B", borderRadius: 10, padding: 14, fontSize: 13, color: "#FF413B" }}>
              Error al cargar datos: {error}
            </div>
          )}

          {alerts.length > 0 && <AlertsPanel alerts={alerts} />}

          <div>
            {selectedVslId && selectedVsl && (
              <div style={{ fontSize: 11, color: C.mutedMid, marginBottom: 8 }}>
                Filtrando por: <span style={{ color: C.orange, fontWeight: 700 }}>{selectedVsl.videoName}</span>
              </div>
            )}
            <KPISummary summary={filteredSummary} loading={loading} />
          </div>

          <VSLIntelligencePanel
            primary={selectedVsl}
            compare={compareVsl}
            range={range}
            adRanking={adRanking}
            cacTarget={cacTarget}
            ticketMin={ticketMin}
          />

          <AdRankingTable rows={filteredAdRanking} cacTarget={cacTarget} ticketMin={ticketMin} />

          {(loading || filteredFunnel.length > 0) && (
            <section>
              <div style={{ fontSize: 13, fontWeight: 600, color: C.white, marginBottom: 12 }}>
                Funnels por Campaña
                <InfoTooltip text="Cada tarjeta muestra el recorrido Impresiones → Clics → Plays del VSL → Clics en CTA → Compras para una campaña, con el % de conversión entre cada paso." />
                {selectedVslId && selectedVsl && (
                  <span style={{ fontSize: 11, color: C.mutedMid, fontWeight: 400, marginLeft: 8 }}>
                    · {selectedVsl.videoName}
                  </span>
                )}
              </div>
              {loading ? (
                <div style={{ height: 180, background: C.card, border: `1px solid ${C.border}`, borderRadius: 14 }} />
              ) : (
                <div style={{ display: "grid", gridTemplateColumns: `repeat(auto-fill, minmax(${isMobile ? 260 : 340}px, 1fr))`, gap: 16 }}>
                  {filteredFunnel.map(f => (
                    <CampaignFunnelCard
                      key={f.campaignName}
                      campaign={f}
                      ads={filteredAdRanking.filter(a => a.campaignName === f.campaignName)}
                    />
                  ))}
                </div>
              )}
            </section>
          )}

          <HourlyHeatmap cells={filteredHeatmap} />

          <LTVTable rows={filteredLtv} />

          <ProductRevenueTable rows={productRevenue} />

          <AIAnalyst result={aiResult} loading={aiLoading} onAnalyze={runAIAnalysis} />

        </main>
      </div>

      {isMobile && (
        <MobileBottomNav
          activeView="analytics"
          onDashboard={onDashboard}
          onUsers={onUsers}
          onTransactions={onTransactions}
          onSettings={onSettings}
          isAdmin={isAdmin}
          allowedSections={allowedSections}
          filter="todos"
          onFilter={() => {}}
        />
      )}

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
