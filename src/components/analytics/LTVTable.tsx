import { C } from "../../tokens";
import type { LTVRow } from "../../services/analytics";

interface Props { rows: LTVRow[] }

export function LTVTable({ rows }: Props) {
  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 20 }}>
      <div style={{ fontSize: 14, fontWeight: 600, color: C.white, marginBottom: 4 }}>LTV por Fuente de Tráfico</div>
      <div style={{ fontSize: 12, color: C.mutedMid, marginBottom: 16 }}>
        ROI Real = LTV Promedio ÷ CAC — revela el valor a largo plazo de cada fuente
      </div>
      <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 12 }}>
        <thead>
          <tr style={{ borderBottom: `1px solid ${C.border}` }}>
            {["Campaña","Clientes","LTV Prom.","Ingresos Totales","CAC","ROI Real"].map(h => (
              <th key={h} style={{ padding: "6px 10px", color: C.mutedMid, fontWeight: 500, textAlign: "left" }}>{h}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((r, i) => (
            <tr key={i} style={{ borderBottom: `1px solid ${C.border}` }}>
              <td style={{ padding: "9px 10px", color: C.white, fontWeight: 500 }}>{r.campaignName}</td>
              <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.customers}</td>
              <td style={{ padding: "9px 10px", color: C.white, fontWeight: 600 }}>${r.ltv.toFixed(0)}</td>
              <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.totalRevenue.toFixed(0)}</td>
              <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.cac.toFixed(0)}</td>
              <td style={{ padding: "9px 10px" }}>
                <span style={{ color: r.roiReal >= 5 ? "#FE803F" : r.roiReal >= 2 ? "#FFC252" : "#FF413B", fontWeight: 700, fontSize: 13 }}>
                  {r.roiReal.toFixed(1)}x
                </span>
              </td>
            </tr>
          ))}
          {rows.length === 0 && (
            <tr><td colSpan={6} style={{ padding: 20, textAlign: "center", color: C.mutedMid, fontSize: 13 }}>Sin datos suficientes para calcular LTV</td></tr>
          )}
        </tbody>
      </table>
    </div>
  );
}
