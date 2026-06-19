import { useMemo, Fragment } from "react";
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

const FAMILY_COLORS: Record<string, string> = {
  "AIVI":           "#FE803F",
  "Método V3":      "#FFC247",
  "Reto 15D":       "#2FB7FF",
  "Reto 11D":       "#2FB7FF",
  "Master Creator": "#A78BFA",
};

function familyColor(family: string): string {
  return FAMILY_COLORS[family] ?? "#A0A0B4";
}

export function UsersTable({ plans, kpis }: UsersTableProps) {
  const { isMobile } = useResponsive();

  const families = useMemo(() => {
    const map: Record<string, PlanRow[]> = {};
    for (const plan of plans) {
      const key = plan.family || plan.name;
      if (!map[key]) map[key] = [];
      map[key].push(plan);
    }
    return Object.entries(map)
      .map(([family, rows]) => ({
        family,
        rows,
        totalActive:    rows.reduce((s, r) => s + r.active,    0),
        totalCancelled: rows.reduce((s, r) => s + r.cancelled, 0),
        totalDelayed:   rows.reduce((s, r) => s + r.delayed,   0),
        totalMensual:   rows.reduce((s, r) => s + r.mensual,   0),
        totalAnual:     rows.reduce((s, r) => s + r.anual,     0),
        totalTrial:     rows.reduce((s, r) => s + r.trial,     0),
      }))
      .sort((a, b) => b.totalActive - a.totalActive);
  }, [plans]);

  const totalActive     = families.reduce((s, f) => s + f.totalActive,    0);
  const totalCancelled  = families.reduce((s, f) => s + f.totalCancelled, 0);
  const totalDelayed    = families.reduce((s, f) => s + f.totalDelayed,   0);
  const totalMensual    = families.reduce((s, f) => s + f.totalMensual,   0);
  const totalAnual      = families.reduce((s, f) => s + f.totalAnual,     0);
  const totalTrial      = families.reduce((s, f) => s + f.totalTrial,     0);

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

      <div style={{ overflow: "auto", flex: 1, WebkitOverflowScrolling: "touch" }}>
        <table style={{ width: "100%", borderCollapse: "collapse", minWidth: isMobile ? 480 : "auto" }}>
          <thead>
            <tr>
              <th style={{ ...th, textAlign: "left" }}>Familia / Plan</th>
              <th style={th}>Activos</th>
              <th style={th}>Cancel.</th>
              <th style={th}>Mensual</th>
              <th style={th}>Anual</th>
              <th style={th}>Trial</th>
            </tr>
          </thead>
          <tbody>
            {families.length === 0 ? (
              <tr><td colSpan={6} style={{ ...td, textAlign: "center", color: C.muted }}>Sin datos aún</td></tr>
            ) : families.map(({ family, rows, totalActive: fActive, totalCancelled: fCancelled, totalMensual: fMensual, totalAnual: fAnual, totalTrial: fTrial }) => (
              <Fragment key={family}>
                {/* Fila de familia */}
                <tr style={{ background: "rgba(255,255,255,0.025)" }}>
                  <td style={{ ...td, textAlign: "left", borderTop: `1px solid ${C.borderMid}` }}>
                    <span style={{ fontWeight: 900, fontSize: 12, color: familyColor(family) }}>{family}</span>
                    <span style={{
                      marginLeft: 8, fontSize: 9, fontWeight: 700, padding: "1px 6px",
                      borderRadius: 8, background: `${familyColor(family)}15`,
                      color: familyColor(family), border: `0.5px solid ${familyColor(family)}30`,
                    }}>{fActive} activos</span>
                  </td>
                  <td style={{ ...td, color: C.green, fontWeight: 900, borderTop: `1px solid ${C.borderMid}` }}>{fActive}</td>
                  <td style={{ ...td, borderTop: `1px solid ${C.borderMid}` }}><PillBadge n={fCancelled} color={C.red} /></td>
                  <td style={{ ...td, borderTop: `1px solid ${C.borderMid}` }}><PillBadge n={fMensual} color={C.white} /></td>
                  <td style={{ ...td, borderTop: `1px solid ${C.borderMid}` }}><PillBadge n={fAnual}   color={C.white} /></td>
                  <td style={{ ...td, borderTop: `1px solid ${C.borderMid}` }}><PillBadge n={fTrial}   color={C.yellow} /></td>
                </tr>
                {/* Sub-filas de planes */}
                {rows.map((p, i) => (
                  <tr key={`plan-${family}-${i}`} className="aivi-row">
                    <td style={{ ...td, textAlign: "left", paddingLeft: isMobile ? 14 : 20, fontSize: 11, color: C.mutedLight, fontWeight: 600 }}>
                      {p.name.replace(`${family} — `, "").replace("AIVI — ", "").replace("Método V3 — ", "")}
                    </td>
                    <td style={{ ...td, color: C.green }}>{p.active}</td>
                    <td style={td}><PillBadge n={p.cancelled} color={C.red} /></td>
                    <td style={td}><PillBadge n={p.mensual}   color={C.white} /></td>
                    <td style={td}><PillBadge n={p.anual}     color={C.white} /></td>
                    <td style={td}><PillBadge n={p.trial}     color={C.yellow} /></td>
                  </tr>
                ))}
              </Fragment>
            ))}
            {families.length > 0 && (
              <tr style={{ background: "rgba(254,128,63,0.05)" }}>
                <td style={{ ...td, fontWeight: 900, fontSize: 13, color: C.white }}>Total</td>
                <td style={{ ...td, color: C.green,  fontWeight: 900 }}>{totalActive}</td>
                <td style={{ ...td, color: C.red,    fontWeight: 900 }}>{totalCancelled}</td>
                <td style={{ ...td, color: C.white,  fontWeight: 900 }}>{totalMensual}</td>
                <td style={{ ...td, color: C.white,  fontWeight: 900 }}>{totalAnual}</td>
                <td style={{ ...td, color: C.yellow, fontWeight: 900 }}>{totalTrial}</td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {/* Bottom metrics */}
      <div style={{
        borderTop: `1px solid ${C.border}`, paddingTop: 10,
        display: "grid",
        gridTemplateColumns: isMobile ? "repeat(2, 1fr)" : "repeat(4, auto)",
        gap: isMobile ? 12 : 20,
        flexShrink: 0,
      }}>
        {[
          ["CPA",         `$${cpa}`,               C.yellow],
          ["Ticket Prom.", `$${ticket}`,            C.green],
          ["Cancelados",  String(totalCancelled),   C.red],
          ["Atrasados",   String(totalDelayed),      C.yellow],
        ].map(([lbl, val, col]) => (
          <div key={lbl as string}>
            <div style={{ fontSize: 9, color: C.muted, fontWeight: 700, textTransform: "uppercase", letterSpacing: ".06em", marginBottom: 2 }}>{lbl}</div>
            <div style={{ fontSize: isMobile ? 14 : 16, fontWeight: 900, color: col as string }}>{val}</div>
          </div>
        ))}
      </div>
    </Card>
  );
}
