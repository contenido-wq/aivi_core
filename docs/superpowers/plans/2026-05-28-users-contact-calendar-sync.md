# UsersView — Contacto, Calendario y Fix de Sync — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Añadir datos de contacto accionables (email/WhatsApp/país) y calendario de actividad de pagos en el perfil de usuario, y corregir la conversión de moneda en `daily_metrics` + botón de sync manual.

**Architecture:** Cinco archivos modificados en orden de menor a mayor dependencia: primero el service layer (`dashboard.ts`), luego el Edge Function (`hotmart-webhook`), después los componentes de UI de menor a mayor (`TopNav` → `DashboardView` → `UsersView`).

**Tech Stack:** React 18 + TypeScript, Vite, Supabase JS, Deno (Edge Functions), Lucide React, tokens de diseño en `src/tokens.ts`.

---

## Task 1: `dashboard.ts` — Añadir `phone` a `UserProfile` + `syncToday()`

**Files:**
- Modify: `src/services/dashboard.ts`

- [ ] **Step 1: Añadir `phone` a la interfaz `UserProfile`**

En `src/services/dashboard.ts`, buscar la interfaz `UserProfile` (línea ~619) y agregar el campo `phone`:

```typescript
export interface UserProfile {
  email:             string;
  name:              string;
  status:            "active" | "cancelled" | "delayed" | "trial";
  planName:          string;
  amountUsd:         number;
  ltv:               number;
  firstPurchaseDate: string;
  lastPurchaseDate:  string;
  country:           string;
  channel:           string;
  phone:             string | null;   // ← nuevo
  transactions:      UserTx[];
  daysActive:        number;
  renewalsCount:     number;
}
```

- [ ] **Step 2: Extraer teléfono en `getUsersTraceability`**

Dentro del bucle `for (const email of emailSet)`, después del bloque que extrae `country` y `channel` (línea ~710), agregar la extracción del teléfono:

```typescript
    // Teléfono: recorrer todos los payloads hasta encontrar uno
    let phone: string | null = null;
    for (const tx of sorted) {
      try {
        const rp = typeof tx.raw_payload === "string" ? JSON.parse(tx.raw_payload) : tx.raw_payload;
        const p = rp?.data?.buyer?.checkout_phone ?? rp?.data?.buyer?.phone ?? null;
        if (p && String(p).trim() !== "") { phone = String(p).trim(); break; }
      } catch { /* ignore */ }
    }
```

- [ ] **Step 3: Incluir `phone` en el objeto `UserProfile` que se pushea al array**

En el bloque `users.push({...})` (línea ~719), agregar `phone` junto a los demás campos:

```typescript
    users.push({
      email,
      name: sub?.buyer_name ?? sorted[0]?.buyer_name ?? "—",
      status,
      planName:          sub?.plan_name ?? sorted[0]?.plan_name ?? "—",
      amountUsd:         toUSD(Number(sub?.amount ?? 0), sub?.currency ?? "USD"),
      ltv,
      firstPurchaseDate,
      lastPurchaseDate,
      country,
      channel,
      phone,                // ← nuevo
      transactions: [...txs]
        .sort((a: any, b: any) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
        .map((t: any): UserTx => ({
          id:        t.id,
          eventType: t.event_type ?? "purchase",
          planName:  t.plan_name,
          amount:    Number(t.amount),
          currency:  t.currency ?? "USD",
          amountUsd: toUSD(Number(t.amount), t.currency),
          createdAt: t.created_at,
          status:    t.status,
        })),
      daysActive,
      renewalsCount: Math.max(0, activeTxs.length - 1),
    });
```

- [ ] **Step 4: Agregar función `syncToday()` al final del archivo**

