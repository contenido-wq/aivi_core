# Mobile Bottom Navigation — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reemplazar el hamburguesa del drawer en móvil con una barra de navegación fija en la parte inferior que muestra Dashboard, Usuarios, Transacciones y un botón Filtro con bottom sheet.

**Architecture:** Un nuevo componente `MobileBottomNav` (con `FilterSheet` embebido) se agrega a cada vista. El `Sidebar` retorna `null` en móvil. El botón hamburguesa se elimina de `TopNav` y del header de `TransactionsView`. `UsersView` recibe props `onDashboard` y `onTransactions`. `App.tsx` los pasa.

**Tech Stack:** React 19 + TypeScript 5.8, inline styles, CSS variables desde `src/tokens.ts`, íconos Lucide React, sin framework de tests (verificación vía `tsc -b --noEmit` + inspección visual).

## Global Constraints

- Solo inline styles — sin clases CSS ni Tailwind
- Solo modifica comportamiento móvil (`isMobile` = width < 768px) — tablet y desktop sin cambios
- Idioma UI: español neutro latinoamericano
- Colores del objeto `C` en `src/tokens.ts`
- Fuente de la constante `FONT` en `src/tokens.ts`
- Tipo `ProductFilter` desde `src/services/dashboard`

---

## File Map

| Archivo | Acción |
|---|---|
| `src/components/layout/MobileBottomNav.tsx` | Crear |
| `src/components/layout/Sidebar.tsx` | 1 línea — devolver null en móvil siempre |
| `src/components/dashboard/TopNav.tsx` | Eliminar bloque hamburguesa + import Menu |
| `src/views/DashboardView.tsx` | Importar MobileBottomNav, añadir barra, paddingBottom |
| `src/views/TransactionsView.tsx` | Eliminar hamburguesa del header, importar MobileBottomNav, añadir barra, paddingBottom |
| `src/views/UsersView.tsx` | Añadir props onDashboard/onTransactions, importar MobileBottomNav, añadir barra, paddingBottom |
| `src/App.tsx` | Pasar onDashboard y onTransactions a UsersView |

---

## Task 1: Crear `MobileBottomNav`

**Files:**
- Create: `src/components/layout/MobileBottomNav.tsx`

**Interfaces:**
- Consumes: `C`, `FONT` desde `../../tokens`; `ProductFilter` desde `../../services/dashboard`
- Produces: `export function MobileBottomNav(props: MobileBottomNavProps): JSX.Element`
  ```ts
  interface MobileBottomNavProps {
    activeView?:     string;
    onDashboard?:    () => void;
    onUsers?:        () => void;
    onTransactions?: () => void;
    filter:          ProductFilter;
    onFilter:        (f: ProductFilter) => void;
  }
  ```

- [ ] **Step 1: Crear el archivo**

Crear `src/components/layout/MobileBottomNav.tsx` con el siguiente contenido completo:

