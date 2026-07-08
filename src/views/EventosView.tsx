import { useState, useEffect, useRef, useMemo } from "react";
import { Calendar, Upload, Search, Loader2, RefreshCw, Menu } from "lucide-react";
import { C, FONT } from "../tokens";
import { useResponsive } from "../hooks/useResponsive";
import { Sidebar } from "../components/layout/Sidebar";
import { MobileBottomNav } from "../components/layout/MobileBottomNav";
import {
  parseEventCSV, uploadEventUsers, getEventsSummary, getEventDetail,
  type EventSummary, type EventUserRow, type ModuleUsageRow,
} from "../services/events";
import type { AppView } from "../types";

interface EventosViewProps {
  onSettings:       () => void;
  onSignOut?:       () => void;
  onDashboard?:     () => void;
  onUsers?:         () => void;
  onTransactions?:  () => void;
  onAnalytics?:     () => void;
  activeView?:      string;
  isAdmin?:         boolean;
  allowedSections?: AppView[];
}

function fmtDate(iso: string | null) {
  if (!iso) return "—";
  return new Intl.DateTimeFormat("es-CO", { day: "2-digit", month: "short", year: "numeric" }).format(new Date(iso));
}

function KPITile({ label, value, color }: { label: string; value: string; color: string }) {
  return (
    <div style={{
      background: C.card, border: `1px solid ${C.border}`, borderRadius: 14,
      padding: "14px 16px", flex: 1, minWidth: 0,
    }}>
      <div style={{ fontSize: 10, fontWeight: 800, color: C.mutedLight, letterSpacing: "0.08em", textTransform: "uppercase", marginBottom: 6 }}>
        {label}
      </div>
      <div style={{ fontSize: 28, fontWeight: 900, color, letterSpacing: "-0.03em" }}>{value}</div>
    </div>
  );
}

