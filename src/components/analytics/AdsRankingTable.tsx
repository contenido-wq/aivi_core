import { C } from "../../tokens";
import type { AdRankRow } from "../../services/analytics";

type Action = "ESCALAR" | "PAUSAR" | "MONITOREAR";

function rowBg(cac: number, target: number) {
  if (cac === 0 || target === 0) return "transparent";
  if (cac <= target)       return "rgba(48,209,88,0.04)";
  if (cac <= target * 1.5) return "rgba(255,194,82,0.04)";
  return "rgba(255,65,59,0.04)";
}

function cacColor(cac: number, target: number) {
  if (cac === 0 || target === 0) return C.mutedMid;
  if (cac <= target)       return C.green;
  if (cac <= target * 1.5) return C.yellow;
  return C.red;
}

function scoreColor(s: number) {
  return s >= 80 ? C.green : s >= 50 ? C.yellow : C.red;
}

function classifyRow(r: AdRankRow, cacTarget: number, ticketMin: number): Action {
  const avgTicket = r.sales > 0 && r.investment > 0 ? (r.investment * r.roas) / r.sales : 0;
  const ticketOk  = ticketMin === 0 || avgTicket >= ticketMin;
  if (r.sales >= 1 && r.cac > 0 && r.cac <= cacTarget && r.roas >= 2.0 && ticketOk) return "ESCALAR";
  if ((r.cac > 0 && r.cac > cacTarget * 1.5) || (r.roas < 1.0 && r.investment > 0)) return "PAUSAR";
  return "MONITOREAR";
}

const ACTION_STYLE: Record<Action, { color: string; bg: string; border: string }> = {
  ESCALAR:    { color: C.green,  bg: "rgba(48,209,88,0.12)",  border: "rgba(48,209,88,0.3)"  },
  PAUSAR:     { color: C.red,    bg: "rgba(255,65,59,0.12)",  border: "rgba(255,65,59,0.3)"  },
  MONITOREAR: { color: C.yellow, bg: "rgba(255,194,82,0.12)", border: "rgba(255,194,82,0.3)" },
};

interface Props {
  rows:              AdRankRow[];
  cacTarget:         number;
  ticketMin:         number;
  onCacTargetChange: (n: number) => void;
  onTicketMinChange: (n: number) => void;
  onOpenMapping:     () => void;
}

export function AdsRankingTable({ rows, cacTarget, ticketMin, onCacTargetChange, onTicketMinChange, onOpenMapping }: Props) {
  const inputStyle: React.CSSProperties = {
    width: 64, background: C.bgSecondary,
    border: `1px solid ${C.border}`, borderRadius: 6,
    padding: "4px 8px", color: C.white, fontSize: 12,
    fontFamily: "inherit",
  };

  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 20 }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16, flexWrap: "wrap", gap: 8 }}>
        <div style={{ fontSize: 14, fontWeight: 600, color: C.white }}>Anuncios por CAC</div>
        <div style={{ display: "flex", gap: 12, alignItems: "center", flexWrap: "wrap" }}>
          <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
            <span style={{ fontSize: 11, color: C.mutedMid }}>CAC objetivo $</span>
            <input
              type="number" value={cacTarget}
              onChange={e => onCacTargetChange(Number(e.target.value))}
              style={inputStyle}
            />
          </div>
          <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
            <span style={{ fontSize: 11, color: C.mutedMid }}>Ticket mín. $</span>
            <input
              type="number" value={ticketMin}
              onChange={e => onTicketMinChange(Number(e.target.value))}
              style={inputStyle}
            />
          </div>
          <button
            onClick={onOpenMapping}
            style={{
              background: `rgba(254,128,63,0.12)`, border: `1px solid rgba(254,128,63,0.30)`,
              color: C.orange, borderRadius: 8, padding: "4px 12px", fontSize: 12, cursor: "pointer",
            }}
          >
            Configurar VSLs
          </button>
        </div>
      </div>

      <div style={{ overflowX: "auto" }}>
        <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 12 }}>
          <thead>
            <tr style={{ borderBottom: `1px solid ${C.border}` }}>
              {["Campaña","Inv.","Clicks","CPM","CPC","Plays","Play%","Ventas","Ticket","CAC","ROAS","VSL","Score","Acción"].map(h => (
                <th key={h} style={{
                  padding: "6px 10px", color: C.mutedMid, fontWeight: 500,
                  textAlign: "left", whiteSpace: "nowrap",
                }}>
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {rows.map((r, i) => {
              const action     = classifyRow(r, cacTarget, ticketMin);
              const acStyle    = ACTION_STYLE[action];
              const avgTicket  = r.sales > 0 && r.investment > 0 ? (r.investment * r.roas) / r.sales : 0;
              return (
                <tr key={i} style={{ background: rowBg(r.cac, cacTarget), borderBottom: `1px solid ${C.border}` }}>
                  <td style={{ padding: "9px 10px", color: C.white, fontWeight: 500, maxWidth: 160, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                    {r.campaignName}
                  </td>
                  <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.investment.toFixed(0)}</td>
                  <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.clicks.toLocaleString("es")}</td>
                  <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.cpm.toFixed(2)}</td>
                  <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.cpc.toFixed(2)}</td>
                  <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.plays.toLocaleString("es")}</td>
                  <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.playRate.toFixed(1)}%</td>
                  <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.sales}</td>
                  <td style={{ padding: "9px 10px", color: avgTicket >= ticketMin && ticketMin > 0 ? C.green : C.mutedLight, fontWeight: avgTicket >= ticketMin && ticketMin > 0 ? 700 : 400 }}>
                    {avgTicket > 0 ? `$${avgTicket.toFixed(0)}` : "—"}
                  </td>
                  <td style={{ padding: "9px 10px", color: cacColor(r.cac, cacTarget), fontWeight: 700 }}>
                    {r.cac > 0 ? `$${r.cac.toFixed(0)}` : "—"}
                  </td>
                  <td style={{ padding: "9px 10px", color: r.roas >= 2 ? C.green : r.roas >= 1 ? C.yellow : C.red, fontWeight: 600 }}>
                    {r.roas > 0 ? `${r.roas.toFixed(2)}x` : "—"}
                  </td>
                  <td style={{ padding: "9px 10px", color: C.mutedMid, maxWidth: 100, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                    {r.videoName ?? "—"}
                  </td>
                  <td style={{ padding: "9px 10px" }}>
                    <span style={{ background: `${scoreColor(r.score)}20`, color: scoreColor(r.score), borderRadius: 12, padding: "2px 8px", fontSize: 11, fontWeight: 700 }}>
                      {r.score}
                    </span>
                  </td>
                  <td style={{ padding: "9px 10px" }}>
                    <span style={{ background: acStyle.bg, border: `1px solid ${acStyle.border}`, color: acStyle.color, borderRadius: 12, padding: "2px 10px", fontSize: 10, fontWeight: 700, whiteSpace: "nowrap" }}>
                      {action}
                    </span>
                  </td>
                </tr>
              );
            })}
            {rows.length === 0 && (
              <tr>
                <td colSpan={14} style={{ padding: 20, textAlign: "center", color: C.mutedMid, fontSize: 13 }}>
                  Sin datos de anuncios en el período
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
