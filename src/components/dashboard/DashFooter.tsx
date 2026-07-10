import { C } from "../../tokens";
import { useResponsive } from "../../hooks/useResponsive";
import type { KPIData } from "../../services/dashboard";

interface DashFooterProps { kpis: KPIData | null; }

export function DashFooter({ kpis }: DashFooterProps) {
  const { isMobile } = useResponsive();
  const mrr   = kpis?.mrr ?? 0;
  const arr   = mrr * 12;
  const valLo = arr * 2;
  const valHi = arr * 2.4;
  const fmt   = (n: number) => {
    const parts = n.toFixed(2).split(".");
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return `$${parts.join(".")}`;
  };

  return (
    <footer className="dash-footer-safe" style={{
      background: C.sidebar,
      borderTop: `1px solid ${C.border}`,
      padding: isMobile ? "8px 12px" : "8px 24px",
      display: "flex", alignItems: "center", justifyContent: "space-between",
      flexShrink: 0,
      flexWrap: "wrap",
      gap: isMobile ? 8 : 0,
    }}>
      <div style={{ display: "flex", gap: isMobile ? 16 : 28, alignItems: "center", flexWrap: "wrap" }}>
        {(isMobile
          ? [["MRR", fmt(mrr), C.green], ["ARR", fmt(arr), C.green]]
          : [["MRR", fmt(mrr), C.green], ["ARR", fmt(arr), C.green], ["Valuación", `${fmt(valLo)} – ${fmt(valHi)}`, C.yellow]]
        ).map(([lbl, val, col]) => (
          <div key={lbl}>
            <div style={{ fontSize: 10, fontWeight: 700, color: C.muted, textTransform: "uppercase", letterSpacing: "0.06em" }}>{lbl}</div>
            <div style={{ fontSize: isMobile ? 13 : 16, fontWeight: 900, color: col, letterSpacing: "-0.02em", marginTop: 1 }}>{val}</div>
          </div>
        ))}
      </div>
      <div style={{ display: "flex", alignItems: "center", gap: 6, fontSize: 10, color: C.mutedLight, fontWeight: 600 }}>
        <span style={{ width: 7, height: 7, borderRadius: "50%", background: C.green, display: "inline-block", animation: "pulse-dot 2s ease-in-out infinite" }} />
        AIVI CORE
      </div>
    </footer>
  );
}
