import { LayoutDashboard, BarChart2, Users, CreditCard, RefreshCw, Settings, ChevronRight, X, LogOut } from "lucide-react";
import { C } from "../../tokens";
import type { ProductFilter, DailyData } from "../../services/dashboard";

interface SidebarProps {
  filter:           ProductFilter;
  onFilter:         (f: ProductFilter) => void;
  onSettings:       () => void;
  onSignOut?:       () => void;
  onUsers?:         () => void;
  onTransactions?:  () => void;
  activeView?:      string;
  mrr:        number;
  arr:        number;
  daily?:     DailyData | null;
  /** Whether the sidebar is open (mobile drawer mode) */
  open?: boolean;
  /** Callback to close the sidebar (mobile) */
  onClose?: () => void;
  /** Whether sidebar is in mobile mode (drawer) */
  isMobile?: boolean;
}

const NAV_ITEMS = [
  { icon: LayoutDashboard, label: "Dashboard",     view: "dashboard"     },
  { icon: Users,           label: "Usuarios",      view: "usuarios"      },
  { icon: CreditCard,      label: "Transacciones", view: "transacciones" },
  { icon: BarChart2,       label: "Analytics",     view: null            },
  { icon: RefreshCw,       label: "Suscripciones", view: null            },
];

const FILTERS: { value: ProductFilter; label: string }[] = [
  { value: "todos", label: "Todos" },
  { value: "AIVI",  label: "AIVI"  },
  { value: "MV3",   label: "MV3"   },
];

