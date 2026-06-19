# Texture + Pill Glassmorphism Buttons — Design Spec

**Goal:** Añadir grain texture al fondo del dashboard y rediseñar los botones de navegación y acción con estilo pill glassmorphism (referencia: imagen de nav bar Instagram/iOS).

## 1. Grain Texture

- Pseudo-elemento `html::before` con SVG `feTurbulence` fractalNoise
- Opacidad: 3.5% — visible en fondos oscuros, invisible en cards/text
- `pointer-events: none`, `z-index: 9999`, `position: fixed`, `inset: 0`
- Tamaño tile: 200×200px repeating
- Afecta solo `src/index.css`, sin cambios de componentes

## 2. Mobile Bottom Nav — Pill Glassmorphism

**Cambio estructural en `MobileBottomNav.tsx`:**
- Contenedor pasa de barra full-width a cápsula centrada flotante
- `position: fixed`, `bottom: 24px`, `left: 50%`, `transform: translateX(-50%)`
- `border-radius: 999px`, padding horizontal amplio
- Fondo: `rgba(20,20,20,0.65)` + `backdrop-filter: blur(24px)`
- Borde: `1px solid rgba(255,255,255,0.12)` + highlight superior `rgba(255,255,255,0.08)`
- Ítem activo: cuadrado interno `rgba(30,30,30,0.90)`, `border-radius: 16px`, icono naranja
- Ítems inactivos: icono solo, opacidad 45%
- Eliminar `borderTop` y `paddingBottom` del estilo actual

## 3. Sidebar Nav Items — Glassmorphism Activo

**Cambio en `Sidebar.tsx` estado activo:**
- Agregar `backdropFilter: "blur(12px)"` al estado activo (ya está pero sin blur efectivo)
- Cambiar fondo activo de `rgba(254,128,63,0.10)` a `rgba(254,128,63,0.07)` — más translúcido
- Mantener left-border naranja 3px como indicador de posición
- Sin cambios en ítems inactivos

## 4. Botones de Acción Primarios — Full Pill

**Cambio en `src/index.css` clase `.aivi-btn-primary`:**
- `border-radius: var(--radius-sm)` (8px) → `border-radius: 999px`
- Agregar `box-shadow: 0 1px 0 rgba(255,255,255,0.12) inset` — brillo superior de vidrio
- Padding horizontal aumentado: `padding-left/right` +4px para compensar la forma redondeada
- Aplica a todos los botones con clase `aivi-btn-primary`: "Entrar", "Sincronizar", etc.

## Files

| Archivo | Cambio |
|---|---|
| `src/index.css` | grain overlay + `.aivi-btn-primary` pill radius + inset highlight |
| `src/components/layout/MobileBottomNav.tsx` | rediseño completo a pill flotante |
| `src/components/layout/Sidebar.tsx` | estado activo glassmorphism |
