# Spec: Permisos por Sección para Usuarios Aprobados

**Fecha:** 2026-07-08
**Estado:** Aprobado

---

## Contexto

Hoy, `access_requests` (tabla que sirve como cola de solicitudes Y lista de miembros aprobados — no existe `authorized_users`/`team_members` separada) solo tiene `status: pending|approved|rejected`. Cualquier usuario aprobado ve todo: `Sidebar`/`MobileBottomNav` renderizan siempre los mismos ítems de navegación, y el botón "Ajustes" (visible para todos) lleva a `AdminPanel` sin ningún guard — `App.tsx:48` (`if (view === "admin") return <AdminPanel .../>`) no verifica `isAdmin` en absoluto. El prop `isAdmin` ya está enhebrado por toda la app (`App.tsx` → cada vista → `Sidebar`/`MobileBottomNav`) pero llega como `isAdmin: _isAdmin = false` (con guion bajo, sin usar) en ambos componentes de navegación — es un no-op hoy.

**Identidad y límite de seguridad real:** no existen cuentas individuales de Supabase Auth por persona — todos comparten una sola cuenta (`portal@aivicore.app`, `src/lib/authConfig.ts`). "Quién eres" es solo el email que el usuario escribió en el login, verificado contra `access_requests` y guardado en `localStorage` (`useAuth.ts`). Por lo tanto, **el control de permisos por sección que se describe aquí es de UI (cliente)**, no una política RLS a nivel de fila — cualquier usuario con la sesión compartida podría, en teoría, saltarse esto llamando a Supabase directamente. Esto es una limitación preexistente de la arquitectura (no introducida por este cambio) y resolverla de raíz requeriría migrar a cuentas reales por usuario. Fuera de alcance aquí — se documenta para que quede explícito.

El usuario decidió: los 5 destinos existentes (`AppView`: `dashboard`, `usuarios`, `transacciones`, `analytics`, `admin`) son todos otorgables/quitables por usuario, incluyendo Ajustes/Admin.

---

## Solución

### 1. Migración: nueva columna `allowed_sections`

`supabase/migrations/20260708000000_add_allowed_sections_to_access_requests.sql`:

```sql
alter table access_requests
  add column allowed_sections text[] not null default '{}'::text[];

-- Preservar el comportamiento actual para usuarios ya aprobados (hoy todos ven todo)
update access_requests
  set allowed_sections = array['dashboard','usuarios','transacciones','analytics','admin']
  where status = 'approved';
```

Filas nuevas (nuevas solicitudes) quedan con `allowed_sections = {}` por defecto — el admin debe otorgar secciones explícitamente al aprobar. Las ya aprobadas no pierden nada de lo que ya veían.

### 2. Login: capturar y persistir `allowed_sections`

`src/views/LoginView.tsx` (`handleLogin`, líneas 38-51):
- Extender el `.select("email")` a `.select("email, allowed_sections")`.
- Al escribir `localStorage.setItem(SESSION_KEY, ...)` (línea 55), incluir `allowedSections: rows?.[0]?.allowed_sections ?? []`.
- En la rama del super-admin (`normalizedEmail === ADMIN_EMAIL`, que hoy se salta la consulta), persistir `allowedSections: ["dashboard","admin","usuarios","transacciones","analytics"]` directamente (el admin siempre tiene todo, sin depender de una fila en `access_requests`).

### 3. `useAuth.ts`: exponer `allowedSections`

- Extender el parseo de `localStorage.getItem(SESSION_KEY)` (líneas 11-18 y 38-43) para leer también `allowedSections` del mismo objeto JSON, con `useState<AppView[]>([])` como default.
- Agregar `allowedSections` al valor de retorno del hook (línea 60).
- En `signOut` y cuando `!session`, resetear `allowedSections` a `[]` (mismo patrón que `teamEmail`).

### 4. `App.tsx`: cerrar el hueco de seguridad y filtrar vistas

- Obtener `allowedSections` de `useAuth()`.
- `const canAccess = (v: AppView) => isAdmin || allowedSections.includes(v);` (mantiene `isAdmin` como atajo del super-admin explícito, redundante-seguro con lo anterior).
- Envolver cada rama de vista (`admin`, `usuarios`, `analytics`, `transacciones`, `dashboard`) con `canAccess(view)`; si no tiene acceso, no renderizar esa vista — en su lugar, redirigir a la primera sección permitida (`allowedSections[0]`) o, si `allowedSections.length === 0`, mostrar una pantalla simple "No tienes acceso a ninguna sección. Contacta al administrador." con un botón de cerrar sesión.
- Esto corrige puntualmente el hueco existente: hoy cualquier usuario aprobado llega a `AdminPanel` sin chequeo alguno.
- Pasar `allowedSections={allowedSections}` a las 4 vistas (junto al `isAdmin` que ya reciben).

### 5. `Sidebar.tsx` / `MobileBottomNav.tsx`: filtrar navegación

