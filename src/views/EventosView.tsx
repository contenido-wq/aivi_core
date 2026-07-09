import { useState, useEffect, useRef, useMemo } from "react";
import { Calendar, Upload, Search, Loader2, RefreshCw, Menu, ArrowLeft, X } from "lucide-react";
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Cell, LabelList, PieChart, Pie,
} from "recharts";
import { C, FONT } from "../tokens";
import { useResponsive } from "../hooks/useResponsive";
import { Sidebar } from "../components/layout/Sidebar";
import { MobileBottomNav } from "../components/layout/MobileBottomNav";
import { Card } from "../components/ui/Card";
import {
  parseEventCSV, uploadEventUsers, getEventsSummary, getEventDetail, userStatus, MODULES,
  type EventSummary, type EventUserRow, type ModuleUsageRow, type StatusBreakdownRow, type UserStatus,
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

const STATUS_COLOR: Record<UserStatus, string> = {
  no_activado: C.red,
  sin_tokens:  C.yellow,
  con_tokens:  C.green,
};

const STATUS_SHORT_LABEL: Record<UserStatus, string> = {
  no_activado: "No activado",
  sin_tokens:  "Por empezar",
  con_tokens:  "Ejecutado",
};

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

function StatusTip({ active, payload }: any) {
  if (!active || !payload?.length) return null;
  const p = payload[0].payload as StatusBreakdownRow;
  return (
    <div style={{
      background: "#18181B", border: `1px solid ${C.border}`, borderRadius: 10,
      padding: "10px 14px", fontSize: 12, boxShadow: "0 8px 24px rgba(0,0,0,0.5)",
    }}>
      <div style={{ color: C.white, marginBottom: 4, fontWeight: 600 }}>{p.label}</div>
      <div style={{ color: STATUS_COLOR[p.status], fontWeight: 700 }}>{p.count} usuarios · {p.pct}%</div>
    </div>
  );
}

function ModuleTip({ active, payload }: any) {
  if (!active || !payload?.length) return null;
  const p = payload[0].payload as ModuleUsageRow;
  return (
    <div style={{
      background: "#18181B", border: `1px solid ${C.border}`, borderRadius: 10,
      padding: "10px 14px", fontSize: 12, boxShadow: "0 8px 24px rgba(0,0,0,0.5)",
    }}>
      <div style={{ color: C.white, marginBottom: 4, fontWeight: 600 }}>{p.label}</div>
      <div style={{ color: C.orange, fontWeight: 700 }}>{p.usersWithUsage} usuarios · {p.pct}%</div>
      <div style={{ color: C.mutedMid, marginTop: 2 }}>{p.totalUses} usos totales</div>
    </div>
  );
}

function StatusDonutChart({ data }: { data: StatusBreakdownRow[] }) {
  const total = data.reduce((s, d) => s + d.count, 0);
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 28, flexWrap: "wrap", justifyContent: "center", padding: "8px 0", width: "100%" }}>
      <div style={{ position: "relative", width: 160, height: 160, flexShrink: 0 }}>
        <ResponsiveContainer width="100%" height="100%">
          <PieChart>
            <Pie
              data={data} dataKey="count" nameKey="label"
              innerRadius={52} outerRadius={78} paddingAngle={2} stroke="none"
              isAnimationActive animationDuration={600}
            >
              {data.map(d => <Cell key={d.status} fill={STATUS_COLOR[d.status]} />)}
            </Pie>
            <Tooltip content={<StatusTip />} />
          </PieChart>
        </ResponsiveContainer>
        <div style={{
          position: "absolute", inset: 0, display: "flex", flexDirection: "column",
          alignItems: "center", justifyContent: "center", pointerEvents: "none",
        }}>
          <div style={{ fontFamily: FONT, fontSize: 24, fontWeight: 900, color: C.white, letterSpacing: "-0.02em" }}>{total}</div>
          <div style={{ fontSize: 9, fontWeight: 800, color: C.mutedLight, textTransform: "uppercase", letterSpacing: "0.08em" }}>Total</div>
        </div>
      </div>
      <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
        {data.map(d => (
          <div key={d.status} style={{ display: "flex", alignItems: "center", gap: 8, fontSize: 12 }}>
            <span style={{ width: 8, height: 8, borderRadius: "50%", background: STATUS_COLOR[d.status], flexShrink: 0 }} />
            <span style={{ color: C.mutedLight, minWidth: 160 }}>{d.label}</span>
            <span style={{ fontWeight: 700, color: C.white, fontFamily: FONT }}>{d.count}</span>
            <span style={{ color: C.mutedMid, fontSize: 11 }}>({d.pct}%)</span>
          </div>
        ))}
      </div>
    </div>
  );
}

