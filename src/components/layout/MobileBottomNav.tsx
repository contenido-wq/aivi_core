import { useState } from "react";
import { LayoutDashboard, Users, CreditCard, SlidersHorizontal } from "lucide-react";
import { C, FONT } from "../../tokens";
import type { ProductFilter } from "../../services/dashboard";

interface MobileBottomNavProps {
  activeView?:     string;
  onDashboard?:    () => void;
  onUsers?:        () => void;
  onTransactions?: () => void;
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
] as const;

export function MobileBottomNav({
  activeView, onDashboard, onUsers, onTransactions, filter, onFilter,
}: MobileBottomNavProps) {
  const [sheetOpen, setSheetOpen] = useState(false);

  const handleNav = (view: string) => {
    if (view === "dashboard")     onDashboard?.();
    if (view === "usuarios")      onUsers?.();
    if (view === "transacciones") onTransactions?.();
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
        position: "fixed", bottom: 0, left: 0, right: 0,
        height: 60,
        paddingBottom: "env(safe-area-inset-bottom, 0px)",
        background: C.sidebar,
        borderTop: `1px solid ${C.border}`,
        backdropFilter: "blur(12px)",
        zIndex: 200,
        display: "grid",
        gridTemplateColumns: "repeat(4, 1fr)",
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
                background: "none", border: "none", cursor: "pointer",
                display: "flex", flexDirection: "column",
                alignItems: "center", justifyContent: "center", gap: 3,
                padding: "8px 0",
                borderTop: isActive ? `2px solid ${C.orange}` : "2px solid transparent",
                color: isActive ? C.orange : C.mutedLight,
              }}
            >
              <Icon size={18} />
              <span style={{
                fontSize: 9, fontWeight: 700,
                letterSpacing: "0.04em", textTransform: "uppercase",
              }}>
                {item.label}
              </span>
            </button>
          );
        })}
        <button
          onClick={() => setSheetOpen(true)}
          style={{
            background: "none", border: "none", cursor: "pointer",
            display: "flex", flexDirection: "column",
            alignItems: "center", justifyContent: "center", gap: 3,
            padding: "8px 0",
            borderTop: "2px solid transparent",
            color: C.mutedLight,
          }}
        >
          <SlidersHorizontal size={18} />
          <span style={{
            fontSize: 9, fontWeight: 700,
            letterSpacing: "0.04em", textTransform: "uppercase",
          }}>
            Filtro
          </span>
        </button>
      </nav>
    </>
  );
}
