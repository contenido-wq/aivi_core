import { useState, useEffect, useMemo }  from "react";
import { ArrowLeft, Search, RefreshCw, Loader2, TrendingUp, Calendar, MapPin, Radio, CheckCircle2, XCircle, Clock, AlertTriangle, Mail, Phone } from "lucide-react";
import { C, FONT }                       from "../tokens";
import { getUsersTraceability, getProductFamily } from "../services/dashboard";
import type { UserProfile, ProductFilter } from "../services/dashboard";
import { useResponsive }                  from "../hooks/useResponsive";
import { MobileBottomNav }               from "../components/layout/MobileBottomNav";

interface UsersViewProps {
  onBack:          () => void;
  onDashboard?:    () => void;
  onTransactions?: () => void;
}

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

function daysAgo(iso: string) {
  if (!iso) return 0;
  return Math.max(0, Math.floor((Date.now() - new Date(iso).getTime()) / 86400000));
}

function statusBadge(s: UserProfile["status"]) {
  const map = {
    active:    { label: "Activo",    bg: "rgba(254,128,63,0.12)",  border: "rgba(254,128,63,0.30)",  color: "#FE803F" },
    cancelled: { label: "Cancelado", bg: "rgba(255,65,59,0.12)",   border: "rgba(255,65,59,0.30)",  color: "#FF413B" },
    delayed:   { label: "Retrasado", bg: "rgba(255,194,82,0.12)",  border: "rgba(255,194,82,0.30)", color: "#FFC252" },
    trial:     { label: "Trial",     bg: "rgba(255,194,82,0.12)",  border: "rgba(255,194,82,0.30)", color: "#FFC252" },
  };
  const m = map[s] ?? map.cancelled;
  return (
    <span style={{
      fontSize: 9, fontWeight: 700, letterSpacing: "0.06em", textTransform: "uppercase",
      padding: "2px 8px", borderRadius: 4,
      background: m.bg, border: `1px solid ${m.border}`, color: m.color,
    }}>{m.label}</span>
  );
}

function txLabel(status: string, isFirst: boolean): string {
  if (isFirst)              return "Primera compra";
  if (status === "active")  return "Renovación";
  if (status === "refunded")  return "Reembolso";
  if (status === "chargeback") return "Chargeback";
  if (status === "delayed")   return "Pago retrasado";
  return "Transacción";
}

function txColor(status: string) {
  if (status === "active")                          return C.green;
  if (status === "refunded" || status === "chargeback") return C.red;
  if (status === "delayed")                         return C.yellow;
  return C.mutedMid;
}

function retentionScore(u: UserProfile): number {
  if (u.status === "cancelled") return 20;
  if (u.status === "delayed")   return 40;
  if (u.renewalsCount >= 12) return 99;
  if (u.renewalsCount >= 6)  return 95;
  if (u.renewalsCount >= 3)  return 80;
  if (u.renewalsCount >= 1)  return 65;
  return 50;
}

function riskLabel(score: number) {
  if (score >= 80) return { txt: "Bajo — cliente fidelizado",    color: C.green };
  if (score >= 55) return { txt: "Medio — mantener seguimiento", color: C.yellow };
  return           { txt: "Alto — riesgo de cancelación",        color: C.red };
}

interface FamilySummary {
  family:   string;
  count:    number;    // compras activas o delayed
  isActive: boolean;   // es el plan de suscripción actual del usuario
  isRepeat: boolean;   // count >= 2
}

function getProductFamilySummary(
  transactions: { planName: string; status: string }[],
  currentPlanName: string
): FamilySummary[] {
  const map: Record<string, number> = {};
  for (const tx of transactions) {
    if (tx.status !== "active" && tx.status !== "delayed") continue;
    const fam = getProductFamily(tx.planName);
    map[fam] = (map[fam] ?? 0) + 1;
  }
  const activeFamily = getProductFamily(currentPlanName);
  return Object.entries(map)
    .map(([family, count]) => ({
      family,
      count,
      isActive: family === activeFamily,
      isRepeat: count >= 2,
    }))
    .sort((a, b) => {
      if (a.family === "AIVI") return -1;
      if (b.family === "AIVI") return 1;
      return b.count - a.count;
    });
}

// Used in the user list to badge all users — cheaper than full summary since we don't need isActive per row
function countFamilies(transactions: { planName: string; status: string }[]): number {
  const set = new Set<string>();
  for (const tx of transactions) {
    if (tx.status !== "active" && tx.status !== "delayed") continue;
    set.add(getProductFamily(tx.planName));
  }
  return set.size;
}

