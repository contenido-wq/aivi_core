# Spec: Mobile Bottom Navigation Bar
**Fecha:** 2026-06-18  
**Estado:** Aprobado

---

## Contexto

AIVI Core tiene un sistema responsive (`useResponsive`) con breakpoints: mobile (<768px), tablet (768–1023px), desktop (≥1024px). En móvil, la navegación actual usa un hamburguesa en el `TopNav` que abre el `Sidebar` como drawer overlay. El sidebar contiene: nav items, filtro de producto y resumen del día.

La UX del drawer en móvil es subóptima — requiere dos taps para navegar. El patrón estándar de apps móviles es una barra de navegación fija en la parte inferior.

---

## Solución

Reemplazar el drawer móvil con una barra de navegación fija en la parte inferior que incluye los 3 destinos activos + un botón de filtro.

---

## Componentes

### Nuevo: `src/components/layout/MobileBottomNav.tsx`

Contiene dos piezas en un solo archivo:

**`MobileBottomNav`** — barra fija:
- `position: fixed`, `bottom: 0`, `left: 0`, `right: 0`, `zIndex: 200`
- Altura visual: 60px + `paddingBottom: env(safe-area-inset-bottom, 0px)` (iOS notch)
- Fondo: `C.sidebar`, `borderTop: 1px solid C.border`, `backdropFilter: blur(12px)`
- 4 columnas iguales (CSS grid `repeat(4, 1fr)`)
- Cada ítem: icono 18px centrado + label 9px debajo (caps, `fontWeight: 700`)
- Ítem activo: color `C.orange`, línea naranja `2px` en `borderTop` del ítem
- Ítem inactivo: color `C.mutedLight`, sin línea

| Posición | Ícono (lucide) | Label |
|---|---|---|
| 1 | `LayoutDashboard` | "Dashboard" |
| 2 | `Users` | "Usuarios" |
| 3 | `CreditCard` | "Transacciones" |
| 4 | `SlidersHorizontal` | "Filtro" |

**Props de `MobileBottomNav`:**
```ts
interface MobileBottomNavProps {
  activeView?:      string;
  onDashboard?:     () => void;
  onUsers?:         () => void;
  onTransactions?:  () => void;
  filter:           ProductFilter;
  onFilter:         (f: ProductFilter) => void;
}
```

**`FilterSheet`** (función auxiliar, mismo archivo) — bottom sheet:
- Estado local `sheetOpen: boolean` dentro de `MobileBottomNav`
- Al tocar "Filtro": `setSheetOpen(true)`
- Overlay: `position: fixed`, inset 0, `background: rgba(0,0,0,0.5)`, `zIndex: 300` — tap cierra el sheet
- Sheet: `position: fixed`, `bottom: 0`, `left: 0`, `right: 0`, `zIndex: 301`
- Fondo `C.sidebar`, `borderRadius: "16px 16px 0 0"`, padding 20px, `paddingBottom: calc(20px + env(safe-area-inset-bottom, 0px))`
- Título "Producto" en 9px caps `C.orange`
- 4 botones de filtro: Todos / AIVI / MV3 / Reto 15D — mismo estilo visual que los filtros del sidebar (fondo `rgba(254,128,63,0.12)` + borde naranja cuando activo)
- Al seleccionar un filtro: llama `onFilter(value)` y cierra el sheet

---

## Cambios en archivos existentes

### `src/components/layout/Sidebar.tsx`
Cambio mínimo: al inicio de la función, antes de la definición de `sidebarContent`:
```tsx
// Antes:
if (isMobile && !open) return null;
// Después:
if (isMobile) return null;
```
El sidebar nunca se renderiza en móvil. Props `open` y `onClose` se mantienen en la interface para no romper consumidores.

### `src/components/dashboard/TopNav.tsx`
Eliminar el bloque condicional del botón hamburguesa:
```tsx
// Eliminar este bloque completo:
{isMobile && (
  <button onClick={onMenuOpen} aria-label="Abrir menú" ...>
    <Menu size={20} />
  </button>
)}
```
El import de `Menu` de lucide-react también se elimina si queda sin uso.

### `src/views/DashboardView.tsx`
1. Importar `MobileBottomNav`
2. Al final del JSX de la vista, dentro del div exterior: `{isMobile && <MobileBottomNav activeView={activeView} onDashboard={...} onUsers={...} onTransactions={...} filter={filter} onFilter={onFilter} />}`
3. Al contenedor scrollable principal: agregar `paddingBottom: isMobile ? 64 : 0`

### `src/views/TransactionsView.tsx`
Mismo patrón: importar + agregar `<MobileBottomNav>` + `paddingBottom: isMobile ? 64 : 0` en el contenedor.

### `src/views/UsersView.tsx`
Mismo patrón: importar + agregar `<MobileBottomNav>` + `paddingBottom: isMobile ? 64 : 0` en el contenedor.

---

## Lo que NO cambia

- El `Sidebar` en desktop/tablet — sin modificar su comportamiento
- Los props `open`, `onClose`, `onMenuOpen` — se mantienen en las interfaces (el estado `sidebarOpen` en cada vista queda sin uso en móvil pero sin errores)
- El filtro de producto — el estado vive donde ya vive hoy; `MobileBottomNav` lo recibe como prop
- `useResponsive`, breakpoints, `isLarge`, `isXLarge` — sin tocar
- `index.css` — sin modificar

---

## Archivos a crear / modificar

| Archivo | Acción |
|---|---|
| `src/components/layout/MobileBottomNav.tsx` | Crear |
| `src/components/layout/Sidebar.tsx` | 1 línea |
| `src/components/dashboard/TopNav.tsx` | Eliminar bloque hamburguesa |
| `src/views/DashboardView.tsx` | Importar + añadir barra + paddingBottom |
| `src/views/TransactionsView.tsx` | Importar + añadir barra + paddingBottom |
| `src/views/UsersView.tsx` | Importar + añadir barra + paddingBottom |

---

## Criterios de éxito

- En móvil (< 768px): no aparece hamburguesa, aparece barra inferior con 4 ítems
- La navegación entre Dashboard / Usuarios / Transacciones funciona desde la barra inferior
- El ítem activo se resalta en naranja
- Al tocar "Filtro" se abre el sheet; al seleccionar un producto el filtro cambia y el sheet se cierra
- El contenido no queda tapado por la barra
- En tablet y desktop: sin cambios visibles
