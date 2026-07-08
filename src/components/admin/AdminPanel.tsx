import { useState, useEffect, useCallback } from "react";
import {
  ArrowLeft, ShieldCheck, Volume2, Upload,
  CheckCircle, XCircle, Clock, RefreshCw, Loader2, Trash2,
} from "lucide-react";
import { Toggle }       from "../ui/Toggle";
import { useResponsive } from "../../hooks/useResponsive";
import { AUDIO_SETTINGS } from "../../data/mock";
import { supabase }     from "../../services/supabase";
import { C }            from "../../tokens";
import type { AppView } from "../../types";

interface AdminPanelProps { onBack: () => void; }

interface AccessRequest {
  id:               string;
  email:            string;
  status:           "pending" | "approved" | "rejected";
  requested_at:     string;
  reviewed_at:      string | null;
  allowed_sections: AppView[];
}

const SECTIONS: { key: AppView; label: string }[] = [
  { key: "dashboard",     label: "Dashboard" },
  { key: "usuarios",      label: "Usuarios" },
  { key: "transacciones", label: "Transacciones" },
  { key: "analytics",     label: "Analytics" },
  { key: "eventos",       label: "Eventos" },
  { key: "admin",         label: "Ajustes" },
];

export function AdminPanel({ onBack }: AdminPanelProps) {
  const { isMobile } = useResponsive();

  // ── Config state ──────────────────────────────────────
  const [hasPaidAds,  setHasPaidAds]  = useState(true);
  const [campaign,    setCampaign]    = useState("");
  const [excluded,    setExcluded]    = useState("");
  const [daily,       setDaily]       = useState("");
  const [monthly,     setMonthly]     = useState("");
  const [celebration, setCelebration] = useState("");

  // ── Access requests state ─────────────────────────────
  const [requests,  setRequests]  = useState<AccessRequest[]>([]);
  const [reqLoad,   setReqLoad]   = useState(true);
  const [reqError,  setReqError]  = useState<string | null>(null);
  const [actionId,  setActionId]  = useState<string | null>(null);  // request being processed
  const [actionMsg, setActionMsg] = useState<{ id: string; msg: string; ok: boolean } | null>(null);

  // ── Cargar solicitudes ────────────────────────────────
  const loadRequests = useCallback(async () => {
    setReqLoad(true);
    setReqError(null);
    const { data, error } = await supabase
      .from("access_requests")
      .select("id, email, status, requested_at, reviewed_at, allowed_sections")
      .order("requested_at", { ascending: false });

    if (error) {
      setReqError(error.message);
    } else {
      setRequests((data as AccessRequest[]) ?? []);
    }
    setReqLoad(false);
  }, []);

  useEffect(() => { loadRequests(); }, [loadRequests]);

  // ── Aprobar solicitud ─────────────────────────────────
  const handleApprove = async (req: AccessRequest) => {
    setActionId(req.id);
    setActionMsg(null);

    const { error } = await supabase
      .from("access_requests")
      .update({ status: "approved", reviewed_at: new Date().toISOString() })
      .eq("id", req.id);

    if (error) {
      setActionMsg({ id: req.id, msg: error.message, ok: false });
    } else {
      setActionMsg({ id: req.id, msg: "Acceso aprobado. El miembro ya puede entrar con su correo.", ok: true });
      await loadRequests();
    }

    setActionId(null);
  };

  // ── Alternar sección otorgada ─────────────────────────
  const handleToggleSection = async (req: AccessRequest, section: AppView) => {
    const has = req.allowed_sections.includes(section);
    const next = has
      ? req.allowed_sections.filter(s => s !== section)
      : [...req.allowed_sections, section];

    setRequests(rs => rs.map(r => r.id === req.id ? { ...r, allowed_sections: next } : r));

    const { error } = await supabase
      .from("access_requests")
      .update({ allowed_sections: next })
      .eq("id", req.id);

    if (error) {
      // revertir si falló
      setRequests(rs => rs.map(r => r.id === req.id ? { ...r, allowed_sections: req.allowed_sections } : r));
      setActionMsg({ id: req.id, msg: error.message, ok: false });
    }
  };

  // ── Quitar usuario aprobado ───────────────────────────
  const handleRemove = async (req: AccessRequest) => {
    setActionId(req.id);
    setActionMsg(null);
    const { error } = await supabase
      .from("access_requests")
      .delete()
      .eq("id", req.id);

    if (error) {
      setActionMsg({ id: req.id, msg: error.message, ok: false });
    } else {
      setActionMsg({ id: req.id, msg: "Acceso eliminado.", ok: true });
      await loadRequests();
    }
    setActionId(null);
  };

  // ── Rechazar solicitud ────────────────────────────────
  const handleReject = async (req: AccessRequest) => {
    setActionId(req.id);
    setActionMsg(null);
    const { error } = await supabase
      .from("access_requests")
      .update({ status: "rejected", reviewed_at: new Date().toISOString() })
      .eq("id", req.id);

    if (error) {
      setActionMsg({ id: req.id, msg: error.message, ok: false });
    } else {
      setActionMsg({ id: req.id, msg: "Solicitud rechazada.", ok: true });
      await loadRequests();
    }
    setActionId(null);
  };

  // ── Estilos ───────────────────────────────────────────
  const sec: React.CSSProperties = {
    background: "#fff",
    borderRadius: isMobile ? 12 : 14,
    padding: isMobile ? "16px 16px" : "22px 26px",
    marginBottom: 16,
    boxShadow: "0 1px 6px rgba(0,0,0,0.07)",
  };
  const lbl: React.CSSProperties = { fontSize: 13, fontWeight: 600, color: "#333", display: "block", marginBottom: 6 };
  const inp: React.CSSProperties = {
    width: "100%",
    background: "#F2F2F5",
    border: "1px solid #E0E0E6",
    borderRadius: 8,
    padding: isMobile ? "12px 14px" : "10px 14px",
    fontSize: 16,
    color: "#222",
    outline: "none",
  };

  const Field = ({ label: l, value, onChange, placeholder = "" }: { label: string; value: string; onChange: (v: string) => void; placeholder?: string }) => (
    <div style={{ marginBottom: 14 }}>
      <label style={lbl}>{l}</label>
      <input value={value} onChange={e => onChange(e.target.value)} placeholder={placeholder} style={inp} />
    </div>
  );

  const pending  = requests.filter(r => r.status === "pending");
  const approved = requests.filter(r => r.status === "approved");
  const rejected = requests.filter(r => r.status === "rejected");

  const fmtDate = (iso: string) =>
    new Intl.DateTimeFormat("es-CO", { day: "2-digit", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit" }).format(new Date(iso));

  return (
    <div style={{ minHeight: "100vh", background: "#F2F2F5", paddingBottom: 80, fontFamily: "'Hanken Grotesk', sans-serif" }}>
      {/* Header */}
      <div style={{
        background: "#fff",
        borderBottom: "1px solid #eee",
        padding: isMobile ? "0 12px" : "0 24px",
        height: 52,
        display: "flex",
        alignItems: "center",
        justifyContent: "space-between",
        position: "sticky",
        top: 0,
        zIndex: 10,
      }}>
        <button onClick={onBack} style={{ background: "none", border: "none", cursor: "pointer", display: "flex", alignItems: "center", gap: 6, color: "#555", fontSize: 13 }}>
          <ArrowLeft size={14} /> {!isMobile && "Volver al Dashboard"}
        </button>
        <span style={{ display: "flex", alignItems: "center", gap: 6, color: "#333", fontSize: 13, fontWeight: 700 }}>
          <ShieldCheck size={14} /> Panel admin
        </span>
      </div>

      <div style={{ maxWidth: 720, margin: "20px auto", padding: isMobile ? "0 12px" : "0 16px" }}>

        {/* ── Solicitudes de acceso ── */}
        <div style={sec}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16, flexWrap: "wrap", gap: 8 }}>
            <h3 style={{ fontSize: isMobile ? 15 : 17, fontWeight: 800, color: "#111", margin: 0 }}>
              Solicitudes de acceso
            </h3>
            <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
              {pending.length > 0 && (
                <span style={{
                  fontSize: 11, fontWeight: 700, color: "#fff",
                  background: "#FE803F", borderRadius: 20, padding: "2px 10px",
                }}>
                  {pending.length} pendiente{pending.length > 1 ? "s" : ""}
                </span>
              )}
              <button onClick={loadRequests} disabled={reqLoad} title="Refrescar" style={{
                background: "none", border: "1px solid #ddd", borderRadius: 8,
                padding: "5px 8px", cursor: reqLoad ? "not-allowed" : "pointer",
                color: "#888", display: "flex", alignItems: "center",
              }}>
                <RefreshCw size={13} style={{ animation: reqLoad ? "spin 0.8s linear infinite" : "none" }} />
              </button>
            </div>
          </div>

          {reqError && (
            <p style={{ color: "#e53935", fontSize: 13, marginBottom: 12 }}>Error: {reqError}</p>
          )}

          {reqLoad ? (
            <div style={{ textAlign: "center", padding: "20px 0", color: "#aaa" }}>
              <Loader2 size={20} style={{ animation: "spin 0.8s linear infinite" }} />
            </div>
          ) : requests.length === 0 ? (
            <p style={{ color: "#aaa", fontSize: 13 }}>No hay solicitudes todavía.</p>
          ) : (
            <>
              {/* Pendientes */}
              {pending.length > 0 && (
                <div style={{ marginBottom: 16 }}>
                  <div style={{ fontSize: 11, fontWeight: 700, color: "#888", textTransform: "uppercase", letterSpacing: "0.06em", marginBottom: 8 }}>
                    Pendientes
                  </div>
                  {pending.map(r => (
                    <RequestRow
                      key={r.id} req={r}
                      loading={actionId === r.id}
                      message={actionMsg?.id === r.id ? actionMsg : null}
                      onApprove={() => handleApprove(r)}
                      onReject={() => handleReject(r)}
                      onToggleSection={section => handleToggleSection(r, section)}
                      fmtDate={fmtDate}
                    />
                  ))}
                </div>
              )}

              {/* Aprobadas */}
              {approved.length > 0 && (
                <div style={{ marginBottom: 16 }}>
                  <div style={{ fontSize: 11, fontWeight: 700, color: "#888", textTransform: "uppercase", letterSpacing: "0.06em", marginBottom: 8 }}>
                    Aprobadas
                  </div>
                  {approved.map(r => (
                    <RequestRow
                      key={r.id} req={r}
                      loading={actionId === r.id}
                      message={actionMsg?.id === r.id ? actionMsg : null}
                      onApprove={() => {}} onReject={() => {}}
                      onRemove={() => handleRemove(r)}
                      onToggleSection={section => handleToggleSection(r, section)}
                      fmtDate={fmtDate}
                    />
                  ))}
                </div>
              )}

              {/* Rechazadas */}
              {rejected.length > 0 && (
                <div>
                  <div style={{ fontSize: 11, fontWeight: 700, color: "#888", textTransform: "uppercase", letterSpacing: "0.06em", marginBottom: 8 }}>
                    Rechazadas
                  </div>
                  {rejected.map(r => (
                    <RequestRow
                      key={r.id} req={r}
                      loading={false} message={null}
                      onApprove={() => {}} onReject={() => {}}
                      onToggleSection={() => {}}
                      fmtDate={fmtDate}
                    />
                  ))}
                </div>
              )}
            </>
          )}
        </div>

        {/* ── Filtros & metas ── */}
        <div style={sec}>
          <h3 style={{ fontSize: isMobile ? 15 : 17, fontWeight: 800, color: "#111", marginBottom: 20 }}>Filtros & metas</h3>
          <Field label="Campaign name filter"      value={campaign}    onChange={setCampaign} />
          <Field label="Excluded campaigns today"  value={excluded}    onChange={setExcluded} />
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 14 }}>
            <label style={lbl}>Has paid ads</label>
            <Toggle on={hasPaidAds} onChange={() => setHasPaidAds(!hasPaidAds)} color="#2563EB" />
          </div>
          <Field label="Meta diaria de facturación"   value={daily}       onChange={setDaily}       placeholder="Ej: 500" />
          <Field label="Meta mensual nuevos usuarios" value={monthly}     onChange={setMonthly}     placeholder="Ej: 100" />
          <Field label="Meta de celebración (USD)"    value={celebration} onChange={setCelebration} placeholder="Ej: 10000" />
        </div>

        {/* ── Audios ── */}
        <div style={sec}>
          <h3 style={{ fontSize: isMobile ? 15 : 17, fontWeight: 800, color: "#111", marginBottom: 18 }}>Audios</h3>
          {AUDIO_SETTINGS.map((a, i) => (
            <div key={i} style={{
              display: "flex", justifyContent: "space-between", alignItems: "center",
              padding: "11px 0", borderBottom: i < AUDIO_SETTINGS.length - 1 ? "1px solid #f0f0f0" : "none",
              flexWrap: isMobile ? "wrap" : "nowrap",
              gap: isMobile ? 8 : 0,
            }}>
              <div style={{ minWidth: 0, flex: 1 }}>
                <div style={{ fontSize: 13, fontWeight: 600, color: "#222" }}>{a.label}</div>
                <div style={{ fontSize: 10, color: "#aaa", marginTop: 2, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>default: {a.defaultPath}</div>
              </div>
              <div style={{ display: "flex", gap: 8, flexShrink: 0 }}>
                <button style={{ background: "none", border: "1px solid #ddd", borderRadius: 7, padding: "5px 10px", color: "#555", display: "flex", alignItems: "center" }}><Volume2 size={13} /></button>
                <button style={{ background: "none", border: "1px solid #ddd", borderRadius: 7, padding: "5px 12px", fontSize: 11, fontWeight: 600, color: "#444", display: "flex", alignItems: "center", gap: 4 }}><Upload size={11} /> Subir</button>
              </div>
            </div>
          ))}
        </div>

        <div style={{ display: "flex", justifyContent: "flex-end", gap: 10, flexWrap: "wrap" }}>
          <button onClick={onBack} style={{ padding: "10px 22px", borderRadius: 8, border: "1px solid #ddd", background: "none", cursor: "pointer", fontSize: 13, flex: isMobile ? 1 : "none" }}>Cancelar</button>
          <button style={{ padding: "10px 22px", borderRadius: 8, background: "#2563EB", color: "#fff", border: "none", cursor: "pointer", fontSize: 13, fontWeight: 700, flex: isMobile ? 1 : "none" }}>Guardar</button>
        </div>
      </div>

      <style>{`@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`}</style>
    </div>
  );
}