function computeProspectingScore(
  user: UserProfile,
  families: FamilySummary[]
): number {
  const hasAIVI = families.some(f => f.family === "AIVI");
  if (hasAIVI) return -1; // -1 = señal de "ya es cliente AIVI"

  let score = 0;
  if (families.length >= 1)                              score += 30;
  if (families.some(f => f.family === "Método V3"))      score += 20;
  if (families.length >= 3)                              score += 15;
  else if (families.length >= 2)                         score += 10;
  if (families.some(f => f.isRepeat))                    score += 15;
  if (user.status === "active")                          score += 10;
  if (user.ltv >= 500)                                   score += 10;
  else if (user.ltv >= 300)                              score += 5;
  if (user.daysActive >= 90)                             score += 5;
  return Math.min(100, score);
}

function getProspectingReasons(user: UserProfile, families: FamilySummary[]): string[] {
  if (families.some(f => f.family === "AIVI")) return [];
  const reasons: string[] = [];
  reasons.push("Sin AIVI todavía — oportunidad directa de upsell");

  if (families.some(f => f.family === "Método V3" && f.isActive))
    reasons.push("Tiene Método V3 activo — ya conoce el ecosistema");

  if (families.length >= 2)
    reasons.push(`Ha comprado ${families.length} productos distintos — confía en la marca`);

  const repeatFam = families.find(f => f.isRepeat);
  if (repeatFam)
    reasons.push(`Ha renovado ${repeatFam.family} ×${repeatFam.count} — disposición de pago probada`);

  if (user.daysActive >= 30)
    reasons.push(`Lleva ${user.daysActive} días en el ecosistema — relación establecida`);

  if (user.ltv >= 300)
    reasons.push(`LTV de $${user.ltv.toFixed(0)} — cliente de alto valor`);

  if (user.status === "active")
    reasons.push("Suscripción activa — momento ideal para upsell");

  return reasons;
}

function prospectScoreLabel(score: number): { txt: string; color: string } {
  if (score >= 80) return { txt: "🔥 Listo para comprar", color: C.green  };
  if (score >= 55) return { txt: "Buen prospecto",        color: C.orange };
  if (score >= 30) return { txt: "Calentar primero",      color: C.yellow };
  return             { txt: "No priorizar",               color: C.muted  };
}

const PROGRAM_FILTERS: { value: ProductFilter; label: string }[] = [
  { value: "todos",         label: "Todos"          },
  { value: "AIVI",          label: "AIVI"           },
  { value: "MV3",           label: "MV3"            },
  { value: "Reto15D",       label: "Reto 15D"       },
  { value: "sinAIVI",       label: "Sin AIVI"       },
  { value: "multiProducto", label: "Multi-producto" },
];

function cleanPhone(raw: string): string {
  return raw.replace(/[\s+\-().]/g, "");
}

// ─────────────────────────────────────────────────────────────────────────────

