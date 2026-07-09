import { useState, useEffect, useRef, useMemo } from "react";
import { Calendar, Upload, Loader2, RefreshCw, Menu, Pencil, Check, X as XIcon, UserPlus, Trash2, KeyRound } from "lucide-react";
import { C, FONT } from "../tokens";
import { useResponsive } from "../hooks/useResponsive";
import { Sidebar } from "../components/layout/Sidebar";
import { MobileBottomNav } from "../components/layout/MobileBottomNav";
import { EventDashboardBody, UserDetailPanel } from "../components/eventos/shared";
import {
  parseEventCSV, uploadEventUsers, getEventsSummary, getEventDetail, setEventDisplayName,
  type EventSummary, type EventUserRow, type ModuleUsageRow, type StatusBreakdownRow,
} from "../services/events";
import { createEventGuest, listEventGuests, deleteEventGuest, type EventGuest } from "../services/eventGuests";
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

function fmtDateTime(iso: string | null) {
  if (!iso) return "—";
  return new Intl.DateTimeFormat("es-CO", { day: "2-digit", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit" }).format(new Date(iso));
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
  const [statusBreakdown, setStatusBreakdown] = useState<StatusBreakdownRow[]>([]);
  const [loadingList, setLoadingList] = useState(true);
  const [loadingDetail, setLoadingDetail] = useState(false);
  const [search,      setSearch]      = useState("");
  const [uploading,   setUploading]   = useState(false);
  const [uploadMsg,   setUploadMsg]   = useState<{ msg: string; ok: boolean } | null>(null);
  const [selectedUser, setSelectedUser] = useState<EventUserRow | null>(null);
  const [mobileView,  setMobileView]  = useState<"list" | "detail">("list");

  // Renombrar evento
  const [editingName, setEditingName] = useState(false);
  const [nameInput,   setNameInput]   = useState("");
  const [savingName,  setSavingName]  = useState(false);

  // Invitados
  const [guests,        setGuests]        = useState<EventGuest[]>([]);
  const [loadingGuests,  setLoadingGuests] = useState(false);
  const [showAddGuest,  setShowAddGuest]  = useState(false);
  const [newUsername,   setNewUsername]   = useState("");
  const [newPassword,   setNewPassword]   = useState("");
  const [newLabel,      setNewLabel]      = useState("");
  const [creatingGuest, setCreatingGuest] = useState(false);
  const [guestMsg,      setGuestMsg]      = useState<{ msg: string; ok: boolean } | null>(null);
  const [justCreated,   setJustCreated]   = useState<{ username: string; password: string } | null>(null);

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

  const loadGuests = async (code: string) => {
    setLoadingGuests(true);
    const list = await listEventGuests(code);
    setGuests(list);
    setLoadingGuests(false);
  };

  useEffect(() => {
    setSelectedUser(null);
    setMobileView("list");
    setEditingName(false);
    setShowAddGuest(false);
    setJustCreated(null);
    setGuestMsg(null);
    if (!selectedCode) { setUsers([]); setModuleUsage([]); setStatusBreakdown([]); setGuests([]); return; }
    setLoadingDetail(true);
    getEventDetail(selectedCode).then(({ users, moduleUsage, statusBreakdown }) => {
      setUsers(users);
      setModuleUsage(moduleUsage);
      setStatusBreakdown(statusBreakdown);
      setLoadingDetail(false);
    });
    loadGuests(selectedCode);
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

  const startEditName = () => {
    if (!selectedEvent) return;
    setNameInput(selectedEvent.label);
    setEditingName(true);
  };

  const saveEditName = async () => {
    if (!selectedCode || !nameInput.trim()) return;
    setSavingName(true);
    try {
      await setEventDisplayName(selectedCode, nameInput.trim());
      await loadEvents();
      setEditingName(false);
    } finally {
      setSavingName(false);
    }
  };

  const handleAddGuest = async () => {
    if (!selectedCode || !newUsername.trim() || newPassword.length < 4) {
      setGuestMsg({ msg: "Usuario requerido y contraseña de al menos 4 caracteres.", ok: false });
      return;
    }
    setCreatingGuest(true);
    setGuestMsg(null);
    try {
      await createEventGuest(selectedCode, newUsername, newPassword, newLabel || undefined);
      setJustCreated({ username: newUsername.trim(), password: newPassword });
      setNewUsername(""); setNewPassword(""); setNewLabel("");
      setShowAddGuest(false);
      await loadGuests(selectedCode);
    } catch (e) {
      setGuestMsg({ msg: e instanceof Error ? e.message : "No se pudo crear el invitado (¿el usuario ya existe?).", ok: false });
    } finally {
      setCreatingGuest(false);
    }
  };

  const handleRemoveGuest = async (id: string) => {
    if (!selectedCode) return;
    await deleteEventGuest(id);
    await loadGuests(selectedCode);
  };

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

        {/* Contenido + panel de detalle */}
        <div style={{ flex: 1, display: "flex", overflow: "hidden" }}>
        {(!isMobile || mobileView === "list") && (
        <div style={{ flex: 1, minWidth: 0, overflowY: "auto", padding: `16px 24px ${isMobile ? 64 : 16}px`, display: "flex", flexDirection: "column", gap: 16 }}>
          {loadingDetail ? (
            <div style={{ textAlign: "center", padding: "40px 0", color: C.muted }}>
              <Loader2 size={20} style={{ animation: "spin 0.8s linear infinite" }} />
            </div>
          ) : selectedEvent ? (
            <>
              {/* Nombre del evento (editable) */}
              <div style={{ display: "flex", alignItems: "center", gap: 8, flexWrap: "wrap" }}>
                {editingName ? (
                  <>
                    <input
                      autoFocus
                      value={nameInput}
                      onChange={e => setNameInput(e.target.value)}
                      onKeyDown={e => { if (e.key === "Enter") saveEditName(); if (e.key === "Escape") setEditingName(false); }}
                      style={{
                        background: "rgba(255,255,255,0.06)", border: `1px solid rgba(254,128,63,0.4)`,
                        borderRadius: 7, color: C.white, fontSize: 15, fontWeight: 700,
                        padding: "5px 10px", outline: "none", fontFamily: FONT, minWidth: 200,
                      }}
                    />
                    <button onClick={saveEditName} disabled={savingName} title="Guardar" style={{ background: "rgba(74,222,128,0.12)", border: "1px solid rgba(74,222,128,0.3)", borderRadius: 6, color: "#4ADE80", padding: 5, cursor: "pointer", display: "flex" }}>
                      <Check size={14} />
                    </button>
                    <button onClick={() => setEditingName(false)} title="Cancelar" style={{ background: "none", border: `1px solid ${C.border}`, borderRadius: 6, color: C.mutedLight, padding: 5, cursor: "pointer", display: "flex" }}>
                      <XIcon size={14} />
                    </button>
                  </>
                ) : (
                  <>
                    <div style={{ fontSize: 16, fontWeight: 800, color: C.white }}>{selectedEvent.label}</div>
                    <button onClick={startEditName} title="Renombrar evento" style={{ background: "none", border: "none", color: C.mutedLight, cursor: "pointer", display: "flex", padding: 4 }}>
                      <Pencil size={13} />
                    </button>
                    <span style={{ fontSize: 11, color: C.muted }}>{selectedEvent.code}</span>
                  </>
                )}
              </div>

              <EventDashboardBody
                event={selectedEvent}
                statusBreakdown={statusBreakdown}
                moduleUsage={moduleUsage}
                filteredUsers={filteredUsers}
                search={search}
                onSearchChange={setSearch}
                selectedUser={selectedUser}
                onSelectUser={u => { setSelectedUser(u); if (isMobile) setMobileView("detail"); }}
              />

              {/* Invitados */}
              <div>
                <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 10, gap: 10, flexWrap: "wrap" }}>
                  <div style={{ fontSize: 13, fontWeight: 700, color: C.white }}>Invitados</div>
                  <button
                    onClick={() => { setShowAddGuest(v => !v); setGuestMsg(null); }}
                    style={{
                      display: "flex", alignItems: "center", gap: 6, padding: "6px 12px", borderRadius: 8,
                      fontSize: 11, fontWeight: 700, background: "rgba(254,128,63,0.12)",
                      border: "1px solid rgba(254,128,63,0.3)", color: C.orange, cursor: "pointer",
                    }}
                  >
                    <UserPlus size={13} /> Agregar persona
                  </button>
                </div>

                {justCreated && (
                  <div style={{
                    marginBottom: 10, padding: "10px 14px", borderRadius: 10, fontSize: 12,
                    background: "rgba(74,222,128,0.08)", border: "1px solid rgba(74,222,128,0.25)",
                  }}>
                    <div style={{ color: "#4ADE80", fontWeight: 700, marginBottom: 4 }}>
                      Invitado creado. Guarda esta contraseña — no se puede volver a ver.
                    </div>
                    <div style={{ color: C.white, fontFamily: "ui-monospace, monospace" }}>
                      Usuario: <b>{justCreated.username}</b> · Contraseña: <b>{justCreated.password}</b>
                    </div>
                    <button onClick={() => setJustCreated(null)} style={{ marginTop: 6, background: "none", border: "none", color: C.mutedLight, fontSize: 11, cursor: "pointer", padding: 0 }}>
                      Cerrar
                    </button>
                  </div>
                )}

                {showAddGuest && (
                  <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 14, marginBottom: 10, display: "flex", flexDirection: "column", gap: 8, maxWidth: 420 }}>
                    <input
                      value={newUsername} onChange={e => setNewUsername(e.target.value)}
                      placeholder="Usuario"
                      style={{ background: "rgba(255,255,255,0.04)", border: `1px solid ${C.border}`, borderRadius: 7, padding: "8px 10px", fontSize: 12, color: C.white, outline: "none", fontFamily: FONT }}
                    />
                    <input
                      value={newPassword} onChange={e => setNewPassword(e.target.value)}
                      placeholder="Contraseña (mínimo 4 caracteres)" type="text"
                      style={{ background: "rgba(255,255,255,0.04)", border: `1px solid ${C.border}`, borderRadius: 7, padding: "8px 10px", fontSize: 12, color: C.white, outline: "none", fontFamily: FONT }}
                    />
                    <input
                      value={newLabel} onChange={e => setNewLabel(e.target.value)}
                      placeholder="Nota (opcional, ej. nombre de la persona)"
                      style={{ background: "rgba(255,255,255,0.04)", border: `1px solid ${C.border}`, borderRadius: 7, padding: "8px 10px", fontSize: 12, color: C.white, outline: "none", fontFamily: FONT }}
                    />
                    {guestMsg && !guestMsg.ok && (
                      <div style={{ fontSize: 11, color: "#FF8A87" }}>{guestMsg.msg}</div>
                    )}
                    <button
                      onClick={handleAddGuest}
                      disabled={creatingGuest}
                      style={{
                        display: "flex", alignItems: "center", justifyContent: "center", gap: 6,
                        padding: "8px 0", borderRadius: 8, fontSize: 12, fontWeight: 700,
                        background: creatingGuest ? "rgba(254,128,63,0.4)" : C.gradBtn,
                        border: "none", cursor: creatingGuest ? "not-allowed" : "pointer", color: "#fff",
                      }}
                    >
                      {creatingGuest ? <Loader2 size={13} style={{ animation: "spin 0.8s linear infinite" }} /> : <KeyRound size={13} />}
                      Crear acceso
                    </button>
                  </div>
                )}

                <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, overflow: "hidden" }}>
                  {loadingGuests ? (
                    <div style={{ padding: "16px 14px", textAlign: "center" }}><Loader2 size={16} style={{ animation: "spin 0.8s linear infinite", color: C.muted }} /></div>
                  ) : guests.length === 0 ? (
                    <div style={{ padding: "16px 14px", fontSize: 12, color: C.muted, textAlign: "center" }}>Nadie tiene acceso a este evento todavía.</div>
                  ) : guests.map(g => (
                    <div key={g.id} style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: "10px 14px", borderBottom: `1px solid rgba(255,255,255,0.04)`, gap: 10 }}>
                      <div style={{ minWidth: 0 }}>
                        <div style={{ fontSize: 12, fontWeight: 700, color: C.white }}>{g.username}{g.label ? <span style={{ color: C.mutedMid, fontWeight: 400 }}> · {g.label}</span> : null}</div>
                        <div style={{ fontSize: 10, color: C.mutedMid }}>
                          Creado {fmtDateTime(g.created_at)}{g.last_login_at ? ` · Último ingreso ${fmtDateTime(g.last_login_at)}` : " · Sin ingresar todavía"}
                        </div>
                      </div>
                      <button onClick={() => handleRemoveGuest(g.id)} title="Quitar acceso" style={{ background: "none", border: `1px solid rgba(255,65,59,0.3)`, borderRadius: 6, color: "#FF8A87", padding: 6, cursor: "pointer", display: "flex", flexShrink: 0 }}>
                        <Trash2 size={13} />
                      </button>
                    </div>
                  ))}
                </div>
              </div>
            </>
          ) : (
            <div style={{ textAlign: "center", padding: "40px 0", color: C.muted, fontSize: 13 }}>
              Sube un CSV de un evento para ver su dashboard.
            </div>
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
