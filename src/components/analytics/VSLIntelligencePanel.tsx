import {
  LineChart, Line, XAxis, YAxis, Tooltip,
  ReferenceDot, ResponsiveContainer,
} from "recharts";
import { C, FONT } from "../../tokens";
import type { VSLData } from "../../services/analytics";

type Level = "high" | "mid" | "low";

function scoreLevel(value: number, hi: number, mid: number): Level {
  if (value >= hi)  return "high";
  if (value >= mid) return "mid";
  return "low";
}

const LEVEL_COLOR: Record<Level, string> = { high: C.green, mid: C.yellow, low: C.red };
const LEVEL_DOTS:  Record<Level, string> = { high: "●●●", mid: "●●○", low: "●○○" };

function fmtSec(s: number) {
  return `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`;
}

function MetricRow({ label, value, color }: { label: string; value: string; color?: string }) {
  return (
    <div style={{
      display: "flex", justifyContent: "space-between", alignItems: "center",
      padding: "5px 0", borderBottom: `1px solid ${C.border}`,
    }}>
      <span style={{ fontSize: 11, color: C.muted }}>{label}</span>
      <span style={{ fontSize: 12, fontWeight: 700, color: color ?? C.white }}>{value}</span>
    </div>
  );
}

function VerdictRow({ label, level }: { label: string; level: Level }) {
  return (
    <div style={{
      display: "flex", justifyContent: "space-between", alignItems: "center",
      padding: "6px 0", borderBottom: `1px solid ${C.border}`,
    }}>
      <span style={{ fontSize: 11, color: C.mutedLight }}>{label}</span>
      <span style={{ fontSize: 13, color: LEVEL_COLOR[level], letterSpacing: 1, fontWeight: 700 }}>
        {LEVEL_DOTS[level]}
      </span>
    </div>
  );
}

function buildChartData(primary: VSLData, compare?: VSLData | null) {
  const maxSec = Math.max(
    primary.retention[primary.retention.length - 1]?.second ?? 0,
    compare ? (compare.retention[compare.retention.length - 1]?.second ?? 0) : 0,
  );
  const data: Record<string, number | null>[] = [];
  for (let s = 0; s <= maxSec; s += 5) {
    const pt: Record<string, number | null> = { s };
    pt["primary"] = primary.retention.find(p => p.second >= s)?.percentage ?? null;
    if (compare) {
      pt["compare"] = compare.retention.find(p => p.second >= s)?.percentage ?? null;
    }
    data.push(pt);
  }
  return data;
}

interface Props {
  primary:  VSLData | null;
  compare?: VSLData | null;
}

