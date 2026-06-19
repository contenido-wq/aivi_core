# Responsive Design Fix — Opción A — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Agregar breakpoints `isLarge`/`isXLarge` al sistema responsive existente, corregir el layout en monitores grandes (1440px+), arreglar la grilla rota del KPIRow en móvil, hacer UsersView responsive en móvil, y acortar los tabs de TransactionsView en móvil.

**Architecture:** El sistema responsive de la app es un hook de React (`useResponsive`) que devuelve flags booleanos basados en el ancho de ventana. Los componentes usan inline styles con esos flags. No hay Tailwind ni CSS modules — todo es CSS-in-JS con variables en `src/tokens.ts`. Las vistas (`DashboardView`, `TransactionsView`, `UsersView`) son los contenedores de layout; los componentes hijos solo reciben props o leen el hook directamente.

**Tech Stack:** Vite 6 + React 19 + TypeScript 5.8 + inline styles con CSS variables. Sin framework de testing unitario — la verificación es TypeScript (`tsc -b`) + inspección visual en el navegador.

## Global Constraints

- No modificar ningún breakpoint existente (`mobile`, `tablet`, `desktop`, `isShortScreen`) ni su lógica
- Mantener inline styles — no introducir clases CSS ni Tailwind
- No modificar lógica de datos ni servicios
- `isLarge` = width ≥ 1440px; `isXLarge` = width ≥ 1920px
- El sidebar en modo large es 240px (era 220px en desktop)
- El contenido total se capa en `maxWidth: 1920px` centrado cuando `isXLarge`
- Idioma de la UI: español neutro latinoamericano

---

## File Map

| Archivo | Cambio |
|---|---|
| `src/hooks/useResponsive.ts` | + `isLarge`, `isXLarge` en `ResponsiveState` y `calc()` |
| `src/components/dashboard/KPIRow.tsx` | Última KPICard con `gridColumn: "span 2"` en móvil |
| `src/views/DashboardView.tsx` | Sidebar 240px en large, max-width 1920px en xLarge, padding 32px en large |
| `src/views/TransactionsView.tsx` | Sidebar 240px en large, labels cortos en móvil, max-width 1920px en xLarge |
| `src/views/UsersView.tsx` | + `useResponsive`, layout móvil con toggle lista/detalle, grid responsive |

---

## Task 1: Agregar `isLarge` e `isXLarge` a `useResponsive`

**Files:**
- Modify: `src/hooks/useResponsive.ts`

**Interfaces:**
- Produces: `ResponsiveState.isLarge: boolean`, `ResponsiveState.isXLarge: boolean` — ambos disponibles para todos los consumidores del hook desde esta tarea en adelante.

- [ ] **Step 1: Abrir el archivo**

Leer `src/hooks/useResponsive.ts` para ver el estado actual. El archivo tiene la interface `ResponsiveState`, la función `calc()` interna, y el hook `useResponsive()`.

- [ ] **Step 2: Modificar `src/hooks/useResponsive.ts`**

Reemplazar el contenido completo del archivo con:

```ts
import { useState, useEffect, useCallback } from "react";

export type Breakpoint = "mobile" | "tablet" | "desktop";

interface ResponsiveState {
  bp: Breakpoint;
  isMobile: boolean;
  isTablet: boolean;
  isDesktop: boolean;
  isShortScreen: boolean;
  /** true when width >= 1440px (monitor externo, TV conectado a Mac) */
  isLarge: boolean;
  /** true when width >= 1920px (full HD+ o 4K) */
  isXLarge: boolean;
  width: number;
  height: number;
}

export function useResponsive(): ResponsiveState {
  const calc = useCallback((): ResponsiveState => {
    const w = typeof window !== "undefined" ? window.innerWidth  : 1200;
    const h = typeof window !== "undefined" ? window.innerHeight : 900;
    const isShortScreen = h < 820;
    const isLarge  = w >= 1440;
    const isXLarge = w >= 1920;
    if (w < 768)  return { bp: "mobile",  isMobile: true,  isTablet: false, isDesktop: false, isShortScreen, isLarge, isXLarge, width: w, height: h };
    if (w < 1024) return { bp: "tablet",  isMobile: false, isTablet: true,  isDesktop: false, isShortScreen, isLarge, isXLarge, width: w, height: h };
    return                { bp: "desktop", isMobile: false, isTablet: false, isDesktop: true,  isShortScreen, isLarge, isXLarge, width: w, height: h };
  }, []);

  const [state, setState] = useState<ResponsiveState>(calc);

  useEffect(() => {
    let raf: number;
    const onResize = () => {
      cancelAnimationFrame(raf);
      raf = requestAnimationFrame(() => setState(calc()));
    };
    window.addEventListener("resize", onResize, { passive: true });
    window.addEventListener("orientationchange", onResize);
    return () => {
      cancelAnimationFrame(raf);
      window.removeEventListener("resize", onResize);
      window.removeEventListener("orientationchange", onResize);
    };
  }, [calc]);

  return state;
}
```

