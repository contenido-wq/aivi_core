import { useState, useEffect, useCallback } from "react";
import { Download, Search, RefreshCw, Menu } from "lucide-react";
import { C, FONT } from "../tokens";
import { Sidebar } from "../components/layout/Sidebar";
import { useResponsive } from "../hooks/useResponsive";
import {
  getFullTransactions,
  getTransactionCount,
  type Transaction,
  type TxCategory,
  type ProductFilter,
} from "../services/dashboard";

const CATEGORIES: { key: TxCategory; label: string; color: string }[] = [
  { key: "compras",               label: "Compras Aprobadas",        color: C.green   },
  { key: "solicitudes_reembolso", label: "Solicitudes de Reembolso", color: C.yellow  },
  { key: "reembolsos",            label: "Reembolsos Hechos",        color: C.orange  },
  { key: "cancelaciones",         label: "Cancelaciones",            color: C.red     },
  { key: "atrasados",             label: "Atrasados",                color: C.purple  },
  { key: "chargeback",            label: "Tarjeta Rechazada",        color: C.pink    },
];

interface TransactionsViewProps {
  onSettings:   () => void;
  onSignOut?:   () => void;
  onDashboard?: () => void;
  onUsers?:     () => void;
  activeView?:  string;
}

export function TransactionsView({
  onSettings, onSignOut, onDashboard, onUsers, activeView = "transacciones",
}: TransactionsViewProps) {
  const { isMobile, isTablet } = useResponsive();
  const thisYearStart = `${new Date().getFullYear()}-01-01`;

  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [filter, setFilter]           = useState<ProductFilter>("todos");

  const PAGE_SIZE = 50;

  const [activeTab, setActiveTab]     = useState<TxCategory>("compras");
  const [rows, setRows]               = useState<Transaction[]>([]);
  const [totalCount, setTotalCount]   = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [loading, setLoading]         = useState(false);
  const [search, setSearch]           = useState("");
  const [startDate, setStartDate]     = useState(thisYearStart);
  const [endDate, setEndDate]         = useState("");

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const start = startDate ? new Date(startDate) : null;
      const end   = endDate   ? new Date(endDate)   : null;
      const [data, total] = await Promise.all([
        getFullTransactions(activeTab, start, end, search, filter, currentPage, PAGE_SIZE),
        getTransactionCount(activeTab, start, end, filter),
      ]);
      setRows(data);
      setTotalCount(total);
    } catch (err) {
      console.error("[TransactionsView] Error cargando transacciones:", err);
    } finally {
      setLoading(false);
    }
  }, [activeTab, startDate, endDate, search, filter, currentPage]);

  useEffect(() => { load(); }, [load]);

  useEffect(() => {
    setCurrentPage(1);
  }, [activeTab, startDate, endDate, filter]);

  function exportCSV() {
    const headers = [
      "Fecha", "Nombre", "Email", "Teléfono", "País",
      "Plan", "Monto", "Divisa", "USD", "Origen Venta",
      "Fuente Tráfico", "Código Oferta", "ID Hotmart",
    ];
    const csvRows = rows.map((r) =>
      [
        new Date(r.createdAt).toLocaleString("es-CO"),
        r.buyerName, r.buyerEmail, r.buyerPhone, r.buyerCountry,
        r.planName,
        r.amount.toFixed(2), r.currency,
        r.amountUsd.toFixed(2),
        r.saleOrigin, r.trafficSource, r.offerCode, r.hotmartId,
      ].map((v) => `"${String(v).replace(/"/g, '""')}"`).join(",")
    );

    const blob = new Blob(
      [headers.join(",") + "\n" + csvRows.join("\n")],
      { type: "text/csv;charset=utf-8;" }
    );
    const url = URL.createObjectURL(blob);
    const a   = document.createElement("a");
    a.href     = url;
    a.download = `transacciones_${activeTab}_${new Date().toISOString().split("T")[0]}.csv`;
    a.click();
    URL.revokeObjectURL(url);
  }

  const activeCategory = CATEGORIES.find((c) => c.key === activeTab)!;
  const isMobileLayout = isMobile || isTablet;

  return (
    <div style={{ display: "flex", height: "100vh", background: C.bg, fontFamily: FONT, color: C.white, overflow: "hidden" }}>
      <Sidebar
        filter={filter}
        onFilter={setFilter}
        onSettings={onSettings}
        onSignOut={onSignOut}
        onDashboard={onDashboard}
        onUsers={onUsers}
        activeView={activeView}
        mrr={0}
        arr={0}
        open={sidebarOpen}
        onClose={() => setSidebarOpen(false)}
        isMobile={isMobileLayout}
      />

      <div style={{
        marginLeft: isMobileLayout ? 0 : 220,
        flex: 1,
        display: "flex",
        flexDirection: "column",
        overflow: "hidden",
        width: "100%",
      }}>
        {/* Header */}
        <div style={{
          padding: "14px 20px",
          borderBottom: `1px solid ${C.border}`,
          display: "flex",
          alignItems: "center",
          gap: 14,
          background: C.sidebar,
          flexShrink: 0,
        }}>
          {isMobileLayout && (
            <button
              onClick={() => setSidebarOpen(true)}
              style={{ background: "none", border: "none", cursor: "pointer", color: C.mutedMid, display: "flex", padding: 4 }}
            >
              <Menu size={20} />
            </button>
          )}
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 16, fontWeight: 800, letterSpacing: "-0.03em" }}>
              Transacciones
            </div>
            <div style={{ fontSize: 11, color: C.mutedMid }}>
              {loading
                ? "Cargando..."
                : `${totalCount.toLocaleString()} registros · ${activeCategory.label}`}
            </div>
          </div>
          <button
            onClick={exportCSV}
            disabled={rows.length === 0}
            style={{
              display: "flex", alignItems: "center", gap: 6,
              padding: "7px 14px", borderRadius: 8, fontSize: 12, fontWeight: 700,
              background: rows.length > 0 ? C.orange : C.card,
              border: "none", cursor: rows.length > 0 ? "pointer" : "not-allowed",
              color: rows.length > 0 ? "#fff" : C.muted,
            }}
          >
            <Download size={14} /> Exportar CSV
          </button>
        </div>

        {/* Scrollable content */}
        <div style={{ flex: 1, overflowY: "auto", overflowX: "hidden", display: "flex", flexDirection: "column" }}>
          {/* Tabs */}
          <div style={{
            display: "flex",
            gap: 4,
            padding: "12px 20px",
            borderBottom: `1px solid ${C.border}`,
            overflowX: "auto",
            flexShrink: 0,
          }}>
            {CATEGORIES.map((cat) => (
              <button
                key={cat.key}
                onClick={() => setActiveTab(cat.key)}
                style={{
                  padding: "6px 14px",
                  borderRadius: 20,
                  fontSize: 12,
                  fontWeight: 700,
                  border: `1px solid ${activeTab === cat.key ? cat.color : C.border}`,
                  background: activeTab === cat.key ? `${cat.color}20` : "transparent",
                  color: activeTab === cat.key ? cat.color : C.mutedMid,
                  cursor: "pointer",
                  whiteSpace: "nowrap",
                  transition: "all 0.15s",
                }}
              >
                AIVI {cat.label.toUpperCase()}
              </button>
            ))}
          </div>

          {/* Filters */}
          <div style={{
            padding: "10px 20px",
            display: "flex",
            gap: 8,
            flexWrap: "wrap",
            alignItems: "center",
            borderBottom: `1px solid ${C.border}`,
            flexShrink: 0,
          }}>
            <div style={{ position: "relative", flex: "1 1 200px" }}>
              <Search size={13} style={{
                position: "absolute", left: 10, top: "50%",
                transform: "translateY(-50%)", color: C.muted,
                pointerEvents: "none",
              }} />
              <input
                type="text"
                placeholder="Buscar por nombre, email o teléfono..."
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                style={{
                  width: "100%", paddingLeft: 30, paddingRight: 10,
                  height: 34, borderRadius: 8,
                  background: C.card, border: `1px solid ${C.border}`,
                  color: C.white, fontSize: 12,
                  boxSizing: "border-box", outline: "none",
                }}
              />
            </div>
            <input type="date" value={startDate} onChange={(e) => setStartDate(e.target.value)} style={dateInputStyle()} />
            <span style={{ color: C.muted, fontSize: 12 }}>→</span>
            <input type="date" value={endDate} onChange={(e) => setEndDate(e.target.value)} style={dateInputStyle()} />
            <button
              onClick={() => { setStartDate(thisYearStart); setEndDate(""); setSearch(""); setCurrentPage(1); }}
              style={{ padding: "5px 10px", borderRadius: 8, fontSize: 11, background: "none", border: `1px solid ${C.border}`, color: C.muted, cursor: "pointer" }}
            >
              Limpiar
            </button>
            <button
              onClick={load}
              style={{ display: "flex", alignItems: "center", gap: 4, padding: "5px 10px", borderRadius: 8, fontSize: 11, background: "none", border: `1px solid ${C.border}`, color: C.mutedLight, cursor: "pointer" }}
            >
              <RefreshCw size={11} /> Actualizar
            </button>
          </div>

          {/* Table */}
          <div style={{ flex: 1, overflowX: "auto" }}>
            {loading ? (
              <div style={{ padding: 48, textAlign: "center", color: C.mutedMid, fontSize: 13 }}>
                Cargando...
              </div>
            ) : rows.length === 0 ? (
              <div style={{ padding: 64, textAlign: "center" }}>
                <div style={{ fontSize: 32, marginBottom: 12 }}>📭</div>
                <div style={{ color: C.mutedMid, fontSize: 13 }}>No hay registros en esta categoría</div>
              </div>
            ) : (
              <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 12, minWidth: 1050 }}>
                <thead>
                  <tr style={{ borderBottom: `1px solid ${C.border}` }}>
                    {["Fecha/Hora", "Nombre", "Email", "Teléfono", "País", "Plan", "Monto", "USD", "Origen Venta", "Fuente Tráfico", "ID Hotmart"].map((h) => (
                      <th key={h} style={{
                        padding: "9px 14px", textAlign: "left",
                        color: C.muted, fontWeight: 700, fontSize: 10,
                        letterSpacing: "0.08em", textTransform: "uppercase",
                        whiteSpace: "nowrap", background: C.panel,
                        position: "sticky", top: 0, zIndex: 1,
                      }}>
                        {h}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {rows.map((row, i) => (
                    <tr
                      key={row.id}
                      style={{ borderBottom: `1px solid ${C.border}`, background: i % 2 === 0 ? "transparent" : C.bgSecondary }}
                    >
                      <td style={td()}>{fmtDate(row.createdAt)}</td>
                      <td style={{ ...td(), fontWeight: 600, color: C.white }}>{row.buyerName}</td>
                      <td style={{ ...td(), color: C.mutedLight }}>{row.buyerEmail}</td>
                      <td style={td()}>
                        {row.buyerPhone !== "—" ? (
                          <a
                            href={`https://wa.me/${row.buyerPhone.replace(/\D/g, "")}`}
                            target="_blank"
                            rel="noopener noreferrer"
                            style={{ color: C.green, textDecoration: "none" }}
                          >
                            {row.buyerPhone}
                          </a>
                        ) : "—"}
                      </td>
                      <td style={td()}>{row.buyerCountry}</td>
                      <td style={{ ...td(), maxWidth: 150, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                        {row.planName}
                      </td>
                      <td style={td()}>
                        {row.amount.toFixed(2)}{" "}
                        <span style={{ color: C.muted }}>{row.currency}</span>
                      </td>
                      <td style={{ ...td(), color: C.green, fontWeight: 700 }}>
                        ${row.amountUsd.toFixed(2)}
                      </td>
                      <td style={{ ...td(), color: C.mutedLight }}>{row.saleOrigin}</td>
                      <td style={{ ...td(), color: C.teal }}>{row.trafficSource}</td>
                      <td style={{ ...td(), color: C.muted, fontSize: 10, fontFamily: "monospace" }}>
                        {row.hotmartId !== "—" ? `${row.hotmartId.slice(0, 16)}…` : "—"}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>

          {/* Paginación */}
          {totalCount > 0 && (() => {
            const totalPages = Math.ceil(totalCount / PAGE_SIZE);
            return (
              <div style={{
                display: "flex", alignItems: "center", justifyContent: "center",
                gap: 16, padding: "14px 20px",
                borderTop: `1px solid ${C.border}`,
                background: C.panel,
                flexShrink: 0,
              }}>
                <button
                  onClick={() => setCurrentPage((p) => Math.max(1, p - 1))}
                  disabled={currentPage === 1}
                  style={{
                    padding: "6px 14px", borderRadius: 8, fontSize: 12, fontWeight: 700,
                    background: currentPage === 1 ? C.card : C.orange,
                    border: "none",
                    color: currentPage === 1 ? C.muted : "#fff",
                    cursor: currentPage === 1 ? "not-allowed" : "pointer",
                  }}
                >
                  ← Anterior
                </button>
                <span style={{ fontSize: 12, color: C.mutedLight }}>
                  Página <strong style={{ color: C.white }}>{currentPage}</strong> de{" "}
                  <strong style={{ color: C.white }}>{totalPages || 1}</strong>
                  <span style={{ color: C.muted }}> · {totalCount.toLocaleString()} registros</span>
                </span>
                <button
                  onClick={() => setCurrentPage((p) => Math.min(totalPages, p + 1))}
                  disabled={currentPage >= totalPages}
                  style={{
                    padding: "6px 14px", borderRadius: 8, fontSize: 12, fontWeight: 700,
                    background: currentPage >= totalPages ? C.card : C.orange,
                    border: "none",
                    color: currentPage >= totalPages ? C.muted : "#fff",
                    cursor: currentPage >= totalPages ? "not-allowed" : "pointer",
                  }}
                >
                  Siguiente →
                </button>
              </div>
            );
          })()}
        </div>
      </div>
    </div>
  );
}

function td(): React.CSSProperties {
  return { padding: "9px 14px", color: C.mutedLight, whiteSpace: "nowrap" };
}

function dateInputStyle(): React.CSSProperties {
  return {
    height: 34, padding: "0 10px", borderRadius: 8,
    background: C.card, border: `1px solid ${C.border}`,
    color: C.white, fontSize: 12,
  };
}

function fmtDate(iso: string): string {
  const d = new Date(iso);
  return d.toLocaleString("es-CO", {
    day: "2-digit", month: "2-digit", year: "2-digit",
    hour: "2-digit", minute: "2-digit",
  });
}