```typescript
export async function syncToday(): Promise<{ ok: boolean; inserted?: number; error?: string }> {
  const now   = Date.now();
  const start = now - 24 * 60 * 60 * 1000; // últimas 24h
  const url   = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/hotmart-sync?start=${start}&end=${now}`;
  try {
    const res = await fetch(url, {
      headers: { Authorization: `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}` },
    });
    return res.json();
  } catch (e) {
    return { ok: false, error: String(e) };
  }
}
```

- [ ] **Step 5: Verificar compilación TypeScript**

```bash
npm run build
```

Esperado: sin errores de tipos. Si hay error `Property 'phone' does not exist`, verificar que el campo se agregó en la interfaz Y en el `users.push({...})`.

- [ ] **Step 6: Commit**

```bash
git add src/services/dashboard.ts
git commit -m "feat: añadir phone a UserProfile y syncToday() en dashboard service"
```

---

## Task 2: `hotmart-webhook` — Fix `recalcDailyMetrics` a USD

**Files:**
- Modify: `supabase/functions/hotmart-webhook/index.ts`

- [ ] **Step 1: Agregar mapa de tasas y función `toUSD` al principio del archivo**

Después de las constantes `SALE_EVENTS`, `REFUND_EVENTS`, etc. (línea ~29), agregar:

```typescript
const RATES: Record<string, number> = {
  USD: 1,     COP: 1/4100,  EUR: 1.08,  DOP: 1/59,
  BRL: 1/5.2, MXN: 1/17,   ARS: 1/1000, CLP: 1/950,
  PEN: 1/3.7, VES: 1/36,
};

function amountToUSD(amount: number, currency: string): number {
  return amount * (RATES[currency] ?? 1);
}
```

- [ ] **Step 2: Actualizar el `select` en `recalcDailyMetrics` para incluir `currency`**

En la función `recalcDailyMetrics`, cambiar:

```typescript
// ANTES:
const { data: todayTx } = await supabase
  .from("transactions")
  .select("event_type, amount")
  .gte("created_at", start)
  .lte("created_at", end);
```

por:

```typescript
// DESPUÉS:
const { data: todayTx } = await supabase
  .from("transactions")
  .select("event_type, amount, currency")
  .gte("created_at", start)
  .lte("created_at", end);
```

- [ ] **Step 3: Usar `amountToUSD` al acumular revenue**

En el bucle `for (const tx of (todayTx ?? []))`, cambiar:

```typescript
// ANTES:
if (SALE_EVENTS.includes(tx.event_type))   { metrics.new_users++; metrics.revenue += Number(tx.amount); }
if (REFUND_EVENTS.includes(tx.event_type)) { metrics.refunds++;   metrics.revenue -= Number(tx.amount); }
```

por:

```typescript
// DESPUÉS:
if (SALE_EVENTS.includes(tx.event_type))   { metrics.new_users++; metrics.revenue += amountToUSD(Number(tx.amount), tx.currency ?? "USD"); }
if (REFUND_EVENTS.includes(tx.event_type)) { metrics.refunds++;   metrics.revenue -= amountToUSD(Number(tx.amount), tx.currency ?? "USD"); }
```

- [ ] **Step 4: Verificar que el archivo compila sin errores TypeScript**

```bash
cd supabase/functions/hotmart-webhook && deno check index.ts 2>&1 | head -20
```

Si `deno` no está instalado, continuar — el deploy lo validará.

- [ ] **Step 5: Commit**

```bash
git add supabase/functions/hotmart-webhook/index.ts
git commit -m "fix: recalcDailyMetrics convierte revenue a USD antes de guardar en daily_metrics"
```

---

## Task 3: `TopNav.tsx` — Botón de sync con spinner

**Files:**
- Modify: `src/components/dashboard/TopNav.tsx`

- [ ] **Step 1: Agregar `onSync` a la interfaz y estado de loading**

Reemplazar el contenido completo de `src/components/dashboard/TopNav.tsx`:

```tsx
import { useState }            from "react";
import { RefreshCw, BarChart2, Bell, Zap, Menu } from "lucide-react";
import { C }                   from "../../tokens";
import { Toggle }              from "../ui/Toggle";

interface TopNavProps {
  time:        string;
  adsOn:       boolean;
  onAdsToggle: () => void;
  isMobile?:   boolean;
  onMenuOpen?: () => void;
  onSync?:     () => Promise<void>;
}