- [ ] **Step 3: Verificar tipos**

```bash
npx tsc -b --noEmit
```

Esperado: sin errores de TypeScript. Si hay errores, son por consumidores del hook que usan destructuring — los va a resolver el resto de las tareas.

- [ ] **Step 4: Commit**

```bash
git add src/hooks/useResponsive.ts
git commit -m "feat(responsive): add isLarge and isXLarge breakpoints"
```

---

## Task 2: KPIRow — 5.ª tarjeta ocupa ancho completo en móvil

**Files:**
- Modify: `src/components/dashboard/KPIRow.tsx`

**Interfaces:**
- Consumes: `useResponsive()` → `isMobile`, `isTablet` (ya existe en el componente)
- Produces: sin cambio de interface pública

- [ ] **Step 1: Leer el archivo**

Abrir `src/components/dashboard/KPIRow.tsx`. La función `KPIRow` tiene 5 llamadas a `<KPICard>`. La última es la de "Atrasados" (con `icon={<Clock size={iconSize}/>}`).

- [ ] **Step 2: Modificar el return de `KPIRow`**

Envolver únicamente la 5.ª `<KPICard>` con un `<div>` que tiene `gridColumn: "span 2"` solo en móvil. Las primeras 4 tarjetas no cambian.

Reemplazar el bloque del `return` en `KPIRow` (la parte del `<div>` externo y sus 5 hijos) con:

```tsx
return (
  <div style={{
    display: "grid",
    gridTemplateColumns: gridCols,
    gap: isMobile ? 8 : 10,
    padding: isMobile ? "8px 12px" : "10px 24px",
    flexShrink: 0,
  }}>
    <KPICard icon={<DollarSign size={iconSize}/>} label="Facturación Bruta"
      value={fmt(kpis?.grossRevenue ?? 0)} valueColor={C.green} hero compact={compact}
      sub={
        weekRevenue > 0
          ? `${kpis?.monthsActive ?? 0} meses · sem ${fmtShort(weekRevenue)} · mes ${fmtShort(monthRevenue)}`
          : `${kpis?.monthsActive ?? 0} ${(kpis?.monthsActive ?? 0) === 1 ? "mes" : "meses"} activo`
      }
    />
    <KPICard icon={<BarChart2 size={iconSize}/>}  label="Inversión Total"    value={fmt(kpis?.investment ?? 0)}   valueColor={C.yellow} compact={compact} sub={filter === "todos" ? "Pauta Meta Ads · total cuenta" : "Pauta Meta Ads · cuenta total"} />
    <KPICard icon={<TrendingUp size={iconSize}/>} label="ROAS"               value={`${roas.toFixed(2)}x`}        valueColor={C.yellow} sub={filter === "todos" ? "Ingresos / Inversión" : "Revenue producto / Pauta total"} compact={compact} />
    <KPICard
      icon={<Users size={iconSize}/>} label="Activos / Cancel"
      value={<span>
        <span style={{ color: C.green }}>{kpis?.activeTotal ?? 0}</span>
        <span style={{ color: C.muted, fontSize: compact ? 16 : 22, margin: "0 4px" }}>/</span>
        <span style={{ color: C.red }}>{kpis?.cancelled ?? 0}</span>
      </span>}
      valueColor={C.green}
      sub={
        (daily?.newUsers ?? 0) > 0
          ? `+${daily!.newUsers} nuevos hoy`
          : undefined
      }
      compact={compact}
    />
    {/* Última tarjeta: span 2 en móvil para no quedar sola a la izquierda */}
    <div style={isMobile ? { gridColumn: "span 2" } : undefined}>
      <KPICard icon={<Clock size={iconSize}/>} label="Atrasados" value={kpis?.delayed ?? 0} valueColor={C.yellow} sub="Pagos pendientes" compact={compact} />
    </div>
  </div>
);
```

