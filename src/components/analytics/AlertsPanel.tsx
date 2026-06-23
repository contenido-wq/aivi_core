import { C } from "../../tokens";
import type { Alert } from "../../services/analytics";

const STYLE: Record<Alert["level"], { bg: string; border: string; icon: string }> = {
  rojo:     { bg: "rgba(255,65,59,0.12)",  border: "#FF413B", icon: "🔴" },
  amarillo: { bg: "rgba(255,194,82,0.12)", border: "#FFC252", icon: "🟡" },
  verde:    { bg: "rgba(74,222,128,0.12)", border: "#4ADE80", icon: "🟢" },
};

interface Props { alerts: Alert[] }

export function AlertsPanel({ alerts }: Props) {
  if (alerts.length === 0) return null;
  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
      {alerts.map((a, i) => {
        const s = STYLE[a.level];
        return (
          <div key={i} style={{
            background: s.bg, border: `1px solid ${s.border}`,
            borderRadius: 10, padding: "10px 14px",
            display: "flex", alignItems: "center", gap: 10,
          }}>
            <span style={{ fontSize: 14 }}>{s.icon}</span>
            <span style={{ fontSize: 13, color: C.white, lineHeight: 1.4 }}>{a.message}</span>
          </div>
        );
      })}
    </div>
  );
}