export function TopNav({ time, adsOn, onAdsToggle, isMobile, onMenuOpen, onSync }: TopNavProps) {
  const [syncing, setSyncing] = useState(false);

  const handleSync = async () => {
    if (!onSync || syncing) return;
    setSyncing(true);
    try { await onSync(); } finally { setSyncing(false); }
  };

  return (
    <nav style={{
      background: C.nav,
      borderBottom: `1px solid ${C.border}`,
      height: 52,
      display: "flex", alignItems: "center",
      justifyContent: "space-between",
      padding: isMobile ? "0 12px" : "0 24px",
      flexShrink: 0,
      gap: 8,
    }}>
      <div style={{ display: "flex", alignItems: "center", gap: 7, fontSize: 11, minWidth: 0 }}>
        {isMobile && (
          <button
            onClick={onMenuOpen}
            aria-label="Abrir menú"
            style={{
              background: "none", border: "none", color: C.white,
              padding: 6, display: "flex", alignItems: "center",
              justifyContent: "center", marginRight: 4,
            }}
          >
            <Menu size={20} />
          </button>
        )}
        <span style={{ color: C.mutedLight, whiteSpace: "nowrap" }}>AIVI CORE</span>
        <span style={{ color: C.muted }}>›</span>
        <span style={{ color: C.orange, fontWeight: 700 }}>Dashboard</span>
      </div>

      <div style={{ display: "flex", alignItems: "center", gap: isMobile ? 8 : 16, fontSize: 11, flexShrink: 0 }}>
        {!isMobile && (
          <>
            {onSync && (
              <button
                onClick={handleSync}
                disabled={syncing}
                title="Sincronizar últimas 24h con Hotmart"
                style={{
                  background: "none", border: "none",
                  color: syncing ? C.orange : C.mutedLight,
                  cursor: syncing ? "not-allowed" : "pointer",
                  display: "flex", alignItems: "center", gap: 5,
                }}
              >
                <RefreshCw size={13} style={{ animation: syncing ? "spin 0.8s linear infinite" : "none" }} />
                <span style={{ fontSize: 10 }}>{syncing ? "Sincronizando…" : "Sincronizar"}</span>
              </button>
            )}
            <button style={{ background: "none", border: "none", color: C.mutedLight, display: "flex", alignItems: "center", gap: 5 }}>
              <BarChart2 size={14} />
              <span>Sync Ads</span>
            </button>
          </>
        )}
        <div style={{ display: "flex", alignItems: "center", gap: 5 }}>
          <Zap size={12} style={{ color: adsOn ? C.orange : C.red }} />
          {!isMobile && <span style={{ fontSize: 10, color: adsOn ? C.orange : C.red, fontWeight: 700 }}>{adsOn ? "ON" : "OFF"}</span>}
          <Toggle on={adsOn} onChange={onAdsToggle} color={C.orange} />
        </div>
        <button style={{ background: "none", border: "none", color: C.mutedLight, display: "flex", alignItems: "center" }}>
          <Bell size={13} />
        </button>
        {!isMobile && <span style={{ color: C.mutedLight, fontVariantNumeric: "tabular-nums" }}>{time}</span>}
      </div>
    </nav>
  );
}
```

- [ ] **Step 2: Verificar compilación**

```bash
npm run build
```

Esperado: sin errores.

- [ ] **Step 3: Commit**

```bash
git add src/components/dashboard/TopNav.tsx
git commit -m "feat: botón Sincronizar en TopNav con spinner"
```

---

## Task 4: `DashboardView.tsx` — Conectar `onSync`

**Files:**
- Modify: `src/views/DashboardView.tsx`

- [ ] **Step 1: Importar `syncToday` y `useCallback`**

En la línea de imports de `DashboardView.tsx`, agregar:

```typescript
import { useState, useCallback }   from "react";
// ...
import { syncToday }               from "../services/dashboard";
```

Nota: `useCallback` ya puede estar importado desde React — verificar primero. Si no está, agregarlo al import de React existente.

- [ ] **Step 2: Crear `handleSync` dentro del componente**

Después de la línea donde se desestructura `useDashboardData` (línea ~33), agregar:

```typescript
  const handleSync = useCallback(async () => {
    await syncToday();
    await refresh();
  }, [refresh]);
