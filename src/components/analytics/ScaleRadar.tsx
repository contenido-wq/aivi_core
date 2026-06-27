import { C } from "../../tokens";
import type { AdRankRow } from "../../services/analytics";

type Action = "ESCALAR" | "PAUSAR" | "MONITOREAR";

function classify(r: AdRankRow, cacTarget: number, ticketMin: number): Action {
  const avgTicket = r.sales > 0 && r.investment > 0 ? (r.investment * r.roas) / r.sales : 0;
  const ticketOk  = ticketMin === 0 || avgTicket >= ticketMin;
  if (r.sales >= 1 && r.cac > 0 && r.cac <= cacTarget && r.roas >= 2.0 && ticketOk) return "ESCALAR";
  if ((r.cac > 0 && r.cac > cacTarget * 1.5) || (r.roas < 1.0 && r.investment > 0)) return "PAUSAR";
  return "MONITOREAR";
}

const STYLES: Record<Action, { color: string; bg: string; border: string; icon: string }> = {
  ESCALAR:    { color: C.green,  bg: "rgba(48,209,88,0.10)",  border: "rgba(48,209,88,0.25)",  icon: "🟢" },
  MONITOREAR: { color: C.yellow, bg: "rgba(255,194,82,0.10)", border: "rgba(255,194,82,0.25)", icon: "🟡" },
  PAUSAR:     { color: C.red,    bg: "rgba(255,65,59,0.10)",  border: "rgba(255,65,59,0.25)",  icon: "🔴" },
};

interface Props {
  campaigns: AdRankRow[];
  cacTarget: number;
  ticketMin: number;
}

export function ScaleRadar({ campaigns, cacTarget, ticketMin }: Props) {
  if (campaigns.length === 0) return null;

  const byAction: Record<Action, AdRankRow[]> = { ESCALAR: [], PAUSAR: [], MONITOREAR: [] };
  for (const c of campaigns) byAction[classify(c, cacTarget, ticketMin)].push(c);

  return (
    <div style={{
      background: C.card, border: `1px solid ${C.border}`,
      borderRadius: 14, padding: 20,
    }}>
      <div style={{ fontSize: 13, fontWeight: 600, color: C.white, marginBottom: 16 }}>
        Radar de Decisión
      </div>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 12 }}>
        {(["ESCALAR", "MONITOREAR", "PAUSAR"] as Action[]).map(action => {
          const rows  = byAction[action];
          const style = STYLES[action];
          return (
            <div
              key={action}
              style={{
                background: style.bg, border: `1px solid ${style.border}`,
                borderRadius: 10, padding: "14px 16px",
              }}
            >
              <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 8 }}>
                <span style={{ fontSize: 16, lineHeight: 1 }}>{style.icon}</span>
                <div>
                  <div style={{ fontSize: 10, fontWeight: 700, color: style.color, letterSpacing: "0.06em" }}>
                    {action}
                  </div>
                  <div style={{ fontSize: 22, fontWeight: 900, color: style.color, lineHeight: 1.1 }}>
                    {rows.length}
                  </div>
                </div>
              </div>
              <div style={{ display: "flex", flexDirection: "column", gap: 3 }}>
                {rows.map(c => (
                  <div key={c.campaignName} style={{
                    fontSize: 10, color: style.color, opacity: 0.85,
                    overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
                  }}>
                    {c.campaignName}
                  </div>
                ))}
                {rows.length === 0 && (
                  <div style={{ fontSize: 10, color: C.muted }}>—</div>
                )}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
