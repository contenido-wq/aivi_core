import { useState } from "react";
import { LayoutDashboard, Users, CreditCard, BarChart2, SlidersHorizontal, Settings } from "lucide-react";
import { C, FONT } from "../../tokens";
import type { ProductFilter } from "../../services/dashboard";

interface MobileBottomNavProps {
  activeView?:     string;
  onDashboard?:    () => void;
  onUsers?:        () => void;
  onTransactions?: () => void;
  onAnalytics?:    () => void;
  onSettings?:     () => void;
  isAdmin?:        boolean;
  filter:          ProductFilter;
  onFilter:        (f: ProductFilter) => void;
}

const FILTERS: { value: ProductFilter; label: string }[] = [
  { value: "todos",   label: "Todos"    },
  { value: "AIVI",    label: "AIVI"     },
  { value: "MV3",     label: "MV3"      },
  { value: "Reto15D", label: "Reto 15D" },
];

const NAV = [
  { icon: LayoutDashboard, label: "Dashboard",     view: "dashboard"     },
  { icon: Users,           label: "Usuarios",      view: "usuarios"      },
  { icon: CreditCard,      label: "Transacciones", view: "transacciones" },
  { icon: BarChart2,       label: "Analytics",     view: "analytics"     },
] as const;

export function MobileBottomNav({
  activeView, onDashboard, onUsers, onTransactions, onAnalytics, onSettings, isAdmin: _isAdmin = false, filter, onFilter,
}: MobileBottomNavProps) {
  const [sheetOpen, setSheetOpen] = useState(false);

  const handleNav = (view: string) => {
    if (view === "dashboard")     onDashboard?.();
    if (view === "usuarios")      onUsers?.();
    if (view === "transacciones") onTransactions?.();
    if (view === "analytics")     onAnalytics?.();
  };

  const handleFilter = (f: ProductFilter) => {
    onFilter(f);
    setSheetOpen(false);
  };

  return (
    <>
      {sheetOpen && (
        <>
          <div
            onClick={() => setSheetOpen(false)}
            style={{
              position: "fixed", inset: 0,
              background: "rgba(0,0,0,0.5)",
              zIndex: 300,
            }}
          />
          <div style={{
            position: "fixed", bottom: 0, left: 0, right: 0,
            background: C.sidebar,
            borderRadius: "16px 16px 0 0",
            padding: "20px 20px",
            paddingBottom: "calc(20px + env(safe-area-inset-bottom, 0px))",
            zIndex: 301,
            fontFamily: FONT,
          }}>
            <div style={{
              fontSize: 9, fontWeight: 800, color: C.orange,
              letterSpacing: "0.12em", textTransform: "uppercase",
              marginBottom: 12,
            }}>
              Producto
            </div>
            {FILTERS.map(f => (
              <button
                key={f.value}
                onClick={() => handleFilter(f.value)}
                style={{
                  display: "block", width: "100%",
                  background: filter === f.value ? "rgba(254,128,63,0.12)" : "transparent",
                  border: `1px solid ${filter === f.value ? "rgba(254,128,63,0.28)" : C.border}`,
                  borderRadius: 8, padding: "10px 14px",
                  color: filter === f.value ? C.orange : C.white,
                  fontSize: 13, fontWeight: 700, textAlign: "left",
                  marginBottom: 6, cursor: "pointer", fontFamily: FONT,
                }}
              >
                {f.label}
              </button>
            ))}
          </div>
        </>
      )}

      <nav style={{
        position: "fixed",
        bottom: "calc(20px + env(safe-area-inset-bottom, 0px))",
        left: "50%",
        transform: "translateX(-50%)",
        zIndex: 200,
        display: "flex",
        alignItems: "center",
        gap: 4,
        padding: "6px",
        background: "rgba(20,20,20,0.65)",
        backdropFilter: "blur(24px)",
        WebkitBackdropFilter: "blur(24px)",
        borderRadius: 999,
        border: "1px solid rgba(255,255,255,0.12)",
        boxShadow: "0 1px 0 rgba(255,255,255,0.08) inset, 0 8px 32px rgba(0,0,0,0.45)",
        fontFamily: FONT,
      }}>
        {NAV.map(item => {
          const Icon = item.icon;
          const isActive = activeView === item.view;
          return (
            <button
              key={item.view}
              onClick={() => handleNav(item.view)}
              style={{
                background: isActive ? "rgba(30,30,30,0.90)" : "transparent",
                border: "none",
                borderRadius: 16,
                cursor: "pointer",
                width: 46,
                height: 44,
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                color: isActive ? C.orange : "rgba(255,255,255,0.45)",
                transition: "all 0.2s cubic-bezier(.4,0,.2,1)",
                boxShadow: isActive ? "0 2px 8px rgba(0,0,0,0.35)" : "none",
                flexShrink: 0,
              }}
            >
              <Icon size={20} />
            </button>
          );
        })}
        <button
          onClick={() => setSheetOpen(true)}
          style={{
            background: "transparent",
            border: "none",
            borderRadius: 16,
            cursor: "pointer",
            width: 46,
            height: 44,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            color: "rgba(255,255,255,0.45)",
            transition: "all 0.2s",
            flexShrink: 0,
          }}
        >
          <SlidersHorizontal size={20} />
        </button>
        {onSettings && (
          <button
            onClick={onSettings}
            style={{
              background: "transparent",
              border: "none",
              borderRadius: 16,
              cursor: "pointer",
              width: 46,
              height: 44,
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              color: "rgba(255,255,255,0.45)",
              transition: "all 0.2s",
              flexShrink: 0,
            }}
          >
            <Settings size={20} />
          </button>
        )}
      </nav>
    </>
  );
}