```

- [ ] **Step 3: Pasar `onSync` a `<TopNav />`**

En las tres apariciones de `<TopNav ...>` dentro de `DashboardView` (desktop tall, laptop, mobile), agregar el prop `onSync={handleSync}`:

```tsx
<TopNav
  time={time}
  adsOn={adsOn}
  onAdsToggle={() => setAdsOn(!adsOn)}
  isMobile={isMobile || isTablet}
  onMenuOpen={() => setSidebarOpen(true)}
  onSync={handleSync}
/>
```

Hay una sola instancia de `<TopNav` en el archivo — verificarlo con `grep -n "TopNav" src/views/DashboardView.tsx` antes de editar.

- [ ] **Step 4: Verificar compilación**

```bash
npm run build
```

Esperado: sin errores. Si hay error en `useCallback` no importado, agregarlo al import de React.

- [ ] **Step 5: Commit**

```bash
git add src/views/DashboardView.tsx
git commit -m "feat: conectar botón Sincronizar en DashboardView con syncToday"
```

---

## Task 5: `UsersView.tsx` — Sección de contacto accionable

**Files:**
- Modify: `src/views/UsersView.tsx`

- [ ] **Step 1: Agregar imports de iconos `Mail` y `Phone`**

En la línea 2 de `UsersView.tsx`, agregar `Mail` y `Phone` al import de lucide-react:

```typescript
import { ArrowLeft, Search, RefreshCw, Loader2, TrendingUp, Calendar, MapPin, Radio, CheckCircle2, XCircle, Clock, AlertTriangle, Mail, Phone } from "lucide-react";
```

- [ ] **Step 2: Agregar función helper `cleanPhone` al bloque de helpers (antes de la línea `// ─────`)**

```typescript
function cleanPhone(raw: string): string {
  return raw.replace(/[\s+\-().]/g, "");
}
```

- [ ] **Step 3: Reemplazar el bloque "Info row" en el `mainPanel`**

Localizar el comentario `{/* Info row — 4 datos únicos sin repetir */}` (línea ~318) y reemplazar todo ese bloque hasta `</div>` (que cierra el `.map(...)`) con:

```tsx
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
```

- [ ] **Step 4: Verificar compilación TypeScript**

```bash
npm run build
```

Esperado: sin errores. Si hay error `Property 'phone' does not exist on type 'UserProfile'`, confirmar que el Task 1 fue completado correctamente.

- [ ] **Step 5: Commit**

```bash
git add src/views/UsersView.tsx
git commit -m "feat: sección de contacto accionable (email, WhatsApp, país) en perfil de usuario"
```

---

## Task 6: `UsersView.tsx` — Calendario de actividad de pagos

**Files:**
- Modify: `src/views/UsersView.tsx`

- [ ] **Step 1: Agregar función `buildTxDateMap` antes de la línea `// ─────`**

```typescript
const CAL_DAYS   = ["Lu","Ma","Mi","Ju","Vi","Sá","Do"] as const;
const CAL_MONTHS = ["Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic"] as const;
const PRIORITY: Record<string, number> = { active: 3, delayed: 2, cancelled: 2, refunded: 1, chargeback: 1 };

type DotStatus = "active" | "delayed" | "refunded";

function buildTxDateMap(txs: { createdAt: string; status: string }[]): Record<string, DotStatus> {
  const map: Record<string, DotStatus> = {};
  for (const tx of txs) {
    if (!tx.createdAt) continue;
    // Convertir a fecha Colombia (UTC-5)
    const col = new Date(new Date(tx.createdAt).getTime() - 5 * 60 * 60 * 1000);
    const key = col.toISOString().slice(0, 10);
    const incoming: DotStatus =
      tx.status === "active"   ? "active" :
      tx.status === "refunded" || tx.status === "chargeback" ? "refunded" : "delayed";
    const inP  = PRIORITY[tx.status]  ?? 0;
    const curP = PRIORITY[map[key]]   ?? 0;
    if (inP > curP) map[key] = incoming;
  }
  return map;
}
```