export function Sidebar({ filter, onFilter, onSettings, onSignOut, onUsers, onTransactions, activeView, mrr, arr, daily, open, onClose, isMobile }: SidebarProps) {
  const fmtK = (n: number) => {
    const parts = n.toFixed(2).split(".");
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return `$${parts.join(".")}`;
  };

  // In mobile mode, don't render unless open
  if (isMobile && !open) return null;

  const sidebarContent = (
    <aside style={{
      width: isMobile ? 270 : 220,
      flexShrink: 0,
      background: C.sidebar,
      borderRight: `1px solid ${C.border}`,
      display: "flex",
      flexDirection: "column",
      height: "100vh",
      position: "fixed",
      left: 0,
      top: 0,
      zIndex: 100,
      overflowY: "auto",
      WebkitOverflowScrolling: "touch",
    }} className={isMobile ? "sidebar-drawer" : undefined}>
      {/* Logo + Close button on mobile */}
      <div style={{ padding: "20px 18px 16px", borderBottom: `1px solid ${C.border}`, display: "flex", alignItems: "center", gap: 10, justifyContent: "space-between" }}>
        <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
          <img
            src="/logo.png"
            alt="AIVI"
            style={{ width: 36, height: 36, borderRadius: 10, objectFit: "contain", flexShrink: 0 }}
          />
          <div style={{ lineHeight: 1 }}>
            <div style={{
              fontSize: 17, fontWeight: 900, letterSpacing: "-0.04em",
              background: C.grad, WebkitBackgroundClip: "text", WebkitTextFillColor: "transparent",
            }}>AIVI</div>
            <div style={{ fontSize: 9, fontWeight: 800, color: C.orange, letterSpacing: "0.14em", marginTop: 1 }}>CORE</div>
          </div>
        </div>
        {isMobile && (
          <button
            onClick={onClose}
            aria-label="Cerrar menú"
            style={{
              background: "none",
              border: "none",
              color: C.mutedLight,
              padding: 6,
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              borderRadius: 8,
            }}
          >
            <X size={20} />
          </button>
        )}
      </div>

      {/* Nav */}
      <nav style={{ padding: "12px 8px", flex: 1, display: "flex", flexDirection: "column", gap: 2 }}>
        {NAV_ITEMS.map((item) => {
          const Icon     = item.icon;
          const isActive = activeView === item.view;
          const clickable = item.view !== null;
          const handleClick = () => {
            if (!clickable) return;
            if (item.view === "usuarios") onUsers?.();
            if (item.view === "transacciones") onTransactions?.();
            if (isMobile) onClose?.();
          };
          return (
            <div key={item.label} onClick={handleClick} style={{
              display: "flex", alignItems: "center", gap: 10,
              padding: "10px 12px", borderRadius: 10,
              background: isActive ? "rgba(255,107,44,0.10)" : "transparent",
              backdropFilter: isActive ? "blur(10px)" : "none",
              border: `1px solid ${isActive ? "rgba(255,107,44,0.25)" : "transparent"}`,
              borderLeft: isActive ? "3px solid rgba(255,107,44,0.8)" : "3px solid transparent",
              paddingLeft: isActive ? 10 : 12,
              cursor: clickable ? "pointer" : "default",
              opacity: clickable ? 1 : 0.4,
              transition: "all 0.15s",
            }}>
              <Icon size={16} style={{ color: isActive ? C.orange : C.white }} />
              <span style={{ fontSize: 12, fontWeight: 700, color: isActive ? C.orange : C.white, flex: 1 }}>
                {item.label}
              </span>
              {isActive && <ChevronRight size={12} style={{ color: C.orange }} />}
            </div>
          );
        })}

        {/* Filtro */}
        <div style={{ marginTop: 16, paddingLeft: 2 }}>
          <div style={{ fontSize: 9, fontWeight: 800, color: C.white, letterSpacing: "0.1em", textTransform: "uppercase", marginBottom: 6, paddingLeft: 10 }}>
            Producto
          </div>
          {FILTERS.map(f => (
            <button key={f.value} onClick={() => { onFilter(f.value); if (isMobile) onClose?.(); }} style={{
              display: "block", width: "100%",
              background: filter === f.value ? "rgba(255,107,44,0.12)" : "transparent",
              backdropFilter: filter === f.value ? "blur(10px)" : "none",
              border: `1px solid ${filter === f.value ? "rgba(255,107,44,0.28)" : "transparent"}`,
              borderRadius: 8, padding: "8px 12px",
              color: filter === f.value ? C.orange : C.white,
              fontSize: 11, fontWeight: 700, textAlign: "left",
              marginBottom: 2, transition: "all 0.15s",
            }}>
              {filter === f.value ? "● " : "○ "}{f.label}
            </button>
          ))}
        </div>

        {/* Resumen del día */}
        <div style={{ marginTop: 16, paddingLeft: 2 }}>
          <div style={{ fontSize: 9, fontWeight: 800, color: C.white, letterSpacing: "0.1em", textTransform: "uppercase", marginBottom: 6, paddingLeft: 10 }}>
            Resumen del día
          </div>
          <div style={{ background: "rgba(255,255,255,0.04)", borderRadius: 10, border: `1px solid ${C.border}`, padding: "10px 12px" }}>
            {[
              { label: "Ingresos",  value: `$${(daily?.revenue    ?? 0).toFixed(2)}`, color: C.green  },
              { label: "Inversión", value: `$${(daily?.investment ?? 0).toFixed(2)}`, color: C.yellow },
              { label: "ROAS",      value: `${daily?.investment ? ((daily.revenue / daily.investment).toFixed(2)) : "0.00"}x`, color: C.yellow },
            ].map(({ label, value, color }) => (
              <div key={label} style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "5px 0", borderBottom: `1px solid rgba(255,255,255,0.05)` }}>
                <span style={{ fontSize: 10, color: C.mutedLight }}>{label}</span>
                <span style={{ fontSize: 13, fontWeight: 800, color, fontVariantNumeric: "tabular-nums" }}>{value}</span>
              </div>
            ))}
            {/* Meta diaria */}
            {(() => {
              const goal   = 400;
              const pct    = Math.min(((daily?.revenue ?? 0) / goal) * 100, 100);
              return (
                <div style={{ paddingTop: 8 }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 5 }}>
                    <span style={{ fontSize: 10, color: C.mutedLight }}>Meta diaria</span>
                    <span style={{ fontSize: 11, fontWeight: 800, color: pct >= 100 ? C.green : C.orange }}>{pct.toFixed(0)}%</span>
                  </div>
                  <div style={{ height: 4, background: "rgba(255,255,255,0.06)", borderRadius: 2, overflow: "hidden" }}>
                    <div style={{ height: "100%", width: `${pct}%`, borderRadius: 2, transition: "width 0.6s ease", background: pct >= 100 ? C.green : `linear-gradient(90deg, ${C.orange}, ${C.yellow})` }} />
                  </div>
                </div>
              );
            })()}
          </div>
        </div>

      </nav>

      {/* Footer */}
      <div style={{ padding: "14px 16px", borderTop: `1px solid ${C.border}` }}>
        <div style={{
          background: "rgba(255,255,255,0.05)",
          backdropFilter: "blur(10px)",
          borderRadius: 12,
          border: `1px solid ${C.border}`,
          padding: "12px 14px",
          marginBottom: 8,
        }}>
          <div style={{ fontSize: 9, color: C.muted, fontWeight: 800, textTransform: "uppercase", letterSpacing: "0.08em", marginBottom: 8 }}>
            Métricas Recurrentes
          </div>
          {[["MRR", fmtK(mrr), C.green], ["ARR", fmtK(arr), C.green]].map(([k, v, col]) => (
            <div key={k} style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 4 }}>
              <span style={{ fontSize: 10, color: C.mutedLight }}>{k}</span>
              <span style={{ fontSize: 14, fontWeight: 900, color: col, letterSpacing: "-.02em" }}>{v}</span>
            </div>
          ))}
        </div>
        <div style={{ display: "flex", gap: 6 }}>
          <button onClick={() => { onSettings(); if (isMobile) onClose?.(); }} style={{
            flex: 1, padding: "8px", borderRadius: 8,
            background: "transparent",
            border: `1px solid ${C.border}`,
            color: C.mutedLight, fontSize: 11, fontWeight: 600,
            display: "flex", alignItems: "center", justifyContent: "center", gap: 6,
            transition: "all .15s",
            cursor: "pointer",
          }}>
            <Settings size={13} /> Ajustes
          </button>
          {onSignOut && (
            <button onClick={onSignOut} title="Cerrar sesión" style={{
              padding: "8px 10px", borderRadius: 8,
              background: "transparent",
              border: `1px solid ${C.border}`,
              color: C.mutedLight, fontSize: 11, fontWeight: 600,
              display: "flex", alignItems: "center", justifyContent: "center",
              transition: "all .15s",
              cursor: "pointer",
              flexShrink: 0,
            }}>
              <LogOut size={13} />
            </button>
          )}
        </div>
      </div>
    </aside>
  );

  // Mobile: wrap with overlay
  if (isMobile) {
    return (
      <>
        <div className="sidebar-overlay" onClick={onClose} />
        {sidebarContent}
      </>
    );
  }

  return sidebarContent;
}
