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
    <Card style={{ padding: "16px 18px", display: "flex", flexDirection: "column", overflow: mobile ? "visible" : "hidden", minHeight: 0, flex: mobile ? undefined : 1 }}>
      {/* Header */}
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 10, flexShrink: 0 }}>
        <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
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
        <span style={{ fontSize: 11, fontWeight: 800, color: C.yellow }}>
          ${totalUsd.toLocaleString("en-US", { minimumFractionDigits: 0, maximumFractionDigits: 0 })}
        </span>
      </div>

      {/* Subtítulo */}
      <div style={{
        fontSize: 9, color: C.mutedMid, marginBottom: 8, flexShrink: 0,
        padding: "6px 0", borderBottom: `1px solid ${C.border}`,
      }}>
        Compradores con cuotas sin pagar — ordenados por monto
      </div>

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
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", gap: 6 }}>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{
                    fontSize: 11, fontWeight: 700, color: C.white,
                    overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
                  }}>
                    {u.name}
                  </div>
                  <div style={{
                    fontSize: 9, color: C.mutedMid, marginTop: 2,
                    overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
                  }}>
                    {u.planName.replace("Método V3 — ", "MV3 ").replace("AIVI — ", "")}
                  </div>
                </div>
                <div style={{ textAlign: "right", flexShrink: 0 }}>
                  <div style={{ fontSize: 12, fontWeight: 800, color: C.yellow }}>
                    ${u.totalUsd.toFixed(0)}
                  </div>
                  <div style={{ display: "flex", alignItems: "center", gap: 3, justifyContent: "flex-end", marginTop: 2 }}>
                    <AlertCircle size={8} style={{ color: C.red }} />
                    <span style={{ fontSize: 9, color: C.red, fontWeight: 700 }}>
                      {u.cuotas} {u.cuotas === 1 ? "cuota" : "cuotas"}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </Card>
  );
}