- [ ] **Step 2: Agregar estado `calView` y efecto de reset**

Después del bloque de estado existente (después de la línea `const [statusFilter, setStatusFilter]`), agregar:

```typescript
  const [calView, setCalView] = useState<{ year: number; month: number }>(() => {
    const now = new Date();
    return { year: now.getFullYear(), month: now.getMonth() };
  });

  useEffect(() => {
    if (!selected?.firstPurchaseDate) return;
    const d = new Date(selected.firstPurchaseDate);
    setCalView({ year: d.getFullYear(), month: d.getMonth() });
  }, [selected?.email]); // eslint-disable-line
```

- [ ] **Step 3: Agregar valores derivados del calendario**

Después de la línea `const ltvProm = ...` (justo antes del bloque `/* ── TOPBAR ── */`), agregar:

```typescript
  // Calendario
  const txDateMap  = useMemo(() => selected ? buildTxDateMap(selected.transactions) : {}, [selected]);
  const calFirst   = new Date(calView.year, calView.month, 1);
  const calStartCol = (calFirst.getDay() + 6) % 7; // Lu=0
  const calDaysN   = new Date(calView.year, calView.month + 1, 0).getDate();
  const calCells   = [...Array(calStartCol).fill(null), ...Array.from({ length: calDaysN }, (_, i) => i + 1)] as (number | null)[];
  const nowForCal  = new Date();
  const isMaxMonth = calView.year === nowForCal.getFullYear() && calView.month === nowForCal.getMonth();
  const calPrev    = () => setCalView(v => v.month === 0 ? { year: v.year - 1, month: 11 } : { year: v.year, month: v.month - 1 });
  const calNext    = () => { if (!isMaxMonth) setCalView(v => v.month === 11 ? { year: v.year + 1, month: 0 } : { year: v.year, month: v.month + 1 }); };
```

- [ ] **Step 4: Insertar el bloque del calendario en `mainPanel`**

Localizar el comentario `{/* Historial de pagos */}` (línea ~373) e insertar el bloque del calendario **justo antes** de ese comentario:

```tsx
      {/* Calendario de actividad */}
      <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 12, overflow: "hidden" }}>
        <div style={{ padding: "10px 16px", borderBottom: `1px solid ${C.border}`, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <span style={{ fontSize: 10, fontWeight: 600, letterSpacing: "0.08em", color: C.mutedMid, textTransform: "uppercase" }}>Actividad de pagos</span>
          <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
            <button onClick={calPrev} style={{ background: "none", border: "none", color: C.mutedLight, cursor: "pointer", padding: "0 4px", fontSize: 16, lineHeight: 1, fontFamily: FONT }}>‹</button>
            <span style={{ fontSize: 11, fontWeight: 700, color: C.white, minWidth: 80, textAlign: "center" }}>
              {CAL_MONTHS[calView.month]} {calView.year}
            </span>
            <button onClick={calNext} disabled={isMaxMonth} style={{ background: "none", border: "none", color: isMaxMonth ? C.muted : C.mutedLight, cursor: isMaxMonth ? "default" : "pointer", padding: "0 4px", fontSize: 16, lineHeight: 1, fontFamily: FONT }}>›</button>
          </div>
        </div>
        <div style={{ padding: "12px 16px" }}>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(7,1fr)", marginBottom: 4 }}>
            {CAL_DAYS.map(d => (
              <div key={d} style={{ textAlign: "center", fontSize: 9, fontWeight: 700, color: C.muted, padding: "2px 0" }}>{d}</div>
            ))}
          </div>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(7,1fr)", gap: 1 }}>
            {calCells.map((d, i) => {
              const dayKey = d !== null
                ? `${calView.year}-${String(calView.month + 1).padStart(2,"0")}-${String(d).padStart(2,"0")}`
                : null;
              const dot = dayKey ? txDateMap[dayKey] : undefined;
              const dotColor = dot === "active" ? C.green : dot === "refunded" ? C.red : dot === "delayed" ? C.yellow : null;
              const isToday  = d !== null && nowForCal.getDate() === d && nowForCal.getMonth() === calView.month && nowForCal.getFullYear() === calView.year;
              return (
                <div key={i} style={{ textAlign: "center", padding: "3px 1px" }}>
                  {d !== null && (
                    <>
                      <span style={{ fontSize: 10, color: isToday ? C.orange : dotColor ? C.white : C.mutedMid, fontWeight: isToday ? 800 : dotColor ? 600 : 400, display: "block" }}>{d}</span>
                      {dotColor
                        ? <div style={{ width: 4, height: 4, borderRadius: "50%", background: dotColor, boxShadow: `0 0 4px ${dotColor}`, margin: "1px auto 0" }} />
                        : <div style={{ height: 5 }} />
                      }
                    </>
                  )}
                </div>
              );
            })}
          </div>
          <div style={{ display: "flex", gap: 12, marginTop: 10, paddingTop: 8, borderTop: `1px solid rgba(255,255,255,0.04)` }}>
            {([
              { color: C.green,  label: "Cobro"     },
              { color: C.yellow, label: "Retrasado" },
              { color: C.red,    label: "Reembolso" },
            ] as const).map(({ color, label }) => (
              <div key={label} style={{ display: "flex", alignItems: "center", gap: 5 }}>
                <div style={{ width: 6, height: 6, borderRadius: "50%", background: color, boxShadow: `0 0 4px ${color}`, flexShrink: 0 }} />
                <span style={{ fontSize: 9, color: C.muted }}>{label}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

```