export function EventosView({
  onSettings, onSignOut, onDashboard, onUsers, onTransactions, onAnalytics,
  activeView = "eventos", isAdmin = false, allowedSections = [],
}: EventosViewProps) {
  const { isMobile, isTablet, isLarge, isXLarge } = useResponsive();
  const isMobileLayout = isMobile || isTablet;
  const sidebarWidth = isMobileLayout ? 0 : (isLarge ? 240 : 220);

  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [events,      setEvents]      = useState<EventSummary[]>([]);
  const [selectedCode, setSelectedCode] = useState<string | null>(null);
  const [users,       setUsers]       = useState<EventUserRow[]>([]);
  const [moduleUsage, setModuleUsage] = useState<ModuleUsageRow[]>([]);
  const [loadingList, setLoadingList] = useState(true);
  const [loadingDetail, setLoadingDetail] = useState(false);
  const [search,      setSearch]      = useState("");
  const [uploading,   setUploading]   = useState(false);
  const [uploadMsg,   setUploadMsg]   = useState<{ msg: string; ok: boolean } | null>(null);

  const fileInputRef = useRef<HTMLInputElement>(null);

  const loadEvents = async () => {
    setLoadingList(true);
    const summary = await getEventsSummary();
    setEvents(summary);
    if (summary.length > 0 && !summary.some(e => e.code === selectedCode)) {
      setSelectedCode(summary[0].code);
    }
    setLoadingList(false);
  };

  useEffect(() => { loadEvents(); }, []); // eslint-disable-line

  useEffect(() => {
    if (!selectedCode) { setUsers([]); setModuleUsage([]); return; }
    setLoadingDetail(true);
    getEventDetail(selectedCode).then(({ users, moduleUsage }) => {
      setUsers(users);
      setModuleUsage(moduleUsage);
      setLoadingDetail(false);
    });
  }, [selectedCode]);

  const handleFile = async (file: File) => {
    setUploading(true);
    setUploadMsg(null);
    try {
      const rows = await parseEventCSV(file);
      if (rows.length === 0) {
        setUploadMsg({ msg: "El archivo no tiene filas válidas (falta email o enrollment_code).", ok: false });
      } else {
        const { count } = await uploadEventUsers(rows);
        setUploadMsg({ msg: `${count} usuarios importados/actualizados.`, ok: true });
        await loadEvents();
        setSelectedCode(rows[0].enrollment_code);
      }
    } catch (e) {
      setUploadMsg({ msg: e instanceof Error ? e.message : "Error al procesar el archivo.", ok: false });
    } finally {
      setUploading(false);
      if (fileInputRef.current) fileInputRef.current.value = "";
    }
  };

  const selectedEvent = events.find(e => e.code === selectedCode) ?? null;

  const filteredUsers = useMemo(() => {
    const q = search.toLowerCase();
    if (!q) return users;
    return users.filter(u =>
      (u.nombre ?? "").toLowerCase().includes(q) ||
      u.email.toLowerCase().includes(q)
    );
  }, [users, search]);

  return (
    <div style={{ display: "flex", height: "100vh", background: C.bg, fontFamily: FONT, color: C.white, overflow: "hidden", ...(isXLarge && { maxWidth: 1920, margin: "0 auto" }) }}>
      <Sidebar
        filter="todos"
        onFilter={() => {}}
        onSettings={onSettings}
        onSignOut={onSignOut}
        onDashboard={onDashboard}
        onUsers={onUsers}
        onTransactions={onTransactions}
        onAnalytics={onAnalytics}
        activeView={activeView}
        mrr={0} arr={0}
        isAdmin={isAdmin}
        allowedSections={allowedSections}
        width={sidebarWidth || undefined}
        open={sidebarOpen}
        onClose={() => setSidebarOpen(false)}
        isMobile={isMobileLayout}
      />

      <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden", marginLeft: sidebarWidth }}>
        {/* Header */}
        <div style={{
          display: "flex", alignItems: "center", justifyContent: "space-between",
          padding: `10px ${isMobile ? 12 : 24}px`, minHeight: 56, borderBottom: `1px solid ${C.border}`,
          background: C.nav, flexShrink: 0, flexWrap: "wrap", gap: 12,
        }}>
          <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
            {isMobileLayout && (
              <button onClick={() => setSidebarOpen(true)} aria-label="Abrir menú" style={{
                background: "none", border: "none", color: C.mutedLight, padding: 4,
                display: "flex", alignItems: "center", justifyContent: "center", borderRadius: 8,
              }}>
                <Menu size={20} />
              </button>
            )}
            <Calendar size={16} style={{ color: C.orange }} />
            <div style={{ fontSize: 15, fontWeight: 700, color: C.white }}>Eventos</div>
          </div>

          <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
            <button onClick={loadEvents} disabled={loadingList} title="Refrescar" style={{
              background: "none", border: `1px solid ${C.border}`, borderRadius: 8, padding: "6px 8px",
              cursor: loadingList ? "not-allowed" : "pointer", color: C.mutedLight, display: "flex", alignItems: "center",
            }}>
              <RefreshCw size={13} style={{ animation: loadingList ? "spin 0.8s linear infinite" : "none" }} />
            </button>
            <input
              ref={fileInputRef} type="file" accept=".csv" style={{ display: "none" }}
              onChange={e => { const f = e.target.files?.[0]; if (f) handleFile(f); }}
            />
            <button
              onClick={() => fileInputRef.current?.click()}
              disabled={uploading}
              style={{
                display: "flex", alignItems: "center", gap: 6,
                padding: "7px 14px", borderRadius: 8, fontSize: 12, fontWeight: 700,
                background: uploading ? "rgba(254,128,63,0.4)" : C.gradBtn,
                border: "none", cursor: uploading ? "not-allowed" : "pointer", color: "#fff",
              }}
            >
              {uploading ? <Loader2 size={14} style={{ animation: "spin 0.8s linear infinite" }} /> : <Upload size={14} />}
              {uploading ? "Subiendo..." : "Subir CSV"}
            </button>
          </div>
        </div>

        {uploadMsg && (
          <div style={{
            margin: "10px 24px 0", fontSize: 12, fontWeight: 600, padding: "8px 12px", borderRadius: 8,
            color: uploadMsg.ok ? "#4ADE80" : "#FF8A87",
            background: uploadMsg.ok ? "rgba(74,222,128,0.1)" : "rgba(255,65,59,0.1)",
            border: `1px solid ${uploadMsg.ok ? "rgba(74,222,128,0.25)" : "rgba(255,65,59,0.25)"}`,
          }}>
            {uploadMsg.msg}
          </div>
        )}

        {/* Selector de evento */}
        <div style={{ padding: "12px 24px 0", display: "flex", gap: 6, flexWrap: "wrap", flexShrink: 0 }}>
          {loadingList ? (
            <Loader2 size={16} style={{ animation: "spin 0.8s linear infinite", color: C.muted }} />
          ) : events.length === 0 ? (
            <div style={{ fontSize: 12, color: C.muted }}>Todavía no hay eventos cargados. Sube un CSV para empezar.</div>
          ) : events.map(ev => (
            <button
              key={ev.code}
              onClick={() => setSelectedCode(ev.code)}
              style={{
                padding: "6px 12px", borderRadius: 8, fontSize: 12, fontWeight: 700,
                border: `1px solid ${selectedCode === ev.code ? "rgba(254,128,63,0.4)" : C.border}`,
                background: selectedCode === ev.code ? "rgba(254,128,63,0.12)" : "transparent",
                color: selectedCode === ev.code ? C.orange : C.mutedLight,
                cursor: "pointer",
              }}
            >
              {ev.label} <span style={{ opacity: 0.6 }}>· {ev.total}</span>
            </button>
          ))}
        </div>

        {/* Contenido */}
        <div style={{ flex: 1, overflowY: "auto", padding: `16px 24px ${isMobile ? 64 : 16}px`, display: "flex", flexDirection: "column", gap: 16 }}>
          {loadingDetail ? (
            <div style={{ textAlign: "center", padding: "40px 0", color: C.muted }}>
              <Loader2 size={20} style={{ animation: "spin 0.8s linear infinite" }} />
            </div>
          ) : selectedEvent ? (
            <>
              <div style={{ display: "flex", gap: 10, flexWrap: "wrap" }}>
                <KPITile label="Total registrados" value={String(selectedEvent.total)} color={C.white} />
                <KPITile
                  label="Activos"
                  value={`${selectedEvent.activos} (${selectedEvent.total > 0 ? Math.round(selectedEvent.activos / selectedEvent.total * 100) : 0}%)`}
                  color={C.green}
                />
                <KPITile
                  label="Verificados"
                  value={`${selectedEvent.verificados} (${selectedEvent.total > 0 ? Math.round(selectedEvent.verificados / selectedEvent.total * 100) : 0}%)`}
                  color={C.orange}
                />
              </div>

              {/* Uso por módulo */}
              <div>
                <div style={{ fontSize: 13, fontWeight: 700, color: C.white, marginBottom: 10 }}>Uso por módulo</div>
                <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, overflow: "hidden" }}>
                  <div style={{ display: "grid", gridTemplateColumns: "1fr 100px 70px 100px", padding: "8px 14px", fontSize: 10, fontWeight: 800, color: C.muted, textTransform: "uppercase", letterSpacing: "0.06em", borderBottom: `1px solid ${C.border}` }}>
                    <span>Módulo</span><span>Usuarios</span><span>%</span><span>Usos totales</span>
                  </div>
                  {moduleUsage.map(m => (
                    <div key={m.key} style={{ display: "grid", gridTemplateColumns: "1fr 100px 70px 100px", padding: "8px 14px", fontSize: 12, borderBottom: `1px solid rgba(255,255,255,0.04)` }}>
                      <span style={{ color: C.white }}>{m.label}</span>
                      <span style={{ color: C.mutedLight }}>{m.usersWithUsage}</span>
                      <span style={{ color: m.pct > 0 ? C.orange : C.muted, fontWeight: 700 }}>{m.pct}%</span>
                      <span style={{ color: C.mutedLight }}>{m.totalUses}</span>
                    </div>
                  ))}
                </div>
              </div>

              {/* Tabla de usuarios */}
              <div>
                <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 10, gap: 10, flexWrap: "wrap" }}>
                  <div style={{ fontSize: 13, fontWeight: 700, color: C.white }}>Usuarios ({filteredUsers.length})</div>
                  <div style={{ position: "relative", flex: "0 1 260px" }}>
                    <Search size={12} style={{ position: "absolute", left: 9, top: "50%", transform: "translateY(-50%)", color: C.muted }} />
                    <input
                      value={search} onChange={e => setSearch(e.target.value)}
                      placeholder="Buscar nombre o email…"
                      style={{
                        width: "100%", background: "rgba(255,255,255,0.04)", border: `1px solid ${C.border}`,
                        borderRadius: 7, padding: "6px 8px 6px 28px", fontSize: 12, color: C.white,
                        outline: "none", fontFamily: FONT, boxSizing: "border-box",
                      }}
                    />
                  </div>
                </div>
                <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, overflow: "hidden", overflowX: "auto" }}>
                  <div style={{ minWidth: 560 }}>
                    <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 90px 90px 120px", padding: "8px 14px", fontSize: 10, fontWeight: 800, color: C.muted, textTransform: "uppercase", letterSpacing: "0.06em", borderBottom: `1px solid ${C.border}` }}>
                      <span>Nombre</span><span>Email</span><span>Activo</span><span>Verificado</span><span>Registrado</span>
                    </div>
                    {filteredUsers.length === 0 ? (
                      <div style={{ padding: "20px 14px", fontSize: 12, color: C.muted, textAlign: "center" }}>Sin resultados</div>
                    ) : filteredUsers.map(u => (
                      <div key={u.email} style={{ display: "grid", gridTemplateColumns: "1fr 1fr 90px 90px 120px", padding: "8px 14px", fontSize: 12, borderBottom: `1px solid rgba(255,255,255,0.04)` }}>
                        <span style={{ color: C.white, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{u.nombre || u.email.split("@")[0]}</span>
                        <span style={{ color: C.mutedMid, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{u.email}</span>
                        <span style={{ color: u.usuario_activo ? C.green : C.muted }}>{u.usuario_activo ? "Sí" : "No"}</span>
                        <span style={{ color: u.verificado ? C.green : C.muted }}>{u.verificado ? "Sí" : "No"}</span>
                        <span style={{ color: C.mutedLight }}>{fmtDate(u.registrado_el)}</span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </>
          ) : (
            <div style={{ textAlign: "center", padding: "40px 0", color: C.muted, fontSize: 13 }}>
              Sube un CSV de un evento para ver su dashboard.
            </div>
          )}
        </div>
      </div>

      {isMobile && (
        <MobileBottomNav
          activeView={activeView}
          onDashboard={onDashboard}
          onUsers={onUsers}
          onTransactions={onTransactions}
          onAnalytics={onAnalytics}
          onSettings={onSettings}
          isAdmin={isAdmin}
          allowedSections={allowedSections}
          filter="todos"
          onFilter={() => {}}
        />
      )}

      <style>{`@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`}</style>
    </div>
  );
}
