import { Fragment, useState } from "react";
import { C } from "../../tokens";
import { InfoTooltip } from "./InfoTooltip";
import { classifyAd } from "../../services/analytics";
import type { AdVSLRow, AdAction } from "../../services/analytics";

const AD_ACTION_STYLE: Record<AdAction, { color: string; bg: string; border: string }> = {
  ESCALAR:    { color: C.green,  bg: C.greenSoft,             border: "rgba(48,209,88,0.3)"  },
  PAUSAR:     { color: C.red,    bg: "rgba(255,65,59,0.12)",  border: "rgba(255,65,59,0.3)"  },
  MONITOREAR: { color: C.yellow, bg: "rgba(255,194,82,0.12)", border: "rgba(255,194,82,0.3)" },
};

function scoreColor(s: number) { return s >= 80 ? C.green : s >= 50 ? C.yellow : C.red; }
function cacColor(cac: number, target: number) {
  if (cac === 0 || target === 0) return C.mutedMid;
  if (cac <= target)       return C.green;
  if (cac <= target * 1.5) return C.yellow;
  return C.red;
}

interface Props {
  rows:      AdVSLRow[];
  cacTarget: number;
  ticketMin: number;
}

export function AdRankingTable({ rows, cacTarget, ticketMin }: Props) {
  const [expanded, setExpanded] = useState<Set<string>>(new Set());

  const toggle = (adId: string) => {
    setExpanded(prev => {
      const next = new Set(prev);
      if (next.has(adId)) next.delete(adId); else next.add(adId);
      return next;
    });
  };

  if (rows.length === 0) return null;

  return (
    <section>
      <div style={{ fontSize: 13, fontWeight: 600, color: C.white, marginBottom: 12 }}>
        Ranking de Anuncios
        <InfoTooltip text="Cada fila es un anuncio individual de Meta cruzado con el VSL que usa. Ordenado por Score descendente — el de arriba es el candidato más fuerte a escalar." />
      </div>
      <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, overflow: "hidden" }}>
        <div style={{ overflowX: "auto" }}>
          <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 12 }}>
            <thead>
              <tr style={{ borderBottom: `1px solid ${C.border}` }}>
                {["", "Anuncio", "VSL", "Inv.", "CAC", "ROI", "Vistas", "Vistas Ún.", "Repr.", "Repr. Ún.", "Tasa Repr.", "Engagement", "Aud. Pitch", "Score", "Acción"].map(h => (
                  <th key={h} style={{ padding: "8px", color: C.mutedMid, fontWeight: 500, textAlign: "left", whiteSpace: "nowrap" }}>{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {rows.map(r => {
                const action  = classifyAd(r, cacTarget, ticketMin);
                const acStyle = AD_ACTION_STYLE[action];
                const isOpen  = expanded.has(r.adId);
                return (
                  <Fragment key={r.adId}>
                    <tr style={{ borderBottom: `1px solid ${C.border}` }}>
                      <td style={{ padding: "8px" }}>
                        <button onClick={() => toggle(r.adId)} style={{ background: "transparent", border: "none", color: C.mutedMid, cursor: "pointer", fontSize: 11 }}>
                          {isOpen ? "▾" : "▸"}
                        </button>
                      </td>
                      <td style={{ padding: "8px", color: C.white, fontWeight: 500, maxWidth: 160, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{r.adName}</td>
                      <td style={{ padding: "8px", color: C.mutedLight, maxWidth: 120, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{r.videoName ?? "Sin VSL"}</td>
                      <td style={{ padding: "8px", color: C.mutedLight }}>${r.investment.toFixed(0)}</td>
                      <td style={{ padding: "8px", color: cacColor(r.cac, cacTarget), fontWeight: 700 }}>{r.cac > 0 ? `$${r.cac.toFixed(0)}` : "—"}</td>
                      <td style={{ padding: "8px", color: r.roi >= 1 ? C.green : r.roi >= 0 ? C.yellow : C.red, fontWeight: 600 }}>{r.investment > 0 ? `${r.roi.toFixed(2)}x` : "—"}</td>
                      <td style={{ padding: "8px", color: C.mutedLight }}>{r.views.toLocaleString("es")}</td>
                      <td style={{ padding: "8px", color: C.mutedLight }}>{r.uniqueViews.toLocaleString("es")}</td>
                      <td style={{ padding: "8px", color: C.mutedLight }}>{r.plays.toLocaleString("es")}</td>
                      <td style={{ padding: "8px", color: C.mutedLight }}>{r.uniquePlays.toLocaleString("es")}</td>
                      <td style={{ padding: "8px", color: C.mutedLight }}>{r.playRate.toFixed(1)}%</td>
                      <td style={{ padding: "8px", color: C.mutedLight }}>{r.engagement.toFixed(0)}%</td>
                      <td style={{ padding: "8px", color: C.mutedLight }}>{r.pitchAudience != null ? `${r.pitchAudience.toFixed(0)}%` : "—"}</td>
                      <td style={{ padding: "8px" }}>
                        <span style={{ background: `${scoreColor(r.score)}20`, color: scoreColor(r.score), borderRadius: 12, padding: "2px 8px", fontSize: 11, fontWeight: 700 }}>{r.score}</span>
                      </td>
                      <td style={{ padding: "8px" }}>
                        <span style={{ background: acStyle.bg, border: `1px solid ${acStyle.border}`, color: acStyle.color, borderRadius: 12, padding: "2px 10px", fontSize: 10, fontWeight: 700, whiteSpace: "nowrap" }}>{action}</span>
                      </td>
                    </tr>
                    {isOpen && (
                      <tr style={{ borderBottom: `1px solid ${C.border}`, background: "rgba(255,255,255,0.02)" }}>
                        <td colSpan={15} style={{ padding: "8px 16px", fontSize: 11, color: C.mutedMid }}>
                          <strong>ad_id:</strong> {r.adId} · <strong>adset:</strong> {r.adsetName ?? "—"} · <strong>placement:</strong> {r.placement ?? "—"} · <strong>campaña:</strong> {r.campaignName}
                        </td>
                      </tr>
                    )}
                  </Fragment>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>
    </section>
  );
}
