# Spec: Analytics en Bottom Nav + Responsive de AnalyticsView + Reparación del Drawer Móvil

**Fecha:** 2026-07-07
**Estado:** Aprobado

---

## Contexto

El usuario reportó que no ve "Analytics" en los botones inferiores en móvil. La investigación reveló tres problemas relacionados, no uno solo:

1. `MobileBottomNav.tsx` solo tiene 3 ítems (Dashboard, Usuarios, Transacciones) — nunca se agregó Analytics cuando se creó esa vista.
2. `AnalyticsView.tsx` no tiene NINGÚN manejo responsive: renderiza el `Sidebar` fijo de 220px sin importar el tamaño de pantalla, nunca llama a `useResponsive()`, y nunca renderiza `MobileBottomNav`. Es la única vista con este hueco.
3. El spec `2026-06-18-mobile-bottom-nav-design.md` documenta que el drawer del `Sidebar` en móvil fue **desactivado a propósito** (`if (isMobile) return null` sin chequear `open`) en favor del bottom nav, por UX de doble-tap. El usuario, tras conocer ese contexto, pidió explícitamente revivirlo de todas formas para recuperar acceso a MRR/ARR y "Resumen del día" en móvil, aceptando el trade-off de doble-tap para llegar a esa información.

Adicionalmente, dos elementos de Analytics tienen ancho fijo en px que desbordarían en pantallas angostas: `CampaignMappingModal` (560px) y `VSLSelectorBar` (320px).

---

## Solución

### 1. Agregar "Analytics" al `MobileBottomNav`

`src/components/layout/MobileBottomNav.tsx`:
- Importar `BarChart2` de `lucide-react`.
- Agregar `onAnalytics?: () => void;` a `MobileBottomNavProps`.
- Agregar `{ icon: BarChart2, label: "Analytics", view: "analytics" }` al arreglo `NAV`.
- En `handleNav`, agregar el caso `if (view === "analytics") onAnalytics?.();`.
- Reducir el ancho de cada botón de 52px a 46px (mismo alto 44px, mismo gap 4px) para que las hasta 6 pastillas (4 nav + filtro + ajustes) quepan en pantallas de 320px sin desbordarse: `6×46 + 5×4 + 12(padding) = 308px`.

Conectar `onAnalytics` en los 3 consumidores existentes:
- `src/views/DashboardView.tsx`: ya recibe `onAnalytics` como prop — pasarlo a `<MobileBottomNav>`.
- `src/views/TransactionsView.tsx`: agregar `onAnalytics?: () => void;` a `TransactionsViewProps`, pasarlo a `<MobileBottomNav>`.
- `src/views/UsersView.tsx`: agregar `onAnalytics?: () => void;` a `UsersViewProps`, pasarlo a `<MobileBottomNav>`.
- `src/App.tsx`: pasar `onAnalytics={() => setView("analytics")}` a `<TransactionsView>` y `<UsersView>`.

### 2. Responsive completo de `AnalyticsView.tsx`

- Importar y usar `useResponsive()` para obtener `isMobile`/`isTablet`.
- Agregar estado local `sidebarOpen`.
- `<Sidebar>`: pasar `isMobile={isMobile || isTablet}`, `open={sidebarOpen}`, `onClose={() => setSidebarOpen(false)}`; `width` condicional (`0` en mobile/tablet, `SIDEBAR_W` en desktop).
- Contenedor de contenido: `marginLeft` condicional (`0` en mobile/tablet).
- Header: agregar botón hamburguesa (ícono `Menu`) cuando `isMobile || isTablet`, que llama `setSidebarOpen(true)`; reducir paddings horizontales en mobile siguiendo el patrón `px` ya usado en `DashboardView`/`TransactionsView`.
- `<main>`: agregar `paddingBottom: isMobile ? 64 : 0` para que el contenido no quede tapado por el bottom nav.
- Grid de "Funnels por Campaña": cambiar `minmax(340px, 1fr)` a `minmax(${isMobile ? 260 : 340}px, 1fr)` para que no desborde en pantallas angostas.
- Renderizar `{isMobile && <MobileBottomNav activeView="analytics" onDashboard={onDashboard} onUsers={onUsers} onTransactions={onTransactions} onSettings={onSettings} isAdmin={isAdmin} filter="todos" onFilter={() => {}} />}` (sin `onAnalytics`, ya que es la vista activa — mismo patrón no-op que ya usa `<Sidebar onAnalytics={() => {}}>` en este archivo).

