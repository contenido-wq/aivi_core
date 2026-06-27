# UI Brand Alignment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Alinear la UI de AIVI Core con el manual de marca oficial: una sola tipografía (Hanken Grotesk), paleta de 5 colores exactos (#101010 / #FFC252 / #FE803F / #FAFAFA / #FF413B), y efecto de glow atmosférico en cards.

**Architecture:** Tres capas de cambio: (1) tokens centralizados en `tokens.ts` e `index.css` que propagan cambios automáticamente, (2) valores hardcodeados en componentes que necesitan cambio explícito, (3) elemento visual de glow atmosférico en sidebar y cards. No hay cambios de layout ni de estructura de componentes.

**Tech Stack:** React 18 + TypeScript, Vite, CSS-in-JS (inline styles) + index.css para clases utilitarias.

## Global Constraints

- Idioma: Español neutro latinoamericano — no tocar copy existente
- Dark mode obligatorio: fondo `#101010`, nunca blanco
- Paleta permitida: SOLO `#101010`, `#FFC252`, `#FE803F`, `#FAFAFA`, `#FF413B` y sus versiones alpha/rgba
- Fuente: SOLO `Hanken Grotesk` (Thin/Light/Bold/Black) — eliminar Exo 2 completamente
- Sin nuevos componentes — modificar únicamente los existentes
- No cambiar lógica de negocio, solo estilos

## Mapeo de colores fuera de marca → marca

| Token/valor eliminado | Nuevo valor | Razón brand |
|---|---|---|
| `#7AC943` (green) | `#FE803F` (orange) | Activo/positivo = ejecución = naranja |
| `#3FA9F5` (blue) | `#FE803F` (orange) | Secundario → naranja primario |
| `#A78BFA` (purple) | `#FFC252` (yellow) | Inversión/plan = idea = amarillo |
| `#2DD4BF` (teal) | `#FE803F` (orange) | Sin soporte en marca |
| Reto 15D/11D: `#2FB7FF` | `#FF413B` | Reto = intensidad = rojo |
| Master Creator: `#A78BFA` | `#FAFAFA` | Premium/elite = blanco |
| Retention bar gradient (verde) | `#FFC252 → #FE803F → #FF413B` | Flujo AIVI idea→ejecución→resultado |

---

## Task 1: Tipografía — Eliminar Exo 2, elevar Hanken Grotesk Black

**Files:**
- Modify: `src/index.css:1`
- Modify: `src/tokens.ts:53`
- Modify: `src/components/dashboard/KPIRow.tsx:3,39-44`
- Modify: `src/components/layout/Sidebar.tsx:3,96,268`
- Modify: `src/components/dashboard/TopNav.tsx:3,113`

**Interfaces:**
- Consumes: `FONT_DISPLAY` export from tokens.ts (se elimina)
- Produce: ninguno nuevo — `FONT_DISPLAY` desaparece del sistema

- [ ] **Step 1: Actualizar Google Fonts — quitar Exo 2**

En `src/index.css` línea 1, reemplazar:
```css
@import url('https://fonts.googleapis.com/css2?family=Exo+2:wght@700;800;900&family=Hanken+Grotesk:wght@300;400;500;600;700;800;900&display=swap');
```
por:
```css
@import url('https://fonts.googleapis.com/css2?family=Hanken+Grotesk:wght@300;400;500;600;700;800;900&display=swap');
```

- [ ] **Step 2: Eliminar FONT_DISPLAY de tokens.ts**

En `src/tokens.ts`, reemplazar línea 53:
```ts
export const FONT_DISPLAY = "'Exo 2', sans-serif";
```
por:
```ts
export const FONT_DISPLAY = "'Hanken Grotesk', sans-serif";
```
(Dejarlo apuntando a Hanken Grotesk mientras se eliminan los usos; lo quitaremos al final de esta tarea.)

- [ ] **Step 3: Actualizar KPIRow — quitar FONT_DISPLAY, subir escala tipográfica**

En `src/components/dashboard/KPIRow.tsx`:

Cambiar línea 3:
```tsx
import { C, FONT_DISPLAY } from "../../tokens";
```
→
```tsx
import { C } from "../../tokens";
```