export function UsersView({ onBack, onDashboard, onTransactions }: UsersViewProps) {
  const [users,         setUsers]         = useState<UserProfile[]>([]);
  const [loading,       setLoading]       = useState(true);
  const [selected,      setSelected]      = useState<UserProfile | null>(null);
  const [query,         setQuery]         = useState("");
  const [programFilter, setProgramFilter] = useState<ProductFilter>("todos");
  const [statusFilter,  setStatusFilter]  = useState<"todos" | UserProfile["status"]>("todos");
  const [mobileView,    setMobileView]    = useState<"list" | "detail">("list");

  const { isMobile, isLarge, isXLarge } = useResponsive();

  const load = async (pf: ProductFilter) => {
    setLoading(true);
    setSelected(null);
    const data = await getUsersTraceability(pf);
    setUsers(data);
    if (pf !== "multiProducto" && data.length > 0) setSelected(data[0]);
    setLoading(false);
  };

  useEffect(() => { load(programFilter); }, [programFilter]); // eslint-disable-line

  const familyCounts = useMemo(
    () => new Map(users.map(u => [u.email, countFamilies(u.transactions)])),
    [users]
  );

  const filtered = useMemo(() => {
    let list = users;

    if (programFilter === "multiProducto") {
      list = list
        .filter(u => (familyCounts.get(u.email) ?? 0) >= 2)
        .sort((a, b) => (familyCounts.get(b.email) ?? 0) - (familyCounts.get(a.email) ?? 0));
    }

    if (statusFilter !== "todos") list = list.filter(u => u.status === statusFilter);
    const q = query.toLowerCase();
    if (!q) return list;
    return list.filter(u =>
      u.email.toLowerCase().includes(q) ||
      u.name.toLowerCase().includes(q) ||
      u.planName.toLowerCase().includes(q)
    );
  }, [users, query, statusFilter, programFilter, familyCounts]);

  const score = selected ? retentionScore(selected) : 0;
  const risk  = riskLabel(score);

  const familySummary: FamilySummary[] = selected
    ? getProductFamilySummary(selected.transactions, selected.planName)
    : [];
  const hasAIVI = familySummary.some(f => f.family === "AIVI");

  const prospectScore   = selected ? computeProspectingScore(selected, familySummary) : 0;
  const prospectReasons = selected && prospectScore >= 0 ? getProspectingReasons(selected, familySummary) : [];
  const prospectLabel   = prospectScore >= 0 ? prospectScoreLabel(prospectScore) : { txt: "", color: "" };

  // Transacciones ordenadas de más antigua a más nueva (para identificar "primera compra")
  const txsSorted = selected
    ? [...selected.transactions].sort((a, b) => new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime())
    : [];
  const firstTxId = txsSorted[0]?.id;

  const activePays = selected?.transactions.filter(t => t.status === "active" || t.status === "delayed").length ?? 0;
  const avgPerPay  = activePays > 0 ? (selected?.ltv ?? 0) / activePays : 0;

  /* ── Topbar stats (refleja el filtro activo) ── */
  const activeCount     = users.filter(u => u.status === "active").length;
  const ltvSum          = users.reduce((s, u) => s + u.ltv, 0);
  const ltvProm         = users.length > 0 ? ltvSum / users.length : 0;


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
        {isMobile && mobileView === "detail" && (
          <button onClick={() => setMobileView("list")} style={{
            background: "none", border: "none", color: C.mutedLight,
            display: "flex", alignItems: "center", gap: 5, fontSize: 12,
            cursor: "pointer", padding: "6px 10px", borderRadius: 8,
          }}>
            <ArrowLeft size={14} /> Lista
          </button>
        )}
        <button onClick={onBack} style={{
          background: "none", border: "none", color: C.mutedLight,
          display: "flex", alignItems: "center", gap: 5, fontSize: 12,
          cursor: "pointer", padding: "6px 10px", borderRadius: 8,
        }}>
          <ArrowLeft size={14} /> Dashboard
        </button>
        <span style={{ color: C.border }}>›</span>
        <span style={{ fontSize: 13, fontWeight: 700, color: C.orange }}>Trazabilidad de Usuarios</span>
        {programFilter !== "todos" && (
          <span style={{ fontSize: 10, fontWeight: 700, color: C.orange, background: "rgba(254,128,63,0.12)", border: "1px solid rgba(254,128,63,0.3)", borderRadius: 4, padding: "1px 7px" }}>
            {PROGRAM_FILTERS.find(f => f.value === programFilter)?.label ?? programFilter}
          </span>
        )}
      </div>
      <div style={{ display: "flex", alignItems: "center", gap: 20, fontSize: 11, color: C.mutedMid }}>
        <span>Activos: <strong style={{ color: C.green }}>{activeCount}</strong></span>
        <span>LTV prom: <strong style={{ color: C.orange }}>{fmtUSD(ltvProm)}</strong></span>
        <span>Total: <strong style={{ color: C.white }}>{users.length}</strong></span>
        <button onClick={() => load(programFilter)} disabled={loading} style={{
          background: "none", border: "none", color: C.mutedMid,
          cursor: loading ? "not-allowed" : "pointer", display: "flex", alignItems: "center",
        }}>
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
      {/* Program filter tabs */}
      <div style={{ padding: "8px 10px", borderBottom: `1px solid rgba(255,255,255,0.05)`, display: "flex", gap: 4 }}>
        {PROGRAM_FILTERS.map(f => (
          <button key={f.value} onClick={() => setProgramFilter(f.value)} style={{
            flex: 1, padding: "5px 0", borderRadius: 6, fontSize: 11, fontWeight: 700,
            border: `1px solid ${programFilter === f.value ? "rgba(254,128,63,0.35)" : C.border}`,
            background: programFilter === f.value ? "rgba(254,128,63,0.12)" : "transparent",
            color: programFilter === f.value ? C.orange : C.mutedMid,
            cursor: "pointer", transition: "all 0.12s", fontFamily: FONT,
          }}>{f.label}</button>
        ))}
      </div>

      {/* Status filter */}
      <div style={{ padding: "6px 10px", borderBottom: `1px solid rgba(255,255,255,0.04)`, display: "flex", gap: 3, overflowX: "auto" }}>
        {(["todos","active","delayed","cancelled"] as const).map(s => {
          const labels = { todos: "Todos", active: "Activos", delayed: "Retrasados", cancelled: "Cancelados" };
          const colors = { todos: C.mutedMid, active: C.green, delayed: C.yellow, cancelled: C.red };
          const active = statusFilter === s;
          return (
            <button key={s} onClick={() => setStatusFilter(s)} style={{
              padding: "3px 8px", borderRadius: 4, fontSize: 9, fontWeight: 700,
              border: `1px solid ${active ? colors[s]+"55" : "transparent"}`,
              background: active ? colors[s]+"15" : "transparent",
              color: active ? colors[s] : C.muted,
              cursor: "pointer", whiteSpace: "nowrap", fontFamily: FONT, letterSpacing: "0.04em",
            }}>{labels[s]}</button>
          );
        })}
      </div>

      {/* Search */}
      <div style={{ padding: "8px 10px", borderBottom: `1px solid rgba(255,255,255,0.04)` }}>
        <div style={{ position: "relative" }}>
          <Search size={12} style={{ position: "absolute", left: 9, top: "50%", transform: "translateY(-50%)", color: C.muted }} />
          <input
            value={query}
            onChange={e => setQuery(e.target.value)}
            placeholder="Buscar nombre, email, plan…"
            style={{
              width: "100%", background: "rgba(255,255,255,0.04)",
              border: `1px solid ${C.border}`, borderRadius: 7,
              padding: "6px 8px 6px 28px", fontSize: 12, color: C.white,
              outline: "none", fontFamily: FONT, boxSizing: "border-box",
            }}
          />
        </div>
      </div>

      {/* Column headers */}
      <div style={{ padding: "5px 14px", borderBottom: `1px solid rgba(255,255,255,0.04)`, display: "flex", justifyContent: "space-between", fontSize: 9, letterSpacing: "0.1em", color: C.muted, textTransform: "uppercase" }}>
        <span>Usuario</span><span>LTV</span>
      </div>

      {/* List */}
      <div style={{ overflowY: "auto", flex: 1, paddingBottom: isMobile ? 64 : 0 }}>
        {loading ? (
          <div style={{ textAlign: "center", padding: "40px 0", color: C.muted }}>
            <Loader2 size={18} style={{ animation: "spin 0.8s linear infinite" }} />
          </div>
        ) : filtered.length === 0 ? (
          <div style={{ textAlign: "center", padding: "40px 16px", color: C.muted, fontSize: 12 }}>Sin resultados</div>
        ) : filtered.map(u => {
          const isSel = selected?.email === u.email;
          return (
            <div key={u.email} onClick={() => { setSelected(u); if (isMobile) setMobileView("detail"); }} style={{
              padding: "9px 14px",
              borderBottom: `1px solid rgba(255,255,255,0.025)`,
              cursor: "pointer",
              borderLeft: isSel ? `2px solid ${C.orange}` : "2px solid transparent",
              background: isSel ? "rgba(254,128,63,0.07)" : "transparent",
              transition: "background 0.1s",
            }}>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 2 }}>
                <span style={{ fontSize: 12, fontWeight: 600, color: C.white, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap", maxWidth: 155 }}>
                  {u.name !== "—" ? u.name : u.email.split("@")[0]}
                </span>
                <span style={{ fontSize: 10, fontWeight: 700, color: C.orange, flexShrink: 0, marginLeft: 6 }}>{fmtUSD(u.ltv)}</span>
              </div>
              <div style={{ fontSize: 10, color: C.mutedMid, marginBottom: 4, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{u.email}</div>
              <div style={{ display: "flex", gap: 5, alignItems: "center" }}>
                {statusBadge(u.status)}
                <span style={{ fontSize: 9, color: C.label }}>
                  {flag(u.country)} {u.country !== "—" ? u.country : ""}
                </span>
                {(familyCounts.get(u.email) ?? 0) >= 2 && (
                  <span style={{
                    fontSize: 9, fontWeight: 700,
                    color: C.orange, background: "rgba(254,128,63,0.12)",
                    border: "1px solid rgba(254,128,63,0.25)",
                    borderRadius: 4, padding: "1px 5px",
                  }}>
                    {familyCounts.get(u.email)}⬡
                  </span>
                )}
              </div>
            </div>
          );
        })}
      </div>
    </aside>
  );

  /* ── MIDDLE: Profile detail ── */
  const mainPanel = !selected ? (
    <main style={{ display: "flex", alignItems: "center", justifyContent: "center", color: C.muted, fontSize: 13, background: C.bg }}>
      Selecciona un usuario
    </main>
  ) : (
    <main style={{ overflowY: "auto", padding: 20, paddingBottom: isMobile ? 84 : 20, display: "flex", flexDirection: "column", gap: 14, background: C.bg }}>

      {/* Profile Header */}
      <div style={{
        background: `linear-gradient(135deg, rgba(254,128,63,0.08) 0%, ${C.card} 55%)`,
        border: `1px solid ${C.border}`,
        borderRadius: 14, padding: "18px 20px",
      }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 14, flexWrap: "wrap", gap: 10 }}>
          <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
            <div style={{
              width: 42, height: 42, borderRadius: 11,
              background: `linear-gradient(135deg, ${C.orange} 0%, #FF3366 100%)`,
              display: "flex", alignItems: "center", justifyContent: "center",
              fontSize: 16, fontWeight: 900, color: "#fff", flexShrink: 0,
            }}>
              {initials(selected.name !== "—" ? selected.name : selected.email)}
            </div>
            <div>
              <div style={{ fontSize: 16, fontWeight: 800, color: C.white, lineHeight: 1.2 }}>
                {selected.name !== "—" ? selected.name : <span style={{ color: C.mutedMid, fontStyle: "italic" }}>Sin nombre</span>}
              </div>
              <div style={{ fontSize: 11, color: C.mutedMid, marginTop: 2 }}>{selected.email}</div>
            </div>
          </div>
          {statusBadge(selected.status)}
        </div>

        {/* Info row — 3 datos: Canal, Primera compra, Programa */}
        <div style={{ display: "flex", gap: 20, flexWrap: "wrap", marginBottom: 10 }}>
          {[
            { icon: <Radio size={11}/>,      val: selected.channel,                    lbl: "Canal"          },
            { icon: <Calendar size={11}/>,   val: fmtDate(selected.firstPurchaseDate),  lbl: "Primera compra" },
            { icon: <TrendingUp size={11}/>, val: selected.planName || "—",             lbl: "Programa"       },
          ].map(({ icon, val, lbl }) => (
            <div key={lbl} style={{ display: "flex", alignItems: "center", gap: 6 }}>
              <span style={{ color: C.label }}>{icon}</span>
              <div>
                <div style={{ fontSize: 11, color: C.white, fontWeight: 500 }}>{val}</div>
                <div style={{ fontSize: 10, color: C.muted }}>{lbl}</div>
              </div>
            </div>
          ))}
        </div>

        {/* Contacto row — accionable */}
        <div style={{ display: "flex", gap: 7, flexWrap: "wrap" }}>
          <a href={`mailto:${selected.email}`}
            style={{ display:"flex", alignItems:"center", gap:5, padding:"4px 10px", borderRadius:6, background:"rgba(255,255,255,0.05)", border:`1px solid ${C.border}`, color:C.white, textDecoration:"none", fontSize:11, cursor:"pointer" }}>
            <Mail size={11} style={{ color: C.orange, flexShrink: 0 }} />
            <span style={{ overflow:"hidden", textOverflow:"ellipsis", whiteSpace:"nowrap", maxWidth:180 }}>{selected.email}</span>
          </a>
          {selected.phone && (
            <a href={`https://wa.me/${cleanPhone(selected.phone)}`} target="_blank" rel="noopener noreferrer"
              style={{ display:"flex", alignItems:"center", gap:5, padding:"4px 10px", borderRadius:6, background:"rgba(37,211,102,0.08)", border:"1px solid rgba(37,211,102,0.25)", color:"#25D366", textDecoration:"none", fontSize:11, cursor:"pointer" }}>
              <Phone size={11} style={{ flexShrink: 0 }} />
              <span>{selected.phone}</span>
            </a>
          )}
          <span style={{ display:"flex", alignItems:"center", gap:5, padding:"4px 10px", borderRadius:6, background:"rgba(255,255,255,0.03)", border:`1px solid ${C.border}`, color:C.mutedLight, fontSize:11 }}>
            <MapPin size={11} style={{ color: C.label, flexShrink: 0 }} />
            {flag(selected.country)} {selected.country !== "—" ? selected.country : "Sin país"}
          </span>
        </div>
      </div>

      {/* Stats Row — 4 métricas únicas, ninguna se repite en otro panel */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(4,1fr)", gap: 10 }}>
        {[
          {
            label: "LTV Total",
            value: fmtUSD(selected.ltv),
            color: C.orange,
            sub: `${activePays} cobro${activePays !== 1 ? "s" : ""} efectivos`,
          },
          {
            label: "Días activo",
            value: selected.daysActive,
            color: C.green,
            sub: `desde ${fmtDate(selected.firstPurchaseDate)}`,
          },
          {
            label: "Renovaciones",
            value: selected.renewalsCount,
            color: C.white,
            sub: selected.renewalsCount >= 1 ? "cliente recurrente" : "sin renovaciones aún",
          },
          {
            label: "Último pago",
            value: `${daysAgo(selected.lastPurchaseDate)}d`,
            color: C.blue,
            sub: fmtDate(selected.lastPurchaseDate),
          },
        ].map(({ label, value, color, sub }) => (
          <div key={label} style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 11, padding: "12px 14px" }}>
            <div style={{ fontSize: 9, fontWeight: 600, letterSpacing: "0.08em", color: C.label, textTransform: "uppercase", marginBottom: 7 }}>{label}</div>
            <div style={{ fontSize: 22, fontWeight: 800, color, lineHeight: 1 }}>{value}</div>
            <div style={{ fontSize: 10, color: C.muted, marginTop: 5 }}>{sub}</div>
          </div>
        ))}
      </div>

      {/* Productos del Ecosistema */}
      <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 12, overflow: "hidden" }}>
        <div style={{ padding: "10px 16px", borderBottom: `1px solid ${C.border}`, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <span style={{ fontSize: 10, fontWeight: 600, letterSpacing: "0.08em", color: C.label, textTransform: "uppercase" }}>
            Productos del ecosistema
          </span>
          <span style={{ fontSize: 9, color: C.muted }}>
            {familySummary.length} familia{familySummary.length !== 1 ? "s" : ""}
          </span>
        </div>
        <div style={{ padding: "10px 16px", display: "flex", flexDirection: "column", gap: 6 }}>
          {familySummary.length === 0 ? (
            <div style={{ fontSize: 12, color: C.muted }}>Sin productos registrados.</div>
          ) : familySummary.map(f => (
            <div key={f.family} style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
              <div style={{ display: "flex", alignItems: "center", gap: 7 }}>
                {f.isActive
                  ? <span style={{ fontSize: 11, color: C.green, fontWeight: 700 }}>✓</span>
                  : <span style={{ fontSize: 11, color: C.border }}>·</span>
                }
                <span style={{ fontSize: 12, color: f.isActive ? C.white : C.mutedLight, fontWeight: f.isActive ? 600 : 400 }}>
                  {f.family}
                </span>
                {f.isRepeat && (
                  <span style={{ fontSize: 9, color: C.orange }}>🔁</span>
                )}
              </div>
              <span style={{
                fontSize: 10, fontWeight: 700,
                color: f.count >= 2 ? C.orange : C.mutedMid,
                background: f.count >= 2 ? "rgba(254,128,63,0.10)" : "transparent",
                border: f.count >= 2 ? "1px solid rgba(254,128,63,0.25)" : "1px solid transparent",
                borderRadius: 4, padding: "1px 7px",
              }}>
                ×{f.count}
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* Historial de pagos */}
      <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 12, overflow: "hidden" }}>
        <div style={{ padding: "11px 16px", borderBottom: `1px solid ${C.border}`, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <span style={{ fontSize: 10, fontWeight: 600, letterSpacing: "0.08em", color: C.mutedMid, textTransform: "uppercase" }}>
            Historial de pagos
          </span>
          <span style={{ fontSize: 9, color: C.muted }}>{selected.transactions.length} transacciones</span>
        </div>
        <div style={{ padding: "14px 16px", maxHeight: 340, overflowY: "auto" }}>
          {selected.transactions.length === 0 ? (
            <p style={{ fontSize: 12, color: C.muted }}>Sin transacciones registradas.</p>
          ) : (
            <div style={{ display: "flex", flexDirection: "column" }}>
              {selected.transactions.map((tx, i) => {
                const isFirst = tx.id === firstTxId;
                const isLast  = i === selected.transactions.length - 1;
                const dotColor = txColor(tx.status);
                return (
                  <div key={tx.id} style={{ display: "flex", gap: 12, paddingBottom: isLast ? 0 : 14 }}>
                    <div style={{ display: "flex", flexDirection: "column", alignItems: "center", flexShrink: 0, width: 18 }}>
                      <div style={{ width: 7, height: 7, borderRadius: "50%", background: dotColor, boxShadow: `0 0 5px ${dotColor}`, marginTop: 4, flexShrink: 0 }} />
                      {!isLast && <div style={{ width: 1, flex: 1, background: C.border, marginTop: 3 }} />}
                    </div>
                    <div style={{ flex: 1 }}>
                      <div style={{ fontSize: 12, color: C.white, fontWeight: 500 }}>
                        {txLabel(tx.status, isFirst)}{" — "}{tx.planName}
                      </div>
                      <div style={{ display: "flex", justifyContent: "space-between", marginTop: 2 }}>
                        <span style={{ fontSize: 10, color: C.muted }}>{fmtDate(tx.createdAt)}</span>
                        <span style={{ fontSize: 10, fontWeight: 600, color: tx.status === "refunded" || tx.status === "chargeback" ? C.red : C.green }}>
                          {tx.status === "refunded" || tx.status === "chargeback" ? "−" : "+"}{fmtUSD(tx.amountUsd)}
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

  /* ── RIGHT: Analytics únicos (sin duplicar nada del panel central) ── */
  const rightPanel = !selected ? null : (
    <aside style={{ borderLeft: `1px solid ${C.border}`, background: C.sidebar, overflowY: "auto", padding: "18px 14px", display: "flex", flexDirection: "column", gap: 14 }}>

      {/* LTV Hero */}
      <div>
        <div style={{ fontSize: 9, fontWeight: 600, letterSpacing: "0.1em", color: C.label, textTransform: "uppercase", marginBottom: 8 }}>Lifetime Value</div>
        <div style={{
          background: C.gradFinance,
          border: `1px solid rgba(254,128,63,0.45)`,
          borderRadius: 13, padding: "16px 14px", textAlign: "center",
          boxShadow: "0 0 25px rgba(254,128,63,0.12), 0 8px 24px rgba(0,0,0,0.3)",
        }}>
          <div style={{ fontSize: 9, fontWeight: 600, letterSpacing: "0.12em", color: C.orange, textTransform: "uppercase", marginBottom: 8 }}>LTV Acumulado</div>
          <div style={{ fontSize: 36, fontWeight: 900, color: C.orange, lineHeight: 1, letterSpacing: "-0.03em" }}>{fmtUSD(selected.ltv)}</div>
          <div style={{ fontSize: 11, color: C.mutedMid, marginTop: 8 }}>
            Prom. {fmtUSD(avgPerPay)} por cobro
          </div>
        </div>
      </div>

      {/* Prospección AIVI */}
      <div>
        <div style={{ fontSize: 9, fontWeight: 600, letterSpacing: "0.1em", color: C.label, textTransform: "uppercase", marginBottom: 8 }}>
          Prospección AIVI
        </div>

        {hasAIVI ? (
          /* Estado B: Ya es cliente AIVI — mostrar retención */
          <div style={{ background: "rgba(254,128,63,0.06)", border: "1px solid rgba(254,128,63,0.25)", borderRadius: 11, padding: 13 }}>
            <div style={{ display: "flex", alignItems: "center", gap: 7, marginBottom: 8 }}>
              <span style={{ fontSize: 14, color: C.orange }}>✓</span>
              <span style={{ fontSize: 12, fontWeight: 700, color: C.orange }}>Ya es cliente AIVI</span>
            </div>
            <div style={{ fontSize: 10, color: C.muted, marginBottom: 4 }}>
              Plan: <span style={{ color: C.mutedLight }}>{selected!.planName}</span>
            </div>
            <div style={{ height: 1, background: C.border, margin: "10px 0" }} />
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 8 }}>
              <span style={{ fontSize: 9, fontWeight: 600, letterSpacing: "0.06em", color: C.label, textTransform: "uppercase" }}>Score retención</span>
              <span style={{ fontSize: 18, fontWeight: 900, color: risk.color }}>{score}</span>
            </div>
            <div style={{ height: 4, background: "rgba(255,255,255,0.06)", borderRadius: 99, marginBottom: 8, overflow: "hidden" }}>
              <div style={{ height: "100%", width: `${score}%`, borderRadius: 99, background: C.gradRetention, transition: "width 0.6s" }} />
            </div>
            <div style={{ fontSize: 10, color: C.muted }}>
              <span style={{ color: risk.color, fontWeight: 600 }}>
                {risk.txt}
              </span>
            </div>
          </div>
        ) : (
          /* Estado A: No tiene AIVI — mostrar score de prospección */
          <div style={{ background: "rgba(255,255,255,0.03)", border: `1px solid ${C.border}`, borderRadius: 11, padding: 13 }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 10 }}>
              <span style={{ fontSize: 9, fontWeight: 600, letterSpacing: "0.06em", color: C.label, textTransform: "uppercase" }}>Score de upsell</span>
              <span style={{ fontSize: 22, fontWeight: 900, color: prospectLabel.color }}>{prospectScore}</span>
            </div>
            <div style={{ height: 5, background: "rgba(255,255,255,0.06)", borderRadius: 99, marginBottom: 8, overflow: "hidden" }}>
              <div style={{ height: "100%", width: `${prospectScore}%`, borderRadius: 99, background: `linear-gradient(90deg, ${C.orange}, #FF3366)`, transition: "width 0.6s" }} />
            </div>
            <div style={{ fontSize: 11, color: prospectLabel.color, fontWeight: 700, marginBottom: 12 }}>
              {prospectLabel.txt}
            </div>

            <div style={{ fontSize: 9, fontWeight: 700, letterSpacing: "0.06em", color: C.label, textTransform: "uppercase", marginBottom: 7 }}>
              Por qué ofrecerle AIVI
            </div>
            <div style={{ display: "flex", flexDirection: "column", gap: 5, marginBottom: 12 }}>
              {prospectReasons.map((r, i) => (
                <div key={i} style={{ display: "flex", alignItems: "flex-start", gap: 6 }}>
                  <span style={{ color: C.orange, fontSize: 10, flexShrink: 0, marginTop: 1 }}>›</span>
                  <span style={{ fontSize: 11, color: C.mutedLight, lineHeight: 1.4 }}>{r}</span>
                </div>
              ))}
            </div>

            <div style={{ display: "flex", gap: 7 }}>
              <a
                href={`mailto:${selected!.email}`}
                style={{
                  flex: 1, textAlign: "center" as const, padding: "7px 0",
                  borderRadius: 7, background: C.gradBtn, color: "#fff",
                  fontSize: 11, fontWeight: 700, textDecoration: "none",
                  display: "flex", alignItems: "center", justifyContent: "center", gap: 5,
                }}
              >
                ✉ Contactar
              </a>
              <button
                onClick={() => {
                  const name = selected!.name !== "—" ? selected!.name : selected!.email;
                  const text = `Por qué ofrecerle AIVI a ${name}:\n\n` +
                    prospectReasons.map(r => `• ${r}`).join("\n");
                  navigator.clipboard.writeText(text).catch(() => {});
                }}
                style={{
                  flex: 1, padding: "7px 0", borderRadius: 7,
                  border: `1px solid ${C.border}`, background: "rgba(255,255,255,0.04)",
                  color: C.mutedLight, fontSize: 11, fontWeight: 700,
                  cursor: "pointer", fontFamily: "inherit",
                }}
              >
                📋 Copiar
              </button>
            </div>
          </div>
        )}
      </div>

      <div style={{ height: 1, background: C.border }} />

      {/* Estado actual */}
      <div>
        <div style={{ fontSize: 9, fontWeight: 600, letterSpacing: "0.1em", color: C.label, textTransform: "uppercase", marginBottom: 10 }}>Estado Actual</div>
        <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
          {[
            { icon: <CheckCircle2 size={13}/>, label: "Suscripción activa",               ok: selected.status === "active" },
            { icon: <AlertTriangle size={13}/>, label: "Pagos al día",                    ok: selected.status !== "delayed" },
            { icon: <XCircle size={13}/>,       label: "No cancelado",                    ok: selected.status !== "cancelled" },
            { icon: <Clock size={13}/>,         label: `${selected.renewalsCount} renovaciones`, ok: selected.renewalsCount >= 1 },
          ].map(({ icon, label, ok }) => (
            <div key={label} style={{ display: "flex", alignItems: "center", gap: 9 }}>
              <span style={{ color: ok ? C.green : C.red, display: "flex", flexShrink: 0 }}>{icon}</span>
              <span style={{ fontSize: 11, color: ok ? C.mutedLight : C.muted }}>{label}</span>
            </div>
          ))}
        </div>
      </div>

    </aside>
  );

  const gridCols = isMobile
    ? "1fr"
    : isLarge
    ? "300px 1fr 360px"
    : "280px 1fr 330px";

  return (
    <div style={{
      display: "grid",
      gridTemplateColumns: gridCols,
      gridTemplateRows: "52px 1fr",
      height: "100vh",
      background: C.bg,
      fontFamily: FONT,
      overflow: "hidden",
      ...(isXLarge && { maxWidth: 1920, margin: "0 auto" }),
    }}>
      {topbar}
      {isMobile ? (
        mobileView === "list" ? leftPanel : mainPanel
      ) : (
        <>
          {leftPanel}
          {mainPanel}
          {rightPanel ?? <aside style={{ borderLeft: `1px solid ${C.border}`, background: C.sidebar }} />}
        </>
      )}
      <style>{`@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`}</style>
      {isMobile && (
        <MobileBottomNav
          activeView="usuarios"
          onDashboard={onDashboard}
          onTransactions={onTransactions}
          filter={programFilter}
          onFilter={setProgramFilter}
        />
      )}
    </div>
  );
}
