import { AlertTriangle, Clock, Shield } from "lucide-react";
import { C } from "../../tokens";
import { Card } from "../ui/Card";
import type { AtRiskUser } from "../../services/dashboard";

interface AtRiskPanelProps {
  users: AtRiskUser[];
}

const RISK_CONFIG = {
  alto:  { color: C.red,    bg: "rgba(255,65,59,0.08)", border: "rgba(255,65,59,0.2)",  icon: AlertTriangle, label: "Alto" },
  medio: { color: C.yellow, bg: "rgba(255,194,82,0.08)", border: "rgba(255,194,82,0.2)", icon: Clock,         label: "Medio" },
  bajo:  { color: C.green,  bg: "rgba(34,197,94,0.08)",  border: "rgba(34,197,94,0.2)",  icon: Shield,        label: "Bajo" },
};

function RiskBadge({ level }: { level: "alto" | "medio" | "bajo" }) {
  const config = RISK_CONFIG[level];
  return (
    <span style={{
      display: "inline-flex", alignItems: "center", gap: 3,
      padding: "2px 8px", borderRadius: 12,
      fontSize: 9, fontWeight: 700,
      background: config.bg,
      border: `1px solid ${config.border}`,
      color: config.color,
      textTransform: "uppercase",
      letterSpacing: "0.05em",
    }}>
      <config.icon size={9} />
      {config.label}
    </span>
  );
}

function DaysBar({ daysActive }: { daysActive: number }) {
  const pct = Math.min((daysActive / 7) * 100, 100);
  const color = daysActive <= 2 ? C.red : daysActive <= 5 ? C.yellow : C.green;

  return (
    <div style={{ display: "flex", alignItems: "center", gap: 6, marginTop: 4 }}>
      <div style={{ flex: 1, height: 3, background: "rgba(255,255,255,0.06)", borderRadius: 2, overflow: "hidden" }}>
        <div style={{
          height: "100%",
          width: `${pct}%`,
          background: color,
          borderRadius: 2,
          transition: "width 0.5s ease",
        }} />
      </div>
      <span style={{ fontSize: 9, color: C.muted, fontWeight: 600, whiteSpace: "nowrap" }}>
        {daysActive}d / 7d
      </span>
    </div>
  );
}

export function AtRiskPanel({ users }: AtRiskPanelProps) {
  const altoCount  = users.filter(u => u.riskLevel === "alto").length;
  const medioCount = users.filter(u => u.riskLevel === "medio").length;
  const bajoCount  = users.filter(u => u.riskLevel === "bajo").length;

  return (
    <Card style={{ padding: "16px 18px", display: "flex", flexDirection: "column", overflow: "hidden", minHeight: 0 }}>
      {/* Header */}
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 10, flexShrink: 0 }}>
        <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
          <AlertTriangle size={14} style={{ color: C.yellow }} />
          <span style={{ fontWeight: 800, fontSize: 13, color: C.white }}>
            Seguimiento
          </span>
          <span style={{
            fontSize: 10, fontWeight: 700, color: C.yellow,
            background: "rgba(255,194,82,0.12)", padding: "2px 8px",
            borderRadius: 10, border: "1px solid rgba(255,194,82,0.2)",
          }}>
            {users.length}
          </span>
        </div>
      </div>

      {/* Resumen de riesgo */}
      {users.length > 0 && (
        <div style={{
          display: "flex", gap: 8, marginBottom: 10, flexShrink: 0,
        }}>
          {[
            { label: "Alto", count: altoCount, color: C.red },
            { label: "Medio", count: medioCount, color: C.yellow },
            { label: "Bajo", count: bajoCount, color: C.green },
          ].map(r => (
            <div key={r.label} style={{
              flex: 1, textAlign: "center",
              padding: "7px 4px", borderRadius: 8,
              background: r.count > 0 ? `${r.color}08` : "rgba(255,255,255,0.03)",
              border: `1px solid ${r.count > 0 ? `${r.color}30` : C.border}`,
            }}>
              <div style={{ fontSize: 18, fontWeight: 900, color: r.count > 0 ? r.color : C.muted, lineHeight: 1 }}>{r.count}</div>
              <div style={{ fontSize: 8, color: r.count > 0 ? r.color : C.muted, fontWeight: 700, textTransform: "uppercase", letterSpacing: "0.05em", marginTop: 3, opacity: r.count > 0 ? 0.8 : 0.5 }}>{r.label}</div>
            </div>
          ))}
        </div>
      )}

      {/* Descripción */}
      <div style={{
        fontSize: 9, color: C.mutedMid, marginBottom: 8, flexShrink: 0,
        padding: "6px 0", borderBottom: `1px solid ${C.border}`,
      }}>
        Compradores nuevos en sus primeros 7 días — riesgo de cancelación
      </div>

      {/* Lista de usuarios */}
      {users.length === 0 ? (
        <div style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", paddingTop: 16, gap: 8 }}>
          <div style={{ fontSize: 28, opacity: 0.15 }}>✅</div>
          <span style={{ color: C.muted, fontSize: 11 }}>Sin usuarios nuevos en riesgo</span>
        </div>
      ) : (
        <div style={{ overflow: "auto", flex: 1, minHeight: 0 }}>
          {users.map((u, i) => (
            <div key={u.email} className="aivi-row" style={{
              padding: "10px 0",
              borderBottom: i < users.length - 1 ? `1px solid ${C.border}` : "none",
            }}>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 4 }}>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{
                    fontSize: 11, fontWeight: 700, color: C.white,
                    overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
                  }}>
                    {u.name}
                  </div>
                  <div style={{
                    fontSize: 9, color: C.mutedMid, marginTop: 1,
                    overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
                  }}>
                    {u.email}
                  </div>
                </div>
                <RiskBadge level={u.riskLevel} />
              </div>

              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", fontSize: 9, color: C.muted }}>
                <span>{u.planName.replace("AIVI — ", "").replace("Método V3 — ", "MV3 ")}</span>
                <span style={{ color: C.green, fontWeight: 700 }}>${u.amountUsd.toFixed(2)} USD</span>
              </div>

              <DaysBar daysActive={u.daysActive} />

              <div style={{ display: "flex", justifyContent: "space-between", marginTop: 4, fontSize: 8, color: C.mutedMid }}>
                <span>Compró: {new Date(u.purchaseDate).toLocaleDateString("es-CO", { day: "2-digit", month: "short" })}</span>
                <span style={{ color: u.daysLeft <= 2 ? C.red : C.yellow, fontWeight: 700 }}>
                  {u.daysLeft === 0 ? "Último día" : `${u.daysLeft} día${u.daysLeft !== 1 ? "s" : ""} restante${u.daysLeft !== 1 ? "s" : ""}`}
                </span>
              </div>
            </div>
          ))}
        </div>
      )}
    </Card>
  );
}
