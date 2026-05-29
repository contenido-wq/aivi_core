import { useState }            from "react";
import { RefreshCw, BarChart2, Bell, Zap, Menu } from "lucide-react";
import { C }                   from "../../tokens";
import { Toggle }              from "../ui/Toggle";

interface TopNavProps {
  time:        string;
  adsOn:       boolean;
  onAdsToggle: () => void;
  isMobile?:   boolean;
  onMenuOpen?: () => void;
  onSync?:     () => Promise<void>;
}

export function TopNav({ time, adsOn, onAdsToggle, isMobile, onMenuOpen, onSync }: TopNavProps) {
  const [syncing, setSyncing] = useState(false);

  const handleSync = async () => {
    if (!onSync || syncing) return;
    setSyncing(true);
    try { await onSync(); } finally { setSyncing(false); }
  };

  return (
    <nav style={{
      background: C.nav,
      borderBottom: `1px solid ${C.border}`,
      height: 52,
      display: "flex", alignItems: "center",
      justifyContent: "space-between",
      padding: isMobile ? "0 12px" : "0 24px",
      flexShrink: 0,
      gap: 8,
    }}>
      <div style={{ display: "flex", alignItems: "center", gap: 7, fontSize: 11, minWidth: 0 }}>
        {isMobile && (
          <button
            onClick={onMenuOpen}
            aria-label="Abrir menú"
            style={{
              background: "none", border: "none", color: C.white,
              padding: 6, display: "flex", alignItems: "center",
              justifyContent: "center", marginRight: 4,
            }}
          >
            <Menu size={20} />
          </button>
        )}
        <span style={{ color: C.mutedLight, whiteSpace: "nowrap" }}>AIVI CORE</span>
        <span style={{ color: C.muted }}>›</span>
        <span style={{ color: C.orange, fontWeight: 700 }}>Dashboard</span>
      </div>

      <div style={{ display: "flex", alignItems: "center", gap: isMobile ? 8 : 16, fontSize: 11, flexShrink: 0 }}>
        {!isMobile && (
          <>
            {onSync && (
              <button
                onClick={handleSync}
                disabled={syncing}
                title="Sincronizar últimas 24h con Hotmart"
                style={{
                  background: "none", border: "none",
                  color: syncing ? C.orange : C.mutedLight,
                  cursor: syncing ? "not-allowed" : "pointer",
                  display: "flex", alignItems: "center", gap: 5,
                }}
              >
                <RefreshCw size={13} style={{ animation: syncing ? "spin 0.8s linear infinite" : "none" }} />
                <span style={{ fontSize: 10 }}>{syncing ? "Sincronizando…" : "Sincronizar"}</span>
              </button>
            )}
            <button style={{ background: "none", border: "none", color: C.mutedLight, display: "flex", alignItems: "center", gap: 5 }}>
              <BarChart2 size={14} />
              <span>Sync Ads</span>
            </button>
          </>
        )}
        <div style={{ display: "flex", alignItems: "center", gap: 5 }}>
          <Zap size={12} style={{ color: adsOn ? C.orange : C.red }} />
          {!isMobile && <span style={{ fontSize: 10, color: adsOn ? C.orange : C.red, fontWeight: 700 }}>{adsOn ? "ON" : "OFF"}</span>}
          <Toggle on={adsOn} onChange={onAdsToggle} color={C.orange} />
        </div>
        <button style={{ background: "none", border: "none", color: C.mutedLight, display: "flex", alignItems: "center" }}>
          <Bell size={13} />
        </button>
        {!isMobile && <span style={{ color: C.mutedLight, fontVariantNumeric: "tabular-nums" }}>{time}</span>}
      </div>
    </nav>
  );
}
