import { useState }            from "react";
import { useClock }            from "../hooks/useClock";
import { useDashboardData }    from "../hooks/useDashboardData";
import { Sidebar }             from "../components/layout/Sidebar";
import { TopNav }              from "../components/dashboard/TopNav";
import { KPIRow }              from "../components/dashboard/KPIRow";
import { UsersTable }          from "../components/dashboard/UsersTable";
import { DailyPanel }          from "../components/dashboard/DailyPanel";
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
  const [date,  setDate]      = useState(() => new Date());
  const [filter, setFilter]   = useState<ProductFilter>("todos");

  const { kpis, plans, daily, transactions, countries, chartData, atRiskUsers, loading, error, refresh, loadChart, chartRange, loadTransactionsByRange } =
    useDashboardData(date, filter);

  if (error) {
    return (
      <div style={{ height: "100vh", display: "flex", alignItems: "center", justifyContent: "center", background: C.bg }}>
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

  return (
    <div style={{ display: "flex", height: "100vh", background: C.bg, overflow: "hidden" }}>
      <Sidebar
        filter={filter}
        onFilter={setFilter}
        onSettings={onSettings}
        mrr={kpis?.mrr ?? 0}
        arr={kpis?.arr ?? 0}
      />

      <div style={{ marginLeft: 220, flex: 1, display: "flex", flexDirection: "column", overflow: "hidden", position: "relative" }}>
        {loading && (
          <div style={{
            position: "absolute", top: 0, left: 0, right: 0, height: 2, zIndex: 999,
            background: `linear-gradient(90deg, ${C.orange}, ${C.yellow}, ${C.orange})`,
          }} />
        )}

        <TopNav time={time} adsOn={adsOn} onAdsToggle={() => setAdsOn(!adsOn)} />

        <KPIRow kpis={kpis} />

        {/* Sección principal: Usuarios + Resumen + Seguimiento (expandida) */}
        <div style={{
          display: "grid", gridTemplateColumns: "1fr 240px 340px",
          gap: 10, padding: "0 24px", flex: 1, minHeight: 0, overflow: "hidden",
        }}>
          <UsersTable plans={plans} kpis={kpis} />
          <DailyPanel date={date} daily={daily} onDateChange={setDate} />
          <AtRiskPanel users={atRiskUsers} />
        </div>

        {/* Sección inferior: Ingresos + Países + Transacciones (compacta) */}
        <div style={{
          display: "grid", gridTemplateColumns: "1fr 260px 270px",
          gap: 10, padding: "10px 24px 0", flexShrink: 0,
          maxHeight: 280,
        }}>
          <ChartPanel chartData={chartData} chartRange={chartRange} onRangeChange={loadChart} />
          <CountriesPanel countries={countries ?? []} />
          <TransactionsPanel transactions={transactions} onDateRangeChange={loadTransactionsByRange} />
        </div>

        <DashFooter kpis={kpis} />
      </div>
    </div>
  );
}