- [ ] **Step 5: Verificar compilación TypeScript**

```bash
npm run build
```

Esperado: sin errores. Errores comunes:
- `Type 'string' is not assignable to type 'DotStatus'` → verificar el tipo del map en `buildTxDateMap`
- `Cannot find name 'CAL_DAYS'` → confirmar que se agregaron al bloque de helpers fuera del componente

- [ ] **Step 6: Verificar en el browser**

```bash
npm run dev
```

Abrir `http://localhost:5173`, ir a Usuarios, seleccionar un usuario con historial. Verificar:
- El header de perfil muestra chips de Email, WhatsApp (si hay teléfono), País
- El calendario aparece entre Stats y Historial de pagos
- Los días con transacciones tienen dot de color
- Las flechas `‹` / `›` navegan entre meses
- La flecha `›` está deshabilitada en el mes actual

- [ ] **Step 7: Commit**

```bash
git add src/views/UsersView.tsx
git commit -m "feat: calendario de actividad de pagos en perfil de usuario (UsersView)"
```

---

## Task 7: Push y deploy

- [ ] **Step 1: Verificar build final limpio**

```bash
npm run build
```

Esperado: `✓ built in X.Xs`, sin errores ni warnings de tipos.

- [ ] **Step 2: Push a main**

```bash
git push origin main
```

El pipeline `.github/workflows/deploy.yml` se dispara automáticamente: build Docker → push ghcr.io → webhook Easypanel.

- [ ] **Step 3: Verificar deploy**

```bash
gh run list --limit 3 --workflow deploy.yml --repo contenido-wq/aivi_core
```

Esperado: el run más reciente en estado `completed / success`.

- [ ] **Step 4: Deploy del Edge Function actualizado**

El `hotmart-webhook` modificado necesita hacer deploy separado vía Supabase CLI:

```bash
npx supabase functions deploy hotmart-webhook --project-ref jihyeeimmhfqlpzljrbu
```

Si el CLI no está autenticado: `npx supabase login` primero.

---

## Self-review checklist

- [x] **Spec coverage:** Contacto (email/WA/país) ✓ | Calendario heatmap con dots de color ✓ | `recalcDailyMetrics` USD ✓ | Botón sync ✓
- [x] **No placeholders:** Todos los pasos tienen código completo
- [x] **Tipos consistentes:** `DotStatus` definido en Task 6 Step 1, usado en Step 3 y Step 4. `phone: string | null` definido en Task 1 Step 1, usado en Task 5 Step 3 (`selected.phone`)
- [x] **Orden de dependencias correcto:** `dashboard.ts` (T1) → `TopNav` (T3) → `DashboardView` (T4) → `UsersView` (T5,T6)