function ModuleUsageChart({ data }: { data: ModuleUsageRow[] }) {
  return (
    <ResponsiveContainer width="100%" height={Math.max(220, data.length * 28)}>
      <BarChart data={data} layout="vertical" margin={{ top: 4, right: 36, left: 4, bottom: 4 }}>
        <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.04)" horizontal={false} />
        <XAxis type="number" hide />
        <YAxis
          type="category" dataKey="label" width={150}
          tick={{ fill: C.mutedLight, fontSize: 11, fontFamily: FONT }}
          tickLine={false} axisLine={false}
        />
        <Tooltip content={<ModuleTip />} cursor={{ fill: "rgba(255,255,255,0.03)" }} />
        <Bar dataKey="usersWithUsage" fill={C.orange} radius={[0, 4, 4, 0]} maxBarSize={18} isAnimationActive animationDuration={600}>
          <LabelList dataKey="usersWithUsage" position="right" fill={C.mutedLight} fontSize={11} fontFamily={FONT} />
        </Bar>
      </BarChart>
    </ResponsiveContainer>
  );
}

interface UserModuleRow {
  key:   string;
  label: string;
  count: number;
  last:  string | null;
}

function UserDetailPanel({ user, onClose, isMobile }: { user: EventUserRow; onClose: () => void; isMobile: boolean }) {
  const status = userStatus(user);

  const moduleRows: UserModuleRow[] = MODULES
    .map(m => ({
      key:   m.key,
      label: m.label,
      count: (user[`${m.key}_exitosas` as keyof EventUserRow] as number) ?? 0,
      last:  (user[`${m.key}_ultima` as keyof EventUserRow] as string | null) ?? null,
    }))
    .sort((a, b) => b.count - a.count);

  return (
    <div style={{ display: "flex", flexDirection: "column", height: "100%" }}>
      {/* Header */}
      <div style={{ padding: "16px 18px", borderBottom: `1px solid ${C.border}`, flexShrink: 0 }}>
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 10 }}>
          <button onClick={onClose} style={{
            background: "none", border: "none", color: C.mutedLight, cursor: "pointer",
            display: "flex", alignItems: "center", gap: 5, fontSize: 12, padding: 0,
          }}>
            {isMobile ? <><ArrowLeft size={14} /> Volver</> : <X size={16} />}
          </button>
        </div>
        <div style={{ fontSize: 15, fontWeight: 700, color: C.white, marginBottom: 3, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
          {user.nombre || user.email.split("@")[0]}
        </div>
        <div style={{ fontSize: 12, color: C.mutedMid, marginBottom: 8, wordBreak: "break-all" }}>{user.email}</div>
        <span style={{
          display: "inline-flex", alignItems: "center", gap: 5,
          fontSize: 10, fontWeight: 700, color: STATUS_COLOR[status],
          background: `${STATUS_COLOR[status]}1F`, border: `1px solid ${STATUS_COLOR[status]}40`,
          borderRadius: 5, padding: "3px 8px",
        }}>
          <span style={{ width: 6, height: 6, borderRadius: "50%", background: STATUS_COLOR[status], flexShrink: 0 }} />
          {STATUS_SHORT_LABEL[status]}
        </span>
      </div>

      {/* Datos generales */}
      <div style={{ padding: "14px 18px", borderBottom: `1px solid ${C.border}`, flexShrink: 0 }}>
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
          {[
            { label: "Plan",              value: user.plan ?? "—" },
            { label: "Estado del plan",   value: user.estado_plan ?? "—" },
            { label: "Registrado",        value: fmtDate(user.registrado_el) },
            { label: "Tokens (total)",    value: String(user.tokens_plan_consumidos_total) },
          ].map(f => (
            <div key={f.label}>
              <div style={{ fontSize: 9, fontWeight: 800, color: C.muted, textTransform: "uppercase", letterSpacing: "0.06em", marginBottom: 2 }}>{f.label}</div>
              <div style={{ fontSize: 12, color: C.white, fontWeight: 600, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{f.value}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Uso por módulo */}
      <div style={{ flex: 1, overflowY: "auto", padding: "14px 18px" }}>
        <div style={{ fontSize: 11, fontWeight: 800, color: C.mutedLight, textTransform: "uppercase", letterSpacing: "0.06em", marginBottom: 10 }}>
          Uso por módulo
        </div>
        {moduleRows.map(m => (
          <div key={m.key} style={{
            display: "flex", alignItems: "center", justifyContent: "space-between", gap: 10,
            padding: "8px 0", borderBottom: `1px solid rgba(255,255,255,0.04)`,
            opacity: m.count > 0 ? 1 : 0.4,
          }}>
            <span style={{ fontSize: 12, color: C.white }}>{m.label}</span>
            <div style={{ textAlign: "right", flexShrink: 0 }}>
              <div style={{ fontSize: 12, fontWeight: 700, color: m.count > 0 ? C.orange : C.muted }}>{m.count}×</div>
              <div style={{ fontSize: 10, color: C.mutedMid }}>{fmtDate(m.last)}</div>
            </div>
          </div>
        ))}
      </div>
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
  const [statusBreakdown, setStatusBreakdown] = useState<StatusBreakdownRow[]>([]);
  const [loadingList, setLoadingList] = useState(true);
  const [loadingDetail, setLoadingDetail] = useState(false);
  const [search,      setSearch]      = useState("");
  const [uploading,   setUploading]   = useState(false);
  const [uploadMsg,   setUploadMsg]   = useState<{ msg: string; ok: boolean } | null>(null);
  const [selectedUser, setSelectedUser] = useState<EventUserRow | null>(null);
  const [mobileView,  setMobileView]  = useState<"list" | "detail">("list");

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
    setSelectedUser(null);
    setMobileView("list");
    if (!selectedCode) { setUsers([]); setModuleUsage([]); setStatusBreakdown([]); return; }
    setLoadingDetail(true);
    getEventDetail(selectedCode).then(({ users, moduleUsage, statusBreakdown }) => {
      setUsers(users);
      setModuleUsage(moduleUsage);
      setStatusBreakdown(statusBreakdown);
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
              <div style={{ display: "flex", gap: 10, flexWrap: "wrap" }}>
                <KPITile label="Total asistentes" value={String(selectedEvent.total)} color={C.white} />
                {statusBreakdown.map(s => (
                  <KPITile
                    key={s.status}
                    label={s.status === "no_activado" ? "No activados" : s.status === "sin_tokens" ? "Por empezar" : "Generaron contenido"}
                    value={`${s.count} (${s.pct}%)`}
                    color={STATUS_COLOR[s.status]}
                  />
                ))}
              </div>

              {/* Estado de usuarios + Uso por módulo */}
              <div style={{ display: "flex", gap: 16, flexWrap: "wrap", alignItems: "stretch" }}>
                <div style={{ flex: "1 1 320px", minWidth: 0, display: "flex", flexDirection: "column" }}>
                  <div style={{ fontSize: 13, fontWeight: 700, color: C.white, marginBottom: 10 }}>Estado de usuarios</div>
                  <Card style={{ padding: "12px 14px", flex: 1, display: "flex", alignItems: "center" }}>
                    <StatusDonutChart data={statusBreakdown} />
                  </Card>
                </div>

                <div style={{ flex: "1 1 320px", minWidth: 0, display: "flex", flexDirection: "column" }}>
                  <div style={{ fontSize: 13, fontWeight: 700, color: C.white, marginBottom: 10 }}>Uso por módulo</div>
                  <Card style={{ padding: "12px 14px", flex: 1 }}>
                    <ModuleUsageChart data={moduleUsage} />
                  </Card>
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
                    <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 200px 120px", padding: "8px 14px", fontSize: 10, fontWeight: 800, color: C.muted, textTransform: "uppercase", letterSpacing: "0.06em", borderBottom: `1px solid ${C.border}` }}>
                      <span>Nombre</span><span>Email</span><span>Estado</span><span>Registrado</span>
                    </div>
                    {filteredUsers.length === 0 ? (
                      <div style={{ padding: "20px 14px", fontSize: 12, color: C.muted, textAlign: "center" }}>Sin resultados</div>
                    ) : filteredUsers.map(u => {
                      const status = userStatus(u);
                      const isSel = selectedUser?.email === u.email;
                      return (
                      <div
                        key={u.email}
                        onClick={() => { setSelectedUser(u); if (isMobile) setMobileView("detail"); }}
                        style={{
                          display: "grid", gridTemplateColumns: "1fr 1fr 200px 120px", padding: "8px 14px", fontSize: 12,
                          borderBottom: `1px solid rgba(255,255,255,0.04)`, alignItems: "center", cursor: "pointer",
                          borderLeft: isSel ? `2px solid ${C.orange}` : "2px solid transparent",
                          background: isSel ? "rgba(254,128,63,0.07)" : "transparent",
                        }}
                      >
                        <span style={{ color: C.white, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{u.nombre || u.email.split("@")[0]}</span>
                        <span style={{ color: C.mutedMid, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{u.email}</span>
                        <span style={{
                          display: "inline-flex", alignItems: "center", gap: 5, width: "fit-content",
                          fontSize: 10, fontWeight: 700, color: STATUS_COLOR[status],
                          background: `${STATUS_COLOR[status]}1F`, border: `1px solid ${STATUS_COLOR[status]}40`,
                          borderRadius: 5, padding: "3px 8px",
                        }}>
                          <span style={{ width: 6, height: 6, borderRadius: "50%", background: STATUS_COLOR[status], flexShrink: 0 }} />
                          {STATUS_SHORT_LABEL[status]}
                        </span>
                        <span style={{ color: C.mutedLight }}>{fmtDate(u.registrado_el)}</span>
                      </div>
                      );
                    })}
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
