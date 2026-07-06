import { C } from "../../tokens";
import { InfoTooltip } from "./InfoTooltip";
import type { FunnelCampaign } from "../../services/analytics";

function pct(a: number, b: number) { return b > 0 ? `${((a / b) * 100).toFixed(1)}%` : "—"; }
function scoreColor(s: number) { return s >= 80 ? "#FE803F" : s >= 50 ? "#FFC252" : "#FF413B"; }

interface Props { campaign: FunnelCampaign }

export function CampaignFunnelCard({ campaign: c }: Props) {
  const stages = [
    { label: "Impresiones", value: c.impressions, conv: null },
    { label: "Clicks",      value: c.clicks,      conv: pct(c.clicks, c.impressions) },
    { label: "Plays",       value: c.plays,        conv: pct(c.plays, c.clicks) },
    { label: "CTA Click",   value: c.ctaClicks,    conv: pct(c.ctaClicks, c.plays) },
    { label: "Compras",     value: c.sales,        conv: pct(c.sales, c.ctaClicks) },
  ];
  const maxVal = Math.max(...stages.map(s => s.value), 1);

  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 20 }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 16 }}>
        <div>
          <div style={{ fontSize: 13, fontWeight: 600, color: C.white, marginBottom: 2 }}>{c.campaignName}</div>
          <div style={{ fontSize: 11, color: C.mutedMid }}>{c.videoName ?? "Sin VSL asignado"}</div>
        </div>
        <span style={{
          display: "inline-flex", alignItems: "center",
          background: `${scoreColor(c.score)}20`, color: scoreColor(c.score),
          border: `1px solid ${scoreColor(c.score)}`, borderRadius: 20,
          fontSize: 11, fontWeight: 700, padding: "2px 10px",
        }}>
          Score {c.score}
          <InfoTooltip text="Combina el ROI relativo (50%) y la conversión ventas/plays (50%) en un puntaje de 0 a 100 para comparar campañas de un vistazo." align="right" />
        </span>
      </div>

      <div style={{ display: "flex", gap: 4, alignItems: "flex-end", marginBottom: 16 }}>
        {stages.map((s, i) => {
          const h = Math.max(8, (s.value / maxVal) * 64);
          const opacity = i === 0 || i === stages.length - 1 ? "FF" : "80";
          return (
            <div key={i} style={{ flex: 1, textAlign: "center" }}>
              <div style={{ fontSize: 10, color: C.mutedMid, marginBottom: 4 }}>{s.label}</div>
              <div style={{ height: h, background: `${C.orange}${opacity}`, borderRadius: 4, marginBottom: 4 }} />
              <div style={{ fontSize: 11, fontWeight: 600, color: C.white }}>{s.value.toLocaleString("es")}</div>
              {s.conv && <div style={{ fontSize: 10, color: C.mutedMid }}>{s.conv}</div>}
            </div>
          );
        })}
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 8, borderTop: `1px solid ${C.border}`, paddingTop: 14 }}>
        <div>
          <div style={{ fontSize: 10, color: C.mutedMid }}>CAC</div>
          <div style={{ fontSize: 14, fontWeight: 700, color: C.white }}>${c.cac.toFixed(0)}</div>
        </div>
        <div>
          <div style={{ fontSize: 10, color: C.mutedMid }}>ROI</div>
          <div style={{ fontSize: 14, fontWeight: 700, color: c.roi >= 1 ? "#FE803F" : "#FFC252" }}>{c.roi.toFixed(2)}x</div>
        </div>
        <div>
          <div style={{ fontSize: 10, color: C.mutedMid }}>Inversión</div>
          <div style={{ fontSize: 14, fontWeight: 700, color: C.white }}>${c.investment.toFixed(0)}</div>
        </div>
        {c.topHour !== null && (
          <div>
            <div style={{ fontSize: 10, color: C.mutedMid }}>Hora pico</div>
            <div style={{ fontSize: 13, fontWeight: 600, color: C.mutedLight }}>{c.topHour}:00h</div>
          </div>
        )}
      </div>
    </div>
  );
}