```tsx
import { useState } from "react";
import { LayoutDashboard, Users, CreditCard, SlidersHorizontal } from "lucide-react";
import { C, FONT } from "../../tokens";
import type { ProductFilter } from "../../services/dashboard";

interface MobileBottomNavProps {
  activeView?:     string;
  onDashboard?:    () => void;
  onUsers?:        () => void;
  onTransactions?: () => void;
  filter:          ProductFilter;
  onFilter:        (f: ProductFilter) => void;
}

const FILTERS: { value: ProductFilter; label: string }[] = [
  { value: "todos",   label: "Todos"    },
  { value: "AIVI",    label: "AIVI"     },
  { value: "MV3",     label: "MV3"      },
  { value: "Reto15D", label: "Reto 15D" },
];

const NAV = [
  { icon: LayoutDashboard, label: "Dashboard",     view: "dashboard"     },
  { icon: Users,           label: "Usuarios",      view: "usuarios"      },
  { icon: CreditCard,      label: "Transacciones", view: "transacciones" },
] as const;

export function MobileBottomNav({
  activeView, onDashboard, onUsers, onTransactions, filter, onFilter,
}: MobileBottomNavProps) {
  const [sheetOpen, setSheetOpen] = useState(false);

  const handleNav = (view: string) => {
    if (view === "dashboard")    onDashboard?.();
    if (view === "usuarios")     onUsers?.();
    if (view === "transacciones") onTransactions?.();
  };

  const handleFilter = (f: ProductFilter) => {
    onFilter(f);
    setSheetOpen(false);
  };

  return (
    <>
      {sheetOpen && (
        <>
          <div
            onClick={() => setSheetOpen(false)}
            style={{
              position: "fixed", inset: 0,
              background: "rgba(0,0,0,0.5)",
              zIndex: 300,
            }}
          />
          <div style={{
            position: "fixed", bottom: 0, left: 0, right: 0,
            background: C.sidebar,
            borderRadius: "16px 16px 0 0",
            padding: "20px 20px",
            paddingBottom: "calc(20px + env(safe-area-inset-bottom, 0px))",
            zIndex: 301,
            fontFamily: FONT,
          }}>
            <div style={{
              fontSize: 9, fontWeight: 800, color: C.orange,
              letterSpacing: "0.12em", textTransform: "uppercase",
              marginBottom: 12,
            }}>
              Producto
            </div>
            {FILTERS.map(f => (
              <button
                key={f.value}
                onClick={() => handleFilter(f.value)}
                style={{
                  display: "block", width: "100%",
                  background: filter === f.value ? "rgba(254,128,63,0.12)" : "transparent",
                  border: `1px solid ${filter === f.value ? "rgba(254,128,63,0.28)" : C.border}`,
                  borderRadius: 8, padding: "10px 14px",
                  color: filter === f.value ? C.orange : C.white,
                  fontSize: 13, fontWeight: 700, textAlign: "left",
                  marginBottom: 6, cursor: "pointer", fontFamily: FONT,
                }}
              >
                {f.label}
              </button>
            ))}
          </div>
        </>
      )}

      <nav style={{
        position: "fixed", bottom: 0, left: 0, right: 0,
        height: 60,
        paddingBottom: "env(safe-area-inset-bottom, 0px)",
        background: C.sidebar,
        borderTop: `1px solid ${C.border}`,
        backdropFilter: "blur(12px)",
        zIndex: 200,
        display: "grid",
        gridTemplateColumns: "repeat(4, 1fr)",
        fontFamily: FONT,
      }}>
        {NAV.map(item => {
          const Icon = item.icon;
          const isActive = activeView === item.view;
          return (
            <button
              key={item.view}
              onClick={() => handleNav(item.view)}
              style={{
                background: "none", border: "none", cursor: "pointer",
                display: "flex", flexDirection: "column",
                alignItems: "center", justifyContent: "center", gap: 3,
                padding: "8px 0",
                borderTop: isActive ? `2px solid ${C.orange}` : "2px solid transparent",
                color: isActive ? C.orange : C.mutedLight,
              }}
            >
              <Icon size={18} />
              <span style={{
                fontSize: 9, fontWeight: 700,
                letterSpacing: "0.04em", textTransform: "uppercase",
              }}>
                {item.label}
              </span>
            </button>
          );
        })}
        <button
          onClick={() => setSheetOpen(true)}
          style={{
            background: "none", border: "none", cursor: "pointer",
            display: "flex", flexDirection: "column",
            alignItems: "center", justifyContent: "center", gap: 3,
            padding: "8px 0",
            borderTop: "2px solid transparent",
            color: C.mutedLight,
          }}
        >
          <SlidersHorizontal size={18} />
          <span style={{
            fontSize: 9, fontWeight: 700,
            letterSpacing: "0.04em", textTransform: "uppercase",
          }}>
            Filtro
          </span>
        </button>
      </nav>
    </>
  );
}
```

