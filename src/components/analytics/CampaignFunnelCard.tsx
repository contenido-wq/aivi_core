import { useState } from "react";
import { C } from "../../tokens";
import { InfoTooltip } from "./InfoTooltip";
import type { FunnelCampaign, AdVSLRow } from "../../services/analytics";

function pct(a: number, b: number) { return b > 0 ? `${((a / b) * 100).toFixed(1)}%` : "—"; }
function scoreColor(s: number) { return s >= 80 ? "#FE803F" : s >= 50 ? "#FFC252" : "#FF413B"; }

interface Props { campaign: FunnelCampaign; ads: AdVSLRow[] }

export function CampaignFunnelCard({ campaign: c, ads }: Props) {
  const [expanded, setExpanded] = useState(false);

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
        <div style={{ display: "flex", alignItems: "flex-start", gap: 8 }}>
          {ads.length > 0 && (
            <button onClick={() => setExpanded(v => !v)} style={{ background: "transparent", border: "none", color: C.mutedMid, cursor: "pointer", fontSize: 12, padding: "2px 0" }}>
              {expanded ? "▾" : "▸"}
            </button>
          )}
          <div>
            <div style={{ fontSize: 13, fontWeight: 600, color: C.white, marginBottom: 2 }}>{c.campaignName}</div>
            <div style={{ fontSize: 11, color: C.mutedMid }}>{c.videoName ?? "Sin VSL asignado"}</div>
          </div>
        </div>
        <span style={{
          display: "inline-flex", alignItems: "center",
          background: `${scoreColor(c.score)}20`, color: scoreColor(c.score),
          border: `1px solid ${scoreColor(c.score)}`, borderRadius: 20,
          fontSize: 11, fontWeight: 700, padding: "2px 10px",
        }}>
          Score {c.score}
          <InfoTooltip text="Combina ROI (30%), tasa de conversión (20%), audiencia del pitch (30%) y engagement (20%) en un puntaje de 0 a 100." align="right" />
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

      {expanded && ads.length > 0 && (
        <div style={{ borderTop: `1px solid ${C.border}`, marginTop: 14, paddingTop: 12, display: "flex", flexDirection: "column", gap: 8 }}>
          {ads.map(a => (
            <div key={a.adId} style={{ display: "flex", justifyContent: "space-between", alignItems: "center", background: "rgba(255,255,255,0.03)", borderRadius: 8, padding: "8px 10px" }}>
              <div style={{ minWidth: 0 }}>
                <div style={{ fontSize: 12, color: C.white, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{a.adName}</div>
                <div style={{ fontSize: 10, color: C.mutedMid }}>{a.videoName ?? "Sin VSL"}</div>
              </div>
              <div style={{ display: "flex", gap: 12, flexShrink: 0, fontSize: 11 }}>
                <span style={{ color: C.mutedLight }}>CAC ${a.cac.toFixed(0)}</span>
                <span style={{ color: a.roi >= 1 ? "#FE803F" : "#FFC252" }}>{a.roi.toFixed(2)}x</span>
                <span style={{ color: C.mutedLight }}>{a.sales} ventas</span>
                <span style={{ color: scoreColor(a.score), fontWeight: 700 }}>{a.score}</span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
