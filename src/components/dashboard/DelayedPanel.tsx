import { Clock, AlertCircle } from "lucide-react";
import { C } from "../../tokens";
import { Card } from "../ui/Card";
import type { DelayedUser } from "../../services/dashboard";

interface DelayedPanelProps {
  users: DelayedUser[];
  mobile?: boolean;
}

export function DelayedPanel({ users, mobile }: DelayedPanelProps) {
  const totalUsd = users.reduce((s, u) => s + u.totalUsd, 0);

  return (
    <Card className={users.length > 0 ? "aivi-card-glow-yellow" : undefined} style={{ padding: mobile ? "16px 18px" : "12px 14px", display: "flex", flexDirection: "column", overflow: mobile ? "visible" : "hidden", minHeight: 0, flex: mobile ? undefined : 1 }}>
      {/* Header */}
      <div style={{ marginBottom: 8, flexShrink: 0 }}>
        <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 4 }}>
          <Clock size={14} style={{ color: C.yellow }} />
          <span style={{ fontWeight: 800, fontSize: 13, color: C.white }}>Atrasados</span>
          <span style={{
            fontSize: 10, fontWeight: 700, color: C.yellow,
            background: "rgba(255,194,82,0.12)", padding: "2px 8px",
            borderRadius: 10, border: "1px solid rgba(255,194,82,0.2)",
          }}>
            {users.length}
          </span>
        </div>
        {/* Total USD — peso visual de KPI */}
        <div style={{ fontSize: 28, fontWeight: 900, color: C.yellow, letterSpacing: "-0.04em", lineHeight: 1 }}>
          ${totalUsd.toLocaleString("en-US", { minimumFractionDigits: 0, maximumFractionDigits: 0 })}
        </div>
        <div style={{ fontSize: 9, color: C.mutedMid, marginTop: 2 }}>en cuotas pendientes</div>
      </div>

      {/* Separador */}
      <div style={{ borderTop: `1px solid ${C.border}`, marginBottom: 8, flexShrink: 0 }} />

      {/* Lista */}
      {users.length === 0 ? (
        <div style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", gap: 8 }}>
          <div style={{ fontSize: 28, opacity: 0.15 }}>✅</div>
          <span style={{ color: C.muted, fontSize: 11 }}>Sin pagos atrasados</span>
        </div>
      ) : (
        <div style={mobile ? {} : { overflow: "auto", flex: 1, minHeight: 0 }}>
          {users.map((u, i) => (
            <div key={u.email} className="aivi-row" style={{
              padding: "9px 0",
              borderBottom: i < users.length - 1 ? `1px solid ${C.border}` : "none",
            }}>
              {/* Nombre — fila completa */}
              <div style={{
                fontSize: 13, fontWeight: 700, color: C.white,
                overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
                marginBottom: 3,
              }}>
                {u.name}
              </div>
              {/* Plan + monto + cuotas */}
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", gap: 6 }}>
                <div style={{
                  fontSize: 9, color: C.mutedMid,
                  overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
                }}>
                  {u.planName.replace("Método V3 — ", "MV3 ").replace("AIVI — ", "")}
                </div>
                <div style={{ display: "flex", alignItems: "center", gap: 6, flexShrink: 0 }}>
                  <div style={{ display: "flex", alignItems: "center", gap: 3 }}>
                    <AlertCircle size={8} style={{ color: C.red }} />
                    <span style={{ fontSize: 9, color: C.red, fontWeight: 700 }}>
                      {u.cuotas} {u.cuotas === 1 ? "cuota" : "cuotas"}
                    </span>
                  </div>
                  <span style={{ fontSize: 12, fontWeight: 800, color: C.yellow }}>
                    ${u.totalUsd.toFixed(0)}
                  </span>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </Card>
  );
}
