# Panel de Prospección AIVI — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Agregar inteligencia de prospección AIVI al panel de Trazabilidad de Usuarios existente: card de productos por familia, score de prospección con razones en español, y filtro multi-producto en el listado.

**Architecture:** Todo el cálculo ocurre en el frontend sobre datos ya cargados (`selected.transactions`), sin nuevas consultas a Supabase. Se agrega `getProductFamily()` en `dashboard.ts` y se exporta para uso en `UsersView.tsx`. El panel derecho reemplaza el "Score de Retención" con la card "Prospección AIVI" (que internamente maneja dos estados: sin AIVI / ya es cliente AIVI).

**Tech Stack:** React 18, TypeScript, inline styles (patrón existente del proyecto), Clipboard API para copiar razones.

**Spec:** `docs/superpowers/specs/2026-05-30-panel-prospeccion-design.md`

---

## Mapa de archivos

| Archivo | Acción | Responsabilidad |
|---|---|---|
| `src/services/dashboard.ts` | Modificar | Agregar `getProductFamily()`, `FAMILY_PATTERNS`, actualizar `ProductFilter` |
| `src/views/UsersView.tsx` | Modificar | Helpers de prospección, filtro multi-producto, badge N⬡, dos cards nuevas |

---

## Task 1: Agregar `getProductFamily()` y actualizar `ProductFilter` en `dashboard.ts`

**Files:**
- Modify: `src/services/dashboard.ts`

- [ ] **Step 1: Actualizar el tipo `ProductFilter` para incluir `"multiProducto"`**

En `src/services/dashboard.ts`, línea 4, reemplazar:
```typescript
export type ProductFilter = "todos" | "AIVI" | "MV3" | "sinAIVI";
```
por:
```typescript
export type ProductFilter = "todos" | "AIVI" | "MV3" | "sinAIVI" | "multiProducto";
```

- [ ] **Step 2: Agregar `FAMILY_PATTERNS` y `getProductFamily()` justo después de la línea del tipo `ProductFilter`**

Insertar después de la línea del tipo `ProductFilter` (línea ~4):
```typescript
const FAMILY_PATTERNS: Array<{ keywords: string[]; family: string }> = [
  { keywords: ["aivi"],                                    family: "AIVI" },
  { keywords: ["método v3", "metodo v3", "mv3"],           family: "Método V3" },
  { keywords: ["master creator"],                          family: "Master Creator" },
  { keywords: ["reto 11", "11d"],                          family: "Reto 11D" },
  { keywords: ["cero a viral", "de cero"],                 family: "De Cero a Viral" },
  { keywords: ["clon"],                                    family: "Haz que tu Clon te haga Viral" },
  { keywords: ["contenido que vende", "vende con ia"],     family: "Contenido que Vende con IA" },
];

export function getProductFamily(planName: string): string {
  const lower = (planName ?? "").toLowerCase();
  for (const { keywords, family } of FAMILY_PATTERNS) {
    if (keywords.some(k => lower.includes(k))) return family;
  }
  return planName; // fallback: nombre original del plan
}
```

- [ ] **Step 3: Actualizar `getUsersTraceability()` para tratar `"multiProducto"` como `"todos"`**

En `src/services/dashboard.ts`, función `getUsersTraceability` (línea ~655), el primer bloque de filtrado usa `filter`. Agregar este guard al inicio de la función, justo antes de la primera consulta a Supabase:

```typescript
export async function getUsersTraceability(filter: ProductFilter = "todos"): Promise<UserProfile[]> {
  // multiProducto se resuelve en el frontend — fetching como "todos"
  const fetchFilter: ProductFilter = filter === "multiProducto" ? "todos" : filter;

  const { data: allTx } = await supabase
    .from("transactions")
    .select("id, event_type, buyer_name, buyer_email, plan_name, amount, currency, created_at, status, raw_payload")
    .order("created_at", { ascending: false });
  // ... resto sin cambios, pero reemplazar todas las referencias a `filter` dentro de la función
  // por `fetchFilter` en las llamadas que van a Supabase
```

