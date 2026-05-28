import { useState, useEffect, useMemo }  from "react";
import { ArrowLeft, Search, RefreshCw, Loader2, TrendingUp, Calendar, MapPin, Radio, AlertTriangle, CheckCircle2, XCircle, Clock } from "lucide-react";
import { C, FONT }                       from "../tokens";
import { getUsersTraceability }           from "../services/dashboard";
import type { UserProfile }              from "../services/dashboard";

interface UsersViewProps { onBack: () => void; }

const FLAGS: Record<string, string> = {
  "Colombia":"🇨🇴","México":"🇲🇽","Mexico":"🇲🇽","Argentina":"🇦🇷",
  "Perú":"🇵🇪","Peru":"🇵🇪","Chile":"🇨🇱","Ecuador":"🇪🇨","España":"🇪🇸",
  "Estados Unidos":"🇺🇸","Venezuela":"🇻🇪","Panamá":"🇵🇦","Costa Rica":"🇨🇷",
  "Bolivia":"🇧🇴","Uruguay":"🇺🇾","Paraguay":"🇵🇾","Guatemala":"🇬🇹","Brasil":"🇧🇷",
};

const flag = (c: string) => FLAGS[c] ?? "🌎";

function initials(name: string) {
  const parts = name.trim().split(" ");
  if (parts.length >= 2) return (parts[0][0] + parts[1][0]).toUpperCase();
  return name.slice(0, 2).toUpperCase();
}

function fmtDate(iso: string) {
  if (!iso) return "—";
  return new Intl.DateTimeFormat("es-CO", { day: "2-digit", month: "short", year: "numeric" }).format(new Date(iso));
}

function fmtUSD(n: number) {
  return `$${n.toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`;
}

function statusBadge(s: UserProfile["status"]) {
  const map = {
    active:    { label: "Activo",    bg: "rgba(34,197,94,0.12)",   border: "rgba(34,197,94,0.25)",  color: "#22C55E" },
    cancelled: { label: "Cancelado", bg: "rgba(239,68,68,0.12)",   border: "rgba(239,68,68,0.25)",  color: "#EF4444" },
    delayed:   { label: "Retrasado", bg: "rgba(255,194,82,0.12)",  border: "rgba(255,194,82,0.25)", color: "#FFC252" },
    trial:     { label: "Trial",     bg: "rgba(56,189,248,0.12)",  border: "rgba(56,189,248,0.25)", color: "#38BDF8" },
  };
  const m = map[s] ?? map.cancelled;
  return (
    <span style={{
      fontSize: 9, fontWeight: 700, letterSpacing: "0.5px", textTransform: "uppercase",
      padding: "2px 7px", borderRadius: 3,
      background: m.bg, border: `1px solid ${m.border}`, color: m.color,
    }}>{m.label}</span>
  );
}

function txDot(status: string) {
  if (status === "active")    return { color: C.green };
  if (status === "refunded" || status === "chargeback") return { color: C.red };
  if (status === "delayed")   return { color: C.yellow };
  return { color: C.mutedMid };
}

function retentionScore(u: UserProfile): number {
  if (u.status === "cancelled") return 20;
  if (u.status === "delayed")   return 40;
  if (u.renewalsCount >= 6) return 95;
  if (u.renewalsCount >= 3) return 80;
  if (u.renewalsCount >= 1) return 65;
  return 50;
}

function riskLabel(score: number) {
  if (score >= 80) return { txt: "Bajo — cliente fidelizado",     color: C.green };
  if (score >= 55) return { txt: "Medio — mantener seguimiento",  color: C.yellow };
  return           { txt: "Alto — riesgo de cancelación",          color: C.red };
}

// ─────────────────────────────────────────────────────────────────────────────

