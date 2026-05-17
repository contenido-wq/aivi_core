import { DollarSign, BarChart2, TrendingUp, Users, Clock } from "lucide-react";
import type { CSSProperties, ReactNode } from "react";
import { C } from "../../tokens";
import type { KPIData } from "../../services/dashboard";

interface KPICardProps {
  icon: ReactNode; label: string; value: ReactNode;
  valueColor: string; sub?: string; hero?: boolean;
}

function KPICard({ icon, label, value, valueColor, sub, hero }: KPICardProps) {
  return (
    <div style={{
      background: hero ? C.gradCard : C.card,
      border: `1px solid ${hero ? "transparent" : C.border}`,
      borderRadius: 16,
      padding: "16px 18px",
      display: "flex", flexDirection: "column", gap: 5,
      flex: 1,
      boxShadow: hero
        ? "0 8px 32px rgba(254,128,63,0.35), 0 2px 8px rgba(0,0,0,0.3)"
        : "0 2px 0 0 rgba(255,255,255,0.03) inset, 0 8px 24px rgba(0,0,0,0.5), 0 2px 8px rgba(0,0,0,0.3)",
      transition: "all 0.25s cubic-bezier(.4,0,.2,1)",
    }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
        <span style={{
          fontSize: 9, fontWeight: 800,
          color: hero ? "rgba(255,255,255,0.65)" : C.mutedLight,
          letterSpacing: "0.1em", textTransform: "uppercase",
        }}>{label}</span>
        <span style={{ color: hero ? "rgba(255,255,255,0.45)" : valueColor, opacity: hero ? 1 : 0.5, display: "flex" }}>
          {icon}
        </span>
      </div>
      <div style={{
        fontSize: 30, fontWeight: 900,
        color: hero ? "#fff" : valueColor,
        lineHeight: 1, letterSpacing: "-0.03em",
      }}>{value}</div>
      {sub && <div style={{ fontSize: 10, color: hero ? "rgba(255,255,255,0.55)" : C.muted }}>{sub}</div>}
    </div>
  );
}

interface KPIRowProps { kpis: KPIData | null; }

export function KPIRow({ kpis }: KPIRowProps) {
  const fmt  = (n: number) => {
    const parts = n.toFixed(2).split(".");
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return `$${parts.join(".")}`;
  };
  const roas = kpis?.roas ?? 0;
  const s: CSSProperties = {
    display: "grid", gridTemplateColumns: "1.4fr 1fr 1fr 1fr 1fr",
    gap: 10, padding: "10px 24px", flexShrink: 0,
  };
  return (
    <div style={s}>
      <KPICard icon={<DollarSign size={20}/>} label="Facturación Bruta"
        value={fmt(kpis?.grossRevenue ?? 0)} valueColor={C.green} hero
        sub={`${kpis?.monthsActive ?? 0} ${(kpis?.monthsActive ?? 0) === 1 ? "mes" : "meses"} activo`}
      />
      <KPICard icon={<BarChart2 size={20}/>}  label="Inversión Total"    value={fmt(kpis?.investment ?? 0)}   valueColor={C.yellow} />
      <KPICard icon={<TrendingUp size={20}/>} label="ROAS"               value={`${roas.toFixed(2)}x`}        valueColor={C.yellow} sub="Ingresos / Inversión" />
      <KPICard
        icon={<Users size={20}/>} label="Activos / Cancel"
        value={<span>
          <span style={{ color: C.green }}>{kpis?.activeTotal ?? 0}</span>
          <span style={{ color: C.muted, fontSize: 22, margin: "0 4px" }}>/</span>
          <span style={{ color: C.red }}>{kpis?.cancelled ?? 0}</span>
        </span>}
        valueColor={C.green}
      />
      <KPICard icon={<Clock size={20}/>} label="Atrasados" value={kpis?.delayed ?? 0} valueColor={C.yellow} sub="Pagos pendientes" />
    </div>
  );
}