**Importante:** dentro de `getUsersTraceability`, las referencias a `filter` en las llamadas `matchesPlan(...)` deben usar `fetchFilter`. Las referencias que controlan la lógica `sinAIVI` deben seguir usando `fetchFilter`. Revisar que `matchesPlan(sub.plan_name, filter)` → `matchesPlan(sub.plan_name, fetchFilter)` y el bloque `if (filter === "sinAIVI")` → `if (fetchFilter === "sinAIVI")`.

- [ ] **Step 4: Verificar que TypeScript no tiene errores**

```bash
cd /Users/jheitrujillo/Proyectos/aivi_core && npx tsc --noEmit 2>&1 | head -30
```
Esperado: sin errores relacionados con `ProductFilter` o `getProductFamily`.

- [ ] **Step 5: Commit**

```bash
git add src/services/dashboard.ts
git commit -m "feat: add getProductFamily() and multiProducto filter type"
```

---

## Task 2: Agregar helpers de prospección en `UsersView.tsx`

**Files:**
- Modify: `src/views/UsersView.tsx`

Estos son funciones puras que viven a nivel de módulo (fuera del componente), junto a las funciones `retentionScore` y `riskLabel` existentes (líneas ~71–85).

- [ ] **Step 1: Agregar el import de `getProductFamily`**

En `src/views/UsersView.tsx`, línea 5, agregar `getProductFamily` al import existente de `dashboard`:
```typescript
import { getUsersTraceability, getProductFamily } from "../services/dashboard";
```

- [ ] **Step 2: Agregar la interfaz `FamilySummary` y la función `getProductFamilySummary()`**

Insertar después de las funciones `retentionScore` / `riskLabel` (tras la línea ~85):
```typescript
interface FamilySummary {
  family:   string;
  count:    number;    // compras activas o delayed
  isActive: boolean;   // es el plan de suscripción actual
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
```

- [ ] **Step 3: Agregar `countFamilies()` — para el badge N⬡ del listado**

```typescript
function countFamilies(transactions: { planName: string; status: string }[]): number {
  const set = new Set<string>();
  for (const tx of transactions) {
    if (tx.status !== "active" && tx.status !== "delayed") continue;
    set.add(getProductFamily(tx.planName));
  }
  return set.size;
}
```

- [ ] **Step 4: Agregar `computeProspectingScore()`**

```typescript
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
```

- [ ] **Step 5: Agregar `getProspectingReasons()`**

```typescript
function getProspectingReasons(user: UserProfile, families: FamilySummary[]): string[] {
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

  if (user.ltv >= 200)
    reasons.push(`LTV de $${user.ltv.toFixed(0)} — cliente de alto valor`);

  if (user.status === "active")
    reasons.push("Suscripción activa — momento ideal para upsell");

  return reasons;
}
```

- [ ] **Step 6: Agregar `prospectScoreLabel()`**

```typescript
function prospectScoreLabel(score: number): { txt: string; color: string } {
  if (score >= 80) return { txt: "🔥 Listo para comprar", color: C.green  };
  if (score >= 55) return { txt: "Buen prospecto",        color: C.orange };
  if (score >= 30) return { txt: "Calentar primero",      color: C.yellow };
  return             { txt: "No priorizar",               color: C.muted  };
}
```

- [ ] **Step 7: Verificar TypeScript**

```bash
npx tsc --noEmit 2>&1 | head -30
```
Esperado: sin errores.

- [ ] **Step 8: Commit**

```bash
git add src/views/UsersView.tsx
git commit -m "feat: add prospecting helper functions (score, reasons, families)"
```

---

## Task 3: Filtro "Multi-producto" + badge `N⬡` en el listado izquierdo

**Files:**
- Modify: `src/views/UsersView.tsx`

- [ ] **Step 1: Actualizar `PROGRAM_FILTERS` para agregar "Multi-producto"**

En `UsersView.tsx`, la constante `PROGRAM_FILTERS` (línea ~87):
```typescript
const PROGRAM_FILTERS: { value: ProductFilter; label: string }[] = [
  { value: "todos",        label: "Todos"          },
  { value: "AIVI",         label: "AIVI"           },
  { value: "MV3",          label: "MV3"            },
  { value: "sinAIVI",      label: "Sin AIVI"       },
  { value: "multiProducto", label: "Multi-producto" },
];
```

