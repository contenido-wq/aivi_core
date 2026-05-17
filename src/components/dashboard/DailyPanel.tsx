import { C } from "../../tokens";
import { Card } from "../ui/Card";
import type { DailyData } from "../../services/dashboard";

interface DailyPanelProps {
  date:         Date;
  daily:        DailyData      | null;
  onDateChange: (d: Date) => void;
}

interface MetricRowProps {
  label:  string;
  value:  string;
  color:  string;
}

function MetricRow({ label, value, color }: MetricRowProps) {
  return (
    <div style={{
      display: "flex", justifyContent: "space-between", alignItems: "center",
      padding: "10px 0",
      borderBottom: `1px solid ${C.border}`,
    }}>
      <span style={{ fontSize: 13, fontWeight: 500, color: C.mutedLight }}>{label}</span>
      <span style={{ fontSize: 16, fontWeight: 700, color, fontVariantNumeric: "tabular-nums" }}>{value}</span>
    </div>
  );
}

export function DailyPanel({ daily }: DailyPanelProps) {
  const revenue    = daily?.revenue    ?? 0;
  const investment = daily?.investment ?? 0;
  const roas       = investment > 0 ? (revenue / investment) : 0;
  const dailyGoal  = 400;
  const goalPct    = dailyGoal > 0 ? Math.min((revenue / dailyGoal) * 100, 100) : 0;

  return (
    <Card style={{ padding: "20px", display: "flex", flexDirection: "column", gap: 0 }}>
      <h3 style={{ fontSize: 16, fontWeight: 600, color: C.white, marginBottom: 16, margin: 0 }}>
        Resumen del día
      </h3>

      <MetricRow label="Ingresos hoy" value={`$${revenue.toFixed(2)}`} color={C.green} />
      <MetricRow label="Inversión hoy" value={`$${investment.toFixed(2)}`} color={C.yellow} />
      <MetricRow label="ROAS hoy" value={`${roas.toFixed(2)}x`} color={C.yellow} />

      {/* Meta diaria */}
      <div style={{ padding: "14px 0 0" }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 8 }}>
          <span style={{ fontSize: 13, fontWeight: 500, color: C.mutedLight }}>Meta diaria</span>
          <span style={{
            fontSize: 14, fontWeight: 600, fontVariantNumeric: "tabular-nums",
            color: goalPct >= 100 ? C.green : C.orange,
          }}>
            {goalPct.toFixed(0)}%
          </span>
        </div>
        <div style={{
          height: 6, background: "rgba(255,255,255,0.06)",
          borderRadius: 3, overflow: "hidden",
        }}>
          <div style={{
            height: "100%",
            width: `${goalPct}%`,
            background: goalPct >= 100
              ? C.green
              : `linear-gradient(90deg, ${C.orange}, ${C.yellow})`,
            borderRadius: 3,
            transition: "width 0.6s ease",
          }} />
        </div>
      </div>
    </Card>
  );
}
