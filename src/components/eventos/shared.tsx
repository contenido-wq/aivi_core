import { useState } from "react";
import { Search, ArrowLeft, X, Check, Pencil } from "lucide-react";
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Cell, LabelList, PieChart, Pie,
} from "recharts";
import { C, FONT } from "../../tokens";
import { Card } from "../ui/Card";
import { userStatus, MODULES } from "../../services/events";
import type { EventSummary, EventUserRow, ModuleUsageRow, StatusBreakdownRow, UserStatus } from "../../services/events";

export const STATUS_COLOR: Record<UserStatus, string> = {
  no_activado: C.red,
  sin_tokens:  C.yellow,
  con_tokens:  C.green,
};

export const STATUS_SHORT_LABEL: Record<UserStatus, string> = {
  no_activado: "No activado",
  sin_tokens:  "Por empezar",
  con_tokens:  "Ejecutado",
};

export function fmtDate(iso: string | null) {
  if (!iso) return "—";
  return new Intl.DateTimeFormat("es-CO", { day: "2-digit", month: "short", year: "numeric" }).format(new Date(iso));
}

export function KPITile({ label, value, color }: { label: string; value: string; color: string }) {
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

export function StatusDonutChart({ data }: { data: StatusBreakdownRow[] }) {
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

export function ModuleUsageChart({ data }: { data: ModuleUsageRow[] }) {
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

interface EditableFieldProps {
  value:       string;
  placeholder: string;
  onSave:      (v: string) => Promise<void>;
  fontSize?:   number;
  fontWeight?: number;
}

function EditableField({ value, placeholder, onSave, fontSize = 12, fontWeight = 600 }: EditableFieldProps) {
  const [editing, setEditing] = useState(false);
  const [input,   setInput]   = useState(value);
  const [saving,  setSaving]  = useState(false);

  const start = () => { setInput(value); setEditing(true); };
  const cancel = () => setEditing(false);
  const save = async () => {
    setSaving(true);
    try { await onSave(input); setEditing(false); } finally { setSaving(false); }
  };

  if (editing) {
    return (
      <div style={{ display: "flex", alignItems: "center", gap: 4 }}>
        <input
          autoFocus
          value={input}
          onChange={e => setInput(e.target.value)}
          onKeyDown={e => { if (e.key === "Enter") save(); if (e.key === "Escape") cancel(); }}
          style={{
            background: "rgba(255,255,255,0.06)", border: `1px solid rgba(254,128,63,0.4)`,
            borderRadius: 5, color: C.white, fontSize, fontWeight, padding: "2px 6px",
            outline: "none", fontFamily: FONT, minWidth: 0, flex: 1,
          }}
        />
        <button onClick={save} disabled={saving} title="Guardar" style={{ background: "none", border: "none", color: "#4ADE80", cursor: "pointer", padding: 2, display: "flex", flexShrink: 0 }}>
          <Check size={12} />
        </button>
        <button onClick={cancel} title="Cancelar" style={{ background: "none", border: "none", color: C.mutedLight, cursor: "pointer", padding: 2, display: "flex", flexShrink: 0 }}>
          <X size={12} />
        </button>
      </div>
    );
  }

  return (
    <span
      onClick={start}
      style={{
        display: "inline-flex", alignItems: "center", gap: 4, cursor: "pointer",
        fontSize, fontWeight, color: value ? C.white : C.muted,
        overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
      }}
    >
      {value || placeholder}
      <Pencil size={9} style={{ color: C.mutedLight, opacity: 0.6, flexShrink: 0 }} />
    </span>
  );
}

export function UserDetailPanel({ user, onClose, isMobile, onUpdateUser }: {
  user: EventUserRow;
  onClose: () => void;
  isMobile: boolean;
  /** Si se pasa, el nombre y el teléfono quedan editables (equipo). Sin ella, solo lectura (invitados). */
  onUpdateUser?: (email: string, fields: { nombre?: string; phone?: string }) => Promise<void>;
}) {
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
        <div style={{ marginBottom: 3 }}>
          {onUpdateUser ? (
            <EditableField
              value={user.nombre ?? ""}
              placeholder={user.email.split("@")[0]}
              onSave={v => onUpdateUser(user.email, { nombre: v })}
              fontSize={15} fontWeight={700}
            />
          ) : (
            <div style={{ fontSize: 15, fontWeight: 700, color: C.white, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
              {user.nombre || user.email.split("@")[0]}
            </div>
          )}
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
          <div>
            <div style={{ fontSize: 9, fontWeight: 800, color: C.muted, textTransform: "uppercase", letterSpacing: "0.06em", marginBottom: 2 }}>Teléfono</div>
            {onUpdateUser ? (
              <EditableField
                value={user.phone ?? ""}
                placeholder="Agregar teléfono"
                onSave={v => onUpdateUser(user.email, { phone: v })}
              />
            ) : (
              <div style={{ fontSize: 12, color: C.white, fontWeight: 600, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{user.phone ?? "—"}</div>
            )}
          </div>
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

interface EventDashboardBodyProps {
  event:           EventSummary;
  statusBreakdown: StatusBreakdownRow[];
  moduleUsage:     ModuleUsageRow[];
  filteredUsers:   EventUserRow[];
  search:          string;
  onSearchChange:  (s: string) => void;
  selectedUser:    EventUserRow | null;
  onSelectUser:    (u: EventUserRow) => void;
}

/** KPIs + gráficos de estado/módulo + tabla de usuarios de un evento. Compartido entre EventosView (admin) y EventGuestView (invitado, solo lectura). */
export function EventDashboardBody({
  event, statusBreakdown, moduleUsage, filteredUsers, search, onSearchChange, selectedUser, onSelectUser,
}: EventDashboardBodyProps) {
  return (
    <>
      <div style={{ display: "flex", gap: 10, flexWrap: "wrap" }}>
        <KPITile label="Total asistentes" value={String(event.total)} color={C.white} />
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
              value={search} onChange={e => onSearchChange(e.target.value)}
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
          <div style={{ minWidth: 680 }}>
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 130px 200px 120px", padding: "8px 14px", fontSize: 10, fontWeight: 800, color: C.muted, textTransform: "uppercase", letterSpacing: "0.06em", borderBottom: `1px solid ${C.border}` }}>
              <span>Nombre</span><span>Email</span><span>Teléfono</span><span>Estado</span><span>Registrado</span>
            </div>
            {filteredUsers.length === 0 ? (
              <div style={{ padding: "20px 14px", fontSize: 12, color: C.muted, textAlign: "center" }}>Sin resultados</div>
            ) : filteredUsers.map(u => {
              const status = userStatus(u);
              const isSel = selectedUser?.email === u.email;
              return (
              <div
                key={u.email}
                onClick={() => onSelectUser(u)}
                style={{
                  display: "grid", gridTemplateColumns: "1fr 1fr 130px 200px 120px", padding: "8px 14px", fontSize: 12,
                  borderBottom: `1px solid rgba(255,255,255,0.04)`, alignItems: "center", cursor: "pointer",
                  borderLeft: isSel ? `2px solid ${C.orange}` : "2px solid transparent",
                  background: isSel ? "rgba(254,128,63,0.07)" : "transparent",
                }}
              >
                <span style={{ color: C.white, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{u.nombre || u.email.split("@")[0]}</span>
                <span style={{ color: C.mutedMid, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{u.email}</span>
                <span style={{ color: u.phone ? C.mutedLight : C.muted, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{u.phone ?? "—"}</span>
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
  );
}