- [ ] **Step 2: Actualizar la función `load()` para manejar `"multiProducto"`**

En el componente `UsersView`, función `load` (línea ~141):
```typescript
const load = async (pf: ProductFilter) => {
  setLoading(true);
  setSelected(null);
  const fetchFilter: ProductFilter = pf === "multiProducto" ? "todos" : pf;
  const data = await getUsersTraceability(fetchFilter);
  setUsers(data);
  if (data.length > 0) setSelected(data[0]);
  setLoading(false);
};
```

- [ ] **Step 3: Actualizar el memo `filtered` para aplicar el filtro de familias y ordenar**

En el componente, el memo `filtered` (línea ~152):
```typescript
const filtered = useMemo(() => {
  let list = users;

  // Filtro multi-producto: solo usuarios con 2+ familias distintas
  if (programFilter === "multiProducto") {
    list = list
      .filter(u => countFamilies(u.transactions) >= 2)
      .sort((a, b) => countFamilies(b.transactions) - countFamilies(a.transactions));
  }

  if (statusFilter !== "todos") list = list.filter(u => u.status === statusFilter);
  const q = query.toLowerCase();
  if (!q) return list;
  return list.filter(u =>
    u.email.toLowerCase().includes(q) ||
    u.name.toLowerCase().includes(q)  ||
    u.planName.toLowerCase().includes(q)
  );
}, [users, query, statusFilter, programFilter]);
```

- [ ] **Step 4: Agregar badge `N⬡` a cada fila del listado**

En el bloque de render de cada usuario en el listado izquierdo (dentro de `filtered.map(u => ...)`, línea ~305), agregar el badge junto al `statusBadge`:

```typescript
// Reemplazar la línea:
//   <div style={{ display: "flex", gap: 5, alignItems: "center" }}>
//     {statusBadge(u.status)}
//     <span style={{ fontSize: 9, color: C.label }}>
//       {flag(u.country)} {u.country !== "—" ? u.country : ""}
//     </span>
//   </div>
// por:
<div style={{ display: "flex", gap: 5, alignItems: "center" }}>
  {statusBadge(u.status)}
  <span style={{ fontSize: 9, color: C.label }}>
    {flag(u.country)} {u.country !== "—" ? u.country : ""}
  </span>
  {countFamilies(u.transactions) >= 2 && (
    <span style={{
      fontSize: 9, fontWeight: 700,
      color: C.orange, background: "rgba(255,107,44,0.12)",
      border: "1px solid rgba(255,107,44,0.25)",
      borderRadius: 4, padding: "1px 5px",
    }}>
      {countFamilies(u.transactions)}⬡
    </span>
  )}
</div>
```

- [ ] **Step 5: Verificar en browser**

Levantar el servidor de desarrollo:
```bash
npm run dev
```
Verificar:
1. La pestaña "Multi-producto" aparece en los filtros de programa
2. Al activarla solo se ven usuarios con 2+ productos y el primer usuario tiene el mayor N⬡
3. El badge `N⬡` es naranja y visible en el listado de todos los modos de filtro (no solo multi-producto)
4. Usuarios con un solo producto NO muestran el badge

- [ ] **Step 6: Commit**

```bash
git add src/views/UsersView.tsx
git commit -m "feat: add multi-product filter and N badge to user list"
```

---

## Task 4: Card "Productos del Ecosistema" en el panel derecho

**Files:**
- Modify: `src/views/UsersView.tsx`

- [ ] **Step 1: Calcular `familySummary` en el componente**

Dentro del componente `UsersView`, junto a los demás cálculos derivados de `selected` (cerca de la línea `const score = selected ? retentionScore(selected) : 0`):

```typescript
const familySummary: FamilySummary[] = selected
  ? getProductFamilySummary(selected.transactions, selected.planName)
  : [];
const hasAIVI = familySummary.some(f => f.family === "AIVI");
```

- [ ] **Step 2: Agregar la card en el `mainPanel`**

