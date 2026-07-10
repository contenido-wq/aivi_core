import { C } from "../../tokens";
import { InfoTooltip } from "./InfoTooltip";
import type { AnalyticsSummary } from "../../services/analytics";

function delta(curr: number, prev: number | undefined): string | null {
  if (prev == null || prev === 0) return null;
  const pct = ((curr - prev) / prev) * 100;
  return `${pct >= 0 ? "+" : ""}${pct.toFixed(1)}%`;
}

function fmt(value: number, type: "usd" | "pct" | "num" | "x"): string {
  if (type === "usd") return `$${value.toLocaleString("es", { minimumFractionDigits: 0, maximumFractionDigits: 0 })}`;
  if (type === "pct") return `${value.toFixed(1)}%`;
  if (type === "x")   return `${value.toFixed(2)}x`;
  return value.toLocaleString("es");
}

interface KPI { label: string; value: number; prevValue?: number; type: "usd" | "pct" | "num" | "x"; inverseColor?: boolean; help?: string }
interface Props { summary: AnalyticsSummary | null; loading: boolean }

export function KPISummary({ summary, loading }: Props) {
  const kpis: KPI[] = summary ? [
    { label: "Inversión",      value: summary.investment,  prevValue: summary.prev?.investment,  type: "usd",
      help: "Suma de la inversión publicitaria (Meta Ads) registrada en el período." },
    { label: "Ingresos",       value: summary.revenue,     prevValue: summary.prev?.revenue,     type: "usd",
      help: "Ingresos reales de las ventas atribuidas en el período, en dólares." },
    { label: "ROI",            value: summary.roi,         prevValue: summary.prev?.roi,         type: "x",
      help: "Retorno neto sobre la inversión: (Ingresos − Inversión) ÷ Inversión. 1.0x significa que recuperaste el doble de lo invertido." },
    { label: "CAC Promedio",   value: summary.cac,         prevValue: summary.prev?.cac,         type: "usd", inverseColor: true,
      help: "Costo de adquisición por cliente: Inversión ÷ Ventas. Más bajo es mejor." },
    { label: "Ventas",         value: summary.sales,       prevValue: summary.prev?.sales,       type: "num",
      help: "Número de transacciones activas (aprobadas) en el período." },
    { label: "Plays Totales",  value: summary.plays,       prevValue: summary.prev?.plays,       type: "num",
      help: "Reproducciones del VSL (video de ventas) registradas en VTurb durante el período." },
    { label: "Play Rate",      value: summary.playRate,    prevValue: summary.prev?.playRate,     type: "pct",
      help: "% de visitantes que reprodujeron el VSL sobre el total que llegó a la página (plays ÷ vistas de página)." },
    { label: "Costo por Play", value: summary.costPerPlay, prevValue: summary.prev?.costPerPlay,  type: "usd", inverseColor: true,
      help: "Inversión ÷ Plays — cuánto cuesta cada reproducción del VSL." },
  ] : Array(8).fill({ label: "—", value: 0, type: "num" as const });

  return (
    <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 12 }}>
      {kpis.map((kpi, i) => {
        const d = !loading && summary ? delta(kpi.value, kpi.prevValue) : null;
        const isPositive = d ? !d.startsWith("-") : false;
        const dColor = d
          ? (kpi.inverseColor
              ? (isPositive ? "#FF413B" : "#FE803F")
              : (isPositive ? "#FE803F" : "#FF413B"))
          : C.mutedMid;
        return (
          <div key={i} style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 12, padding: "16px 18px" }}>
            <div style={{ fontSize: 11, color: C.mutedMid, marginBottom: 6, textTransform: "uppercase", letterSpacing: "0.05em" }}>
              {kpi.label}
              {kpi.help && <InfoTooltip text={kpi.help} />}
            </div>
            {loading ? (
              <div style={{ height: 28, background: C.cardHover, borderRadius: 6, width: "70%", animation: "pulse 1.5s ease-in-out infinite" }} />
            ) : (
              <div style={{ display: "flex", alignItems: "baseline", gap: 8 }}>
                <span style={{ fontSize: 22, fontWeight: 700, color: C.white }}>{fmt(kpi.value, kpi.type)}</span>
                {d && <span style={{ fontSize: 11, color: dColor, fontWeight: 600 }}>{d}</span>}
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
}
