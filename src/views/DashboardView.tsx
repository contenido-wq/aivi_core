import { useState }            from "react";
import { useClock }            from "../hooks/useClock";
import { useDashboardData }    from "../hooks/useDashboardData";
import { useResponsive }       from "../hooks/useResponsive";
import { Sidebar }             from "../components/layout/Sidebar";
import { TopNav }              from "../components/dashboard/TopNav";
import { KPIRow }              from "../components/dashboard/KPIRow";
import { UsersTable }          from "../components/dashboard/UsersTable";
import { ChartPanel }          from "../components/dashboard/ChartPanel";
import { TransactionsPanel }   from "../components/dashboard/TransactionsPanel";
import { CountriesPanel }      from "../components/dashboard/CountriesPanel";
import { AtRiskPanel }         from "../components/dashboard/AtRiskPanel";
import { DashFooter }          from "../components/dashboard/DashFooter";
import { C }                   from "../tokens";
import type { ProductFilter }  from "../services/dashboard";

interface DashboardViewProps { onSettings: () => void; }

export function DashboardView({ onSettings }: DashboardViewProps) {
  const time                  = useClock();
  const [adsOn, setAdsOn]     = useState(false);
  const [date]                = useState(() => new Date());
  const [filter, setFilter]   = useState<ProductFilter>("todos");
  const [sidebarOpen, setSidebarOpen] = useState(false);

  const { isMobile, isTablet, isDesktop, isShortScreen } = useResponsive();

  const { kpis, plans, daily, transactions, countries, chartData, atRiskUsers, loading, error, refresh, loadChart, chartRange, loadTransactionsByRange } =
    useDashboardData(date, filter);

  if (error) {
    return (
      <div style={{ height: "100vh", display: "flex", alignItems: "center", justifyContent: "center", background: C.bg, padding: 24 }}>
        <div style={{ textAlign: "center" }}>
          <div style={{ fontSize: 14, color: C.red, marginBottom: 12 }}>Error conectando con Supabase</div>
          <div style={{ fontSize: 11, color: C.muted, maxWidth: 340 }}>{error}</div>
          <button onClick={refresh} style={{ marginTop: 16, padding: "8px 20px", background: C.orange, border: "none", borderRadius: 8, color: "#fff", fontWeight: 700 }}>
            Reintentar
          </button>
        </div>
      </div>
    );
  }

  // Padding values based on breakpoint
  const px = isMobile ? 12 : isTablet ? 16 : 24;

  return (
    <div style={{ display: "flex", height: "100vh", background: C.bg, overflow: "hidden" }}>
      <Sidebar
        filter={filter}
        onFilter={setFilter}
        onSettings={onSettings}
        mrr={kpis?.mrr ?? 0}
        arr={kpis?.arr ?? 0}
        daily={daily}
        open={sidebarOpen}
        onClose={() => setSidebarOpen(false)}
        isMobile={isMobile || isTablet}
      />

      <div style={{
        marginLeft: (isMobile || isTablet) ? 0 : 220,
        flex: 1,
        display: "flex",
        flexDirection: "column",
        overflow: "hidden",
        position: "relative",
        width: "100%",
      }}>
        {loading && (
          <div style={{
            position: "absolute", top: 0, left: 0, right: 0, height: 2, zIndex: 999,
            background: `linear-gradient(90deg, ${C.orange}, ${C.yellow}, ${C.orange})`,
          }} />
        )}

        <TopNav
          time={time}
          adsOn={adsOn}
          onAdsToggle={() => setAdsOn(!adsOn)}
          isMobile={isMobile || isTablet}
          onMenuOpen={() => setSidebarOpen(true)}
        />

        {isDesktop ? (
          isShortScreen ? (
            /* ═══════════════════════════════════════════════
               LAPTOP (desktop + pantalla corta ≤ 820px alto):
               layout scrollable para evitar compresión
               ═══════════════════════════════════════════════ */
            <div style={{ flex: 1, overflow: "auto", WebkitOverflowScrolling: "touch", display: "flex", flexDirection: "column" }}>
              <KPIRow kpis={kpis} />

              {/* Sección principal: Usuarios + At Risk lado a lado */}
              <div style={{
                display: "grid", gridTemplateColumns: "1fr 300px",
                gap: 10, padding: `0 ${px}px`,
                minHeight: 260,
              }}>
                <UsersTable plans={plans} kpis={kpis} />
                <AtRiskPanel users={atRiskUsers} />
              </div>

              {/* Sección inferior: Ingresos + Países + Transacciones */}
              <div style={{
                display: "grid", gridTemplateColumns: "1fr 260px 270px",
                gap: 10, padding: `10px ${px}px 0`, flexShrink: 0,
                height: 360,
              }}>
                <ChartPanel chartData={chartData} chartRange={chartRange} onRangeChange={loadChart} />
                <CountriesPanel countries={countries ?? []} />
                <TransactionsPanel transactions={transactions} onDateRangeChange={loadTransactionsByRange} />
              </div>

              <DashFooter kpis={kpis} />
            </div>
          ) : (
          /* ═══════════════════════════════════════════════
             DESKTOP TALL: layout original con flex fijo (no scroll)
             ═══════════════════════════════════════════════ */
          <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
            <KPIRow kpis={kpis} />

            {/* Sección principal: Usuarios + At Risk */}
            <div style={{
              display: "grid", gridTemplateColumns: "1fr 300px",
              gap: 10, padding: `0 ${px}px`, flex: 1, minHeight: 0, overflow: "hidden",
            }}>
              <UsersTable plans={plans} kpis={kpis} />
              <AtRiskPanel users={atRiskUsers} />
            </div>

            {/* Sección inferior: Ingresos + Países + Transacciones (altura automática) */}
            <div style={{
              display: "grid", gridTemplateColumns: "1fr 260px 270px",
              gap: 10, padding: `10px ${px}px 0`, flexShrink: 0,
              height: 380,
            }}>
              <ChartPanel chartData={chartData} chartRange={chartRange} onRangeChange={loadChart} />
              <CountriesPanel countries={countries ?? []} />
              <TransactionsPanel transactions={transactions} onDateRangeChange={loadTransactionsByRange} />
            </div>

            <DashFooter kpis={kpis} />
          </div>
          )
        ) : (
          /* ═══════════════════════════════════════════════
             MOBILE / TABLET: scrollable single column
             ═══════════════════════════════════════════════ */
          <div style={{
            flex: 1,
            overflow: "auto",
            WebkitOverflowScrolling: "touch",
            display: "flex",
            flexDirection: "column",
          }}>
            <KPIRow kpis={kpis} />

            {/* Sección principal */}
            <div style={{ padding: `0 ${px}px`, display: "flex", flexDirection: "column", gap: 10 }}>
              <UsersTable plans={plans} kpis={kpis} />
              <AtRiskPanel users={atRiskUsers} />
            </div>

            {/* Sección inferior */}
            {isTablet ? (
              <div style={{ padding: `10px ${px}px 0`, display: "flex", flexDirection: "column", gap: 10 }}>
                <ChartPanel chartData={chartData} chartRange={chartRange} onRangeChange={loadChart} />
                <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
                  <div style={{ maxHeight: 360, overflow: "hidden" }}>
                    <CountriesPanel countries={countries ?? []} />
                  </div>
                  <div style={{ maxHeight: 360, overflow: "hidden" }}>
                    <TransactionsPanel transactions={transactions} onDateRangeChange={loadTransactionsByRange} />
                  </div>
                </div>
              </div>
            ) : (
              <div style={{ padding: `10px ${px}px 0`, display: "flex", flexDirection: "column", gap: 10 }}>
                <ChartPanel chartData={chartData} chartRange={chartRange} onRangeChange={loadChart} />
                <CountriesPanel countries={countries ?? []} />
                <TransactionsPanel transactions={transactions} onDateRangeChange={loadTransactionsByRange} />
              </div>
            )}

            <DashFooter kpis={kpis} />
          </div>
        )}
      </div>
    </div>
  );
}