En el `mainPanel` (componente `<main>` que contiene las cards del perfil), agregar la card después del bloque `{/* Stats Row */}` y antes del `{/* Calendario de actividad */}`. Insertar:

```typescript
{/* Productos del Ecosistema */}
<div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 12, overflow: "hidden" }}>
  <div style={{ padding: "11px 16px", borderBottom: `1px solid ${C.border}`, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
    <span style={{ fontSize: 10, fontWeight: 600, letterSpacing: "0.08em", color: C.mutedMid, textTransform: "uppercase" }}>
      Productos del ecosistema
    </span>
    <span style={{ fontSize: 9, color: C.muted }}>
      {familySummary.length} familia{familySummary.length !== 1 ? "s" : ""}
    </span>
  </div>
  <div style={{ padding: "10px 16px", display: "flex", flexDirection: "column", gap: 6 }}>
    {familySummary.length === 0 ? (
      <p style={{ fontSize: 12, color: C.muted }}>Sin productos registrados.</p>
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
          background: f.count >= 2 ? "rgba(255,107,44,0.10)" : "transparent",
          border: f.count >= 2 ? "1px solid rgba(255,107,44,0.25)" : "1px solid transparent",
          borderRadius: 4, padding: "1px 7px",
        }}>
          ×{f.count}
        </span>
      </div>
    ))}
  </div>
</div>
```

- [ ] **Step 3: Verificar en browser**

Seleccionar un usuario con múltiples productos. Verificar:
1. La card aparece entre las Stats Row y el Calendario
2. Las familias están agrupadas correctamente (ej: 3 transacciones MV3 → "Método V3 ×3 🔁")
3. La familia AIVI aparece primero si existe
4. El ✓ verde aparece solo en la familia correspondiente al plan actual del usuario
5. Un usuario con solo MV3 no muestra AIVI en la lista

- [ ] **Step 4: Commit**

```bash
git add src/views/UsersView.tsx
git commit -m "feat: add product families card to user detail panel"
```

---

## Task 5: Card "Prospección AIVI" en el panel derecho (reemplaza Score de Retención)

**Files:**
- Modify: `src/views/UsersView.tsx`

- [ ] **Step 1: Calcular datos de prospección en el componente**

Junto a los cálculos de `familySummary` (Task 4, Step 1), agregar:

```typescript
const prospectScore   = selected ? computeProspectingScore(selected, familySummary) : 0;
const prospectReasons = selected && prospectScore >= 0 ? getProspectingReasons(selected, familySummary) : [];
const prospectLabel   = prospectScore >= 0 ? prospectScoreLabel(prospectScore) : { txt: "", color: "" };
```

- [ ] **Step 2: Reemplazar la sección "Score de Retención" en el `rightPanel`**

En el `rightPanel`, localizar el bloque `{/* Score de retención */}` (línea ~563–578). Reemplazarlo completamente con:

```typescript
{/* Prospección AIVI */}
<div>
  <div style={{ fontSize: 9, fontWeight: 600, letterSpacing: "0.1em", color: C.label, textTransform: "uppercase", marginBottom: 8 }}>
    Prospección AIVI
  </div>

  {hasAIVI ? (
    /* Estado B: Ya es cliente AIVI */
    <div style={{ background: "rgba(34,197,94,0.06)", border: "1px solid rgba(34,197,94,0.25)", borderRadius: 11, padding: 13 }}>
      <div style={{ display: "flex", alignItems: "center", gap: 7, marginBottom: 8 }}>
        <span style={{ fontSize: 14, color: C.green }}>✓</span>
        <span style={{ fontSize: 12, fontWeight: 700, color: C.green }}>Ya es cliente AIVI</span>
      </div>
      <div style={{ fontSize: 10, color: C.muted, marginBottom: 4 }}>
        Plan: <span style={{ color: C.mutedLight }}>{selected!.planName}</span>
      </div>
      <div style={{ height: 1, background: C.border, margin: "10px 0" }} />
      {/* Mantener score de retención para clientes AIVI */}
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 8 }}>
        <span style={{ fontSize: 9, fontWeight: 600, letterSpacing: "0.06em", color: C.label, textTransform: "uppercase" }}>Score retención</span>
        <span style={{ fontSize: 18, fontWeight: 900, color: riskLabel(retentionScore(selected!)).color }}>{retentionScore(selected!)}</span>
      </div>
      <div style={{ height: 4, background: "rgba(255,255,255,0.06)", borderRadius: 99, marginBottom: 8, overflow: "hidden" }}>
        <div style={{ height: "100%", width: `${retentionScore(selected!)}%`, borderRadius: 99, background: C.gradRetention, transition: "width 0.6s" }} />
      </div>
      <div style={{ fontSize: 10, color: C.muted }}>
        <span style={{ color: riskLabel(retentionScore(selected!)).color, fontWeight: 600 }}>
          {riskLabel(retentionScore(selected!)).txt}
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

      {/* Razones */}
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

      {/* Botones de acción */}
      <div style={{ display: "flex", gap: 7 }}>
        <a
          href={`mailto:${selected!.email}`}
          style={{
            flex: 1, textAlign: "center", padding: "7px 0",
            borderRadius: 7, background: C.orange, color: "#fff",
            fontSize: 11, fontWeight: 700, textDecoration: "none",
            display: "flex", alignItems: "center", justifyContent: "center", gap: 5,
          }}
        >
          ✉ Contactar
        </a>
        <button
          onClick={() => {
            const text = `Por qué ofrecerle AIVI a ${selected!.name !== "—" ? selected!.name : selected!.email}:\n\n` +
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
```

- [ ] **Step 3: Verificar TypeScript**

```bash
npx tsc --noEmit 2>&1 | head -40
```
Esperado: sin errores.

- [ ] **Step 4: Verificar en browser — caso sin AIVI**

Seleccionar un usuario con MV3 pero sin AIVI:
1. El score numérico aparece (ej: 75)
2. La barra de progreso refleja el score
3. La etiqueta aparece con color correcto ("Buen prospecto" en naranja)
4. Las razones se listan dinámicamente (deben ser las que aplican a ese usuario)
5. El botón "✉ Contactar" abre el mailto
6. El botón "📋 Copiar" copia el texto al portapapeles (verificar pegando en un editor)

- [ ] **Step 5: Verificar en browser — caso con AIVI**

Seleccionar un usuario que tenga AIVI en sus transacciones:
1. Aparece "✓ Ya es cliente AIVI" en verde
2. Se muestra el score de retención (el existente, no el de prospección)
3. No aparecen razones ni botones de contactar

- [ ] **Step 6: Verificar en browser — filtro multi-producto**

1. Activar el filtro "Multi-producto" en las pestañas
2. Solo usuarios con 2+ familias aparecen en el listado
3. El primero tiene el mayor N⬡
4. Al seleccionar uno, su card de prospección muestra razones que mencionan los múltiples productos

- [ ] **Step 7: Commit final**

```bash
git add src/views/UsersView.tsx
git commit -m "feat: add AIVI prospecting card with score, reasons, and action buttons"
```

---

## Criterios de aceptación final

Antes de considerar completo, verificar:

1. **Score correcto:** Un usuario con MV3 activo, sin AIVI, con renovaciones → score >= 75
2. **Score cero:** Un usuario sin ningún producto del ecosistema → score < 30, etiqueta "No priorizar"
3. **Ya cliente:** Un usuario con AIVI → muestra "Ya es cliente AIVI" + score de retención, sin botones de upsell
4. **Repeat buyer:** Un usuario con MV3 ×3 → la card de productos muestra "🔁" y la razón "Ha renovado Método V3 ×3" aparece
5. **Copiar:** El texto copiado incluye el nombre/email y todas las razones en formato bullet
6. **Multi-producto:** El filtro muestra solo usuarios con 2+ familias, ordenados desc
7. **Badge N⬡:** Visible en listado izquierdo solo para usuarios con 2+ familias, en todos los modos de filtro
8. **TypeScript:** `npx tsc --noEmit` sin errores
9. **Sin regresiones:** El historial de pagos, calendario, LTV hero y los filtros AIVI/MV3/sinAIVI siguen funcionando igual