Cambiar líneas 39-44 dentro de `KPICard` (el bloque del valor numérico):
```tsx
<div style={{
  fontSize: compact ? 20 : 30, fontWeight: 900,
  color: hero ? "#fff" : valueColor,
  lineHeight: 1, letterSpacing: "-0.03em",
  overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
  fontFamily: FONT_DISPLAY,
}}>{value}</div>
```
→
```tsx
<div style={{
  fontSize: compact ? 24 : hero ? 42 : 36, fontWeight: 900,
  color: hero ? "#fff" : valueColor,
  lineHeight: 1, letterSpacing: "-0.04em",
  overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
}}>{value}</div>
```

- [ ] **Step 4: Actualizar Sidebar — quitar FONT_DISPLAY**

En `src/components/layout/Sidebar.tsx`:

Cambiar línea 3:
```tsx
import { C, FONT_DISPLAY } from "../../tokens";
```
→
```tsx
import { C } from "../../tokens";
```

Cambiar línea 96 (label "CORE" bajo el logo):
```tsx
<div style={{ fontSize: 9, fontWeight: 800, color: C.orange, letterSpacing: "0.14em", marginTop: 1, fontFamily: FONT_DISPLAY }}>CORE</div>
```
→
```tsx
<div style={{ fontSize: 9, fontWeight: 800, color: C.orange, letterSpacing: "0.14em", marginTop: 1 }}>CORE</div>
```

Cambiar línea 268 (valores MRR/ARR):
```tsx
<span style={{ fontSize: 14, fontWeight: 900, color: col, letterSpacing: "-.02em", fontFamily: FONT_DISPLAY }}>{v}</span>
```
→
```tsx
<span style={{ fontSize: 14, fontWeight: 900, color: col as string, letterSpacing: "-.02em" }}>{v}</span>
```

- [ ] **Step 5: Actualizar TopNav — quitar FONT_DISPLAY**

En `src/components/dashboard/TopNav.tsx`:

Cambiar línea 3:
```tsx
import { C, FONT_DISPLAY }     from "../../tokens";
```
→
```tsx
import { C }     from "../../tokens";
```

Encontrar la línea del reloj (aproximadamente línea 113) con `fontFamily: FONT_DISPLAY` y eliminar ese atributo:
```tsx
{!isMobile && <span style={{ color: C.mutedLight, fontVariantNumeric: "tabular-nums", fontFamily: FONT_DISPLAY, fontWeight: 700 }}>{time}</span>}
```
→
```tsx
{!isMobile && <span style={{ color: C.mutedLight, fontVariantNumeric: "tabular-nums", fontWeight: 700 }}>{time}</span>}
```

- [ ] **Step 6: Eliminar FONT_DISPLAY export de tokens.ts**

Ahora que no hay ningún consumidor, eliminar la línea de tokens.ts:
```ts
export const FONT_DISPLAY = "'Hanken Grotesk', sans-serif";
```
La línea desaparece completamente.

- [ ] **Step 7: Verificar en browser**

Correr `npm run dev` y confirmar:
- Los números KPI se ven en Hanken Grotesk Black, escala mayor (36/42px)
- La etiqueta "CORE" en sidebar usa Hanken Grotesk
- El reloj en TopNav usa Hanken Grotesk
- No hay errores de consola relacionados con fuentes

- [ ] **Step 8: Commit**

```bash
git add src/index.css src/tokens.ts src/components/dashboard/KPIRow.tsx src/components/layout/Sidebar.tsx src/components/dashboard/TopNav.tsx
git commit -m "design: remove Exo 2, use Hanken Grotesk Black for KPIs, scale up numeric typography"
```

---

## Task 2: Planet Glow — Glow atmosférico en cards y sidebar

**Files:**
- Modify: `src/index.css:100-153`
- Modify: `src/components/layout/Sidebar.tsx` (footer section)
- Modify: `src/components/dashboard/AtRiskPanel.tsx:64`
- Modify: `src/components/dashboard/DelayedPanel.tsx:15`

**Interfaces:**
- Produce: clases CSS `.aivi-card-glow-yellow` y `.aivi-card-glow-red` para uso en componentes

- [ ] **Step 1: Mejorar glow en .aivi-card y .aivi-card-highlight**

