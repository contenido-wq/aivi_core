import { useState, useEffect, useCallback, useMemo } from "react";
import {
  AreaChart, Area, XAxis, YAxis, Tooltip,
  ReferenceLine, ReferenceDot, ResponsiveContainer,
  BarChart, Bar, PieChart, Pie, Cell,
} from "recharts";
import { C, FONT } from "../../tokens";
import type { VSLData, DateRange, DimensionRow, AdRankRow, AdAction } from "../../services/analytics";
import {
  getVSLByCountry, getVSLByDevice, getVSLByOS,
  getVSLByBrowser, classifyAd,
} from "../../services/analytics";

// ── Tipos ─────────────────────────────────────────────────────────────────────

type DimensionTab = "general" | "country" | "device" | "os" | "browser" | "source";
type Level        = "high" | "mid" | "low";

// ── Helpers ───────────────────────────────────────────────────────────────────

function scoreLevel(value: number, hi: number, mid: number): Level {
  if (value >= hi)  return "high";
  if (value >= mid) return "mid";
  return "low";
}

const LEVEL_COLOR: Record<Level, string> = { high: "#22c55e", mid: C.yellow, low: C.red };
const LEVEL_LABEL: Record<Level, string> = { high: "Bueno", mid: "Regular", low: "Mejorar" };

function fmtSec(s: number) {
  const m   = Math.floor(Number(s) / 60);
  const sec = Number(s) % 60;
  return `${m}:${String(sec).padStart(2, "0")}`;
}

function flagEmoji(code: string): string {
  if (!code || code.length !== 2) return "🌐";
  return code.toUpperCase().split("").map(c =>
    String.fromCodePoint(c.charCodeAt(0) + 127397)
  ).join("");
}

function buildChartData(primary: VSLData, compare?: VSLData | null) {
  const maxSec = Math.max(
    primary.retention[primary.retention.length - 1]?.second ?? 0,
    compare ? (compare.retention[compare.retention.length - 1]?.second ?? 0) : 0,
  );
  if (maxSec === 0) return [];
  const step = maxSec > 600 ? 10 : 5;
  const data: Record<string, number | null>[] = [];
  for (let s = 0; s <= maxSec; s += step) {
    const pt: Record<string, number | null> = { s };
    pt["primary"] = primary.retention.find(p => p.second >= s)?.percentage ?? null;
    if (compare) pt["compare"] = compare.retention.find(p => p.second >= s)?.percentage ?? null;
    data.push(pt);
  }
  return data;
}

// ── Sub-componentes ───────────────────────────────────────────────────────────

function KpiCard({ label, value, color, sub }: { label: string; value: string; color?: string; sub?: string }) {
  return (
    <div style={{
      background: "rgba(255,255,255,0.04)", borderRadius: 10,
      padding: "12px 16px", flex: 1, minWidth: 100,
    }}>
      <div style={{ fontSize: 10, color: C.mutedMid, fontWeight: 600, textTransform: "uppercase", letterSpacing: "0.06em", marginBottom: 4 }}>{label}</div>
      <div style={{ fontSize: 18, fontWeight: 800, color: color ?? C.white }}>{value}</div>
      {sub && <div style={{ fontSize: 10, color: C.muted, marginTop: 2 }}>{sub}</div>}
    </div>
  );
}

function DimSkeleton() {
  return (
    <div style={{
      height: 240, background: "rgba(255,255,255,0.03)",
      borderRadius: 8, margin: "0 16px",
    }} />
  );
}

function DimEmpty({ msg }: { msg?: string }) {
  return (
    <div style={{
      height: 200, display: "flex", alignItems: "center", justifyContent: "center",
      flexDirection: "column", gap: 6,
      background: "rgba(255,255,255,0.02)", borderRadius: 8, margin: "0 16px",
      border: `1px dashed ${C.border}`,
    }}>
      <div style={{ fontSize: 12, color: C.mutedMid }}>{msg ?? "Sin datos para este período"}</div>
      <div style={{ fontSize: 11, color: C.muted }}>El sync de VTurb traerá datos la próxima hora</div>
    </div>
  );
}

