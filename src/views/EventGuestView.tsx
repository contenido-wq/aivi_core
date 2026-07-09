import { useState, useEffect, useMemo } from "react";
import { Calendar, LogOut, Loader2 } from "lucide-react";
import { C, FONT } from "../tokens";
import { useResponsive } from "../hooks/useResponsive";
import { EventDashboardBody, UserDetailPanel } from "../components/eventos/shared";
import { getEventDetailAsGuest, type EventUserRow, type ModuleUsageRow, type StatusBreakdownRow } from "../services/events";

interface EventGuestViewProps {
  guestId:        string;
  enrollmentCode: string;
  label:          string | null;
  onSignOut:      () => void;
}

export function EventGuestView({ guestId, enrollmentCode, label, onSignOut }: EventGuestViewProps) {
  const { isMobile } = useResponsive();

  const [users,       setUsers]       = useState<EventUserRow[]>([]);
  const [moduleUsage, setModuleUsage] = useState<ModuleUsageRow[]>([]);
  const [statusBreakdown, setStatusBreakdown] = useState<StatusBreakdownRow[]>([]);
  const [loading,     setLoading]     = useState(true);
  const [loadError,   setLoadError]   = useState<string | null>(null);
  const [search,      setSearch]      = useState("");
  const [selectedUser, setSelectedUser] = useState<EventUserRow | null>(null);
  const [mobileView,  setMobileView]  = useState<"list" | "detail">("list");

  useEffect(() => {
    getEventDetailAsGuest(guestId).then(result => {
      if (!result.ok) {
        setLoadError(result.error);
        setLoading(false);
        return;
      }
      setUsers(result.users);
      setModuleUsage(result.moduleUsage);
      setStatusBreakdown(result.statusBreakdown);
      setLoading(false);
    });
  }, [guestId]);

  const filteredUsers = useMemo(() => {
    const q = search.toLowerCase();
    if (!q) return users;
    return users.filter(u =>
      (u.nombre ?? "").toLowerCase().includes(q) ||
      u.email.toLowerCase().includes(q)
    );
  }, [users, search]);

  const total = users.length;
  const event = {
    code: enrollmentCode,
    label: label ?? enrollmentCode,
    total,
    activos: users.filter(u => u.usuario_activo).length,
    verificados: users.filter(u => u.verificado).length,
  };

  return (
    <div style={{ display: "flex", height: "100vh", background: C.bg, fontFamily: FONT, color: C.white, overflow: "hidden" }}>
      <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
        {/* Header */}
        <div style={{
          display: "flex", alignItems: "center", justifyContent: "space-between",
          padding: `10px ${isMobile ? 12 : 24}px`, minHeight: 56, borderBottom: `1px solid ${C.border}`,
          background: C.nav, flexShrink: 0, gap: 12,
        }}>
          <div style={{ display: "flex", alignItems: "center", gap: 10, minWidth: 0 }}>
            <Calendar size={16} style={{ color: C.orange, flexShrink: 0 }} />
            <div style={{ minWidth: 0 }}>
              <div style={{ fontSize: 9, fontWeight: 800, color: C.mutedLight, letterSpacing: "0.1em", textTransform: "uppercase" }}>AIVI Core</div>
              <div style={{ fontSize: 14, fontWeight: 700, color: C.white, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{event.label}</div>
            </div>
          </div>
          <button onClick={onSignOut} title="Salir" style={{
            background: "none", border: `1px solid ${C.border}`, borderRadius: 8, padding: "7px 10px",
            color: C.mutedLight, cursor: "pointer", display: "flex", alignItems: "center", gap: 6, fontSize: 12, flexShrink: 0,
          }}>
            <LogOut size={13} /> {!isMobile && "Salir"}
          </button>
        </div>

        {/* Contenido + panel de detalle */}
        <div style={{ flex: 1, display: "flex", overflow: "hidden" }}>
          {(!isMobile || mobileView === "list") && (
            <div style={{ flex: 1, minWidth: 0, overflowY: "auto", padding: `16px 24px ${isMobile ? 24 : 16}px`, display: "flex", flexDirection: "column", gap: 16 }}>
              {loading ? (
                <div style={{ textAlign: "center", padding: "40px 0", color: C.muted }}>
                  <Loader2 size={20} style={{ animation: "spin 0.8s linear infinite" }} />
                </div>
              ) : loadError ? (
                <div style={{ textAlign: "center", padding: "40px 0", color: C.mutedLight, fontSize: 13 }}>{loadError}</div>
              ) : (
                <EventDashboardBody
                  event={event}
                  statusBreakdown={statusBreakdown}
                  moduleUsage={moduleUsage}
                  filteredUsers={filteredUsers}
                  search={search}
                  onSearchChange={setSearch}
                  selectedUser={selectedUser}
                  onSelectUser={u => { setSelectedUser(u); if (isMobile) setMobileView("detail"); }}
                />
              )}
            </div>
          )}

          {selectedUser && (!isMobile || mobileView === "detail") && (
            <div style={{
              width: isMobile ? "100%" : 340, flexShrink: 0,
              borderLeft: isMobile ? "none" : `1px solid ${C.border}`,
              background: C.sidebar, overflowY: "auto",
            }}>
              <UserDetailPanel
                user={selectedUser}
                isMobile={isMobile}
                onClose={() => { setSelectedUser(null); setMobileView("list"); }}
              />
            </div>
          )}
        </div>
      </div>

      <style>{`@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`}</style>
    </div>
  );
}