- [ ] **Step 2: Verificar tipos**

```bash
npx tsc -b --noEmit
```

Esperado: sin errores.

- [ ] **Step 3: Commit**

```bash
git add src/components/layout/MobileBottomNav.tsx
git commit -m "feat(mobile): add MobileBottomNav component with FilterSheet"
```

---

## Task 2: Sidebar retorna null en móvil + TopNav sin hamburguesa

**Files:**
- Modify: `src/components/layout/Sidebar.tsx:65`
- Modify: `src/components/dashboard/TopNav.tsx`

**Interfaces:**
- Sin cambios en interfaces públicas — los props `open`, `onClose`, `onMenuOpen` se mantienen en las interfaces para no romper consumidores.

- [ ] **Step 1: Sidebar — devolver null siempre en móvil**

En `src/components/layout/Sidebar.tsx`, línea 65, cambiar:

```tsx
// ANTES:
if (isMobile && !open) return null;

// DESPUÉS:
if (isMobile) return null;
```

- [ ] **Step 2: TopNav — eliminar import de Menu**

En `src/components/dashboard/TopNav.tsx`, línea 2:

```tsx
// ANTES:
import { RefreshCw, BarChart2, Bell, Zap, Menu } from "lucide-react";

// DESPUÉS:
import { RefreshCw, BarChart2, Bell, Zap } from "lucide-react";
```

- [ ] **Step 3: TopNav — eliminar bloque del botón hamburguesa**

En `src/components/dashboard/TopNav.tsx`, dentro del `return`, eliminar este bloque completo (dentro del primer `<div>` con `display: flex`):

```tsx
// ELIMINAR este bloque:
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
```

- [ ] **Step 4: Verificar tipos**

```bash
npx tsc -b --noEmit
```

Esperado: sin errores. Si hay warning por `isMobile` o `onMenuOpen` sin usar en TopNav, se pueden dejar (los props existen en la interface para compatibilidad).

- [ ] **Step 5: Commit**

```bash
git add src/components/layout/Sidebar.tsx src/components/dashboard/TopNav.tsx
git commit -m "feat(mobile): sidebar hidden on mobile, remove TopNav hamburger"
```

---

## Task 3: DashboardView — añadir MobileBottomNav

**Files:**
- Modify: `src/views/DashboardView.tsx`

**Interfaces:**
- Consumes: `MobileBottomNav` desde `../components/layout/MobileBottomNav`
- Consumes: `isMobile` (ya existe en el destructuring de `useResponsive`)
- Consumes: `filter`, `setFilter`, `onUsers`, `onTransactions`, `activeView` (ya existen)

- [ ] **Step 1: Añadir import de MobileBottomNav**

En `src/views/DashboardView.tsx`, en el bloque de imports (después del import de `Sidebar`):

```tsx
// Añadir esta línea:
import { MobileBottomNav } from "../components/layout/MobileBottomNav";
```

- [ ] **Step 2: Añadir paddingBottom al contenedor scrollable móvil**

En `src/views/DashboardView.tsx`, línea ≈200, el div del branch móvil/tablet:

```tsx
// ANTES:
<div style={{
  flex: 1,
  overflow: "auto",
  WebkitOverflowScrolling: "touch",
  display: "flex",
  flexDirection: "column",
}}>

// DESPUÉS:
<div style={{
  flex: 1,
  overflow: "auto",
  WebkitOverflowScrolling: "touch",
  display: "flex",
  flexDirection: "column",
  paddingBottom: isMobile ? 64 : 0,
}}>
```

- [ ] **Step 3: Añadir MobileBottomNav al JSX**

En `src/views/DashboardView.tsx`, justo antes del cierre `</div>` del div exterior (el que tiene `display: "flex", height: "100vh"`), añadir:

```tsx
{isMobile && (
  <MobileBottomNav
    activeView={activeView}
    onUsers={onUsers}
    onTransactions={onTransactions}
    filter={filter}
    onFilter={setFilter}
  />
)}
```

