import {
  LayoutDashboard, DollarSign, Users, CreditCard,
  ArrowRightLeft, Globe, Settings,
} from "lucide-react";
import { C } from "../../tokens";

const NAV = [
  { icon: LayoutDashboard, label: "Resumen",       active: true  },
  { icon: DollarSign,      label: "Ingresos",      active: false },
  { icon: Users,           label: "Usuarios",      active: false },
  { icon: CreditCard,      label: "Planes",        active: false },
  { icon: ArrowRightLeft,  label: "Transacciones", active: false },
  { icon: Globe,           label: "Geografía",     active: false },
  { icon: Settings,        label: "Ajustes",       active: false },
];

export function Sidebar() {
  return (
    <aside style={{
      width:          72,
      background:     C.sidebar,
      borderRight:    `1px solid ${C.border}`,
      display:        "flex",
      flexDirection:  "column",
      alignItems:     "center",
      padding:        "16px 8px",
      flexShrink:     0,
      gap:            4,
    }}>
      {/* Logo */}
      <div style={{
        width: 36, height: 36, borderRadius: 10,
        background: C.orange,
        display: "flex", alignItems: "center", justifyContent: "center",
        marginBottom: 24, flexShrink: 0,
      }}>
        <img src="/logo.png" alt="AIVI" style={{ height: 22, width: "auto", objectFit: "contain" }} />
      </div>

      {/* Nav items */}
      <nav style={{ flex: 1, width: "100%", display: "flex", flexDirection: "column", gap: 2 }}>
        {NAV.map(({ icon: Icon, label, active }) => (
          <button
            key={label}
            className="sidebar-btn"
            aria-current={active ? "page" : undefined}
            title={label}
            style={{
              width:          "100%",
              background:     active ? `${C.orange}18` : "transparent",
              border:         "none",
              borderRadius:   10,
              padding:        "10px 0",
              display:        "flex",
              flexDirection:  "column",
              alignItems:     "center",
              gap:            4,
              cursor:         "pointer",
              color:          active ? C.orange : C.mutedMid,
              transition:     "all 0.15s",
            }}
          >
            <Icon size={18} strokeWidth={active ? 2 : 1.6} />
            <span style={{
              fontSize:      9,
              fontWeight:    active ? 600 : 400,
              letterSpacing: "0.01em",
              whiteSpace:    "nowrap",
            }}>
              {label}
            </span>
          </button>
        ))}
      </nav>
    </aside>
  );
}
