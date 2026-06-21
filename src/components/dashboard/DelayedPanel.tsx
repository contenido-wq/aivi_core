import { AlertCircle, XCircle } from "lucide-react";
import { C } from "../../tokens";
import { Card } from "../ui/Card";
import type { DelayedUser, CancelledUser } from "../../services/dashboard";

interface DelayedPanelProps {
  users:          DelayedUser[];
  cancelledUsers: CancelledUser[];
  mobile?:        boolean;
}

function shortPlan(name: string) {
  return name
    .replace("Método V3 — ", "MV3 ")
    .replace("AIVI — ", "")
    .replace("Reto 15D — ", "R15D ");
}

export function DelayedPanel({ users, cancelledUsers, mobile }: DelayedPanelProps) {
  const totalDelayed   = users.reduce((s, u) => s + u.totalUsd, 0);
  const totalCount     = users.length + cancelledUsers.length;

  return (
    <Card style={{
      padding: mobile ? "16px 18px" : "12px 14px",
      display: "flex", flexDirection: "column",
      overflow: mobile ? "visible" : "hidden",
      minHeight: 0, flex: mobile ? undefined : 1,
      borderColor: totalCount > 0 ? "rgba(255,65,59,0.25)" : C.border,
    }}>
      {/* Header */}
      <div style={{ marginBottom: 8, flexShrink: 0 }}>
        <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 4 }}>
          <AlertCircle size={14} style={{ color: C.red }} />
          <span style={{ fontWeight: 800, fontSize: 13, color: C.white }}>Alertas</span>
          {totalCount > 0 && (
            <span style={{
              fontSize: 10, fontWeight: 700, color: C.red,
              background: "rgba(255,65,59,0.12)", padding: "2px 8px",
              borderRadius: 10, border: "1px solid rgba(255,65,59,0.25)",
            }}>
              {totalCount}
            </span>
          )}
        </div>
        {totalDelayed > 0 && (
          <>
            <div style={{ fontSize: 26, fontWeight: 900, color: C.red, letterSpacing: "-0.04em", lineHeight: 1 }}>
              ${totalDelayed.toLocaleString("en-US", { minimumFractionDigits: 0, maximumFractionDigits: 0 })}
            </div>
            <div style={{ fontSize: 9, color: C.mutedMid, marginTop: 2 }}>en cuotas pendientes</div>
          </>
        )}
      </div>

      <div style={{ borderTop: `1px solid ${C.border}`, marginBottom: 8, flexShrink: 0 }} />

      {/* Lista unificada */}
      {totalCount === 0 ? (
        <div style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", gap: 8 }}>
          <div style={{ fontSize: 28, opacity: 0.15 }}>✅</div>
          <span style={{ color: C.muted, fontSize: 11 }}>Sin alertas activas</span>
        </div>
      ) : (
        <div style={mobile ? {} : { overflow: "auto", flex: 1, minHeight: 0 }}>

          {/* Atrasados */}
          {users.map((u, i) => (
            <div key={`d-${u.email}`} style={{
              padding: "8px 0",
              borderBottom: (i < users.length - 1 || cancelledUsers.length > 0)
                ? `1px solid rgba(255,65,59,0.12)` : "none",
            }}>
              <div style={{ display: "flex", alignItems: "center", gap: 5, marginBottom: 2 }}>
                <AlertCircle size={9} style={{ color: C.red, flexShrink: 0 }} />
                <span style={{ fontSize: 9, fontWeight: 700, color: C.red, textTransform: "uppercase", letterSpacing: "0.06em" }}>
                  Atrasado
                </span>
                <span style={{ fontSize: 9, color: C.red, opacity: 0.6 }}>
                  · {u.cuotas} {u.cuotas === 1 ? "cuota" : "cuotas"}
                </span>
              </div>
              <div style={{
                fontSize: 13, fontWeight: 700, color: C.red,
                overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
                marginBottom: 1,
              }}>
                {u.name}
              </div>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                <div style={{
                  fontSize: 9, color: "rgba(255,65,59,0.6)",
                  overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
                }}>
                  {shortPlan(u.planName)}
                </div>
                <span style={{ fontSize: 11, fontWeight: 800, color: C.red, flexShrink: 0, marginLeft: 6 }}>
                  ${u.totalUsd.toFixed(0)}
                </span>
              </div>
            </div>
          ))}

          {/* Cancelados */}
          {cancelledUsers.map((u, i) => (
            <div key={`c-${u.email}`} style={{
              padding: "8px 0",
              borderBottom: i < cancelledUsers.length - 1 ? `1px solid rgba(255,65,59,0.12)` : "none",
            }}>
              <div style={{ display: "flex", alignItems: "center", gap: 5, marginBottom: 2 }}>
                <XCircle size={9} style={{ color: C.red, flexShrink: 0 }} />
                <span style={{ fontSize: 9, fontWeight: 700, color: C.red, textTransform: "uppercase", letterSpacing: "0.06em" }}>
                  Cancelado
                </span>
              </div>
              <div style={{
                fontSize: 13, fontWeight: 700, color: C.red,
                overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
                marginBottom: 1,
              }}>
                {u.name}
              </div>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                <div style={{
                  fontSize: 9, color: "rgba(255,65,59,0.6)",
                  overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
                }}>
                  {shortPlan(u.planName)}
                </div>
                {u.amountUsd > 0 && (
                  <span style={{ fontSize: 11, fontWeight: 800, color: C.red, flexShrink: 0, marginLeft: 6 }}>
                    ${u.amountUsd.toFixed(0)}
                  </span>
                )}
              </div>
            </div>
          ))}

        </div>
      )}
    </Card>
  );
}
