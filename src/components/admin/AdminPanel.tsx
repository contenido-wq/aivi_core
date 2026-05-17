import { useState } from "react";
import { ArrowLeft, ShieldCheck, Volume2, Upload } from "lucide-react";
import { Toggle } from "../ui/Toggle";
import { AUDIO_SETTINGS } from "../../data/mock";

interface AdminPanelProps { onBack: () => void; }

export function AdminPanel({ onBack }: AdminPanelProps) {
  const [hasPaidAds,  setHasPaidAds]  = useState(true);
  const [campaign,    setCampaign]    = useState("");
  const [excluded,    setExcluded]    = useState("");
  const [daily,       setDaily]       = useState("");
  const [monthly,     setMonthly]     = useState("");
  const [celebration, setCelebration] = useState("");

  const sec: React.CSSProperties = { background: "#fff", borderRadius: 14, padding: "22px 26px", marginBottom: 16, boxShadow: "0 1px 6px rgba(0,0,0,0.07)" };
  const lbl: React.CSSProperties = { fontSize: 13, fontWeight: 600, color: "#333", display: "block", marginBottom: 6 };
  const inp: React.CSSProperties = { width: "100%", background: "#F2F2F5", border: "1px solid #E0E0E6", borderRadius: 8, padding: "10px 14px", fontSize: 13, color: "#222", outline: "none" };

  const Field = ({ label: l, value, onChange, placeholder = "" }: { label: string; value: string; onChange: (v: string) => void; placeholder?: string }) => (
    <div style={{ marginBottom: 14 }}>
      <label style={lbl}>{l}</label>
      <input value={value} onChange={e => onChange(e.target.value)} placeholder={placeholder} style={inp} />
    </div>
  );

  return (
    <div style={{ minHeight: "100vh", background: "#F2F2F5", paddingBottom: 80, fontFamily: "'Hanken Grotesk', sans-serif" }}>
      <div style={{ background: "#fff", borderBottom: "1px solid #eee", padding: "0 24px", height: 52, display: "flex", alignItems: "center", justifyContent: "space-between" }}>
        <button onClick={onBack} style={{ background: "none", border: "none", cursor: "pointer", display: "flex", alignItems: "center", gap: 6, color: "#555", fontSize: 13 }}>
          <ArrowLeft size={14} /> Volver al Dashboard
        </button>
        <span style={{ display: "flex", alignItems: "center", gap: 6, color: "#333", fontSize: 13, fontWeight: 700 }}>
          <ShieldCheck size={14} /> Panel admin
        </span>
      </div>
      <div style={{ maxWidth: 720, margin: "20px auto", padding: "0 16px" }}>
        <div style={sec}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 10 }}>
            <h3 style={{ fontSize: 17, fontWeight: 800, color: "#111" }}>Solicitudes de acceso</h3>
            <span style={{ fontSize: 12, color: "#aaa" }}>0 pendientes</span>
          </div>
          <p style={{ color: "#aaa", fontSize: 13 }}>No hay solicitudes pendientes.</p>
        </div>
        <div style={sec}>
          <h3 style={{ fontSize: 17, fontWeight: 800, color: "#111", marginBottom: 20 }}>Filtros & metas</h3>
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
        <div style={sec}>
          <h3 style={{ fontSize: 17, fontWeight: 800, color: "#111", marginBottom: 18 }}>Audios</h3>
          {AUDIO_SETTINGS.map((a, i) => (
            <div key={i} style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "11px 0", borderBottom: i < AUDIO_SETTINGS.length - 1 ? "1px solid #f0f0f0" : "none" }}>
              <div>
                <div style={{ fontSize: 13, fontWeight: 600, color: "#222" }}>{a.label}</div>
                <div style={{ fontSize: 10, color: "#aaa", marginTop: 2 }}>default: {a.defaultPath}</div>
              </div>
              <div style={{ display: "flex", gap: 8 }}>
                <button style={{ background: "none", border: "1px solid #ddd", borderRadius: 7, padding: "5px 10px", color: "#555", display: "flex", alignItems: "center" }}><Volume2 size={13} /></button>
                <button style={{ background: "none", border: "1px solid #ddd", borderRadius: 7, padding: "5px 12px", fontSize: 11, fontWeight: 600, color: "#444", display: "flex", alignItems: "center", gap: 4 }}><Upload size={11} /> Subir</button>
              </div>
            </div>
          ))}
        </div>
        <div style={{ display: "flex", justifyContent: "flex-end", gap: 10 }}>
          <button onClick={onBack} style={{ padding: "10px 22px", borderRadius: 8, border: "1px solid #ddd", background: "none", cursor: "pointer", fontSize: 13 }}>Cancelar</button>
          <button style={{ padding: "10px 22px", borderRadius: 8, background: "#2563EB", color: "#fff", border: "none", cursor: "pointer", fontSize: 13, fontWeight: 700 }}>Guardar</button>
        </div>
      </div>
    </div>
  );
}