### 3. Anchos fijos que desbordan en móvil

- `src/components/analytics/CampaignMappingModal.tsx`: cambiar `width: 560` por `width: "min(560px, 92vw)"`.
- `src/components/analytics/VSLSelectorBar.tsx`: cambiar `width: 320` (línea 68, panel desplegable) por `width: "min(320px, 90vw)"`.

### 4. Reparar el drawer móvil del `Sidebar` (decisión explícita del usuario, revirtiendo el spec de 2026-06-18)

- `src/components/layout/Sidebar.tsx`: cambiar `if (isMobile) return null;` por `if (isMobile && !open) return null;`; renombrar el prop desestructurado `open: _open` a `open` (deja de ser un parámetro sin uso).
- `src/components/dashboard/TopNav.tsx`: renombrar `onMenuOpen: _onMenuOpen` a `onMenuOpen`; renderizar un botón con ícono `Menu` (lucide-react) cuando `isMobile`, que llama `onMenuOpen`. Esto reactiva la apertura del drawer en `DashboardView` (que ya pasa `onMenuOpen={() => setSidebarOpen(true)}` a `TopNav`).
- `src/views/TransactionsView.tsx`: agregar un botón hamburguesa (ícono `Menu`) en el header (junto al título) cuando `isMobileLayout`, que llama `setSidebarOpen(true)` — hoy el estado `sidebarOpen` existe pero ningún botón lo activa.
- `src/views/AnalyticsView.tsx`: su propio botón hamburguesa se agrega como parte del punto 2.
- `src/views/UsersView.tsx`: no usa `<Sidebar>` (tiene su propio diseño de detalle con botón "volver") — no se toca.

---

## Lo que NO cambia

- El comportamiento de `Sidebar`/`MobileBottomNav` en desktop y tablet (fuera del ajuste de ancho fijo → 92vw/90vw, que solo afecta si la pantalla es más angosta que esos valores).
- `useResponsive`, breakpoints, `isLarge`, `isXLarge`.
- El diseño de `UsersView` (sin `Sidebar`, sin drawer).
- El placeholder deshabilitado "Suscripciones" en `Sidebar` — sigue sin ruta funcional, no se agrega a `MobileBottomNav`.

---

## Archivos a modificar

| Archivo | Cambio |
|---|---|
| `src/components/layout/MobileBottomNav.tsx` | Agregar ítem Analytics + prop `onAnalytics` + resize botones |
| `src/components/layout/Sidebar.tsx` | Reparar el `return null` para respetar `open` |
| `src/components/dashboard/TopNav.tsx` | Renderizar botón hamburguesa real |
| `src/views/DashboardView.tsx` | Pasar `onAnalytics` a `MobileBottomNav` |
| `src/views/TransactionsView.tsx` | Prop `onAnalytics` + botón hamburguesa en header |
| `src/views/UsersView.tsx` | Prop `onAnalytics` + pasar a `MobileBottomNav` |
| `src/views/AnalyticsView.tsx` | Responsive completo: sidebar condicional, hamburguesa, `MobileBottomNav`, grid, paddings |
| `src/components/analytics/CampaignMappingModal.tsx` | Ancho responsive |
| `src/components/analytics/VSLSelectorBar.tsx` | Ancho responsive |
| `src/App.tsx` | Pasar `onAnalytics` a `TransactionsView` y `UsersView` |

---

## Criterios de éxito

- En móvil, el bottom nav muestra 4 ítems (Dashboard, Usuarios, Transacciones, Analytics) + filtro + ajustes, sin desbordarse en pantallas de 320–375px.
- Tocar "Analytics" en el bottom nav navega a `AnalyticsView` desde cualquier vista.
- `AnalyticsView` en móvil: sin sidebar fijo empujando el contenido, con bottom nav visible, contenido no tapado, tarjetas de funnels en una columna sin overflow horizontal.
- El botón hamburguesa abre el drawer del sidebar en Dashboard, Transacciones y Analytics en móvil, mostrando MRR/ARR y resumen del día; un tap fuera o la X lo cierra.
- El modal "Configurar VSLs" y el selector de VSL no se desbordan en pantallas angostas.
- En desktop y tablet: sin cambios visibles de comportamiento.
