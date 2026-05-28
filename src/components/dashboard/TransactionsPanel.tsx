import { useState, useEffect } from "react";
import { ChevronLeft, ChevronRight, Calendar } from "lucide-react";
import { C } from "../../tokens";
import { Card } from "../ui/Card";
import type { Transaction } from "../../services/dashboard";

const EVENT_LABEL: Record<string, string> = {
  PURCHASE_COMPLETE:          "Venta",
  PURCHASE_APPROVED:          "Venta",
  PURCHASE_REFUNDED:          "Reembolso",
  CHARGEBACK:                 "Chargeback",
  PURCHASE_CHARGEBACK:        "Chargeback",
  SUBSCRIPTION_CANCELLATION:  "Cancelación",
  PURCHASE_CANCELED:          "Cancelación",
  PURCHASE_DELAYED:           "Atrasado",
  PURCHASE_PROTEST:           "Trial",
};

const MONTHS_ES = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];

type ViewMode = "dia" | "mes";

interface TransactionsPanelProps {
  transactions: Transaction[];
  onDateRangeChange: (startDate: Date, endDate: Date) => void;
}

export function TransactionsPanel({ transactions, onDateRangeChange }: TransactionsPanelProps) {
  const [viewMode, setViewMode] = useState<ViewMode>("dia");
  const [currentDate, setCurrentDate] = useState(() => new Date());

  // Cuando cambia la fecha o el modo, disparar la carga de transacciones
  useEffect(() => {
    if (viewMode === "dia") {
      const start = new Date(currentDate);
      start.setHours(0, 0, 0, 0);
      const end = new Date(currentDate);
      end.setHours(23, 59, 59, 999);
      onDateRangeChange(start, end);
    } else {
      // Mes completo
      const start = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
      const end = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
      end.setHours(23, 59, 59, 999);
      onDateRangeChange(start, end);
    }
  }, [currentDate, viewMode, onDateRangeChange]);

  const navigateDate = (direction: -1 | 1) => {
    const newDate = new Date(currentDate);
    if (viewMode === "dia") {
      newDate.setDate(newDate.getDate() + direction);
    } else {
      newDate.setMonth(newDate.getMonth() + direction);
    }
    setCurrentDate(newDate);
  };

  const goToToday = () => {
    setCurrentDate(new Date());
    setViewMode("dia");
  };

  const formatDateLabel = (): string => {
    if (viewMode === "dia") {
      const today = new Date();
      const isToday =
        currentDate.getDate() === today.getDate() &&
        currentDate.getMonth() === today.getMonth() &&
        currentDate.getFullYear() === today.getFullYear();
      if (isToday) return "Hoy";
      return currentDate.toLocaleDateString("es-CO", { day: "2-digit", month: "short", year: "numeric" });
    }
    return `${MONTHS_ES[currentDate.getMonth()]} ${currentDate.getFullYear()}`;
  };

  const isNegative = (e: string) => ["PURCHASE_REFUNDED", "CHARGEBACK", "PURCHASE_CHARGEBACK"].includes(e);
  const isCancel   = (e: string) => ["SUBSCRIPTION_CANCELLATION", "PURCHASE_CANCELED"].includes(e);

  const totalUsd = transactions.reduce((s, t) => {
    if (isNegative(t.eventType)) return s - t.amountUsd;
    if (isCancel(t.eventType)) return s;
    return s + t.amountUsd;
  }, 0);

  const ventas     = transactions.filter(t => !isNegative(t.eventType) && !isCancel(t.eventType)).length;
  const reembolsos = transactions.filter(t => isNegative(t.eventType)).length;

  return (
    <Card style={{ padding: "14px 16px", display: "flex", flexDirection: "column", overflow: "hidden", height: "100%" }}>
      {/* Header: Título + Modo */}
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 8, flexShrink: 0 }}>
        <div style={{ fontWeight: 800, fontSize: 13, color: C.white, display: "flex", alignItems: "center", gap: 6 }}>
          <Calendar size={14} style={{ color: C.orange }} />
          Transacciones
        </div>
        {/* Toggle día/mes */}
        <div style={{ display: "flex", gap: 2 }}>
          {(["dia", "mes"] as ViewMode[]).map(m => (
            <button
              key={m}
              onClick={() => setViewMode(m)}
              style={{
                background: viewMode === m ? "rgba(255,107,44,0.12)" : "transparent",
                border: viewMode === m ? "1px solid rgba(255,107,44,0.3)" : `1px solid ${C.border}`,
                borderRadius: 5, color: viewMode === m ? C.orange : C.muted,
                padding: "3px 10px", fontSize: 10, fontWeight: viewMode === m ? 700 : 500,
                cursor: "pointer", transition: "all 0.15s",
              }}
            >
              {m === "dia" ? "Día" : "Mes"}
            </button>
          ))}
        </div>
      </div>

      {/* Navegación de fecha */}
      <div style={{
        display: "flex", justifyContent: "space-between", alignItems: "center",
        padding: "6px 0", marginBottom: 6, flexShrink: 0,
      }}>
        <button onClick={() => navigateDate(-1)} style={{
          background: "none", border: "none", color: C.mutedLight, cursor: "pointer", padding: 4,
          borderRadius: 4, display: "flex",
        }}>
          <ChevronLeft size={16} />
        </button>

        <button onClick={goToToday} style={{
          background: "none", border: "none", cursor: "pointer",
          fontSize: 12, fontWeight: 700, color: C.white,
          padding: "4px 12px", borderRadius: 6,
        }}>
          {formatDateLabel()}
        </button>

        <button onClick={() => navigateDate(1)} style={{
          background: "none", border: "none", color: C.mutedLight, cursor: "pointer", padding: 4,
          borderRadius: 4, display: "flex",
        }}>
          <ChevronRight size={16} />
        </button>
      </div>

      {/* Resumen */}
      <div style={{
        display: "grid", gridTemplateColumns: "1fr 1fr 1fr",
        gap: 6, padding: "8px 0", borderTop: `1px solid ${C.border}`, borderBottom: `1px solid ${C.border}`,
        marginBottom: 8, flexShrink: 0,
      }}>
        <div style={{ textAlign: "center" }}>
          <div style={{ fontSize: 8, color: C.muted, fontWeight: 600, textTransform: "uppercase", letterSpacing: "0.05em" }}>Total</div>
          <div style={{ fontSize: 13, fontWeight: 900, color: totalUsd >= 0 ? C.green : C.red }}>${Math.abs(totalUsd).toFixed(2)}</div>
          <div style={{ fontSize: 7, color: C.muted }}>USD</div>
        </div>
        <div style={{ textAlign: "center" }}>
          <div style={{ fontSize: 8, color: C.muted, fontWeight: 600, textTransform: "uppercase", letterSpacing: "0.05em" }}>Ventas</div>
          <div style={{ fontSize: 13, fontWeight: 900, color: C.green }}>{ventas}</div>
        </div>
        <div style={{ textAlign: "center" }}>
          <div style={{ fontSize: 8, color: C.muted, fontWeight: 600, textTransform: "uppercase", letterSpacing: "0.05em" }}>Reemb.</div>
          <div style={{ fontSize: 13, fontWeight: 900, color: reembolsos > 0 ? C.red : C.muted }}>{reembolsos}</div>
        </div>
      </div>

      {/* Lista de transacciones */}
      {transactions.length === 0 ? (
        <div style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", paddingTop: 20, gap: 8 }}>
          <div style={{ fontSize: 28, opacity: 0.15 }}>💳</div>
          <span style={{ color: C.muted, fontSize: 11 }}>Sin transacciones</span>
          <span style={{ color: C.muted, fontSize: 9 }}>{formatDateLabel()}</span>
        </div>
      ) : (
        <div style={{ overflow: "auto", flex: 1 }}>
          {transactions.map(t => (
            <div key={t.id} className="aivi-row" style={{
              display: "flex", justifyContent: "space-between", alignItems: "center",
              padding: "8px 0", borderBottom: `1px solid ${C.border}`,
            }}>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 11, fontWeight: 600, color: C.white, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                  {t.buyerName}
                </div>
                <div style={{ fontSize: 9, color: C.muted, marginTop: 1, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                  {t.planName.replace("AIVI — ", "").replace("Método V3 — ", "MV3 ")}
                </div>
                {viewMode === "mes" && (
                  <div style={{ fontSize: 8, color: C.mutedMid, marginTop: 1 }}>
                    {new Date(t.createdAt).toLocaleDateString("es-CO", { day: "2-digit", month: "short", hour: "2-digit", minute: "2-digit" })}
                  </div>
                )}
              </div>
              <div style={{ textAlign: "right", flexShrink: 0, marginLeft: 8 }}>
                <div style={{
                  fontSize: 12, fontWeight: 800,
                  color: isNegative(t.eventType) ? C.red : isCancel(t.eventType) ? C.yellow : C.green,
                }}>
                  {isNegative(t.eventType) ? "-" : "+"}${t.amountUsd.toFixed(2)}
                  <span style={{ fontSize: 7, color: C.muted, marginLeft: 2, fontWeight: 500 }}>USD</span>
                </div>
                <div style={{ fontSize: 9, color: C.muted, marginTop: 1 }}>
                  {EVENT_LABEL[t.eventType] ?? t.eventType}
                </div>
                {t.currency !== "USD" && (
                  <div style={{ fontSize: 8, color: C.mutedMid }}>
                    (orig: ${t.amount.toFixed(2)} {t.currency})
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Conteo */}
      {transactions.length > 0 && (
        <div style={{ flexShrink: 0, paddingTop: 6, textAlign: "center", fontSize: 9, color: C.muted }}>
          {transactions.length} transacción{transactions.length !== 1 ? "es" : ""}
        </div>
      )}
    </Card>
  );
}