// ── Componente fila de solicitud ───────────────────────────────────────────────
interface RequestRowProps {
  req:             AccessRequest;
  loading:         boolean;
  message:         { msg: string; ok: boolean } | null;
  onApprove:       () => void;
  onReject:        () => void;
  onRemove?:       () => void;
  onToggleSection: (section: AppView) => void;
  fmtDate:         (iso: string) => string;
}

function RequestRow({ req, loading, message, onApprove, onReject, onRemove, onToggleSection, fmtDate }: RequestRowProps) {
  const isPending  = req.status === "pending";
  const isApproved = req.status === "approved";
  const isRejected = req.status === "rejected";

  return (
    <div style={{
      background: "#F8F8FB",
      border: "1px solid #eee",
      borderRadius: 10,
      padding: "12px 14px",
      marginBottom: 8,
    }}>
      <div style={{ display: "flex", alignItems: "flex-start", justifyContent: "space-between", gap: 8, flexWrap: "wrap" }}>
        <div style={{ minWidth: 0 }}>
          <div style={{ display: "flex", alignItems: "center", gap: 6, marginBottom: 3, flexWrap: "wrap" }}>
            {isApproved && <CheckCircle size={13} style={{ color: "#FE803F", flexShrink: 0 }} />}
            {isRejected && <XCircle     size={13} style={{ color: "#EF4444", flexShrink: 0 }} />}
            {isPending  && <Clock       size={13} style={{ color: "#FE803F", flexShrink: 0 }} />}
            <span style={{ fontSize: 13, fontWeight: 700, color: "#222", wordBreak: "break-all" }}>{req.email}</span>
          </div>
          <div style={{ fontSize: 11, color: "#aaa" }}>
            Solicitó: {fmtDate(req.requested_at)}
            {req.reviewed_at && <span style={{ marginLeft: 8 }}>· Revisado: {fmtDate(req.reviewed_at)}</span>}
          </div>
          {(isPending || isApproved) && (
            <div style={{ display: "flex", gap: 4, flexWrap: "wrap", marginTop: 6 }}>
              {SECTIONS.map(s => {
                const active = req.allowed_sections.includes(s.key);
                return (
                  <button
                    key={s.key}
                    onClick={() => onToggleSection(s.key)}
                    style={{
                      padding: "2px 8px", borderRadius: 5, fontSize: 10, fontWeight: 700,
                      border: `1px solid ${active ? "#FE803F" : "#ddd"}`,
                      background: active ? "rgba(254,128,63,0.12)" : "transparent",
                      color: active ? "#FE803F" : "#999",
                      cursor: "pointer",
                    }}
                  >
                    {s.label}
                  </button>
                );
              })}
            </div>
          )}
        </div>

        {isPending && (
          <div style={{ display: "flex", gap: 6, flexShrink: 0 }}>
            <button
              onClick={onApprove}
              disabled={loading}
              style={{
                padding: "6px 14px", borderRadius: 7, border: "none",
                background: loading ? "rgba(254,128,63,0.4)" : C.gradBtn,
                color: "#fff", fontSize: 11, fontWeight: 700,
                cursor: loading ? "not-allowed" : "pointer",
                display: "flex", alignItems: "center", gap: 4,
              }}
            >
              {loading ? <Loader2 size={11} style={{ animation: "spin 0.8s linear infinite" }} /> : <CheckCircle size={11} />}
              Aprobar
            </button>
            <button
              onClick={onReject}
              disabled={loading}
              style={{
                padding: "6px 14px", borderRadius: 7, border: "1px solid #eee",
                background: "transparent",
                color: "#EF4444", fontSize: 11, fontWeight: 700,
                cursor: loading ? "not-allowed" : "pointer",
                display: "flex", alignItems: "center", gap: 4,
              }}
            >
              <XCircle size={11} /> Rechazar
            </button>
          </div>
        )}

        {isApproved && onRemove && (
          <button
            onClick={onRemove}
            disabled={loading}
            title="Quitar acceso"
            style={{
              padding: "6px 12px", borderRadius: 7, border: "1px solid #FECACA",
              background: "transparent",
              color: "#EF4444", fontSize: 11, fontWeight: 700,
              cursor: loading ? "not-allowed" : "pointer",
              display: "flex", alignItems: "center", gap: 4, flexShrink: 0,
            }}
          >
            {loading ? <Loader2 size={11} style={{ animation: "spin 0.8s linear infinite" }} /> : <Trash2 size={11} />}
            Quitar
          </button>
        )}
      </div>

      {message && (
        <div style={{
          marginTop: 8, fontSize: 11, fontWeight: 600,
          color: message.ok ? "#16A34A" : "#DC2626",
          background: message.ok ? "#F0FDF4" : "#FEF2F2",
          border: `1px solid ${message.ok ? "#BBF7D0" : "#FECACA"}`,
          borderRadius: 6, padding: "6px 10px",
        }}>
          {message.msg}
        </div>
      )}
    </div>
  );
}