Nota: `onDashboard` no se pasa porque ya estamos en Dashboard.

- [ ] **Step 4: Verificar tipos**

```bash
npx tsc -b --noEmit
```

Esperado: sin errores.

- [ ] **Step 5: Commit**

```bash
git add src/views/DashboardView.tsx
git commit -m "feat(mobile): add MobileBottomNav to DashboardView"
```

---

## Task 4: TransactionsView — eliminar hamburguesa + añadir MobileBottomNav

**Files:**
- Modify: `src/views/TransactionsView.tsx`

**Interfaces:**
- Consumes: `MobileBottomNav` desde `../components/layout/MobileBottomNav`
- Consumes: `isMobile`, `isMobileLayout`, `filter`, `setFilter`, `onDashboard`, `onUsers`, `activeView` (ya existen)

- [ ] **Step 1: Eliminar import de Menu**

En `src/views/TransactionsView.tsx`, línea 2:

```tsx
// ANTES:
import { Download, Search, RefreshCw, Menu } from "lucide-react";

// DESPUÉS:
import { Download, Search, RefreshCw } from "lucide-react";
```

- [ ] **Step 2: Añadir import de MobileBottomNav**

```tsx
// Añadir después de los imports de vistas:
import { MobileBottomNav } from "../components/layout/MobileBottomNav";
```

- [ ] **Step 3: Eliminar bloque hamburguesa del header**

En `src/views/TransactionsView.tsx`, dentro del div del header (línea ≈154), eliminar:

```tsx
// ELIMINAR este bloque:
{isMobileLayout && (
  <button
    onClick={() => setSidebarOpen(true)}
    style={{ background: "none", border: "none", cursor: "pointer", color: C.mutedMid, display: "flex", padding: 4 }}
  >
    <Menu size={20} />
  </button>
)}
```

- [ ] **Step 4: Añadir paddingBottom al contenedor scrollable**

En `src/views/TransactionsView.tsx`, línea ≈188, el div `Scrollable content`:

```tsx
// ANTES:
<div style={{ flex: 1, overflowY: "auto", overflowX: "hidden", display: "flex", flexDirection: "column" }}>

// DESPUÉS:
<div style={{ flex: 1, overflowY: "auto", overflowX: "hidden", display: "flex", flexDirection: "column", paddingBottom: isMobile ? 64 : 0 }}>
```

- [ ] **Step 5: Añadir MobileBottomNav al JSX**

En `src/views/TransactionsView.tsx`, justo antes del cierre `</div>` del div exterior (el que tiene `display: "flex", height: "100vh"`), añadir:

```tsx
{isMobile && (
  <MobileBottomNav
    activeView={activeView}
    onDashboard={onDashboard}
    onUsers={onUsers}
    filter={filter}
    onFilter={setFilter}
  />
)}
```

Nota: `onTransactions` no se pasa porque ya estamos en Transacciones.

- [ ] **Step 6: Verificar tipos**

```bash
npx tsc -b --noEmit
```

Esperado: sin errores.

- [ ] **Step 7: Commit**

```bash
git add src/views/TransactionsView.tsx
git commit -m "feat(mobile): remove hamburger and add MobileBottomNav to TransactionsView"
```

---

## Task 5: UsersView + App.tsx — añadir props y MobileBottomNav

**Files:**
- Modify: `src/views/UsersView.tsx`
- Modify: `src/App.tsx`

**Interfaces:**
- La interface `UsersViewProps` en `UsersView.tsx` pasa de:
  ```ts
  interface UsersViewProps { onBack: () => void; }
  ```
  a:
  ```ts
  interface UsersViewProps {
    onBack:          () => void;
    onDashboard?:    () => void;
    onTransactions?: () => void;
  }
  ```
- `App.tsx` pasa `onDashboard={() => setView("dashboard")}` y `onTransactions={() => setView("transacciones")}` a `<UsersView>`.

