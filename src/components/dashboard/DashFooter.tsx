import { C } from "../../tokens";
import type { KPIData } from "../../services/dashboard";

interface DashFooterProps { kpis: KPIData | null; }

export function DashFooter({ kpis }: DashFooterProps) {
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
    <footer style={{
      background: C.sidebar,
      borderTop: `1px solid ${C.border}`,
      padding: "8px 24px",
      display: "flex", alignItems: "center", justifyContent: "space-between",
      flexShrink: 0,
    }}>
      <div style={{ display: "flex", gap: 28, alignItems: "center" }}>
        {[
          ["MRR",       fmt(mrr),               C.green],
          ["ARR",       fmt(arr),               C.green],
          ["Valuación", `${fmt(valLo)} – ${fmt(valHi)}`, C.yellow],
        ].map(([lbl, val, col]) => (
          <div key={lbl}>
            <div style={{ fontSize: 9, fontWeight: 700, color: C.muted, textTransform: "uppercase", letterSpacing: "0.06em" }}>{lbl}</div>
            <div style={{ fontSize: 16, fontWeight: 900, color: col, letterSpacing: "-0.02em", marginTop: 1 }}>{val}</div>
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