En `src/index.css`, reemplazar el bloque `.aivi-card` (líneas ~100-131):
```css
.aivi-card {
  background: linear-gradient(135deg, #1E1E1E 0%, #141414 100%);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: var(--radius-card);
  box-shadow:
    0 2px 0 0 rgba(255,255,255,0.035) inset,
    0 1px 0 0 rgba(255,255,255,0.02) inset,
    0 12px 30px rgba(0,0,0,0.25),
    0 4px 10px rgba(0,0,0,0.2);
  transition: border-color 0.2s ease, box-shadow 0.2s ease, transform 0.2s ease;
  position: relative;
}
```
→
```css
.aivi-card {
  background: linear-gradient(135deg, #1E1E1E 0%, #141414 100%);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: var(--radius-card);
  box-shadow:
    0 2px 0 0 rgba(255,255,255,0.035) inset,
    0 1px 0 0 rgba(255,255,255,0.02) inset,
    0 12px 30px rgba(0,0,0,0.25),
    0 4px 10px rgba(0,0,0,0.2),
    0 0 80px rgba(254,128,63,0.035);
  transition: border-color 0.2s ease, box-shadow 0.2s ease, transform 0.2s ease;
  position: relative;
}
```

Reemplazar `.aivi-card-highlight` (líneas ~147-153):
```css
.aivi-card-highlight {
  border-color: rgba(254,128,63,0.50) !important;
  box-shadow:
    0 0 0 1px rgba(254,128,63,0.12) inset,
    0 0 25px rgba(254,128,63,0.18),
    0 12px 30px rgba(0,0,0,0.25) !important;
}
```
→
```css
.aivi-card-highlight {
  border-color: rgba(254,128,63,0.50) !important;
  box-shadow:
    0 0 0 1px rgba(254,128,63,0.12) inset,
    0 0 100px rgba(254,128,63,0.22),
    0 0 40px rgba(254,128,63,0.14),
    0 12px 30px rgba(0,0,0,0.25) !important;
}
```

- [ ] **Step 2: Agregar variantes de glow por color de marca**

Después de `.aivi-card-highlight`, agregar:
```css
/* ── Card glow variants (brand colors) ──────────────────────────────────── */
.aivi-card-glow-yellow {
  border-color: rgba(255,194,82,0.30) !important;
  box-shadow:
    0 0 0 1px rgba(255,194,82,0.08) inset,
    0 0 80px rgba(255,194,82,0.12),
    0 0 30px rgba(255,194,82,0.08),
    0 12px 30px rgba(0,0,0,0.25) !important;
}
.aivi-card-glow-red {
  border-color: rgba(255,65,59,0.30) !important;
  box-shadow:
    0 0 0 1px rgba(255,65,59,0.08) inset,
    0 0 80px rgba(255,65,59,0.12),
    0 0 30px rgba(255,65,59,0.08),
    0 12px 30px rgba(0,0,0,0.25) !important;
}
```

- [ ] **Step 3: Agregar glow atmosférico al sidebar**

En `src/components/layout/Sidebar.tsx`, dentro del elemento `<aside>`, antes del cierre de `</aside>`, agregar un elemento decorativo de glow:

Encontrar la línea `return sidebarContent;` al final y antes del cierre del `sidebarContent`, justo antes del `</aside>` que cierra el aside, agregar:
```tsx
{/* Atmospheric brand glow */}
<div style={{
  position: "absolute",
  bottom: 0,
  left: 0,
  right: 0,
  height: 180,
  background: "radial-gradient(ellipse at 50% 100%, rgba(254,128,63,0.10) 0%, rgba(254,128,63,0.04) 45%, transparent 70%)",
  pointerEvents: "none",
  zIndex: 0,
}} />
```

Asegurarse de que el footer div tenga `position: "relative", zIndex: 1` para que quede por encima del glow. Agregar esas props al footer `<div>` de línea 253:
```tsx
<div style={{ padding: "14px 16px", borderTop: `1px solid ${C.border}`, position: "relative", zIndex: 1 }}>
```

- [ ] **Step 4: Aplicar glow amarillo a AtRiskPanel cuando hay usuarios**

