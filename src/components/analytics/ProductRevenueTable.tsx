import { C } from "../../tokens";
import { InfoTooltip } from "./InfoTooltip";
import type { ProductRevenueRow } from "../../services/analytics";

interface Props { rows: ProductRevenueRow[] }

export function ProductRevenueTable({ rows }: Props) {
  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 20 }}>
      <div style={{ fontSize: 14, fontWeight: 600, color: C.white, marginBottom: 4 }}>
        Ingresos por Producto
        <InfoTooltip text="Agrupa las ventas de Hotmart por producto según su plan_name. El rango de fechas es fijo (1 oct 2025 - hoy) y no cambia con el selector de fechas de arriba." />
      </div>
      <div style={{ fontSize: 12, color: C.mutedMid, marginBottom: 16 }}>
        AIVI, Contenido que Vende con IA y MV3 — 1 oct 2025 hasta hoy
      </div>
      <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 12 }}>
        <thead>
          <tr style={{ borderBottom: `1px solid ${C.border}` }}>
            {["Producto", "Ingresos", "Ventas", "Ticket Promedio"].map(h => (
              <th key={h} style={{ padding: "6px 10px", color: C.mutedMid, fontWeight: 500, textAlign: "left" }}>{h}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map(r => (
            <tr key={r.product} style={{ borderBottom: `1px solid ${C.border}` }}>
              <td style={{ padding: "9px 10px", color: C.white, fontWeight: 500 }}>{r.product}</td>
              <td style={{ padding: "9px 10px", color: C.white, fontWeight: 600 }}>${r.revenue.toFixed(0)}</td>
              <td style={{ padding: "9px 10px", color: C.mutedLight }}>{r.sales}</td>
              <td style={{ padding: "9px 10px", color: C.mutedLight }}>${r.avgTicket.toFixed(0)}</td>
            </tr>
          ))}
          {rows.length === 0 && (
            <tr><td colSpan={4} style={{ padding: 20, textAlign: "center", color: C.mutedMid, fontSize: 13 }}>Sin ventas de estos productos en el período</td></tr>
          )}
        </tbody>
      </table>
    </div>
  );
}
