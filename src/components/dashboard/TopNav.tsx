import { RefreshCw, BarChart2, Bell, Zap } from "lucide-react";
import { C } from "../../tokens";
import { Toggle } from "../ui/Toggle";

interface TopNavProps {
  time:        string;
  adsOn:       boolean;
  onAdsToggle: () => void;
}

export function TopNav({ time, adsOn, onAdsToggle }: TopNavProps) {
  return (
    <nav style={{
      background: C.nav,
      borderBottom: `1px solid ${C.border}`,
      height: 52,
      display: "flex", alignItems: "center",
      justifyContent: "space-between",
      padding: "0 24px",
      flexShrink: 0,
    }}>
      <div style={{ display: "flex", alignItems: "center", gap: 7, fontSize: 11 }}>
        <span style={{ color: C.mutedLight }}>AIVI CORE</span>
        <span style={{ color: C.muted }}>›</span>
        <span style={{ color: C.orange, fontWeight: 700 }}>Dashboard</span>
      </div>

      <div style={{ display: "flex", alignItems: "center", gap: 16, fontSize: 11 }}>
        <button style={{ background: "none", border: "none", color: C.mutedLight, display: "flex", alignItems: "center" }}>
          <RefreshCw size={14} />
        </button>
        <button style={{ background: "none", border: "none", color: C.mutedLight, display: "flex", alignItems: "center", gap: 5 }}>
          <BarChart2 size={14} />
          <span>Sync Ads</span>
        </button>
        <div style={{ display: "flex", alignItems: "center", gap: 5 }}>
          <Zap size={12} style={{ color: adsOn ? C.orange : C.red }} />
          <span style={{ fontSize: 10, color: adsOn ? C.orange : C.red, fontWeight: 700 }}>{adsOn ? "ON" : "OFF"}</span>
          <Toggle on={adsOn} onChange={onAdsToggle} color={C.orange} />
        </div>
        <button style={{ background: "none", border: "none", color: C.mutedLight, display: "flex", alignItems: "center" }}>
          <Bell size={13} />
        </button>
        <span style={{ color: C.mutedLight, fontVariantNumeric: "tabular-nums" }}>{time}</span>
      </div>
    </nav>
  );
}