- [ ] **Step 3: Verificar tipos**

```bash
npx tsc -b --noEmit
```

Esperado: sin errores.

- [ ] **Step 4: Commit**

```bash
git add src/components/dashboard/KPIRow.tsx
git commit -m "fix(kpi): last card spans full width on mobile grid"
```

---

## Task 3: DashboardView — sidebar 240px en large, max-width en xLarge, padding escalado

**Files:**
- Modify: `src/views/DashboardView.tsx`

**Interfaces:**
- Consumes: `useResponsive()` → destructurar también `isLarge`, `isXLarge`

- [ ] **Step 1: Actualizar el destructuring de `useResponsive`**

En `DashboardView.tsx`, buscar la línea:

```ts
const { isMobile, isTablet, isDesktop, isShortScreen } = useResponsive();
```

Reemplazarla con:

```ts
const { isMobile, isTablet, isDesktop, isShortScreen, isLarge, isXLarge } = useResponsive();
```

- [ ] **Step 2: Actualizar el sidebar width**

En la prop `isMobile` del componente `<Sidebar>` ya existe la lógica de ancho dentro de `Sidebar.tsx`. Esa lógica lee el prop `isMobile` pero el ancho está hardcodeado internamente en el componente. Para el sidebar, la prop que controla el ancho en desktop se define dentro de `Sidebar.tsx`.

Abrir `src/components/layout/Sidebar.tsx` y en el bloque donde se define `sidebarContent`:

```tsx
// Buscar esta línea:
width: isMobile ? 270 : 220,
// Reemplazar con:
width: isMobile ? 270 : isLarge ? 240 : 220,
```

Pero `isLarge` no está disponible en Sidebar como prop. La solución es pasar un nuevo prop opcional `sidebarWidth` desde DashboardView, o simplemente exponer el cálculo desde el padre.

**Enfoque más limpio:** no agregar prop a Sidebar. En cambio, DashboardView calcula el `sidebarWidth` y lo pasa como prop. Agregar prop `width?: number` a `SidebarProps`:

En `src/components/layout/Sidebar.tsx`, agregar `width?: number` a la interface `SidebarProps`:

```tsx
interface SidebarProps {
  // ... props existentes ...
  /** Override the sidebar width (desktop only). Default: 220 */
  width?: number;
}
```

Y en el `sidebarContent`, cambiar:

```tsx
// Buscar:
width: isMobile ? 270 : 220,
// Reemplazar con:
width: isMobile ? 270 : (width ?? 220),
```

Y en la destructuración de props al inicio de la función `Sidebar`, agregar `width`:

```tsx
export function Sidebar({ filter, onFilter, onSettings, onSignOut, onDashboard, onUsers, onTransactions, activeView, mrr, arr, daily, open, onClose, isMobile, isAdmin = false, width }: SidebarProps) {
```

- [ ] **Step 3: En `DashboardView`, calcular y pasar `sidebarWidth`**

Justo después del destructuring de `useResponsive`, agregar:

```tsx
const sidebarWidth = (isMobile || isTablet) ? 0 : (isLarge ? 240 : 220);
```

Pasar la prop al componente `<Sidebar>`:

```tsx
<Sidebar
  // ... props existentes ...
  width={isLarge ? 240 : 220}
/>
```

- [ ] **Step 4: Actualizar `marginLeft` y `maxWidth` del contenedor de contenido**

En `DashboardView`, buscar el `<div>` con `marginLeft: (isMobile || isTablet) ? 0 : 220`:

```tsx
// Buscar:
marginLeft: (isMobile || isTablet) ? 0 : 220,
// Reemplazar con:
marginLeft: (isMobile || isTablet) ? 0 : sidebarWidth,
```

Y agregar `maxWidth` al mismo div para pantallas xLarge:

```tsx
<div style={{
  marginLeft: (isMobile || isTablet) ? 0 : sidebarWidth,
  flex: 1,
  display: "flex",
  flexDirection: "column",
  overflow: "hidden",
  position: "relative",
  width: "100%",
  // Nuevo: cap total layout en 4K
  ...(isXLarge && { maxWidth: `calc(100vw - ${sidebarWidth}px)` }),
}}>
```

Wait, esto no es correcto. En 4K queremos que toda la app tenga un tope, no solo el contenido.

