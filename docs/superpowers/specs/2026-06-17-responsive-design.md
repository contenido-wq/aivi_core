# Spec: Responsive Design Fix — Opción A
**Fecha:** 2026-06-17  
**Estado:** Aprobado

---

## Contexto

AIVI Core es un dashboard interno (Vite + React + TypeScript, inline styles con CSS variables). Tiene un sistema responsive custom via `useResponsive` con tres breakpoints: mobile (<768px), tablet (768–1023px), desktop (≥1024px). El breakpoint `isShortScreen` detecta laptops con pantalla corta (<820px alto).

**Dispositivo primario:** Laptop (MacBook, Windows 1366–1440px).  
**Caso secundario:** Monitor externo / TV conectado a laptop (1440px–4K).

---

## Problema

1. **Sin breakpoint para pantallas grandes (≥1440px):** El layout se estira infinitamente. Paneles de datos quedan con anchos de 1000–1500px; los KPIs se ven desproporcionados.
2. **KPIRow en móvil:** La 5.ª tarjeta ("Atrasados") queda sola en la fila inferior de la grilla 2-col, ocupando solo la mitad del ancho disponible.
3. **`UsersView` sin responsive:** No importa `useResponsive`. El panel lateral de detalle del usuario usa anchos fijos que rompen en móvil.
4. **Tabs de Transacciones en móvil:** Los labels completos ("AIVI Solicitudes de Reembolso") aprietan el scroll horizontal en pantallas pequeñas.

---

## Solución: Opción A — Breakpoint `isLarge` + max-width centrado

### 1. `useResponsive` — Nuevos flags

Agregar a `ResponsiveState` sin modificar ningún flag existente:

```ts
isLarge:  boolean  // width >= 1440px
isXLarge: boolean  // width >= 1920px
```

Lógica de cálculo:
```ts
const isLarge  = w >= 1440;
const isXLarge = w >= 1920;
// isDesktop sigue siendo w >= 1024 — sin cambio
```

### 2. Layout principal — contenedor con max-width

En `DashboardView`, `TransactionsView` y `UsersView`, el `div` que contiene el contenido principal (el que ya tiene `marginLeft: 220`) recibe:

```ts
maxWidth: isLarge ? 1680 : undefined,
// Solo aplica cuando isLarge, sin afectar desktop estándar
```

No se agrega centrado (`margin: auto`) porque el contenido empieza pegado al sidebar. El max-width simplemente impide que los paneles crezcan más allá de 1680px.

### 3. Sidebar — ancho escalado en large

```ts
width: isLarge ? 240 : (isMobile ? 270 : 220)
```

El `marginLeft` en el contenido principal se ajusta correspondientemente:
```ts
marginLeft: (isMobile || isTablet) ? 0 : (isLarge ? 240 : 220)
```

### 4. KPIRow — Fix 5.ª tarjeta en móvil

En móvil (`isMobile: true`), la grilla es `repeat(2, 1fr)`. La 5.ª tarjeta (`KPICard` de "Atrasados") recibe `style={{ gridColumn: "span 2" }}` para ocupar el ancho completo de la fila.

```tsx
// Solo en isMobile, el último KPICard:
<KPICard ... style={isMobile ? { gridColumn: "span 2" } : undefined} />
```

### 5. `UsersView` — Responsive básico

Importar `useResponsive` y usar `isMobile`:

- **Lista de usuarios:** ya usa `flexDirection: column` — sin cambio.
- **Panel lateral de detalle:** actualmente tiene ancho fijo (~400px). En móvil: `width: "100%"` como overlay full-screen (mismo patrón del sidebar drawer ya implementado en el resto de la app).
- **Input de búsqueda y filtros:** agregar `flexWrap: "wrap"` donde falte.

### 6. Tabs de Transacciones — Labels adaptativos

```ts
const tabLabel = (cat: Category, isMobile: boolean) =>
  isMobile ? cat.shortLabel : `AIVI ${cat.label}`;
```

Agregar `shortLabel` a cada categoría:
| Categoría | shortLabel |
|---|---|
| Compras Aprobadas | Compras |
| Solicitudes de Reembolso | Reembolso |
| Reembolsos Hechos | Reembolsos |
| Cancelaciones | Cancelaciones |
| Atrasados | Atrasados |
| Tarjeta Rechazada | Chargeback |

---

## Archivos a modificar

| Archivo | Cambio |
|---|---|
| `src/hooks/useResponsive.ts` | + `isLarge`, `isXLarge` flags |
| `src/views/DashboardView.tsx` | max-width en contenedor, sidebar 240px en large |
| `src/views/TransactionsView.tsx` | max-width en contenedor, labels cortos en móvil |
| `src/views/UsersView.tsx` | + `useResponsive`, panel lateral móvil responsive |
| `src/components/dashboard/KPIRow.tsx` | `gridColumn: span 2` en 5.ª tarjeta en móvil |

---

## Lo que NO cambia

- Breakpoints `mobile`, `tablet`, `desktop`, `isShortScreen` — sin modificar
- Lógica de datos ni servicios
- Estilos globales de `index.css` (solo se usan para casos que inline styles no pueden manejar)
- AdminPanel y LoginView (no son parte del scope)

---

## Criterios de éxito

- En monitor 1920px: el layout no supera 1680px de ancho; los paneles se ven proporcionados
- En celular: los 5 KPIs se ven sin grilla rota; las tabs de transacciones son legibles
- En UsersView móvil: el panel de detalle abre en full-screen en vez de solaparse con la lista
- Ningún breakpoint existente (mobile/tablet/desktop/shortScreen) deja de funcionar
