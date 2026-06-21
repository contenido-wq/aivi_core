import {
  ComposedChart, Bar, Line, XAxis, YAxis, CartesianGrid,
  Tooltip, ResponsiveContainer, ReferenceLine,
} from "recharts";
import { TrendingUp, Clock, Percent } from "lucide-react";
import { C, FONT } from "../../tokens";
import { Card } from "../ui/Card";
import { useResponsive } from "../../hooks/useResponsive";
import type { ChartDataResult, ChartTimeRange } from "../../services/dashboard";

function ChartTip({ active, payload, label }: any) {
  if (!active || !payload?.length) return null;
  return (
    <div className="fade-in" style={{
      background: "#18181B", border: `1px solid ${C.border}`,
      borderRadius: 10, padding: "10px 14px", fontSize: 12,
      boxShadow: "0 8px 24px rgba(0,0,0,0.5)",
    }}>
      <div style={{ color: C.white, marginBottom: 6, fontWeight: 600 }}>{label}</div>
      {payload.map((p: any, i: number) => (
        <div key={i} style={{ color: p.color || p.stroke, marginBottom: 3, display: "flex", justifyContent: "space-between", gap: 16 }}>
          <span style={{ fontWeight: 400 }}>{p.name}</span>
          <span style={{ fontWeight: 600, fontFamily: FONT }}>
            ${typeof p.value === "number" ? p.value.toFixed(0) : p.value}
          </span>
        </div>
      ))}
    </div>
  );
}

interface InsightChipProps {
  icon: React.ReactNode;
  label: string;
  value: string;
}