**Enfoque correcto para xLarge:** Agregar `maxWidth` al div EXTERIOR (el que tiene `display: "flex"`):

```tsx
// Buscar el div más exterior del DashboardView return:
<div style={{ display: "flex", height: "100vh", background: C.bg, overflow: "hidden" }}>
// Reemplazar con:
<div style={{
  display: "flex",
  height: "100vh",
  background: C.bg,
  overflow: "hidden",
  ...(isXLarge && { maxWidth: 1920, margin: "0 auto" }),
}}>
```

Esto centra toda la app (sidebar incluido) en pantallas 4K, con un máximo de 1920px.

- [ ] **Step 5: Actualizar el padding `px`**

```tsx
// Buscar:
const px = isMobile ? 12 : isTablet ? 16 : 24;
// Reemplazar con:
const px = isMobile ? 12 : isTablet ? 16 : isLarge ? 32 : 24;
```

- [ ] **Step 6: Verificar tipos**

```bash
npx tsc -b --noEmit
```

- [ ] **Step 7: Commit**

```bash
git add src/components/layout/Sidebar.tsx src/views/DashboardView.tsx
git commit -m "feat(responsive): sidebar 240px and max-width cap on large screens"
```

---

## Task 4: TransactionsView — large screen + labels cortos en móvil

**Files:**
- Modify: `src/views/TransactionsView.tsx`

**Interfaces:**
- Consumes: `useResponsive()` → también `isLarge`, `isXLarge`

- [ ] **Step 1: Actualizar destructuring de `useResponsive`**

Buscar en `TransactionsView.tsx`:

```ts
const { isMobile, isTablet } = useResponsive();
```

Reemplazar con:

```ts
const { isMobile, isTablet, isLarge, isXLarge } = useResponsive();
```

- [ ] **Step 2: Agregar labels cortos a las categorías**

Al inicio del archivo, donde está definido el array `CATEGORIES`, reemplazarlo con:

```ts
const CATEGORIES: { key: TxCategory; label: string; shortLabel: string; color: string }[] = [
  { key: "compras",               label: "Compras Aprobadas",        shortLabel: "Compras",     color: C.green   },
  { key: "solicitudes_reembolso", label: "Solicitudes de Reembolso", shortLabel: "Reembolso",   color: C.yellow  },
  { key: "reembolsos",            label: "Reembolsos Hechos",        shortLabel: "Reembolsos",  color: C.orange  },
  { key: "cancelaciones",         label: "Cancelaciones",            shortLabel: "Cancelac.",   color: C.red     },
  { key: "atrasados",             label: "Atrasados",                shortLabel: "Atrasados",   color: C.purple  },
  { key: "chargeback",            label: "Tarjeta Rechazada",        shortLabel: "Chargeback",  color: C.pink    },
];
```

- [ ] **Step 3: Usar `shortLabel` en los tabs de móvil**

Buscar en el JSX el botón de categorías que muestra `AIVI {cat.label.toUpperCase()}`:

```tsx
// Buscar:
AIVI {cat.label.toUpperCase()}
// Reemplazar con:
{isMobile ? cat.shortLabel : `AIVI ${cat.label.toUpperCase()}`}
```

- [ ] **Step 4: Agregar `sidebarWidth` y actualizar `marginLeft`**

Calcular el ancho del sidebar (igual que en DashboardView):

```tsx
const isMobileLayout = isMobile || isTablet;
const sidebarWidth = isMobileLayout ? 0 : (isLarge ? 240 : 220);
```

En el `<Sidebar>` de TransactionsView, agregar la prop `width`:

```tsx
<Sidebar
  // ... props existentes ...
  width={isLarge ? 240 : 220}
/>
```

Actualizar el `marginLeft` del contenedor de contenido:

```tsx
// Buscar:
marginLeft: isMobileLayout ? 0 : 220,
// Reemplazar con:
marginLeft: sidebarWidth,
```

- [ ] **Step 5: Agregar `maxWidth` en xLarge al div exterior**

```tsx
// Buscar el div más exterior:
<div style={{ display: "flex", height: "100vh", background: C.bg, fontFamily: FONT, color: C.white, overflow: "hidden" }}>
// Reemplazar con:
<div style={{
  display: "flex",
  height: "100vh",
  background: C.bg,
  fontFamily: FONT,
  color: C.white,
  overflow: "hidden",
  ...(isXLarge && { maxWidth: 1920, margin: "0 auto" }),
}}>
```

