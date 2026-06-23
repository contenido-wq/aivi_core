import { C } from "../../tokens";
import type { AdRankRow } from "../../services/analytics";

function rowBg(cac: number, target: number) {
  if (cac === 0 || target === 0) return "transparent";
  if (cac <= target)       return "rgba(74,222,128,0.06)";
  if (cac <= target * 1.5) return "rgba(255,194,82,0.06)";
  return "rgba(255,65,59,0.06)";
}

function cacColor(cac: number, target: number) {
  if (cac === 0 || target === 0) return C.mutedMid;
  if (cac <= target)       return "#4ADE80";
  if (cac <= target * 1.5) return "#FFC252";
  return "#FF413B";
}

function scoreColor(s: number) { return s >= 80 ? "#4ADE80" : s >= 50 ? "#FFC252" : "#FF413B"; }

interface Props {
  rows:              AdRankRow[];
  cacTarget:         number;
  onCacTargetChange: (n: number) => void;
  onOpenMapping:     () => void;
}

export function AdsRankingTable({ rows, cacTarget, onCacTargetChange, onOpenMapping }: Props) {
  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 20 }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
        <div style={{ fontSize: 14, fontWeight: 600, color: C.white }}>Anuncios por CAC</div>
        <div style={{ display: "flex", gap: 12, alignItems: "center" }}>
          <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
            <span style={{ fontSize: 12, color: C.mutedMid }}>CAC objetivo $</span>
            <input type="number" value={cacTarget} onChange={e => onCacTargetChange(Number(e.target.value))}
              style={{ width: 64, background: C.bgSecondary, border: `1px solid ${C.border}`, borderRadius: 6, padding: "4px 8px", color: C.white, fontSize: 12 }} />
          </div>
          <button onClick={onOpenMapping} style={{
            background: `${C.orange}18`, border: `1px solid ${C.orange}40`,
            color: C.orange, borderRadius: 8, padding: "4px 12px", fontSize: 12, cursor: "pointer",
          }}>Configurar VSLs</button>
        </div>
      </div>
      <div style={{ overflowX: "auto" }}>
        <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 12 }}>
          <thead>
            <tr style={{ borderBottom: `1px solid ${C.border}` }}>
              {["Campaña","Inversión","Clicks","CPM","CPC","Plays","Play%","Ventas","CAC","ROAS","VSL","Score"].map(h => (
                <th key={h} style={{ padding: "6px 10px", color: C.mutedMid, fontWeight: 500, textAlign: "left", whiteSpace: "nowrap" }}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {rows.map((r, i) => (
              <tr key={i} style={{ background: rowBg(r.cac, cacTarget), borderBottom: `1px solid ${C.border}` }}>
                <td style={{ padding: "9px 10px", color: C.white, fontWeight: 500, maxWidth: 160, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{r.campaignName}</td>
                <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.investment.toFixed(0)}</td>
                <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.clicks.toLocaleString("es")}</td>
                <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.cpm.toFixed(2)}</td>
                <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.cpc.toFixed(2)}</td>
                <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.plays.toLocaleString("es")}</td>
                <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.playRate.toFixed(1)}%</td>
                <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.sales}</td>
                <td style={{ padding: "9px 10px", color: cacColor(r.cac, cacTarget), fontWeight: 700 }}>{r.cac > 0 ? `$${r.cac.toFixed(0)}` : "—"}</td>
                <td style={{ padding: "9px 10px", color: r.roas >= 2 ? "#4ADE80" : "#FFC252", fontWeight: 600 }}>{r.roas > 0 ? `${r.roas.toFixed(2)}x` : "—"}</td>
                <td style={{ padding: "9px 10px", color: C.mutedMid, maxWidth: 120, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{r.videoName ?? "—"}</td>
                <td style={{ padding: "9px 10px" }}>
                  <span style={{ background: `${scoreColor(r.score)}20`, color: scoreColor(r.score), borderRadius: 12, padding: "2px 8px", fontSize: 11, fontWeight: 700 }}>{r.score}</span>
                </td>
              </tr>
            ))}
            {rows.length === 0 && (
              <tr><td colSpan={12} style={{ padding: 20, textAlign: "center", color: C.mutedMid, fontSize: 13 }}>Sin datos de anuncios en el período</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
