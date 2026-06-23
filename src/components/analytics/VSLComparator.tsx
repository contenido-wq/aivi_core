import { LineChart, Line, XAxis, YAxis, Tooltip, Legend, ResponsiveContainer, ReferenceDot } from "recharts";
import { C } from "../../tokens";
import type { VSLData } from "../../services/analytics";

const COLORS = [C.orange, C.yellow, C.red, C.white, "rgba(254,128,63,0.55)", "rgba(255,194,82,0.55)"];

interface Props { vsls: VSLData[] }

export function VSLComparator({ vsls }: Props) {
  if (vsls.length === 0) return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 24, textAlign: "center" }}>
      <div style={{ fontSize: 13, color: C.mutedMid }}>Sin datos de retención en el período</div>
    </div>
  );

  const maxSeconds = Math.max(...vsls.map(v => v.retention.length > 0 ? v.retention[v.retention.length - 1].second : 0));
  const chartData: Record<string, number | null>[] = [];
  for (let s = 0; s <= maxSeconds; s += 5) {
    const point: Record<string, number | null> = { second: s };
    for (const vsl of vsls) {
      const pt = vsl.retention.find(p => p.second >= s);
      point[vsl.videoId] = pt ? pt.percentage : null;
    }
    chartData.push(point);
  }

  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 20 }}>
      <div style={{ fontSize: 14, fontWeight: 600, color: C.white, marginBottom: 16 }}>Comparador de Retención</div>

      <ResponsiveContainer width="100%" height={240}>
        <LineChart data={chartData}>
          <XAxis dataKey="second" tick={{ fontSize: 10, fill: C.mutedMid }}
            tickFormatter={(s: number) => `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`} />
          <YAxis domain={[0, 100]} tick={{ fontSize: 10, fill: C.mutedMid }} tickFormatter={(v: number) => `${v}%`} />
          <Tooltip
            contentStyle={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 8, fontSize: 12 }}
            labelFormatter={(s: number) => `Segundo ${s}`}
            formatter={(v: number) => [`${Number(v).toFixed(1)}%`, ""]}
          />
          <Legend wrapperStyle={{ fontSize: 11 }} />
          {vsls.map((vsl, i) => (
            <Line key={vsl.videoId} type="monotone" dataKey={vsl.videoId} name={vsl.videoName}
              stroke={COLORS[i % COLORS.length]} dot={false} strokeWidth={2} connectNulls />
          ))}
          {vsls.filter(v => v.dropSecond !== null).map((vsl) => {
            const pt = vsl.retention.find(p => p.second >= vsl.dropSecond!);
            return (
              <ReferenceDot key={`drop-${vsl.videoId}`}
                x={vsl.dropSecond!} y={pt?.percentage ?? 0}
                r={5} fill="#FF413B" stroke="none" />
            );
          })}
        </LineChart>
      </ResponsiveContainer>

      <table style={{ width: "100%", borderCollapse: "collapse", marginTop: 20, fontSize: 12 }}>
        <thead>
          <tr style={{ borderBottom: `1px solid ${C.border}` }}>
            {["VSL", "Plays", "Ret. 25%", "Ret. 50%", "Ret. 75%", "CTA Clicks", "Conv.", "Conv. Rate"].map(h => (
              <th key={h} style={{ padding: "6px 8px", color: C.mutedMid, fontWeight: 500, textAlign: "left" }}>{h}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {vsls.map(vsl => (
            <tr key={vsl.videoId} style={{ borderBottom: `1px solid ${C.border}` }}>
              <td style={{ padding: "8px", color: C.white, fontWeight: 500 }}>{vsl.videoName}</td>
              <td style={{ padding: "8px", color: C.mutedLight }}>{vsl.plays.toLocaleString("es")}</td>
              <td style={{ padding: "8px", color: C.mutedLight }}>{vsl.ret25.toFixed(0)}%</td>
              <td style={{ padding: "8px", color: C.mutedLight }}>{vsl.ret50.toFixed(0)}%</td>
              <td style={{ padding: "8px", color: C.mutedLight }}>{vsl.ret75.toFixed(0)}%</td>
              <td style={{ padding: "8px", color: C.mutedLight }}>{vsl.ctaClicks.toLocaleString("es")}</td>
              <td style={{ padding: "8px", color: C.mutedLight }}>{vsl.sales}</td>
              <td style={{ padding: "8px", color: C.orange, fontWeight: 600 }}>{vsl.convRate.toFixed(1)}%</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