- [ ] **Step 6: Verificar tipos**

```bash
npx tsc -b --noEmit
```

- [ ] **Step 7: Commit**

```bash
git add src/views/TransactionsView.tsx
git commit -m "feat(responsive): large screen cap and short tab labels on mobile"
```

---

## Task 5: UsersView — layout responsive en móvil

**Files:**
- Modify: `src/views/UsersView.tsx`

**Interfaces:**
- Consumes: `useResponsive()` → `isMobile`, `isLarge`, `isXLarge`

La vista actualmente usa un grid de 3 columnas fijas `"280px 1fr 330px"`. En móvil (<768px), esto hace que el contenido se salga de la pantalla porque 280+330=610px más la columna central no caben. La solución es:
- En móvil: mostrar lista de usuarios O panel de detalle, nunca los dos al mismo tiempo
- En desktop/tablet: mantener el grid actual sin cambios
- En large (1440px+): ajustar el grid para dar más espacio al panel central

- [ ] **Step 1: Agregar importación de `useResponsive`**

Al inicio de `UsersView.tsx`, ya existen imports de React y otros. Agregar al bloque de imports desde hooks:

```tsx
import { useResponsive } from "../hooks/useResponsive";
```

- [ ] **Step 2: Usar el hook dentro de `UsersView`**

Al inicio de la función `UsersView`, justo después de los `useState`, agregar:

```tsx
const { isMobile, isLarge, isXLarge } = useResponsive();
```

- [ ] **Step 3: Agregar estado para vista activa en móvil**

La vista móvil necesita saber si mostrar la lista o el detalle. Agregar:

```tsx
const [mobileView, setMobileView] = useState<"list" | "detail">("list");
```

Y cuando el usuario selecciona un usuario (en la función que llama `setSelected`), en móvil también cambiar a la vista de detalle. En el `onClick` del item de la lista:

```tsx
// Buscar el onClick en los items de la lista filtered.map:
onClick={() => setSelected(u)}
// Reemplazar con:
onClick={() => { setSelected(u); if (isMobile) setMobileView("detail"); }}
```

- [ ] **Step 4: Agregar botón "Volver a lista" en el topbar para móvil**

En el `topbar` (el elemento `<header>`), agregar un botón condicional para volver en móvil. Buscar en el `topbar` el primer `<button onClick={onBack}>`:

```tsx
// Justo antes del botón onBack, agregar:
{isMobile && mobileView === "detail" && (
  <button onClick={() => setMobileView("list")} style={{
    background: "none", border: "none", color: C.mutedLight,
    display: "flex", alignItems: "center", gap: 5, fontSize: 12,
    cursor: "pointer", padding: "6px 10px", borderRadius: 8,
  }}>
    <ArrowLeft size={14} /> Lista
  </button>
)}
```

- [ ] **Step 5: Actualizar el `gridTemplateColumns` según breakpoint**

En el `return` de `UsersView`, el div exterior tiene:

```tsx
gridTemplateColumns: "280px 1fr 330px",
```

Reemplazar la lógica completa del return con:

```tsx
// En móvil: columna única, mostramos una panel a la vez
// En tablet/desktop: grid original
// En large: grid con más espacio central

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
    {/* En móvil: solo mostrar el panel activo */}
    {isMobile ? (
      mobileView === "list" ? leftPanel : (
        <>
          {mainPanel}
          {rightPanel ?? <aside style={{ display: "none" }} />}
        </>
      )
    ) : (
      <>
        {leftPanel}
        {mainPanel}
        {rightPanel ?? <aside style={{ borderLeft: `1px solid ${C.border}`, background: C.sidebar }} />}
      </>
    )}
    <style>{`@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`}</style>
  </div>
);
```

**Nota sobre el grid en móvil con una sola columna:** El `topbar` tiene `gridColumn: "1/-1"` lo que en una grilla de 1 columna funciona correctamente. `leftPanel` y `mainPanel` son `<aside>` y `<main>` que ocuparán la columna completa. En móvil solo se renderiza uno a la vez, por lo que no hay conflicto.

- [ ] **Step 6: Ajustar el `rightPanel` en móvil**

