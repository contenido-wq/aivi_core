import { useState } from "react";
import { AlertCircle, XCircle, BarChart2 } from "lucide-react";
import { C } from "../../tokens";
import { Card } from "../ui/Card";
import type { DelayedUser, CancelledUser, CancelledByDay } from "../../services/dashboard";

interface DelayedPanelProps {
  users:           DelayedUser[];
  cancelledUsers:  CancelledUser[];
  cancelledByDay:  CancelledByDay[];
  mobile?:         boolean;
}

function shortPlan(name: string) {
  return name
    .replace("Método V3 — ", "MV3 ")
    .replace("AIVI — ", "")
    .replace("Reto 15D — ", "R15D ");
}

function fmtDay(dateStr: string) {
  const [, m, d] = dateStr.split("-");
  return `${d}/${m}`;
}

export function DelayedPanel({ users, cancelledUsers, cancelledByDay, mobile }: DelayedPanelProps) {
  const [view, setView] = useState<"lista" | "dias">("lista");

  const totalDelayed = users.reduce((s, u) => s + u.totalUsd, 0);
  const totalCount   = users.length + cancelledUsers.length;

  const today       = new Date();
  const todayStr    = `${today.getFullYear()}-${String(today.getMonth()+1).padStart(2,"0")}-${String(today.getDate()).padStart(2,"0")}`;
  const todayCount  = cancelledByDay.find(d => d.date === todayStr)?.count ?? 0;
  const maxCount    = Math.max(...cancelledByDay.map(d => d.count), 1);

  return (
    <Card style={{
      padding: mobile ? "16px 18px" : "12px 14px",
      display: "flex", flexDirection: "column",
      overflow: mobile ? "visible" : "hidden",
      minHeight: 0, flex: mobile ? undefined : 1,
      borderColor: totalCount > 0 ? "rgba(255,65,59,0.25)" : C.border,
    }}>
      {/* Header */}
      <div style={{ marginBottom: 6, flexShrink: 0 }}>
        <div style={{ display: "flex", alignItems: "center", gap: 6, marginBottom: 4 }}>
          <AlertCircle size={14} style={{ color: C.red }} />
          <span style={{ fontWeight: 800, fontSize: 13, color: C.white }}>Alertas</span>

          {/* Badge total alertas */}
          {totalCount > 0 && (
            <span style={{
              fontSize: 10, fontWeight: 700, color: C.red,
              background: "rgba(255,65,59,0.12)", padding: "2px 7px",
              borderRadius: 10, border: "1px solid rgba(255,65,59,0.25)",
            }}>
              {totalCount}
            </span>
          )}

          {/* Badge cancelaciones hoy */}
          {todayCount > 0 && (
            <span style={{
              fontSize: 10, fontWeight: 700, color: "#fff",
              background: C.red, padding: "2px 7px",
              borderRadius: 10, marginLeft: 2,
            }}>
              {todayCount} hoy
            </span>
          )}

          {/* Toggle vista */}
          <div style={{ marginLeft: "auto", display: "flex", gap: 2 }}>
            {(["lista", "dias"] as const).map(v => (
              <button key={v} onClick={() => setView(v)} style={{
                background: view === v ? "rgba(255,65,59,0.15)" : "transparent",
                border: view === v ? "1px solid rgba(255,65,59,0.3)" : "1px solid transparent",
                borderRadius: 6, color: view === v ? C.red : C.mutedMid,
                fontSize: 9, fontWeight: 700, padding: "3px 7px", cursor: "pointer",
                textTransform: "uppercase", letterSpacing: "0.05em",
              }}>
                {v === "lista" ? "Lista" : <BarChart2 size={10} />}
              </button>
            ))}
          </div>
        </div>

        {totalDelayed > 0 && (
          <div style={{ display: "flex", alignItems: "baseline", gap: 6 }}>
            <div style={{ fontSize: 24, fontWeight: 900, color: C.red, letterSpacing: "-0.04em", lineHeight: 1 }}>
              ${totalDelayed.toLocaleString("en-US", { minimumFractionDigits: 0, maximumFractionDigits: 0 })}
            </div>
            <div style={{ fontSize: 9, color: C.mutedMid }}>en cuotas pendientes</div>
          </div>
        )}
      </div>

      <div style={{ borderTop: `1px solid ${C.border}`, marginBottom: 8, flexShrink: 0 }} />

      {/* Vista: Lista */}
      {view === "lista" && (
        <>
          {totalCount === 0 ? (
            <div style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", gap: 8 }}>
              <div style={{ fontSize: 28, opacity: 0.15 }}>✅</div>
              <span style={{ color: C.muted, fontSize: 11 }}>Sin alertas activas</span>
            </div>
          ) : (
            <div style={mobile ? {} : { overflow: "auto", flex: 1, minHeight: 0 }}>
              {users.map((u, i) => (
                <div key={`d-${u.email}`} style={{
                  padding: "7px 0",
                  borderBottom: (i < users.length - 1 || cancelledUsers.length > 0)
                    ? `1px solid rgba(255,65,59,0.1)` : "none",
                }}>
                  <div style={{ display: "flex", alignItems: "center", gap: 4, marginBottom: 1 }}>
                    <AlertCircle size={8} style={{ color: C.red, flexShrink: 0 }} />
                    <span style={{ fontSize: 8, fontWeight: 700, color: C.red, textTransform: "uppercase", letterSpacing: "0.06em" }}>
                      Atrasado · {u.cuotas} {u.cuotas === 1 ? "cuota" : "cuotas"}
                    </span>
                  </div>
                  <div style={{ fontSize: 12, fontWeight: 700, color: C.red, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap", marginBottom: 1 }}>
                    {u.name}
                  </div>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                    <div style={{ fontSize: 9, color: "rgba(255,65,59,0.55)", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                      {shortPlan(u.planName)}
                    </div>
                    <span style={{ fontSize: 11, fontWeight: 800, color: C.red, flexShrink: 0, marginLeft: 6 }}>
                      ${u.totalUsd.toFixed(0)}
                    </span>
                  </div>
                </div>
              ))}

              {cancelledUsers.map((u, i) => (
                <div key={`c-${u.email}`} style={{
                  padding: "7px 0",
                  borderBottom: i < cancelledUsers.length - 1 ? `1px solid rgba(255,65,59,0.1)` : "none",
                }}>
                  <div style={{ display: "flex", alignItems: "center", gap: 4, marginBottom: 1 }}>
                    <XCircle size={8} style={{ color: C.red, flexShrink: 0 }} />
                    <span style={{ fontSize: 8, fontWeight: 700, color: C.red, textTransform: "uppercase", letterSpacing: "0.06em" }}>
                      Cancelado
                    </span>
                  </div>
                  <div style={{ fontSize: 12, fontWeight: 700, color: C.red, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap", marginBottom: 1 }}>
                    {u.name}
                  </div>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                    <div style={{ fontSize: 9, color: "rgba(255,65,59,0.55)", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
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
        </>
      )}

      {/* Vista: Por día */}
      {view === "dias" && (
        <div style={mobile ? {} : { overflow: "auto", flex: 1, minHeight: 0 }}>
          {cancelledByDay.length === 0 ? (
            <div style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", gap: 8, paddingTop: 24 }}>
              <div style={{ fontSize: 28, opacity: 0.15 }}>📅</div>
              <span style={{ color: C.muted, fontSize: 11 }}>Sin cancelaciones recientes</span>
            </div>
          ) : (
            cancelledByDay.map(d => (
              <div key={d.date} style={{
                display: "flex", alignItems: "center", gap: 8,
                padding: "5px 0",
                borderBottom: `1px solid rgba(255,65,59,0.08)`,
              }}>
                {/* Fecha */}
                <span style={{
                  fontSize: 10, fontWeight: 700, color: d.date === todayStr ? C.red : C.mutedMid,
                  minWidth: 34, flexShrink: 0,
                }}>
                  {fmtDay(d.date)}
                  {d.date === todayStr && <span style={{ fontSize: 7, marginLeft: 2, color: C.red }}>HOY</span>}
                </span>

                {/* Barra proporcional */}
                <div style={{ flex: 1, height: 6, background: "rgba(255,65,59,0.1)", borderRadius: 3, overflow: "hidden" }}>
                  <div style={{
                    width: `${(d.count / maxCount) * 100}%`,
                    height: "100%",
                    background: d.date === todayStr ? C.red : "rgba(255,65,59,0.5)",
                    borderRadius: 3,
                    transition: "width 0.3s ease",
                  }} />
                </div>

                {/* Conteo */}
                <span style={{
                  fontSize: 11, fontWeight: 800,
                  color: d.date === todayStr ? C.red : "rgba(255,65,59,0.7)",
                  minWidth: 16, textAlign: "right", flexShrink: 0,
                }}>
                  {d.count}
                </span>
              </div>
            ))
          )}
        </div>
      )}
    </Card>
  );
}
