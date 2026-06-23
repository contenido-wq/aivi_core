import { C } from "../../tokens";
import type { HeatmapCell } from "../../services/analytics";

const DAYS  = ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb"];
const HOURS = Array.from({ length: 24 }, (_, i) => i);

interface Props { cells: HeatmapCell[] }

export function HourlyHeatmap({ cells }: Props) {
  const maxVal = Math.max(1, ...cells.map(c => c.value));
  const lookup: Record<string, number> = {};
  for (const c of cells) lookup[`${c.hour}-${c.dow}`] = c.value;

  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 20 }}>
      <div style={{ fontSize: 14, fontWeight: 600, color: C.white, marginBottom: 16 }}>Conversiones por Hora y Día</div>
      <div style={{ overflowX: "auto" }}>
        <table style={{ borderCollapse: "collapse", fontSize: 10 }}>
          <thead>
            <tr>
              <th style={{ width: 28, color: C.mutedMid, fontWeight: 400, textAlign: "right", paddingRight: 6 }} />
              {DAYS.map(d => (
                <th key={d} style={{ width: 36, color: C.mutedMid, fontWeight: 400, textAlign: "center", paddingBottom: 6 }}>{d}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {HOURS.map(h => (
              <tr key={h}>
                <td style={{ color: C.mutedMid, textAlign: "right", paddingRight: 6, whiteSpace: "nowrap" }}>{h}h</td>
                {Array.from({ length: 7 }, (_, dow) => {
                  const val   = lookup[`${h}-${dow}`] ?? 0;
                  const alpha = val > 0 ? 0.15 + (val / maxVal) * 0.85 : 0;
                  return (
                    <td key={dow} title={`${val} conversiones`} style={{
                      width: 36, height: 24,
                      background: val > 0 ? `rgba(254,128,63,${alpha.toFixed(2)})` : C.bgSecondary,
                      border: `1px solid ${C.bg}`,
                      borderRadius: 3,
                      textAlign: "center",
                      color: alpha > 0.5 ? C.white : "transparent",
                      fontWeight: 600,
                      cursor: "default",
                    }}>
                      {val > 0 ? val : ""}
                    </td>
                  );
                })}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