// Vista: Países
function CountryView({ rows, showConversions }: { rows: DimensionRow[]; showConversions: boolean }) {
  if (rows.length === 0) return <DimEmpty />;
  return (
    <div style={{ padding: "8px 20px 12px", display: "flex", flexDirection: "column", gap: 7 }}>
      {rows.map(r => (
        <div key={r.label} style={{ display: "flex", alignItems: "center", gap: 10 }}>
          <span style={{ fontSize: 16, width: 22, flexShrink: 0 }}>{r.code ? flagEmoji(r.code) : "🌐"}</span>
          <div style={{ fontSize: 12, color: C.mutedLight, width: 120, flexShrink: 0, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{r.label}</div>
          <div style={{ flex: 1, height: 5, background: "rgba(255,255,255,0.07)", borderRadius: 3, overflow: "hidden" }}>
            <div style={{ height: "100%", width: `${r.pct}%`, background: C.orange, borderRadius: 3, transition: "width 0.4s ease" }} />
          </div>
          <div style={{ fontSize: 11, color: C.mutedMid, width: 38, textAlign: "right", flexShrink: 0 }}>{r.pct}%</div>
          {showConversions && (
            <div style={{ fontSize: 11, color: "#22c55e", width: 64, textAlign: "right", flexShrink: 0 }}>
              {r.conversions > 0 ? `${r.conversions} conv.` : "—"}
            </div>
          )}
        </div>
      ))}
    </div>
  );
}

// Vista: Dispositivos (donut + cards)
const DEVICE_PALETTE = [C.orange, "#8b5cf6", C.yellow, C.mutedMid];

function DeviceView({ rows }: { rows: DimensionRow[] }) {
  if (rows.length === 0) return <DimEmpty />;
  const top3 = rows.slice(0, 3);
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 24, padding: "12px 20px 16px", flexWrap: "wrap" }}>
      <PieChart width={130} height={130}>
        <Pie data={rows} cx={60} cy={60} innerRadius={36} outerRadius={56} dataKey="pct" startAngle={90} endAngle={-270}>
          {rows.map((_, i) => <Cell key={i} fill={DEVICE_PALETTE[i] ?? C.muted} />)}
        </Pie>
      </PieChart>
      <div style={{ display: "flex", gap: 10, flex: 1, flexWrap: "wrap" }}>
        {top3.map((r, i) => (
          <div key={r.label} style={{ background: "rgba(255,255,255,0.04)", borderRadius: 10, padding: "12px 16px", flex: 1, minWidth: 90 }}>
            <div style={{ fontSize: 10, color: DEVICE_PALETTE[i], fontWeight: 600, textTransform: "uppercase", letterSpacing: "0.06em", marginBottom: 4 }}>{r.label}</div>
            <div style={{ fontSize: 20, fontWeight: 800, color: C.white }}>{r.pct}%</div>
            <div style={{ fontSize: 10, color: C.muted, marginTop: 2 }}>{r.plays.toLocaleString("es")} plays</div>
          </div>
        ))}
      </div>
    </div>
  );
}