En móvil, cuando `mobileView === "detail"`, se muestran `mainPanel` y `rightPanel` apilados verticalmente. Pero el grid de 1 columna los pondrá uno debajo del otro, lo cual puede ser largo. Para simplificar, en móvil solo mostrar `mainPanel` sin `rightPanel`. Reemplazar la sección de móvil en el return:

```tsx
{isMobile ? (
  mobileView === "list" ? leftPanel : mainPanel
) : (
  <>
    {leftPanel}
    {mainPanel}
    {rightPanel ?? <aside style={{ borderLeft: `1px solid ${C.border}`, background: C.sidebar }} />}
  </>
)}
```

- [ ] **Step 7: Verificar tipos**

```bash
npx tsc -b --noEmit
```

Esperado: sin errores. Si hay errores de tipo por `mobileView`, verificar que el tipo sea `"list" | "detail"`.

- [ ] **Step 8: Commit**

```bash
git add src/views/UsersView.tsx
git commit -m "feat(responsive): UsersView mobile layout with list/detail toggle"
```

---

## Task 6: Verificación visual en el navegador

- [ ] **Step 1: Iniciar el servidor de desarrollo**

```bash
npm run dev
```

Abrir el navegador en `http://localhost:5173`.

- [ ] **Step 2: Verificar móvil (375px)**

Abrir DevTools → Device Toolbar → iPhone SE (375×667).

Verificar:
- Los 5 KPIs se muestran en 2 filas: fila 1 tiene 2 tarjetas, fila 2 tiene 2 tarjetas, fila 3 tiene 1 tarjeta (Atrasados) que ocupa el ancho completo
- El sidebar se abre como drawer al tocar el hamburger
- En Transacciones, los tabs dicen "Compras", "Reembolso", etc. (no el texto largo)
- En Usuarios, se ve la lista primero. Al tocar un usuario, aparece el detalle. El topbar tiene botón "← Lista" para volver.

- [ ] **Step 3: Verificar tablet (768px)**

En DevTools cambiar a iPad Mini (768×1024) en portrait.

Verificar:
- Sidebar funciona como drawer (hamburger visible)
- KPIs en grilla 3 columnas
- Layout de columna única para las secciones de abajo
- UsersView muestra el grid de 3 columnas (no el layout móvil de toggle)

- [ ] **Step 4: Verificar laptop corta (1280×768)**

En DevTools, responsive mode → 1280×768.

Verificar:
- Sidebar visible a 220px (no llega a isLarge=1440)
- Layout scrollable (isShortScreen activo porque alto < 820px)
- Todo igual que antes

- [ ] **Step 5: Verificar large (1440px)**

En DevTools → responsive mode → 1440×900.

Verificar:
- Sidebar se amplía a 240px
- Padding horizontal del contenido es 32px
- UsersView muestra `gridTemplateColumns: "300px 1fr 360px"`

- [ ] **Step 6: Verificar xLarge (1920px)**

En DevTools → responsive mode → 1920×1080.

Verificar:
- La app tiene un ancho máximo de 1920px y está centrada (verificar con una resolución simulada de 2560px)
- A 1920px exactos, ocupa toda la pantalla sin padding extra

- [ ] **Step 7: Build de producción**

```bash
npm run build
```

Esperado: build exitoso sin errores de TypeScript ni warnings críticos.

- [ ] **Step 8: Commit final**

```bash
git add -A
git commit -m "chore: verify responsive design across breakpoints"
```

---

## Self-Review

**Spec coverage:**
- ✅ `isLarge`/`isXLarge` agregados a `useResponsive` (Task 1)
- ✅ Sidebar 240px en large (Task 3, Task 4)
- ✅ `maxWidth: 1920px` centrado en xLarge (Task 3, Task 4, Task 5)
- ✅ KPIRow 5.ª tarjeta `span 2` en móvil (Task 2)
- ✅ UsersView responsive con toggle lista/detalle en móvil (Task 5)
- ✅ Labels cortos en tabs de TransactionsView en móvil (Task 4)

**Placeholder scan:** Sin TBD, TODO ni secciones vacías. Cada step tiene código o comando concreto.

**Type consistency:**
- `isLarge`/`isXLarge` definidos en Task 1, consumidos en Tasks 3, 4, 5 — nombres consistentes
- Prop `width?: number` agregada a `SidebarProps` en Task 3, usada en Task 4 — consistente
- `mobileView: "list" | "detail"` definido y usado solo en Task 5 — sin conflicto