function InsightChip({ icon, label, value }: InsightChipProps) {
  return (
    <div style={{
      display: "flex", alignItems: "center", gap: 8,
      background: "rgba(255,255,255,0.03)",
      border: `1px solid rgba(255,255,255,0.1)`,
      borderRadius: 10, padding: "8px 14px",
      flex: 1,
      minWidth: 0,
    }}>
      <span style={{ color: C.mutedMid, flexShrink: 0 }}>{icon}</span>
      <div style={{ minWidth: 0 }}>
        <div style={{ fontSize: 10, color: C.mutedMid, fontWeight: 500, whiteSpace: "nowrap" }}>{label}</div>
        <div style={{ fontSize: 13, color: C.white, fontWeight: 600, fontFamily: FONT, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{value}</div>
      </div>
    </div>
  );
}

interface ChartPanelProps {
  chartData: ChartDataResult | null;
  chartRange: ChartTimeRange;
  onRangeChange: (range: ChartTimeRange) => void;
}

export function ChartPanel({ chartData, chartRange, onRangeChange }: ChartPanelProps) {
  const { isMobile } = useResponsive();
  const points = chartData?.points ?? [];

  // Verificar si hay datos reales (ingresos > 0 en al menos un punto)
  const hasRealData = points.some(p => p.ingresos > 0 || p.inversion > 0);
  const totalIngresos = points.reduce((s, p) => s + p.ingresos, 0);

  // Calcular meta promedio como referencia visual
  const avgIngresos = hasRealData
    ? totalIngresos / points.filter(p => p.ingresos > 0).length
    : 0;
  const metaLine = Math.round(avgIngresos * 1.2); // meta = 20% sobre el promedio

  const TABS: { value: ChartTimeRange; label: string }[] = [
    { value: "hoy",    label: "Hoy" },
    { value: "semana", label: "Semana" },
    { value: "mes",    label: "Mes" },
  ];

  return (
    <Card style={{ padding: isMobile ? "16px 14px 12px" : "20px 24px 16px", height: "100%", overflow: "hidden", display: "flex", flexDirection: "column" }}>
      {/* Header */}
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16, flexWrap: "wrap", gap: 8 }}>
        <div>
          <h2 style={{ fontSize: isMobile ? 14 : 16, fontWeight: 600, color: C.white, margin: 0 }}>
            Ingresos vs Inversión
          </h2>
        </div>

        {/* Tabs */}
        <div style={{ display: "flex", gap: 2 }}>
          {TABS.map(t => (
            <button
              key={t.value}
              onClick={() => onRangeChange(t.value)}
              style={{
                background: chartRange === t.value ? "rgba(254,128,63,0.12)" : "transparent",
                border: chartRange === t.value ? `1px solid rgba(254,128,63,0.3)` : "1px solid transparent",
                borderRadius: 8,
                color: chartRange === t.value ? C.orange : C.mutedMid,
                padding: isMobile ? "4px 10px" : "5px 14px",
                fontSize: isMobile ? 11 : 13,
                fontWeight: chartRange === t.value ? 600 : 400,
                cursor: "pointer",
                transition: "all 0.15s",
              }}
            >
              {t.label}
            </button>
          ))}
        </div>
      </div>

      {/* Insight chips */}
      <div style={{ display: "flex", gap: isMobile ? 6 : 10, marginBottom: 16, flexWrap: isMobile ? "wrap" : "nowrap" }}>
        <InsightChip
          icon={<TrendingUp size={14} />}
          label="Pico de ingresos"
          value={chartData?.peakHour ?? "—"}
        />
        <InsightChip
          icon={<Clock size={14} />}
          label="Hora más rentable"
          value={chartData?.bestHour ?? "—"}
        />
        <InsightChip
          icon={<Percent size={14} />}
          label="Margen"
          value={chartData ? `${chartData.margin}%` : "—"}
        />
      </div>

      {/* Total del periodo */}
      {hasRealData && (
        <div style={{ marginBottom: 8, fontSize: 11, color: C.mutedLight }}>
          Total: <span style={{ fontWeight: 700, color: C.green }}>${totalIngresos.toFixed(2)} USD</span>
        </div>
      )}

      {/* Chart — flex:1 para ocupar todo el espacio disponible en la card */}
      {!hasRealData ? (
        <div style={{
          flex: 1, minHeight: 80, display: "flex", flexDirection: "column",
          alignItems: "center", justifyContent: "center",
          color: C.muted, fontSize: 13, gap: 8,
        }}>
          <div style={{ fontSize: 28, opacity: 0.15 }}>📊</div>
          <span>Sin ingresos en este período</span>
          <span style={{ fontSize: 10 }}>Prueba con "Semana" o "Mes"</span>
        </div>
      ) : (
        <div style={{ flex: 1, minHeight: isMobile ? 120 : 160 }}>
        <ResponsiveContainer width="100%" height="100%">
          <ComposedChart data={points} margin={{ top: 4, right: 8, left: isMobile ? -24 : -16, bottom: 0 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.04)" vertical={false} />
            <XAxis
              dataKey="t"
              tick={{ fill: C.mutedMid, fontSize: isMobile ? 8 : 10, fontFamily: FONT }}
              tickLine={false}
              axisLine={false}
              interval={chartRange === "hoy" ? (isMobile ? 5 : 3) : chartRange === "semana" ? 0 : (isMobile ? 6 : 4)}
            />
            <YAxis
              tick={{ fill: C.mutedMid, fontSize: isMobile ? 8 : 10, fontFamily: FONT }}
              tickLine={false}
              axisLine={false}
              tickFormatter={(v: number) => `$${v}`}
            />
            <Tooltip content={<ChartTip />} />
            {metaLine > 0 && (
              <ReferenceLine
                y={metaLine}
                stroke={C.mutedMid}
                strokeDasharray="6 4"
                strokeWidth={1}
                label={{
                  value: "Meta",
                  position: "right",
                  fill: C.mutedMid,
                  fontSize: 10,
                }}
              />
            )}
            <Bar
              dataKey="ingresos"
              fill={C.blue}
              radius={[3, 3, 0, 0]}
              opacity={0.7}
              name="Ingresos"
              isAnimationActive={true}
              animationDuration={800}
              animationEasing="ease-out"
            />
            <Line
              type="monotone"
              dataKey="inversion"
              stroke={C.purple}
              strokeWidth={2}
              dot={false}
              name="Inversión"
              isAnimationActive={true}
              animationDuration={1000}
              animationEasing="ease-out"
            />
          </ComposedChart>
        </ResponsiveContainer>
        </div>
      )}

      {/* Legend */}
      <div style={{ display: "flex", gap: isMobile ? 10 : 18, marginTop: 12, justifyContent: "center", flexWrap: "wrap" }}>
        {/* Ingresos — barra */}
        <span style={{ fontSize: 11, color: C.mutedLight, display: "flex", alignItems: "center", gap: 6 }}>
          <span style={{ display: "flex", alignItems: "flex-end", gap: 2, height: 14 }}>
            <span style={{ width: 5, height: 8,  borderRadius: "2px 2px 0 0", background: C.blue, display: "inline-block", opacity: 0.5 }} />
            <span style={{ width: 5, height: 14, borderRadius: "2px 2px 0 0", background: C.blue, display: "inline-block", opacity: 0.85 }} />
            <span style={{ width: 5, height: 10, borderRadius: "2px 2px 0 0", background: C.blue, display: "inline-block", opacity: 0.5 }} />
          </span>
          Ingresos
        </span>
        {/* Inversión — línea */}
        <span style={{ fontSize: 11, color: C.mutedLight, display: "flex", alignItems: "center", gap: 6 }}>
          <span style={{ position: "relative", width: 22, height: 14, display: "inline-flex", alignItems: "center" }}>
            <span style={{ width: "100%", height: 2, background: C.purple, borderRadius: 1, display: "inline-block" }} />
            <span style={{ position: "absolute", left: "50%", top: "50%", transform: "translate(-50%,-50%)", width: 6, height: 6, borderRadius: "50%", background: C.purple, border: `2px solid #18181B` }} />
          </span>
          Inversión
        </span>
        {/* Meta — dashed */}
        <span style={{ fontSize: 11, color: C.mutedLight, display: "flex", alignItems: "center", gap: 6 }}>
          <span style={{ width: 18, height: 0, borderTop: `2px dashed ${C.mutedMid}`, display: "inline-block" }} />
          Meta
        </span>
      </div>
    </Card>
  );
}