En `src/components/dashboard/AtRiskPanel.tsx`, línea 64, cambiar el className del Card cuando hay usuarios en riesgo:
```tsx
<Card style={{ padding: "16px 18px", display: "flex", flexDirection: "column", overflow: mobile ? "visible" : "hidden", minHeight: 0, flex: mobile ? undefined : 1 }}>
```
→
```tsx
<Card className={users.length > 0 ? "aivi-card-glow-yellow" : undefined} style={{ padding: "16px 18px", display: "flex", flexDirection: "column", overflow: mobile ? "visible" : "hidden", minHeight: 0, flex: mobile ? undefined : 1 }}>
```

Verificar que `Card` acepta `className`. Leer `src/components/ui/Card.tsx` para confirmar y agregar la prop si no existe. Probablemente necesites agregar `className?: string` a las props del `Card` y pasarlo al div raíz.

- [ ] **Step 5: Aplicar glow amarillo a DelayedPanel cuando hay usuarios**

En `src/components/dashboard/DelayedPanel.tsx`, línea 15, aplicar el mismo patrón:
```tsx
<Card style={{ padding: "16px 18px", display: "flex", flexDirection: "column", overflow: mobile ? "visible" : "hidden", minHeight: 0, flex: mobile ? undefined : 1 }}>
```
→
```tsx
<Card className={users.length > 0 ? "aivi-card-glow-yellow" : undefined} style={{ padding: "16px 18px", display: "flex", flexDirection: "column", overflow: mobile ? "visible" : "hidden", minHeight: 0, flex: mobile ? undefined : 1 }}>
```

- [ ] **Step 6: Verificar en browser**

- Cards del dashboard tienen un sutil halo naranja ambiental
- El sidebar tiene un glow cálido que emana desde abajo
- AtRiskPanel y DelayedPanel brillan en amarillo cuando tienen usuarios
- No hay bordes ni efectos cortados ni overflow visual indeseado

- [ ] **Step 7: Commit**

```bash
git add src/index.css src/components/layout/Sidebar.tsx src/components/dashboard/AtRiskPanel.tsx src/components/dashboard/DelayedPanel.tsx src/components/ui/Card.tsx
git commit -m "design: add planet glow atmospheric lighting to cards and sidebar"
```

---

## Task 3: Sistema de color — Eliminar colores fuera de marca

**Files:**
- Modify: `src/tokens.ts` (valores de C.green, C.blue, C.purple, C.teal, gradRetention, greenSoft)
- Modify: `src/index.css` (badge-active, badge-trial, aivi-retention-bar)
- Modify: `src/components/dashboard/UsersTable.tsx` (FAMILY_COLORS)
- Modify: `src/components/dashboard/AtRiskPanel.tsx` (RISK_CONFIG hardcoded rgba)
- Modify: `src/components/dashboard/TopNav.tsx` (utmStatus ok hardcoded rgba)
- Modify: `src/components/ui/LiveBadge.tsx` (hardcoded green rgba)

**Interfaces:**
- Consumes: `C.green`, `C.blue`, `C.purple`, `C.teal` (valores cambian, nombres se mantienen para no romper importaciones)
- Produce: mismos nombres de token, nuevos valores de marca

- [ ] **Step 1: Remap valores en tokens.ts**

En `src/tokens.ts`, reemplazar el bloque de colores secundarios (líneas ~15-37):
```ts
  green:       "#7AC943",
  greenSoft:   "rgba(122,201,67,0.12)",
  blue:        "#3FA9F5",
  red:         "#FF413B",
  teal:        "#2DD4BF",
  purple:      "#A78BFA",
  pink:        "#F472B6",
```
→
```ts
  green:       "#FE803F",
  greenSoft:   "rgba(254,128,63,0.12)",
  blue:        "#FE803F",
  red:         "#FF413B",
  teal:        "#FE803F",
  purple:      "#FFC252",
  pink:        "#FF413B",
```

Y en el bloque de gradientes, reemplazar `gradRetention`:
```ts
  gradRetention: "linear-gradient(90deg, #7AC943, #B6E85C, #FFB84D)",
```
→
```ts
  gradRetention: "linear-gradient(90deg, #FFC252, #FE803F, #FF413B)",
```

- [ ] **Step 2: Actualizar badges CSS en index.css**

En `src/index.css`, reemplazar `.badge-active`:
```css
.badge-active {
  background: rgba(122,201,67,0.12);
  border: 1px solid rgba(122,201,67,0.35);
  color: #7AC943;
}
```
→
```css
.badge-active {
  background: rgba(254,128,63,0.12);
  border: 1px solid rgba(254,128,63,0.35);
  color: #FE803F;
}
```