export function VSLIntelligencePanel({ primary, compare }: Props) {
  if (!primary) return (
    <div style={{
      background: C.card, border: `1px solid ${C.border}`,
      borderRadius: 14, padding: 32,
      display: "flex", alignItems: "center", justifyContent: "center",
      flexDirection: "column", gap: 8, minHeight: 120,
    }}>
      <div style={{ fontSize: 13, color: C.mutedMid }}>Sin datos de retención para este período</div>
      <div style={{ fontSize: 11, color: C.muted }}>Selecciona un VSL o espera a que lleguen datos de VTurb</div>
    </div>
  );

  const hasRetention = primary.retention.length > 2;
  const chartData  = buildChartData(primary, compare);
  const dropPt     = primary.dropSecond != null
    ? primary.retention.find(p => p.second >= primary.dropSecond!)
    : null;
  const ctaRate    = primary.plays > 0 ? (primary.ctaClicks / primary.plays) * 100 : 0;
  const hookLevel  = scoreLevel(primary.ret25,  60, 40);
  const retLevel   = scoreLevel(primary.ret50,  40, 25);
  const ctaLevel   = scoreLevel(ctaRate,         8,  4);

  return (
    <div style={{
      background: C.card, border: `1px solid ${C.border}`,
      borderRadius: 14, padding: 20,
      display: "grid",
      gridTemplateColumns: "1fr 220px 180px",
      gap: 24,
    }}>
      {/* Columna 1 — Curva de retención */}
      <div>
        <div style={{ fontSize: 13, fontWeight: 600, color: C.white, marginBottom: 4 }}>
          Retención — {primary.videoName}
        </div>
        {primary.dropSecond != null && (
          <div style={{ fontSize: 11, color: C.red, marginBottom: 10 }}>
            Audiencia abandona en {fmtSec(primary.dropSecond)}
          </div>
        )}
        {!hasRetention && (
          <div style={{
            height: 200, display: "flex", alignItems: "center", justifyContent: "center",
            flexDirection: "column", gap: 6,
            background: "rgba(255,255,255,0.02)", borderRadius: 8, border: `1px dashed ${C.border}`,
          }}>
            <div style={{ fontSize: 12, color: C.mutedMid }}>Sin suficientes datos de retención</div>
            <div style={{ fontSize: 11, color: C.muted }}>El sync de VTurb necesita más historial</div>
          </div>
        )}
        {hasRetention && <ResponsiveContainer width="100%" height={200}>
          <LineChart data={chartData}>
            <XAxis
              dataKey="s"
              tick={{ fontSize: 10, fill: C.mutedMid, fontFamily: FONT }}
              tickFormatter={fmtSec}
              tickLine={false} axisLine={false}
            />
            <YAxis
              domain={[0, 100]}
              tick={{ fontSize: 10, fill: C.mutedMid, fontFamily: FONT }}
              tickFormatter={v => `${v}%`}
              tickLine={false} axisLine={false}
            />
            <Tooltip
              contentStyle={{
                background: C.card, border: `1px solid ${C.border}`,
                borderRadius: 8, fontSize: 11,
              }}
              labelFormatter={s => `Minuto ${fmtSec(Number(s))}`}
              formatter={(v: number) => [`${Number(v).toFixed(1)}%`, ""]}
            />
            <Line
              type="monotone" dataKey="primary" name={primary.videoName}
              stroke={C.orange} strokeWidth={2} dot={false} connectNulls
            />
            {compare && (
              <Line
                type="monotone" dataKey="compare" name={compare.videoName}
                stroke={C.yellow} strokeWidth={2} dot={false}
                connectNulls strokeDasharray="6 3"
              />
            )}
            {dropPt && (
              <ReferenceDot
                x={primary.dropSecond!} y={dropPt.percentage}
                r={5} fill={C.red} stroke="none"
              />
            )}
          </LineChart>
        </ResponsiveContainer>}
        {hasRetention && compare && (
          <div style={{ display: "flex", gap: 16, marginTop: 8 }}>
            <span style={{ fontSize: 11, color: C.mutedLight, display: "flex", alignItems: "center", gap: 5 }}>
              <span style={{ width: 18, height: 2, background: C.orange, display: "inline-block", borderRadius: 1 }} />
              {primary.videoName}
            </span>
            <span style={{ fontSize: 11, color: C.mutedLight, display: "flex", alignItems: "center", gap: 5 }}>
              <span style={{ width: 18, height: 0, borderTop: `2px dashed ${C.yellow}`, display: "inline-block" }} />
              {compare.videoName}
            </span>
          </div>
        )}
      </div>

      {/* Columna 2 — Métricas del video */}
      <div>
        <div style={{
          fontSize: 10, fontWeight: 700, color: C.mutedLight,
          textTransform: "uppercase", letterSpacing: "0.07em", marginBottom: 10,
        }}>
          Métricas del video
        </div>
        <MetricRow label="Plays" value={primary.plays.toLocaleString("es")} />
        <MetricRow
          label="Retención 25%"
          value={`${primary.ret25.toFixed(0)}%`}
          color={primary.ret25 >= 60 ? C.green : primary.ret25 >= 40 ? C.yellow : C.red}
        />
        <MetricRow
          label="Retención 50%"
          value={`${primary.ret50.toFixed(0)}%`}
          color={primary.ret50 >= 40 ? C.green : primary.ret50 >= 25 ? C.yellow : C.red}
        />
        <MetricRow
          label="Retención 75%"
          value={`${primary.ret75.toFixed(0)}%`}
          color={primary.ret75 >= 20 ? C.green : primary.ret75 >= 10 ? C.yellow : C.red}
        />
        <MetricRow label="CTA Clicks" value={primary.ctaClicks.toLocaleString("es")} />
        <MetricRow
          label="CTA Click Rate"
          value={`${ctaRate.toFixed(1)}%`}
          color={ctaRate >= 8 ? C.green : ctaRate >= 4 ? C.yellow : C.red}
        />
        <MetricRow
          label="Conv. Rate"
          value={`${primary.convRate.toFixed(1)}%`}
          color={primary.convRate >= 3 ? C.green : primary.convRate >= 1 ? C.yellow : C.red}
        />
        {compare && (
          <>
            <div style={{ height: 1, background: `${C.yellow}40`, margin: "8px 0" }} />
            <div style={{ fontSize: 11, color: C.yellow, fontWeight: 700, marginBottom: 6 }}>
              {compare.videoName}
            </div>
            <MetricRow label="Plays" value={compare.plays.toLocaleString("es")} />
            <MetricRow
              label="Retención 25%"
              value={`${compare.ret25.toFixed(0)}%`}
              color={compare.ret25 >= 60 ? C.green : compare.ret25 >= 40 ? C.yellow : C.red}
            />
            <MetricRow
              label="Retención 50%"
              value={`${compare.ret50.toFixed(0)}%`}
              color={compare.ret50 >= 40 ? C.green : compare.ret50 >= 25 ? C.yellow : C.red}
            />
            <MetricRow
              label="CTA Click Rate"
              value={`${(compare.plays > 0 ? (compare.ctaClicks / compare.plays) * 100 : 0).toFixed(1)}%`}
              color={(compare.plays > 0 ? (compare.ctaClicks / compare.plays) * 100 : 0) >= 8 ? C.green
                   : (compare.plays > 0 ? (compare.ctaClicks / compare.plays) * 100 : 0) >= 4 ? C.yellow : C.red}
            />
          </>
        )}
      </div>

      {/* Columna 3 — Veredicto */}
      <div>
        <div style={{
          fontSize: 10, fontWeight: 700, color: C.mutedLight,
          textTransform: "uppercase", letterSpacing: "0.07em", marginBottom: 10,
        }}>
          Veredicto
        </div>
        <VerdictRow label="Hook (ret. 25%)"     level={hookLevel} />
        <VerdictRow label="Retención media 50%" level={retLevel}  />
        <VerdictRow label="Cierre (CTA rate)"   level={ctaLevel}  />
        <div style={{
          marginTop: 12, padding: "10px 12px", borderRadius: 8,
          background: "rgba(255,255,255,0.03)", border: `1px solid ${C.border}`,
        }}>
          <div style={{ fontSize: 10, color: C.muted, marginBottom: 4 }}>Drop más pronunciado</div>
          <div style={{ fontSize: 14, fontWeight: 700, color: C.red }}>
            {primary.dropSecond != null ? fmtSec(primary.dropSecond) : "—"}
          </div>
          {primary.dropSecond != null && (
            <div style={{ fontSize: 10, color: C.mutedMid, marginTop: 2 }}>
              Revisar el guión en ese punto
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