- Agregar prop `allowedSections?: AppView[]` a ambas (reemplaza el rol que `isAdmin` iba a cumplir y nunca cumplió).
- `NAV_ITEMS`/`NAV`: filtrar con `.filter(item => allowedSections.includes(item.view))` antes de mapear (en `Sidebar.tsx`, el ítem "Suscripciones" con `view: null` no aplica este filtro — sigue mostrándose deshabilitado como hoy).
- Botón "Ajustes": solo renderizar si `allowedSections.includes("admin")`.
- Cada vista (`DashboardView`, `TransactionsView`, `UsersView`, `AnalyticsView`) recibe `allowedSections` como prop nueva y la reenvía a su `<Sidebar>`/`<MobileBottomNav>` (mismo patrón de threading que ya existe para `isAdmin`).

### 6. `AdminPanel.tsx`: editor de permisos por fila

- Extender `interface AccessRequest` con `allowed_sections: string[]`.
- Extender el `.select(...)` en `loadRequests` (línea 46) para incluir `allowed_sections`.
- Nuevo handler:
  ```ts
  const SECTIONS: { key: AppView; label: string }[] = [
    { key: "dashboard",     label: "Dashboard" },
    { key: "usuarios",      label: "Usuarios" },
    { key: "transacciones", label: "Transacciones" },
    { key: "analytics",     label: "Analytics" },
    { key: "admin",         label: "Ajustes" },
  ];

  const handleToggleSection = async (req: AccessRequest, section: AppView) => {
    const has = req.allowed_sections.includes(section);
    const next = has ? req.allowed_sections.filter(s => s !== section) : [...req.allowed_sections, section];
    // update optimista en `requests` + supabase.from("access_requests").update({ allowed_sections: next }).eq("id", req.id)
  };
  ```
- `RequestRow`: nueva fila de 5 chips pequeños (mismo estilo visual que los badges existentes: `borderRadius, fontSize 10-11, padding "2px 8px"`), uno por sección de `SECTIONS`, resaltado si `req.allowed_sections.includes(key)`, clic llama `onToggleSection(key)`. Se muestra para solicitudes `pending` y `approved` (no para `rejected`, sin efecto práctico ahí). El admin puede fijar permisos antes o después de pulsar "Aprobar" — son acciones independientes sobre la misma fila.
- No se agrega validación de "mínimo una sección" al aprobar — si el admin aprueba sin marcar nada, el usuario simplemente no verá ninguna sección hasta que se le asignen (caso borde aceptado, no bloqueante).

---

## Lo que NO cambia

- El modelo de autenticación compartida (`portal@aivicore.app`) — no se migra a cuentas individuales de Supabase Auth. El control de acceso sigue siendo de aplicación/cliente, no RLS por fila.
- Los permisos no se re-validan en caliente: si el admin cambia `allowed_sections` de alguien con sesión activa, el cambio aplica en su próximo login (igual que hoy pasa con cambios de `status`).
- El placeholder "Suscripciones" en `Sidebar` (`view: null`) — sigue sin ser una sección real, no se agrega a `allowed_sections`.
- El Edge Function `supabase/functions/invite-user/index.ts` — sigue sin usarse, fuera de alcance.

---

## Archivos a modificar

| Archivo | Cambio |
|---|---|
| `supabase/migrations/20260708000000_add_allowed_sections_to_access_requests.sql` | Nueva columna + backfill de aprobados existentes |
| `src/views/LoginView.tsx` | Leer y persistir `allowed_sections` en el login |
| `src/hooks/useAuth.ts` | Exponer `allowedSections: AppView[]` |
| `src/App.tsx` | Guard de acceso por vista (incluye cerrar el hueco de Ajustes/Admin) + pasar `allowedSections` a las 4 vistas |
| `src/components/layout/Sidebar.tsx` | Filtrar `NAV_ITEMS` y botón Ajustes por `allowedSections` |
| `src/components/layout/MobileBottomNav.tsx` | Filtrar `NAV` y botón Ajustes por `allowedSections` |
| `src/views/DashboardView.tsx` / `TransactionsView.tsx` / `UsersView.tsx` / `AnalyticsView.tsx` | Recibir y reenviar `allowedSections` |
| `src/components/admin/AdminPanel.tsx` | Editor de permisos (chips) por fila de solicitud |

---

## Criterios de éxito

- Un usuario aprobado solo ve, en el sidebar/bottom nav, las secciones que tiene otorgadas; el botón Ajustes solo aparece si tiene `admin` otorgado.
- Navegar directamente (vía estado interno) a una sección no otorgada ya no es posible — `App.tsx` redirige a una sección permitida.
- El super-admin (`ADMIN_EMAIL`) conserva acceso total siempre, sin depender de una fila en `access_requests`.
- Usuarios aprobados antes de este cambio no pierden acceso a nada que ya tuvieran (backfill a las 5 secciones).
- Desde "Solicitudes de acceso" en Ajustes, el admin puede marcar/desmarcar las 5 secciones por cada solicitud (pendiente o aprobada) y el cambio persiste en Supabase.