Reemplazar `.badge-trial`:
```css
.badge-trial {
  background: rgba(63,169,245,0.12);
  border: 1px solid rgba(63,169,245,0.3);
  color: #3FA9F5;
}
```
→
```css
.badge-trial {
  background: rgba(255,194,82,0.12);
  border: 1px solid rgba(255,194,82,0.3);
  color: #FFC252;
}
```

Reemplazar `.aivi-retention-bar`:
```css
.aivi-retention-bar {
  background: linear-gradient(90deg, #7AC943, #B6E85C, #FFB84D);
}
```
→
```css
.aivi-retention-bar {
  background: linear-gradient(90deg, #FFC252, #FE803F, #FF413B);
}
```

- [ ] **Step 3: Actualizar FAMILY_COLORS en UsersTable**

En `src/components/dashboard/UsersTable.tsx`, reemplazar el objeto `FAMILY_COLORS` (líneas 15-21):
```ts
const FAMILY_COLORS: Record<string, string> = {
  "AIVI":           "#FE803F",
  "Método V3":      "#FFC247",
  "Reto 15D":       "#2FB7FF",
  "Reto 11D":       "#2FB7FF",
  "Master Creator": "#A78BFA",
};
```
→
```ts
const FAMILY_COLORS: Record<string, string> = {
  "AIVI":           "#FE803F",
  "Método V3":      "#FFC252",
  "Reto 15D":       "#FF413B",
  "Reto 11D":       "#FF413B",
  "Master Creator": "#FAFAFA",
};
```

- [ ] **Step 4: Actualizar RISK_CONFIG en AtRiskPanel (hardcoded rgba)**

En `src/components/dashboard/AtRiskPanel.tsx`, reemplazar el objeto `RISK_CONFIG` (líneas 11-15):
```ts
const RISK_CONFIG = {
  alto:  { color: C.red,    bg: "rgba(255,65,59,0.08)", border: "rgba(255,65,59,0.2)",  icon: AlertTriangle, label: "Alto" },
  medio: { color: C.yellow, bg: "rgba(255,194,82,0.08)", border: "rgba(255,194,82,0.2)", icon: Clock,         label: "Medio" },
  bajo:  { color: C.green,  bg: "rgba(34,197,94,0.08)",  border: "rgba(34,197,94,0.2)",  icon: Shield,        label: "Bajo" },
};
```
→
```ts
const RISK_CONFIG = {
  alto:  { color: C.red,    bg: "rgba(255,65,59,0.08)",   border: "rgba(255,65,59,0.2)",   icon: AlertTriangle, label: "Alto" },
  medio: { color: C.yellow, bg: "rgba(255,194,82,0.08)",  border: "rgba(255,194,82,0.2)",  icon: Clock,         label: "Medio" },
  bajo:  { color: C.orange, bg: "rgba(254,128,63,0.08)",  border: "rgba(254,128,63,0.2)",  icon: Shield,        label: "Bajo" },
};
```

También en `AtRiskPanel.tsx`, actualizar el array de resumen de riesgo (líneas ~87-91) que usa `C.green`:
```tsx
{ label: "Bajo", count: bajoCount, color: C.green },
```
→
```tsx
{ label: "Bajo", count: bajoCount, color: C.orange },
```

Y en `DaysBar` (línea 38):
```ts
const color = daysActive <= 2 ? C.red : daysActive <= 5 ? C.yellow : C.green;
```
→
```ts
const color = daysActive <= 2 ? C.red : daysActive <= 5 ? C.yellow : C.orange;
```

Y en la línea del monto del usuario (línea ~146):
```tsx
<span style={{ color: C.green, fontWeight: 700 }}>${u.amountUsd.toFixed(2)} USD</span>
```
→
```tsx
<span style={{ color: C.orange, fontWeight: 700 }}>${u.amountUsd.toFixed(2)} USD</span>
```

- [ ] **Step 5: Actualizar TopNav (hardcoded rgba verde en utmStatus)**

