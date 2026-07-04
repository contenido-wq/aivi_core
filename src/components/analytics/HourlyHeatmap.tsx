import { useState, useEffect } from "react";
import { C } from "../../tokens";
import type { HeatmapCell } from "../../services/analytics";

const DAYS  = ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb"];
const HOURS = Array.from({ length: 24 }, (_, i) => i);

interface Props { cells: HeatmapCell[] }

export function HourlyHeatmap({ cells }: Props) {
  const [tooltip,      setTooltip]      = useState<{ h: number; dow: number; val: number } | null>(null);
  const [selectedCell, setSelectedCell] = useState<{ h: number; dow: number } | null>(null);

  const maxVal = Math.max(1, ...cells.map(c => c.value));
  const lookup: Record<string, number> = {};
  const sourceLookup: Record<string, { source: string; count: number }[]> = {};
  for (const c of cells) {
    lookup[`${c.hour}-${c.dow}`]       = c.value;
    sourceLookup[`${c.hour}-${c.dow}`] = c.bySource;
  }

  useEffect(() => {
    if (selectedCell && !lookup[`${selectedCell.h}-${selectedCell.dow}`]) {
      setSelectedCell(null);
    }
  }, [cells]); // eslint-disable-line react-hooks/exhaustive-deps

  const totalConversions = cells.reduce((s, c) => s + c.value, 0);
  const selectedSources = selectedCell
    ? (sourceLookup[`${selectedCell.h}-${selectedCell.dow}`] ?? [])
    : [];
  const selectedVal = selectedCell
    ? (lookup[`${selectedCell.h}-${selectedCell.dow}`] ?? 0)
    : 0;

  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 20 }}>
      {/* Header */}
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
        <div style={{ fontSize: 14, fontWeight: 600, color: C.white }}>Conversiones por Hora y Día</div>
        <div style={{ fontSize: 12, color: C.mutedMid }}>
          {totalConversions} conversiones totales
        </div>
      </div>

      {totalConversions === 0 ? (
        <div style={{
          height: 120, display: "flex", alignItems: "center", justifyContent: "center",
          flexDirection: "column", gap: 6,
          background: "rgba(255,255,255,0.02)", borderRadius: 8, border: `1px dashed ${C.border}`,
        }}>
          <div style={{ fontSize: 13, color: C.mutedMid }}>Sin conversiones en este período</div>
        </div>
      ) : (
        <div style={{ width: "100%" }}>
          {/* Day labels */}
          <div style={{ display: "grid", gridTemplateColumns: "36px repeat(7, 1fr)", gap: 3, marginBottom: 3 }}>
            <div />
            {DAYS.map(d => (
              <div key={d} style={{ textAlign: "center", fontSize: 11, fontWeight: 600, color: C.mutedMid }}>
                {d}
              </div>
            ))}
          </div>

          {/* Grid rows */}
          {HOURS.map(h => (
            <div key={h} style={{ display: "grid", gridTemplateColumns: "36px repeat(7, 1fr)", gap: 3, marginBottom: 3 }}>
              <div style={{ fontSize: 10, color: C.mutedMid, textAlign: "right", paddingRight: 8, lineHeight: "24px" }}>
                {h}h
              </div>
              {Array.from({ length: 7 }, (_, dow) => {
                const val      = lookup[`${h}-${dow}`] ?? 0;
                const alpha    = val > 0 ? 0.15 + (val / maxVal) * 0.85 : 0;
                const isHot    = tooltip?.h === h && tooltip?.dow === dow;
                const isSelected = selectedCell?.h === h && selectedCell?.dow === dow;
                return (
                  <div
                    key={dow}
                    onMouseEnter={() => setTooltip({ h, dow, val })}
                    onMouseLeave={() => setTooltip(null)}
                    onClick={() => {
                      if (val === 0) return;
                      setSelectedCell(prev => (prev?.h === h && prev?.dow === dow) ? null : { h, dow });
                    }}
                    style={{
                      height: 24,
                      borderRadius: 4,
                      background: val > 0
                        ? `rgba(254,128,63,${alpha.toFixed(2)})`
                        : "rgba(255,255,255,0.04)",
                      border: isSelected
                        ? `2px solid ${C.orange}`
                        : `1px solid ${isHot ? "rgba(254,128,63,0.6)" : "rgba(255,255,255,0.06)"}`,
                      display: "flex", alignItems: "center", justifyContent: "center",
                      cursor: val > 0 ? "pointer" : "default",
                      transition: "border-color 0.1s",
                      position: "relative",
                    }}
                  >
                    {val > 0 && (
                      <span style={{
                        fontSize: 10, fontWeight: 700,
                        color: alpha > 0.5 ? "#fff" : "rgba(254,128,63,0.9)",
                      }}>
                        {val}
                      </span>
                    )}
                  </div>
                );
              })}
            </div>
          ))}

          {/* Tooltip flotante */}
          {tooltip && (
            <div style={{
              marginTop: 12, padding: "6px 12px",
              background: "rgba(254,128,63,0.12)",
              border: "1px solid rgba(254,128,63,0.3)",
              borderRadius: 8, fontSize: 12, color: C.white,
              display: "inline-flex", alignItems: "center", gap: 6,
            }}>
              <span style={{ color: C.orange, fontWeight: 700 }}>{DAYS[tooltip.dow]} {tooltip.h}h</span>
              <span style={{ color: C.mutedLight }}>→</span>
              <span style={{ fontWeight: 600 }}>{tooltip.val} conversión{tooltip.val !== 1 ? "es" : ""}</span>
            </div>
          )}

          {/* Panel de desglose por fuente (clic en celda) */}
          {selectedCell && (
            <div style={{
              marginTop: 12, padding: "12px 16px",
              background: "rgba(255,255,255,0.03)",
              border: `1px solid ${C.border}`,
              borderRadius: 8, fontSize: 12,
            }}>
              <div style={{ display: "flex", alignItems: "center", gap: 6, marginBottom: 8 }}>
                <span style={{ color: C.orange, fontWeight: 700 }}>
                  {DAYS[selectedCell.dow]} {selectedCell.h}h
                </span>
                <span style={{ color: C.mutedLight }}>→</span>
                <span style={{ color: C.white, fontWeight: 600 }}>
                  {selectedVal} conversión{selectedVal !== 1 ? "es" : ""}
                </span>
              </div>
              <div style={{ display: "flex", flexDirection: "column", gap: 4 }}>
                {selectedSources.map(({ source, count }) => (
                  <div key={source} style={{ display: "flex", justifyContent: "space-between", gap: 12 }}>
                    <span style={{ color: C.mutedLight, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                      {source}
                    </span>
                    <span style={{ color: C.white, fontWeight: 600, flexShrink: 0 }}>{count}</span>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Leyenda */}
          <div style={{ display: "flex", alignItems: "center", gap: 8, marginTop: 12 }}>
            <span style={{ fontSize: 10, color: C.muted }}>Menor</span>
            {[0.15, 0.35, 0.55, 0.75, 1.0].map(a => (
              <div key={a} style={{ width: 20, height: 12, borderRadius: 3, background: `rgba(254,128,63,${a})` }} />
            ))}
            <span style={{ fontSize: 10, color: C.muted }}>Mayor</span>
          </div>
        </div>
      )}
    </div>
  );
}