export function UsersView({ onBack }: UsersViewProps) {
  const [users,    setUsers]    = useState<UserProfile[]>([]);
  const [loading,  setLoading]  = useState(true);
  const [selected, setSelected] = useState<UserProfile | null>(null);
  const [query,    setQuery]    = useState("");

  const load = async () => {
    setLoading(true);
    const data = await getUsersTraceability("todos");
    setUsers(data);
    if (data.length > 0 && !selected) setSelected(data[0]);
    setLoading(false);
  };

  useEffect(() => { load(); }, []);   // eslint-disable-line

  const filtered = useMemo(() => {
    const q = query.toLowerCase();
    if (!q) return users;
    return users.filter(u =>
      u.email.toLowerCase().includes(q) ||
      u.name.toLowerCase().includes(q) ||
      u.planName.toLowerCase().includes(q)
    );
  }, [users, query]);

  const score = selected ? retentionScore(selected) : 0;
  const risk  = riskLabel(score);

  /* ── Styles ── */
  const shell: React.CSSProperties = {
    display: "grid",
    gridTemplateColumns: "280px 1fr 360px",
    gridTemplateRows: "52px 1fr",
    height: "100vh",
    background: C.bg,
    fontFamily: FONT,
    overflow: "hidden",
  };

  /* ── TOPBAR ── */
  const topbar = (
    <header style={{
      gridColumn: "1/-1",
      display: "flex", alignItems: "center", justifyContent: "space-between",
      padding: "0 20px",
      borderBottom: `1px solid ${C.border}`,
      background: C.nav,
      zIndex: 10,
    }}>
      <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
        <button onClick={onBack} style={{
          background: "none", border: "none", color: C.mutedLight,
          display: "flex", alignItems: "center", gap: 5, fontSize: 12,
          cursor: "pointer", padding: "6px 10px", borderRadius: 8,
        }}>
          <ArrowLeft size={14} /> Dashboard
        </button>
        <span style={{ color: C.border }}>›</span>
        <span style={{ fontSize: 13, fontWeight: 700, color: C.orange }}>Trazabilidad de Usuarios</span>
      </div>
      <div style={{ display: "flex", alignItems: "center", gap: 16, fontSize: 11, color: C.mutedMid }}>
        <span>Activos: <strong style={{ color: C.green }}>{users.filter(u => u.status === "active").length}</strong></span>
        <span>LTV prom: <strong style={{ color: C.orange }}>{fmtUSD(users.reduce((s,u)=>s+u.ltv,0)/(users.length||1))}</strong></span>
        <span>Total: <strong style={{ color: C.white }}>{users.length}</strong></span>
        <button onClick={load} disabled={loading} style={{ background: "none", border: "none", color: C.mutedMid, cursor: loading?"not-allowed":"pointer", display:"flex",alignItems:"center" }}>
          <RefreshCw size={13} style={{ animation: loading ? "spin 0.8s linear infinite" : "none" }} />
        </button>
      </div>
    </header>
  );

  /* ── LEFT: User list ── */
  const leftPanel = (
    <aside style={{
      borderRight: `1px solid ${C.border}`,
      background: C.sidebar,
      display: "flex", flexDirection: "column",
      overflowY: "hidden",
    }}>
      {/* Search */}
      <div style={{ padding: 10, borderBottom: `1px solid rgba(255,255,255,0.05)`, position: "sticky", top: 0, background: C.sidebar, zIndex: 2 }}>
        <div style={{ position: "relative" }}>
          <Search size={13} style={{ position: "absolute", left: 10, top: "50%", transform: "translateY(-50%)", color: C.muted }} />
          <input
            value={query}
            onChange={e => setQuery(e.target.value)}
            placeholder="Buscar por nombre, email…"
            style={{
              width: "100%", background: "rgba(255,255,255,0.05)",
              border: `1px solid ${C.border}`, borderRadius: 8,
              padding: "7px 10px 7px 30px", fontSize: 12, color: C.white,
              outline: "none", fontFamily: FONT, boxSizing: "border-box",
            }}
          />
        </div>
      </div>

      {/* Header */}
      <div style={{ padding: "6px 14px", borderBottom: `1px solid rgba(255,255,255,0.04)`, display:"flex", justifyContent:"space-between", fontSize:9, letterSpacing:"1.2px", color:C.muted, textTransform:"uppercase" }}>
        <span>Usuario</span><span>LTV</span>
      </div>

      {/* List */}
      <div style={{ overflowY: "auto", flex: 1 }}>
        {loading ? (
          <div style={{ textAlign: "center", padding: "40px 0", color: C.muted }}>
            <Loader2 size={18} style={{ animation: "spin 0.8s linear infinite" }} />
          </div>
        ) : filtered.length === 0 ? (
          <div style={{ textAlign: "center", padding: "40px 16px", color: C.muted, fontSize: 12 }}>Sin resultados</div>
        ) : filtered.map(u => {
          const isActive = selected?.email === u.email;
          return (
            <div key={u.email} onClick={() => setSelected(u)} style={{
              padding: "10px 14px",
              borderBottom: `1px solid rgba(255,255,255,0.025)`,
              cursor: "pointer",
              borderLeft: isActive ? `2px solid ${C.orange}` : "2px solid transparent",
              background: isActive ? "rgba(255,107,44,0.07)" : "transparent",
              transition: "background 0.12s",
            }}>
              <div style={{ display:"flex", justifyContent:"space-between", alignItems:"flex-start", marginBottom:3 }}>
                <span style={{ fontSize:12, fontWeight:600, color:C.white, overflow:"hidden", textOverflow:"ellipsis", whiteSpace:"nowrap", maxWidth:160 }}>{u.name !== "—" ? u.name : u.email.split("@")[0]}</span>
                <span style={{ fontSize:10, fontWeight:700, color:C.orange, flexShrink:0, marginLeft:6 }}>{fmtUSD(u.ltv)}</span>
              </div>
              <div style={{ fontSize:10, color:C.mutedMid, marginBottom:4, overflow:"hidden", textOverflow:"ellipsis", whiteSpace:"nowrap" }}>{u.email}</div>
              <div style={{ display:"flex", gap:5, alignItems:"center", flexWrap:"wrap" }}>
                {statusBadge(u.status)}
                <span style={{ fontSize:9, color:C.muted }}>{flag(u.country)} {u.country !== "—" ? u.country : ""}</span>
              </div>
            </div>
          );
        })}
      </div>
    </aside>
  );

  /* ── MIDDLE: Profile detail ── */
  const mainPanel = !selected ? (
    <main style={{ display:"flex", alignItems:"center", justifyContent:"center", color:C.muted, fontSize:13 }}>
      Selecciona un usuario para ver su perfil
    </main>
  ) : (
    <main style={{ overflowY: "auto", padding: 20, display:"flex", flexDirection:"column", gap:16, background:C.bg }}>

      {/* Profile Header */}
      <div style={{
        background: `linear-gradient(135deg, rgba(255,107,44,0.1) 0%, ${C.card} 60%)`,
        border: `1px solid ${C.border}`,
        borderRadius: 16, padding: "20px 22px",
        position: "relative", overflow: "hidden",
      }}>
        <div style={{ display:"flex", justifyContent:"space-between", alignItems:"flex-start", marginBottom:14, flexWrap:"wrap", gap:10 }}>
          <div style={{ display:"flex", alignItems:"center", gap:12 }}>
            <div style={{
              width:44, height:44, borderRadius:12,
              background: `linear-gradient(135deg, ${C.orange} 0%, #FF3366 100%)`,
              display:"flex", alignItems:"center", justifyContent:"center",
              fontSize:17, fontWeight:900, color:"#fff", flexShrink:0,
            }}>
              {initials(selected.name !== "—" ? selected.name : selected.email)}
            </div>
            <div>
              <div style={{ fontSize:17, fontWeight:800, color:C.white, lineHeight:1.2 }}>
                {selected.name !== "—" ? selected.name : <span style={{ color:C.mutedMid, fontStyle:"italic" }}>Sin nombre</span>}
              </div>
              <div style={{ fontFamily:"monospace", fontSize:11, color:C.mutedMid, marginTop:2 }}>{selected.email}</div>
            </div>
          </div>
          <div style={{ display:"flex", gap:6 }}>
            {statusBadge(selected.status)}
          </div>
        </div>

        <div style={{ display:"flex", gap:18, flexWrap:"wrap" }}>
          {[
            { icon: <MapPin size={12}/>,     val: `${flag(selected.country)} ${selected.country !== "—" ? selected.country : "Sin país"}`, lbl:"País" },
            { icon: <Radio size={12}/>,       val: selected.channel,            lbl:"Canal" },
            { icon: <Calendar size={12}/>,    val: fmtDate(selected.firstPurchaseDate), lbl:"Primera compra" },
            { icon: <TrendingUp size={12}/>,  val: `${selected.renewalsCount} renovaciones`, lbl:"Retención" },
          ].map(({ icon, val, lbl }) => (
            <div key={lbl} style={{ display:"flex", alignItems:"center", gap:6 }}>
              <span style={{ color:C.mutedMid }}>{icon}</span>
              <div>
                <div style={{ fontSize:11, color:C.white, fontWeight:500 }}>{val}</div>
                <div style={{ fontSize:10, color:C.muted }}>{lbl}</div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Stats Row */}
      <div style={{ display:"grid", gridTemplateColumns:"repeat(4,1fr)", gap:10 }}>
        {[
          { label:"LTV Total",       value:fmtUSD(selected.ltv),    color:C.orange, sub:`${selected.transactions.filter(t=>t.status==="active").length} pagos` },
          { label:"Días activo",     value:selected.daysActive,     color:C.green,  sub:fmtDate(selected.firstPurchaseDate) },
          { label:"Plan actual",     value:selected.planName.split(" ").slice(0,2).join(" "), color:C.white, sub:`${fmtUSD(selected.amountUsd)}/mes` },
          { label:"Último pago",     value:fmtDate(selected.lastPurchaseDate), color:C.blue, sub:`hace ${Math.max(0,Math.floor((Date.now()-new Date(selected.lastPurchaseDate).getTime())/(86400000)))}d` },
        ].map(({ label, value, color, sub }) => (
          <div key={label} style={{ background:C.card, border:`1px solid ${C.border}`, borderRadius:12, padding:"14px 16px" }}>
            <div style={{ fontFamily:"monospace", fontSize:9, letterSpacing:"1px", color:C.muted, textTransform:"uppercase", marginBottom:8 }}>{label}</div>
            <div style={{ fontSize:22, fontWeight:800, color, lineHeight:1 }}>{value}</div>
            <div style={{ fontSize:10, color:C.muted, marginTop:5 }}>{sub}</div>
          </div>
        ))}
      </div>

      {/* Historial de pagos */}
      <div style={{ background:C.card, border:`1px solid ${C.border}`, borderRadius:12, overflow:"hidden" }}>
        <div style={{ padding:"12px 16px", borderBottom:`1px solid ${C.border}`, display:"flex", justifyContent:"space-between", alignItems:"center" }}>
          <span style={{ fontFamily:"monospace", fontSize:10, letterSpacing:"1px", color:C.mutedMid, textTransform:"uppercase" }}>● Historial de pagos</span>
          <span style={{ fontFamily:"monospace", fontSize:9, color:C.muted }}>{selected.transactions.length} transacciones</span>
        </div>
        <div style={{ padding:16 }}>
          {selected.transactions.length === 0 ? (
            <p style={{ fontSize:12, color:C.muted }}>Sin transacciones registradas.</p>
          ) : (
            <div style={{ display:"flex", flexDirection:"column", gap:0 }}>
              {selected.transactions.slice(0, 8).map((tx, i) => {
                const dot = txDot(tx.status);
                const isLast = i === Math.min(selected.transactions.length, 8) - 1;
                return (
                  <div key={tx.id} style={{ display:"flex", gap:12, paddingBottom: isLast ? 0 : 14 }}>
                    <div style={{ display:"flex", flexDirection:"column", alignItems:"center", flexShrink:0, width:20 }}>
                      <div style={{ width:8, height:8, borderRadius:"50%", background:dot.color, boxShadow:`0 0 6px ${dot.color}`, marginTop:3, flexShrink:0 }} />
                      {!isLast && <div style={{ width:1, flex:1, background:`${C.border}`, marginTop:4 }} />}
                    </div>
                    <div style={{ flex:1 }}>
                      <div style={{ fontSize:12, color:C.white, fontWeight:500 }}>
                        {tx.status === "active" ? (i === selected.transactions.length - 1 ? "Primera compra" : "Renovación mensual") :
                         tx.status === "refunded" ? "Reembolso" :
                         tx.status === "chargeback" ? "Chargeback" :
                         tx.status === "delayed" ? "Pago retrasado" : tx.eventType}
                        {" — "}{tx.planName}
                      </div>
                      <div style={{ display:"flex", justifyContent:"space-between", marginTop:2 }}>
                        <span style={{ fontFamily:"monospace", fontSize:10, color:C.muted }}>{fmtDate(tx.createdAt)}</span>
                        <span style={{ fontFamily:"monospace", fontSize:10, color: tx.status==="active"||tx.status==="delayed" ? C.green : C.red }}>
                          {tx.status==="refunded"||tx.status==="chargeback" ? "-" : "+"}{fmtUSD(tx.amountUsd)}
                        </span>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>

    </main>
  );

  /* ── RIGHT: Metrics panel ── */
  const rightPanel = !selected ? null : (
    <aside style={{ borderLeft:`1px solid ${C.border}`, background:C.sidebar, overflowY:"auto", padding:"18px 14px", display:"flex", flexDirection:"column", gap:14 }}>

      {/* LTV Hero */}
      <div>
        <div style={{ fontFamily:"monospace", fontSize:9, letterSpacing:"1.5px", color:C.muted, textTransform:"uppercase", marginBottom:8 }}>Lifetime Value</div>
        <div style={{
          background: C.gradFinance,
          border: `1px solid rgba(255,107,44,0.45)`,
          borderRadius:14, padding:16, textAlign:"center", position:"relative", overflow:"hidden",
          boxShadow: "0 0 25px rgba(255,107,44,0.12), 0 8px 24px rgba(0,0,0,0.3)",
        }}>
          <div style={{ fontSize:9, fontWeight:600, letterSpacing:"0.12em", color:C.orange, textTransform:"uppercase", marginBottom:8 }}>LTV Acumulado</div>
          <div style={{ fontSize:38, fontWeight:900, color:C.orange, lineHeight:1, letterSpacing:"-0.03em" }}>{fmtUSD(selected.ltv)}</div>
          <div style={{ fontSize:11, color:C.mutedMid, marginTop:8 }}>
            {fmtUSD(selected.amountUsd)} × {selected.transactions.filter(t=>t.status==="active").length} pagos
          </div>
        </div>
      </div>

      {/* Mini stats */}
      <div>
        <div style={{ fontFamily:"monospace", fontSize:9, letterSpacing:"1.5px", color:C.muted, textTransform:"uppercase", marginBottom:8 }}>Métricas Clave</div>
        <div style={{ display:"grid", gridTemplateColumns:"1fr 1fr", gap:7 }}>
          {[
            { label:"Renovaciones", val:selected.renewalsCount,           color:C.green,  sub:`de ${selected.transactions.filter(t=>t.status==="active").length} cobros` },
            { label:"Último pago",  val:fmtDate(selected.lastPurchaseDate).split(" ").slice(0,2).join(" "), color:C.blue, sub:`hace ${Math.max(0,Math.floor((Date.now()-new Date(selected.lastPurchaseDate).getTime())/(86400000)))}d` },
            { label:"Días activo",  val:selected.daysActive,              color:C.orange, sub:"días totales" },
            { label:"Canal",        val:selected.channel.split(" ")[0],   color:"#5B9EFF", sub:selected.channel },
          ].map(({ label, val, color, sub }) => (
            <div key={label} style={{ background:"rgba(255,255,255,0.03)", border:`1px solid ${C.border}`, borderRadius:10, padding:11 }}>
              <div style={{ fontFamily:"monospace", fontSize:9, color:C.muted, textTransform:"uppercase", letterSpacing:"0.8px", marginBottom:5 }}>{label}</div>
              <div style={{ fontSize:17, fontWeight:700, color }}>{val}</div>
              <div style={{ fontSize:10, color:C.muted, marginTop:3 }}>{sub}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Retention Risk */}
      <div>
        <div style={{ fontFamily:"monospace", fontSize:9, letterSpacing:"1.5px", color:C.muted, textTransform:"uppercase", marginBottom:8 }}>Riesgo de Cancelación</div>
        <div style={{ background:"rgba(255,255,255,0.03)", border:`1px solid ${C.border}`, borderRadius:12, padding:13 }}>
          <div style={{ display:"flex", justifyContent:"space-between", alignItems:"center", marginBottom:8 }}>
            <span style={{ fontFamily:"monospace", fontSize:9, color:C.muted, textTransform:"uppercase", letterSpacing:"0.8px" }}>Score retención</span>
            <span style={{ fontSize:20, fontWeight:800, color:risk.color }}>{score}</span>
          </div>
          <div style={{ height:6, background:"rgba(255,255,255,0.06)", borderRadius:3, marginBottom:8, overflow:"hidden" }}>
            <div style={{ height:"100%", width:`${score}%`, borderRadius:3, background:C.gradRetention, transition:"width 0.6s" }} />
          </div>
          <div style={{ fontSize:10, color:C.muted }}>Estado: <span style={{ color:risk.color, fontWeight:500 }}>{risk.txt}</span></div>
        </div>
      </div>

      {/* Divider */}
      <div style={{ height:1, background:C.border }} />

      {/* Status visual */}
      <div>
        <div style={{ fontFamily:"monospace", fontSize:9, letterSpacing:"1.5px", color:C.muted, textTransform:"uppercase", marginBottom:8 }}>Estado Actual</div>
        <div style={{ display:"flex", flexDirection:"column", gap:7 }}>
          {[
            { icon:<CheckCircle2 size={12}/>,  label:"Suscripción activa",    ok: selected.status === "active" },
            { icon:<AlertTriangle size={12}/>,  label:"Pagos al día",          ok: selected.status !== "delayed" },
            { icon:<XCircle size={12}/>,        label:"No cancelado",          ok: selected.status !== "cancelled" },
            { icon:<Clock size={12}/>,          label:`${selected.renewalsCount}+ renovaciones`, ok: selected.renewalsCount >= 1 },
          ].map(({ icon, label, ok }) => (
            <div key={label} style={{ display:"flex", alignItems:"center", gap:8 }}>
              <span style={{ color: ok ? C.green : C.red, display:"flex" }}>{icon}</span>
              <span style={{ fontSize:11, color: ok ? C.mutedLight : C.muted }}>{label}</span>
            </div>
          ))}
        </div>
      </div>

    </aside>
  );

  return (
    <div style={shell}>
      {topbar}
      {leftPanel}
      {mainPanel}
      {rightPanel ?? <aside style={{ borderLeft:`1px solid ${C.border}`, background:C.sidebar }} />}
      <style>{`@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`}</style>
    </div>
  );
}