En `src/components/dashboard/TopNav.tsx`, buscar la línea ~90 con el estado utmStatus "ok":
```tsx
...(utmStatus === "ok" && { background: "rgba(34,197,94,0.08)", borderColor: "rgba(34,197,94,0.25)", color: C.green }),
```
→
```tsx
...(utmStatus === "ok" && { background: "rgba(254,128,63,0.08)", borderColor: "rgba(254,128,63,0.25)", color: C.orange }),
```

- [ ] **Step 6: Actualizar LiveBadge (hardcoded rgba verde)**

En `src/components/ui/LiveBadge.tsx`, cambiar todos los valores hardcodeados de green:
```tsx
background:    `${C.green}12`,
border:        `1px solid ${C.green}50`,
```
→ Estos ya se resolverán via C.green si cambió el valor del token.

Pero también hay valores hardcodeados como `background: C.green` en el punto pulsante:
```tsx
background: C.green, display: "inline-block",
```
→ Este también se resolverá con el token.

Verificar que el archivo no tiene rgba hardcodeados de verde `rgba(122,201,` o `rgba(34,197,`. Si los hay, reemplazarlos por `rgba(254,128,63,...)`.

- [ ] **Step 7: Verificar en browser**

- No hay ningún elemento verde (`#7AC943`) visible en la UI
- No hay ningún azul (`#3FA9F5`) ni morado (`#A78BFA`) ni teal visible
- FAMILY_COLORS: Reto 15D muestra rojo, Master Creator muestra blanco
- Badges de activo son naranja, badges de trial son amarillo
- La barra de retención usa el gradiente marca (amarillo→naranja→rojo)
- Sidebar "Resumen del día" > Ingresos: naranja, Inversión: amarillo, ROAS: amarillo
- LiveBadge LIVE: naranja (era verde)

- [ ] **Step 8: Commit**

```bash
git add src/tokens.ts src/index.css src/components/dashboard/UsersTable.tsx src/components/dashboard/AtRiskPanel.tsx src/components/dashboard/TopNav.tsx src/components/ui/LiveBadge.tsx
git commit -m "design: replace off-brand colors with brand palette (yellow/orange/red only)"
```

---

## Self-Review

**Spec coverage:**
- ✅ Eliminar Exo 2 → Task 1 completo
- ✅ Hanken Grotesk Black en KPIs a escala mayor → Task 1 Step 3
- ✅ Planet glow en cards → Task 2 Steps 1-2
- ✅ Glow atmosférico sidebar → Task 2 Step 3
- ✅ Glow en AtRisk/Delayed panels → Task 2 Steps 4-5
- ✅ badge-active verde → naranja → Task 3 Step 2
- ✅ badge-trial azul → amarillo → Task 3 Step 2
- ✅ FAMILY_COLORS azul/morado → rojo/blanco → Task 3 Step 3
- ✅ RISK_CONFIG hardcoded rgba verde → naranja → Task 3 Step 4
- ✅ TopNav utmStatus hardcoded rgba → Task 3 Step 5
- ✅ LiveBadge verde → naranja → Task 3 Step 6
- ✅ gradRetention verde → brand gradient → Task 3 Step 1 + Step 2

**Gaps identificados:**
- `DashFooter.tsx` usa C.green para MRR/ARR y el punto pulsante → se resolverá automáticamente con el token
- `TransactionsPanel.tsx` usa C.green para totales positivos → se resolverá automáticamente
- `CountriesPanel.tsx` usa C.green → se resolverá automáticamente
- `DailyPanel.tsx` usa C.green → se resolverá automáticamente
- `UsersView.tsx` usa C.green y C.blue → se resolverán automáticamente con los tokens
- `TransactionsView.tsx` usa C.green, C.purple, C.teal → se resolverán automáticamente

Todos los usos de C.green/C.blue/C.purple/C.teal en componentes React referencian el token, así que el cambio de valor en tokens.ts los propaga sin tocar esos archivos individualmente.

**Excepción confirmada:** Los únicos valores hardcodeados fuera de tokens.ts son:
1. `AtRiskPanel.tsx` RISK_CONFIG (cubierto en Task 3 Step 4)
2. `TopNav.tsx` utmStatus rgba (cubierto en Task 3 Step 5)
3. `index.css` badges y retention bar (cubiertos en Task 3 Step 2)
4. `UsersTable.tsx` FAMILY_COLORS (cubierto en Task 3 Step 3)