// Vista genérica: BarChart horizontal (OS y Browser)
function HBarView({ rows, label }: { rows: DimensionRow[]; label: string }) {
  if (rows.length === 0) return <DimEmpty />;
  return (
    <div style={{ padding: "8px 4px 12px" }}>
      <ResponsiveContainer width="100%" height={Math.max(180, rows.length * 30)}>
        <BarChart data={rows} layout="vertical" margin={{ top: 4, right: 48, left: 8, bottom: 4 }}>
          <XAxis type="number" domain={[0, 100]} hide />
          <YAxis
            type="category" dataKey="label" width={120}
            tick={{ fontSize: 11, fill: C.mutedLight, fontFamily: FONT }}
            tickLine={false} axisLine={false}
          />
          <Tooltip
            contentStyle={{ background: "#1a1a2e", border: `1px solid ${C.border}`, borderRadius: 8, fontSize: 11, color: C.white }}
            formatter={(v: number) => [`${v}%`, label]}
            cursor={{ fill: "rgba(255,255,255,0.04)" }}
          />
          <Bar dataKey="pct" radius={[0, 3, 3, 0]}>
            {rows.map((_, i) => <Cell key={i} fill={i === 0 ? C.orange : `${C.orange}99`} />)}
          </Bar>
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}

// Vista: Fuente de tráfico (anuncios que trajeron tráfico a este VSL + veredicto)
const AD_ACTION_STYLE: Record<AdAction, { color: string; bg: string; border: string }> = {
  ESCALAR:    { color: C.green,  bg: C.greenSoft,             border: "rgba(48,209,88,0.3)"  },
  PAUSAR:     { color: C.red,    bg: "rgba(255,65,59,0.12)",  border: "rgba(255,65,59,0.3)"  },
  MONITOREAR: { color: C.yellow, bg: "rgba(255,194,82,0.12)", border: "rgba(255,194,82,0.3)" },
};

function adCacColor(cac: number, target: number) {
  if (cac === 0 || target === 0) return C.mutedMid;
  if (cac <= target)       return C.green;
  if (cac <= target * 1.5) return C.yellow;
  return C.red;
}

function adScoreColor(s: number) {
  return s >= 80 ? C.green : s >= 50 ? C.yellow : C.red;
}

function AdSourceView({ rows, cacTarget, ticketMin }: { rows: AdRankRow[]; cacTarget: number; ticketMin: number }) {
  if (rows.length === 0) return (
    <DimEmpty msg="Sin anuncios atribuidos a este VSL en el período. Verifica el mapeo campaña→VSL arriba." />
  );
  return (
    <div style={{ padding: "8px 16px 12px", overflowX: "auto" }}>
      <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 12 }}>
        <thead>
          <tr style={{ borderBottom: `1px solid ${C.border}` }}>
            {["Campaña", "Inv.", "Ventas", "CAC", "ROI", "Score", "Acción"].map(h => (
              <th key={h} style={{ padding: "6px 8px", color: C.mutedMid, fontWeight: 500, textAlign: "left", whiteSpace: "nowrap" }}>
                {h}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((r, i) => {
            const action  = classifyAd(r, cacTarget, ticketMin);
            const acStyle = AD_ACTION_STYLE[action];
            return (
              <tr key={`${r.campaignName}-${i}`} style={{ borderBottom: `1px solid ${C.border}` }}>
                <td style={{ padding: "9px 8px", color: C.white, fontWeight: 500, maxWidth: 160, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                  {r.campaignName}
                </td>
                <td style={{ padding: "9px 8px", color: C.mutedLight }}>${r.investment.toFixed(0)}</td>
                <td style={{ padding: "9px 8px", color: C.mutedLight }}>{r.sales}</td>
                <td style={{ padding: "9px 8px", color: adCacColor(r.cac, cacTarget), fontWeight: 700 }}>
                  {r.cac > 0 ? `$${r.cac.toFixed(0)}` : "—"}
                </td>
                <td style={{ padding: "9px 8px", color: r.roi >= 1 ? C.green : r.roi >= 0 ? C.yellow : C.red, fontWeight: 600 }}>
                  {r.investment > 0 ? `${r.roi.toFixed(2)}x` : "—"}
                </td>
                <td style={{ padding: "9px 8px" }}>
                  <span style={{ background: `${adScoreColor(r.score)}20`, color: adScoreColor(r.score), borderRadius: 12, padding: "2px 8px", fontSize: 11, fontWeight: 700 }}>
                    {r.score}
                  </span>
                </td>
                <td style={{ padding: "9px 8px" }}>
                  <span style={{ background: acStyle.bg, border: `1px solid ${acStyle.border}`, color: acStyle.color, borderRadius: 12, padding: "2px 10px", fontSize: 10, fontWeight: 700, whiteSpace: "nowrap" }}>
                    {action}
                  </span>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}

// ── Tabs config ───────────────────────────────────────────────────────────────

const TABS: { key: DimensionTab; label: string }[] = [
  { key: "general", label: "Retención general" },
  { key: "country", label: "Países"            },
  { key: "device",  label: "Dispositivos"      },
  { key: "os",      label: "S. Operativo"      },
  { key: "browser", label: "Navegadores"       },
  { key: "source",  label: "Fuente de tráfico" },
];

// ── Props ─────────────────────────────────────────────────────────────────────

interface Props {
  primary:   VSLData | null;
  compare?:  VSLData | null;
  range:     DateRange | null;
  ranking:   AdRankRow[];
  cacTarget: number;
  ticketMin: number;
}

// ── Componente principal ──────────────────────────────────────────────────────

export function VSLIntelligencePanel({ primary, compare, range, ranking, cacTarget, ticketMin }: Props) {
  const [activeTab,       setActiveTabState] = useState<DimensionTab>("general");
  const [dimCache,        setDimCache]       = useState<Partial<Record<DimensionTab, DimensionRow[]>>>({});
  const [dimLoading,      setDimLoading]     = useState(false);
  const [showConversions, setShowConversions] = useState(false);

  const adsForThisVsl = useMemo(
    () => ranking.filter(r => r.videoId === primary?.videoId),
    [ranking, primary?.videoId],
  );

  // Invalida caché al cambiar rango o video
  useEffect(() => {
    setDimCache({});
    setActiveTabState("general");
  }, [range?.from, range?.to, primary?.videoId]);

  const fetchTab = useCallback(async (tab: DimensionTab) => {
    if (!primary || !range || tab === "general" || tab === "source" || dimCache[tab] !== undefined) return;
    setDimLoading(true);
    try {
      const fetchers: Record<Exclude<DimensionTab, "general" | "source">, () => Promise<DimensionRow[]>> = {
        country: () => getVSLByCountry(range, primary.videoId),
        device:  () => getVSLByDevice(range, primary.videoId),
        os:      () => getVSLByOS(range, primary.videoId),
        browser: () => getVSLByBrowser(range, primary.videoId),
      };
      const data = await fetchers[tab as Exclude<DimensionTab, "general" | "source">]();
      setDimCache(prev => ({ ...prev, [tab]: data }));
    } catch (e) {
      console.error(`fetchTab ${tab}:`, e);
      setDimCache(prev => ({ ...prev, [tab]: [] }));
    } finally {
      setDimLoading(false);
    }
  }, [primary, range, dimCache]);

  const handleTabClick = (tab: DimensionTab) => {
    setActiveTabState(tab);
    fetchTab(tab);
  };

  // ── Sin video seleccionado ──────────────────────────────────────────────────
  if (!primary) return (
    <div style={{
      background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 32,
      display: "flex", alignItems: "center", justifyContent: "center",
      flexDirection: "column", gap: 8, minHeight: 120,
    }}>
      <div style={{ fontSize: 13, color: C.mutedMid }}>Sin datos de retención para este período</div>
      <div style={{ fontSize: 11, color: C.muted }}>Selecciona un VSL o espera a que lleguen datos de VTurb</div>
    </div>
  );

  const hasRetention  = primary.retention.length > 2;
  const chartData     = buildChartData(primary, compare);
  const ctaRate       = primary.plays > 0 ? (primary.ctaClicks / primary.plays) * 100 : 0;
  const hookLevel     = scoreLevel(primary.ret25, 60, 40);
  const retLevel      = scoreLevel(primary.ret50, 40, 25);
  const ctaLevel      = scoreLevel(ctaRate, 8, 4);
  const dropPt        = primary.dropSecond != null
    ? primary.retention.find(p => p.second >= primary.dropSecond!)
    : null;
  const videoDuration = primary.retention.length > 0
    ? primary.retention[primary.retention.length - 1].second
    : null;

  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, overflow: "hidden" }}>

      {/* Header */}
      <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: "16px 20px 0", flexWrap: "wrap", gap: 10 }}>
        <div>
          <div style={{ fontSize: 15, fontWeight: 700, color: C.white }}>{primary.videoName}</div>
          {videoDuration && (
            <div style={{ fontSize: 11, color: C.mutedMid, marginTop: 2 }}>
              Duración: {fmtSec(videoDuration)} · {primary.plays.toLocaleString("es")} plays
            </div>
          )}
        </div>
        <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
          {([
            { label: "Hook",      level: hookLevel },
            { label: "Retención", level: retLevel  },
            { label: "CTA",       level: ctaLevel  },
          ] as { label: string; level: Level }[]).map(({ label, level }) => (
            <div key={label} style={{
              padding: "4px 12px", borderRadius: 20, fontSize: 11, fontWeight: 600,
              background: `${LEVEL_COLOR[level]}18`, border: `1px solid ${LEVEL_COLOR[level]}40`,
              color: LEVEL_COLOR[level],
            }}>
              {label}: {LEVEL_LABEL[level]}
            </div>
          ))}
        </div>
      </div>

      {/* Tab bar */}
      <div style={{
        display: "flex", alignItems: "center", justifyContent: "space-between",
        padding: "12px 20px 0", gap: 8, flexWrap: "wrap",
      }}>
        <div style={{ display: "flex", gap: 4, flexWrap: "wrap" }}>
          {TABS.map(t => (
            <button
              key={t.key}
              onClick={() => handleTabClick(t.key)}
              style={{
                background:  activeTab === t.key ? C.orange : "transparent",
                border:      `1px solid ${activeTab === t.key ? C.orange : C.border}`,
                borderRadius: 20,
                padding:     "4px 12px",
                fontSize:    11,
                fontWeight:  activeTab === t.key ? 600 : 400,
                color:       activeTab === t.key ? C.white : C.mutedLight,
                cursor:      "pointer",
                fontFamily:  FONT,
                transition:  "all 0.15s ease",
              }}
            >
              {t.label}
            </button>
          ))}
        </div>

        {/* Toggle Conversiones */}
        <label style={{ display: "flex", alignItems: "center", gap: 8, cursor: "pointer", userSelect: "none" }}>
          <div
            onClick={() => setShowConversions(v => !v)}
            style={{
              width: 32, height: 18, borderRadius: 9,
              background: showConversions ? C.orange : "rgba(255,255,255,0.12)",
              position: "relative", transition: "background 0.2s ease", cursor: "pointer",
            }}
          >
            <div style={{
              position: "absolute", top: 2,
              left: showConversions ? 16 : 2,
              width: 14, height: 14, borderRadius: "50%",
              background: C.white, transition: "left 0.2s ease",
            }} />
          </div>
          <span style={{ fontSize: 11, color: C.mutedLight }}>Conversiones</span>
        </label>
      </div>

      {/* Contenido del tab */}
      <div style={{ padding: "12px 4px 0" }}>

        {/* Retención general */}
        {activeTab === "general" && (
          <>
            {!hasRetention ? (
              <div style={{
                height: 240, display: "flex", alignItems: "center", justifyContent: "center",
                flexDirection: "column", gap: 6, margin: "0 16px",
                background: "rgba(255,255,255,0.02)", borderRadius: 8, border: `1px dashed ${C.border}`,
              }}>
                <div style={{ fontSize: 12, color: C.mutedMid }}>Sin suficientes datos de retención</div>
                <div style={{ fontSize: 11, color: C.muted }}>El sync de VTurb necesita más historial</div>
              </div>
            ) : (
              <ResponsiveContainer width="100%" height={240}>
                <AreaChart data={chartData} margin={{ top: 8, right: 20, left: 0, bottom: 0 }}>
                  <defs>
                    <linearGradient id="gradPrimary" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%"  stopColor={C.orange} stopOpacity={0.4} />
                      <stop offset="95%" stopColor={C.orange} stopOpacity={0.03} />
                    </linearGradient>
                    <linearGradient id="gradCompare" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%"  stopColor={C.yellow} stopOpacity={0.25} />
                      <stop offset="95%" stopColor={C.yellow} stopOpacity={0.02} />
                    </linearGradient>
                  </defs>
                  <XAxis
                    dataKey="s"
                    tick={{ fontSize: 10, fill: C.mutedMid, fontFamily: FONT }}
                    tickFormatter={fmtSec} tickLine={false}
                    axisLine={{ stroke: C.border }} interval="preserveStartEnd"
                  />
                  <YAxis
                    domain={[0, 100]}
                    tick={{ fontSize: 10, fill: C.mutedMid, fontFamily: FONT }}
                    tickFormatter={v => `${v}%`} tickLine={false} axisLine={false} width={36}
                  />
                  <Tooltip
                    contentStyle={{ background: "#1a1a2e", border: `1px solid ${C.border}`, borderRadius: 8, fontSize: 11, color: C.white }}
                    labelFormatter={s => `⏱ ${fmtSec(Number(s))}`}
                    formatter={(v: number, name: string) => [
                      `${Number(v).toFixed(1)}%`,
                      name === "primary" ? primary.videoName : (compare?.videoName ?? ""),
                    ]}
                  />
                  <ReferenceLine y={50} stroke={C.border} strokeDasharray="4 4" />
                  {dropPt && (
                    <ReferenceDot
                      x={primary.dropSecond!} y={dropPt.percentage}
                      r={6} fill={C.red} stroke="#fff" strokeWidth={1.5}
                      label={{ value: "Drop", position: "top", fontSize: 9, fill: C.red }}
                    />
                  )}
                  <Area type="monotone" dataKey="primary" name="primary"
                    stroke={C.orange} strokeWidth={2.5} fill="url(#gradPrimary)" connectNulls dot={false}
                  />
                  {compare && (
                    <Area type="monotone" dataKey="compare" name="compare"
                      stroke={C.yellow} strokeWidth={2} fill="url(#gradCompare)"
                      connectNulls dot={false} strokeDasharray="6 3"
                    />
                  )}
                </AreaChart>
              </ResponsiveContainer>
            )}

            {hasRetention && compare && (
              <div style={{ display: "flex", gap: 16, padding: "4px 20px 0" }}>
                <span style={{ display: "flex", alignItems: "center", gap: 6, fontSize: 11, color: C.mutedLight }}>
                  <span style={{ width: 18, height: 2.5, background: C.orange, display: "inline-block", borderRadius: 2 }} />
                  {primary.videoName}
                </span>
                <span style={{ display: "flex", alignItems: "center", gap: 6, fontSize: 11, color: C.mutedLight }}>
                  <span style={{ width: 18, height: 0, borderTop: `2px dashed ${C.yellow}`, display: "inline-block" }} />
                  {compare.videoName}
                </span>
              </div>
            )}
          </>
        )}

        {/* Tabs de dimensiones */}
        {activeTab !== "general" && activeTab !== "source" && dimLoading && <DimSkeleton />}
        {activeTab === "country" && !dimLoading && <CountryView rows={dimCache.country ?? []} showConversions={showConversions} />}
        {activeTab === "device"  && !dimLoading && <DeviceView  rows={dimCache.device  ?? []} />}
        {activeTab === "os"      && !dimLoading && <HBarView    rows={dimCache.os      ?? []} label="S. Operativo" />}
        {activeTab === "browser" && !dimLoading && <HBarView    rows={dimCache.browser ?? []} label="Navegadores"  />}
        {activeTab === "source"  && <AdSourceView rows={adsForThisVsl} cacTarget={cacTarget} ticketMin={ticketMin} />}
      </div>

      {/* KPIs — siempre visibles */}
      <div style={{ display: "flex", gap: 10, padding: "16px 20px 20px", flexWrap: "wrap" }}>
        <KpiCard label="Plays" value={primary.plays.toLocaleString("es")} />
        <KpiCard label="Hook (25%)"       value={`${primary.ret25.toFixed(0)}%`} color={LEVEL_COLOR[hookLevel]} sub="Retención al cuarto" />
        <KpiCard label="Ret. media (50%)" value={`${primary.ret50.toFixed(0)}%`} color={LEVEL_COLOR[retLevel]}  sub="Mitad del video" />
        <KpiCard label="Cierre (75%)"     value={`${primary.ret75.toFixed(0)}%`}
          color={primary.ret75 >= 20 ? "#22c55e" : primary.ret75 >= 10 ? C.yellow : C.red}
          sub="Tres cuartos" />
        <KpiCard label="CTA Click Rate"   value={`${ctaRate.toFixed(1)}%`} color={LEVEL_COLOR[ctaLevel]} sub={`${primary.ctaClicks.toLocaleString("es")} clicks`} />
        <KpiCard label="Conv. Rate"       value={`${primary.convRate.toFixed(1)}%`}
          color={primary.convRate >= 3 ? "#22c55e" : primary.convRate >= 1 ? C.yellow : C.red}
          sub={`${primary.sales} ventas`} />
        {primary.dropSecond != null && (
          <KpiCard label="Drop crítico" value={fmtSec(primary.dropSecond)} color={C.red} sub="Revisar guión aquí" />
        )}
      </div>
    </div>
  );
}