- [ ] **Step 1: Añadir import de MobileBottomNav en UsersView**

En `src/views/UsersView.tsx`, en el bloque de imports:

```tsx
// Añadir:
import { MobileBottomNav } from "../components/layout/MobileBottomNav";
```

- [ ] **Step 2: Actualizar UsersViewProps**

En `src/views/UsersView.tsx`, línea 8:

```tsx
// ANTES:
interface UsersViewProps { onBack: () => void; }

// DESPUÉS:
interface UsersViewProps {
  onBack:          () => void;
  onDashboard?:    () => void;
  onTransactions?: () => void;
}
```

- [ ] **Step 3: Actualizar destructuring de props en la función UsersView**

En `src/views/UsersView.tsx`, línea ≈199:

```tsx
// ANTES:
export function UsersView({ onBack }: UsersViewProps) {

// DESPUÉS:
export function UsersView({ onBack, onDashboard, onTransactions }: UsersViewProps) {
```

- [ ] **Step 4: Añadir paddingBottom a la lista de usuarios (leftPanel)**

En `src/views/UsersView.tsx`, la línea del div con `overflowY: "auto", flex: 1` (línea ≈384, inicio del bloque `{/* List */}`):

```tsx
// ANTES:
<div style={{ overflowY: "auto", flex: 1 }}>

// DESPUÉS:
<div style={{ overflowY: "auto", flex: 1, paddingBottom: isMobile ? 64 : 0 }}>
```

- [ ] **Step 5: Añadir paddingBottom al panel de detalle (mainPanel)**

En `src/views/UsersView.tsx`, el `<main>` con `overflowY: "auto"` en la definición de `mainPanel` (línea ≈438):

```tsx
// ANTES:
<main style={{ overflowY: "auto", padding: 20, display: "flex", flexDirection: "column", gap: 14, background: C.bg }}>

// DESPUÉS:
<main style={{ overflowY: "auto", padding: 20, paddingBottom: isMobile ? 84 : 20, display: "flex", flexDirection: "column", gap: 14, background: C.bg }}>
```

Nota: `paddingBottom: 84` = 64 (barra) + 20 (padding original) — el `paddingBottom` longhand sobreescribe el valor inferior del `padding: 20` shorthand.

- [ ] **Step 6: Añadir MobileBottomNav al return de UsersView**

En `src/views/UsersView.tsx`, en el `return`, justo antes del cierre `</div>` del div exterior (el que tiene `display: "grid", height: "100vh"`), añadir:

```tsx
{isMobile && (
  <MobileBottomNav
    activeView="usuarios"
    onDashboard={onDashboard}
    onTransactions={onTransactions}
    filter={programFilter}
    onFilter={setProgramFilter}
  />
)}
```

Nota: `onUsers` no se pasa porque ya estamos en Usuarios. `programFilter` y `setProgramFilter` son el estado interno de la vista (ya existen).

- [ ] **Step 7: Actualizar App.tsx — pasar props a UsersView**

En `src/App.tsx`, línea 49:

```tsx
// ANTES:
if (view === "usuarios") return <UsersView onBack={() => setView("dashboard")} />;

// DESPUÉS:
if (view === "usuarios") return (
  <UsersView
    onBack={() => setView("dashboard")}
    onDashboard={() => setView("dashboard")}
    onTransactions={() => setView("transacciones")}
  />
);
```

- [ ] **Step 8: Verificar tipos**

```bash
npx tsc -b --noEmit
```

Esperado: sin errores.

- [ ] **Step 9: Commit**

```bash
git add src/views/UsersView.tsx src/App.tsx
git commit -m "feat(mobile): add MobileBottomNav to UsersView with onDashboard/onTransactions props"
```

---

## Task 6: Verificación visual

- [ ] **Step 1: Iniciar el servidor de desarrollo**

```bash
npm run dev
```

