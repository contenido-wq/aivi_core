import { useState }            from "react";
import { RefreshCw, BarChart2, Bell, Zap } from "lucide-react";
import { C }     from "../../tokens";
import { Toggle }              from "../ui/Toggle";

interface TopNavProps {
  time:            string;
  adsOn:           boolean;
  onAdsToggle:     () => void;
  isMobile?:       boolean;
  onMenuOpen?:     () => void;
  onSync?:         () => Promise<void>;
  onSyncUtmify?:   () => Promise<{ ok: boolean; totalInvestment?: number; error?: string }>;
}

export function TopNav({ time, adsOn, onAdsToggle, isMobile, onMenuOpen: _onMenuOpen, onSync, onSyncUtmify }: TopNavProps) {
  const [syncing, setSyncing] = useState(false);

  type UtmStatus = "idle" | "loading" | "ok" | "error";
  const [utmStatus, setUtmStatus] = useState<UtmStatus>("idle");
  const [utmMsg,    setUtmMsg]    = useState("");

  const handleSyncUtmify = async () => {
    if (!onSyncUtmify || utmStatus === "loading") return;
    setUtmStatus("loading");
    const result = await onSyncUtmify();
    if (result.ok) {
      setUtmMsg(result.totalInvestment !== undefined ? `$${result.totalInvestment.toFixed(2)} sync` : "Sincronizado");
      setUtmStatus("ok");
    } else {
      setUtmMsg("Error UTMify");
      setUtmStatus("error");
    }
    setTimeout(() => setUtmStatus("idle"), 2000);
  };

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
            <button
              onClick={handleSyncUtmify}
              disabled={utmStatus === "loading"}
              title="Sincronizar inversión desde UTMify"
              style={{
                display: "flex", alignItems: "center", gap: 5,
                borderRadius: 8, padding: "5px 10px", border: "1px solid",
                fontSize: 10, fontWeight: 700, cursor: utmStatus === "loading" ? "not-allowed" : "pointer",
                transition: "all 0.15s",
                ...(utmStatus === "idle"    && { background: "rgba(255,255,255,0.04)", borderColor: "rgba(255,255,255,0.1)",      color: C.mutedLight }),
                ...(utmStatus === "loading" && { background: "rgba(254,128,63,0.08)", borderColor: "rgba(254,128,63,0.25)",      color: C.orange }),
                ...(utmStatus === "ok"      && { background: "rgba(34,197,94,0.08)",  borderColor: "rgba(34,197,94,0.25)",       color: C.green }),
                ...(utmStatus === "error"   && { background: "rgba(255,65,59,0.08)",  borderColor: "rgba(255,65,59,0.25)",       color: C.red }),
              }}
            >
              {utmStatus === "loading"
                ? <><RefreshCw size={11} style={{ animation: "spin 0.8s linear infinite" }} /> Sincronizando…</>
                : utmStatus === "ok"
                ? <>✓ {utmMsg}</>
                : utmStatus === "error"
                ? <>✗ {utmMsg}</>
                : <><BarChart2 size={11} /> UTMify</>
              }
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
        {!isMobile && <span style={{ color: C.mutedLight, fontVariantNumeric: "tabular-nums", fontWeight: 700 }}>{time}</span>}
      </div>
    </nav>
  );
}
