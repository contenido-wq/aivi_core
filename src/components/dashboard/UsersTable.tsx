import { C } from "../../tokens";
import { Card } from "../ui/Card";
import { LiveBadge } from "../ui/LiveBadge";
import { useResponsive } from "../../hooks/useResponsive";
import type { PlanRow, KPIData } from "../../services/dashboard";

interface UsersTableProps { plans: PlanRow[]; kpis: KPIData | null; }

const PillBadge = ({ n, color }: { n: number; color: string }) =>
  n > 0
    ? <span style={{ display: "inline-block", padding: "1px 8px", borderRadius: 20, fontSize: 10, fontWeight: 800, background: `${color}15`, color, border: `0.5px solid ${color}25` }}>{n}</span>
    : <span style={{ color: "rgba(255,255,255,0.15)", fontSize: 11 }}>—</span>;

export function UsersTable({ plans, kpis }: UsersTableProps) {
  const { isMobile } = useResponsive();

  const totalActive     = plans.reduce((s, p) => s + p.active,     0);
  const totalCancelled  = plans.reduce((s, p) => s + p.cancelled,  0);
  const totalDelayed    = plans.reduce((s, p) => s + p.delayed,    0);
  const totalMensual    = plans.reduce((s, p) => s + ((p as any).mensual    ?? 0), 0);
  const totalTrimestral = plans.reduce((s, p) => s + ((p as any).trimestral ?? 0), 0);
  const totalAnual      = plans.reduce((s, p) => s + ((p as any).anual      ?? 0), 0);
  const totalTrial      = plans.reduce((s, p) => s + ((p as any).trial      ?? 0), 0);

  const mrr    = kpis?.mrr ?? 0;
  const cpa    = kpis && kpis.investment > 0 && totalActive > 0 ? (kpis.investment / totalActive).toFixed(2) : "0.00";
  const ticket = totalActive > 0 ? (mrr / totalActive).toFixed(2) : "0.00";

  const th: React.CSSProperties = {
    fontSize: 9, fontWeight: 800, color: C.muted,
    textAlign: "right", padding: "6px 8px",
    letterSpacing: "0.06em", textTransform: "uppercase",
    borderBottom: `1px solid ${C.border}`,
    whiteSpace: "nowrap",
  };
  const td: React.CSSProperties = {
    fontSize: 13, fontWeight: 700, textAlign: "right",
    padding: isMobile ? "9px 6px" : "11px 8px",
    borderTop: `1px solid ${C.border}`,
    whiteSpace: "nowrap",
  };

  return (
    <Card style={{ padding: isMobile ? "12px 12px" : "16px 18px", display: "flex", flexDirection: "column", gap: 10, overflow: "hidden" }}>
      <div style={{ display: "flex", alignItems: "center", gap: 8, flexShrink: 0 }}>
        <span style={{ fontWeight: 900, fontSize: 14, color: C.white }}>Usuarios por Plan</span>
        <LiveBadge />
      </div>

      {/* Scrollable table wrapper for mobile */}
      <div style={{ overflow: "auto", flex: 1, WebkitOverflowScrolling: "touch" }}>
        <table style={{ width: "100%", borderCollapse: "collapse", minWidth: isMobile ? 500 : "auto" }}>
          <thead>
            <tr>
              <th style={{ ...th, textAlign: "left" }}>Plan</th>
              <th style={th}>Activos</th>
              <th style={th}>Cancel.</th>
              <th style={th}>Mensual</th>
              <th style={th}>Trim.</th>
              <th style={th}>Anual</th>
              <th style={th}>Trial</th>
            </tr>
          </thead>
          <tbody>
            {plans.length === 0 ? (
              <tr><td colSpan={7} style={{ ...td, textAlign: "center", color: C.muted }}>Sin datos aún</td></tr>
            ) : plans.map((p, i) => (
              <tr key={i} className="aivi-row">
                <td style={{ ...td, textAlign: "left", fontWeight: 800, fontSize: 12, color: C.white }}>
                  {p.name.replace("AIVI — ", "").replace("Método V3 — ", "MV3 ")}
                </td>
                <td style={{ ...td, color: C.green, fontWeight: 900 }}>{p.active}</td>
                <td style={td}><PillBadge n={p.cancelled}               color={C.red} /></td>
                <td style={td}><PillBadge n={(p as any).mensual    ?? 0} color={C.white} /></td>
                <td style={td}><PillBadge n={(p as any).trimestral ?? 0} color={C.white} /></td>
                <td style={td}><PillBadge n={(p as any).anual      ?? 0} color={C.white} /></td>
                <td style={td}><PillBadge n={(p as any).trial      ?? 0} color={C.yellow} /></td>
              </tr>
            ))}
            {plans.length > 0 && (
              <tr style={{ background: "rgba(255,107,44,0.05)" }}>
                <td style={{ ...td, fontWeight: 900, fontSize: 13, color: C.white }}>Total</td>
                <td style={{ ...td, color: C.green,  fontWeight: 900 }}>{totalActive}</td>
                <td style={{ ...td, color: C.red,    fontWeight: 900 }}>{totalCancelled}</td>
                <td style={{ ...td, color: C.white,  fontWeight: 900 }}>{totalMensual}</td>
                <td style={{ ...td, color: C.white,  fontWeight: 900 }}>{totalTrimestral}</td>
                <td style={{ ...td, color: C.white,  fontWeight: 900 }}>{totalAnual}</td>
                <td style={{ ...td, color: C.yellow, fontWeight: 900 }}>{totalTrial}</td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {/* Bottom metrics — wrap on mobile */}
      <div style={{
        borderTop: `1px solid ${C.border}`, paddingTop: 10,
        display: "grid",
        gridTemplateColumns: isMobile ? "repeat(2, 1fr)" : "repeat(4, auto)",
        gap: isMobile ? 12 : 20,
        flexShrink: 0,
      }}>
        {[["CPA", `$${cpa}`, C.yellow], ["Ticket Prom.", `$${ticket}`, C.green], ["Cancelados", String(totalCancelled), C.red], ["Atrasados", String(totalDelayed), C.yellow]].map(([lbl, val, col]) => (
          <div key={lbl as string}>
            <div style={{ fontSize: 9, color: C.muted, fontWeight: 700, textTransform: "uppercase", letterSpacing: ".06em", marginBottom: 2 }}>{lbl}</div>
            <div style={{ fontSize: isMobile ? 14 : 16, fontWeight: 900, color: col as string }}>{val}</div>
          </div>
        ))}
      </div>
    </Card>
  );
}