Abrir `http://localhost:5173`.

- [ ] **Step 2: Verificar móvil (375px) — Dashboard**

Abrir DevTools → Device Toolbar → iPhone SE (375×667).

Verificar:
- No aparece hamburguesa en el TopNav (solo AIVI CORE › Dashboard + controles)
- Aparece barra inferior con 4 ítems: Dashboard (activo, naranja, línea superior), Usuarios, Transacciones, Filtro
- El scroll del dashboard llega hasta el footer sin que la barra tape contenido
- Al tocar "Usuarios" navega a UsersView
- Al tocar "Transacciones" navega a TransactionsView

- [ ] **Step 3: Verificar FilterSheet**

Con móvil activo en cualquier vista:
- Tocar "Filtro" → aparece overlay oscuro + sheet desde abajo con 4 botones (Todos, AIVI, MV3, Reto 15D)
- El filtro activo aparece en naranja
- Tocar un filtro → sheet se cierra, filtro cambia
- Tocar el overlay (fuera del sheet) → sheet se cierra sin cambiar filtro

- [ ] **Step 4: Verificar móvil — TransactionsView**

Desde móvil navegar a Transacciones:
- El header no tiene botón hamburguesa
- "Transacciones" en la barra inferior está activo (naranja)
- El scroll de la tabla llega hasta el último elemento sin que la barra lo tape

- [ ] **Step 5: Verificar móvil — UsersView**

Navegar a Usuarios:
- "Usuarios" en la barra inferior está activo (naranja)
- En la lista: scroll llega al último usuario sin que la barra tape
- Al tocar un usuario → vista de detalle; scroll en el detalle no queda tapado por la barra
- El botón "← Lista" (el `onBack` del topbar) aún funciona para volver a la lista

- [ ] **Step 6: Verificar desktop sin cambios**

Cambiar DevTools a 1280×900:
- Sidebar aparece a la izquierda normalmente
- No aparece barra inferior
- Hamburguesa no existe — el TopNav tiene los controles normales de desktop

- [ ] **Step 7: Build de producción**

```bash
npm run build
```

Esperado: build exitoso, sin errores TypeScript.

- [ ] **Step 8: Commit final**

```bash
git add -A
git commit -m "chore: verify mobile bottom nav across all views"
```

---

## Self-Review

**Spec coverage:**
- ✅ Barra fija en la parte inferior (position: fixed, zIndex: 200) — Task 1
- ✅ 4 ítems: Dashboard, Usuarios, Transacciones, Filtro — Task 1
- ✅ Ítem activo en naranja con línea superior — Task 1
- ✅ FilterSheet con Todos/AIVI/MV3/Reto 15D — Task 1
- ✅ Sidebar retorna null en móvil siempre — Task 2
- ✅ Hamburguesa eliminado de TopNav — Task 2
- ✅ Hamburguesa eliminado de header de TransactionsView — Task 4
- ✅ paddingBottom en contenedor scrollable de cada vista — Tasks 3, 4, 5
- ✅ MobileBottomNav en DashboardView — Task 3
- ✅ MobileBottomNav en TransactionsView — Task 4
- ✅ MobileBottomNav en UsersView — Task 5
- ✅ onDashboard/onTransactions en UsersView y App.tsx — Task 5
- ✅ Tablet y desktop sin cambios — los ternarios solo aplican `isMobile`

**Placeholder scan:** Ningún TBD ni TODO. Cada step tiene código o comando concreto.

**Type consistency:**
- `MobileBottomNavProps` definido en Task 1 — consumido por Tasks 3, 4, 5 con nombres consistentes
- `onDashboard?`, `onTransactions?` en `UsersViewProps` definidos en Task 5 Step 2 — usados en Steps 3, 6, y 7
- `programFilter` / `setProgramFilter` son `ProductFilter` / `(f: ProductFilter) => void` — compatibles con los props `filter`/`onFilter` de `MobileBottomNav`
