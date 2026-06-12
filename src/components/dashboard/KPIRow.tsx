import { DollarSign, BarChart2, TrendingUp, Users, Clock } from "lucide-react";
import type { ReactNode } from "react";
import { C } from "../../tokens";
import type { KPIData, DailyData } from "../../services/dashboard";
import { useResponsive } from "../../hooks/useResponsive";

interface KPICardProps {
  icon: ReactNode; label: string; value: ReactNode;
  valueColor: string; sub?: string; hero?: boolean;
  compact?: boolean;
}

function KPICard({ icon, label, value, valueColor, sub, hero, compact }: KPICardProps) {
  return (
    <div style={{
      background: hero ? C.gradCard : C.card,
      border: `1px solid ${hero ? "transparent" : C.border}`,
      borderRadius: compact ? 12 : 16,
      padding: compact ? "12px 14px" : "16px 18px",
      display: "flex", flexDirection: "column", gap: compact ? 3 : 5,
      flex: 1,
      minWidth: 0,
      boxShadow: hero
        ? "0 0 0 1px rgba(255,255,255,0.10) inset, 0 0 30px rgba(255,107,44,0.20), 0 12px 40px rgba(255,107,44,0.30), 0 4px 12px rgba(0,0,0,0.4)"
        : "0 2px 0 0 rgba(255,255,255,0.035) inset, 0 8px 24px rgba(0,0,0,0.25), 0 2px 8px rgba(0,0,0,0.2)",
      transition: "all 0.25s cubic-bezier(.4,0,.2,1)",
    }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
        <span style={{
          fontSize: compact ? 8 : 9, fontWeight: 800,
          color: hero ? "rgba(255,255,255,0.65)" : C.mutedLight,
          letterSpacing: "0.1em", textTransform: "uppercase",
        }}>{label}</span>
        <span style={{ color: hero ? "rgba(255,255,255,0.45)" : valueColor, opacity: hero ? 1 : 0.5, display: "flex", flexShrink: 0 }}>
          {icon}
        </span>
      </div>
      <div style={{
        fontSize: compact ? 20 : 30, fontWeight: 900,
        color: hero ? "#fff" : valueColor,
        lineHeight: 1, letterSpacing: "-0.03em",
        overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
      }}>{value}</div>
      {sub && <div style={{ fontSize: compact ? 9 : 10, color: hero ? "rgba(255,255,255,0.55)" : C.muted }}>{sub}</div>}
    </div>
  );
}

interface KPIRowProps {
  kpis:         KPIData   | null;
  daily:        DailyData | null;
  weekRevenue:  number;
  monthRevenue: number;
}

export function KPIRow({ kpis, daily, weekRevenue, monthRevenue }: KPIRowProps) {
  const { isMobile, isTablet } = useResponsive();

  const fmt  = (n: number) => {
    const parts = n.toFixed(2).split(".");
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return `$${parts.join(".")}`;
  };
  const fmtShort = (n: number) =>
    n >= 1000
      ? `$${(n / 1000).toFixed(1)}k`
      : `$${n.toFixed(0)}`;
  const roas = kpis?.roas ?? 0;
  const compact = isMobile;
  const iconSize = compact ? 16 : 20;

  // Grid columns: mobile 2-col, tablet 3-col, desktop 5-col
  const gridCols = isMobile
    ? "repeat(2, 1fr)"
    : isTablet
      ? "repeat(3, 1fr)"
      : "1.4fr 1fr 1fr 1fr 1fr";

  return (
    <div style={{
      display: "grid",
      gridTemplateColumns: gridCols,
      gap: isMobile ? 8 : 10,
      padding: isMobile ? "8px 12px" : "10px 24px",
      flexShrink: 0,
    }}>
      <KPICard icon={<DollarSign size={iconSize}/>} label="Facturación Bruta"
        value={fmt(kpis?.grossRevenue ?? 0)} valueColor={C.green} hero compact={compact}
        sub={
          weekRevenue > 0
            ? `${kpis?.monthsActive ?? 0} meses · sem ${fmtShort(weekRevenue)} · mes ${fmtShort(monthRevenue)}`
            : `${kpis?.monthsActive ?? 0} ${(kpis?.monthsActive ?? 0) === 1 ? "mes" : "meses"} activo`
        }
      />
      <KPICard icon={<BarChart2 size={iconSize}/>}  label="Inversión Total"    value={fmt(kpis?.investment ?? 0)}   valueColor={C.yellow} compact={compact} />
      <KPICard icon={<TrendingUp size={iconSize}/>} label="ROAS"               value={`${roas.toFixed(2)}x`}        valueColor={C.yellow} sub="Ingresos / Inversión" compact={compact} />
      <KPICard
        icon={<Users size={iconSize}/>} label="Activos / Cancel"
        value={<span>
          <span style={{ color: C.green }}>{kpis?.activeTotal ?? 0}</span>
          <span style={{ color: C.muted, fontSize: compact ? 16 : 22, margin: "0 4px" }}>/</span>
          <span style={{ color: C.red }}>{kpis?.cancelled ?? 0}</span>
        </span>}
        valueColor={C.green}
        sub={
          (daily?.newUsers ?? 0) > 0
            ? `+${daily!.newUsers} nuevos hoy`
            : undefined
        }
        compact={compact}
      />
      <KPICard icon={<Clock size={iconSize}/>} label="Atrasados" value={kpis?.delayed ?? 0} valueColor={C.yellow} sub="Pagos pendientes" compact={compact} />
    </div>
  );
}
