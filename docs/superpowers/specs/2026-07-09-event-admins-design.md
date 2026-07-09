# Spec: Administradores por evento

**Fecha:** 2026-07-09
**Estado:** Aprobado

---

## Contexto

Hoy, cualquier miembro del equipo con la sección `"eventos"` habilitada en `allowed_sections` (spec `2026-07-08-per-user-section-permissions-design.md`) ve **todos** los eventos en `EventosView.tsx`, sin excepción — no existe forma de restringir a un admin de evento a ver solo el suyo.

**Identidad y límite de seguridad real (heredado, sin cambios):** el proyecto no tiene cuentas individuales de Supabase Auth por persona — todo el equipo comparte una sola cuenta (`portal@aivicore.app`, `src/lib/authConfig.ts`). "Quién eres" es el email escrito en el login, verificado contra `access_requests` y guardado en `localStorage` (`aivi_team_session`, `useAuth.ts`). Por lo tanto, igual que con `allowed_sections`, **el control de acceso por evento descrito aquí es de aplicación (cliente), no una política RLS por fila** — un usuario con la sesión compartida podría en teoría saltárselo llamando a Supabase directamente. Es la misma limitación preexistente ya documentada en el spec de secciones, no una regresión de este cambio.

El único mecanismo existente de acceso restringido a un solo evento es `event_guests` (spec `2026-07-09-event-rename-and-guest-access.md`): invitados externos, de solo lectura, sin cuenta del equipo. No sirve para modelar "administrador de evento" del equipo.

---

## Solución

### 1. Migración: columna `allowed_events`

`supabase/migrations/<ts>_add_allowed_events_to_access_requests.sql`:

```sql
alter table access_requests
  add column allowed_events text[] not null default '{}'::text[];

-- Preservar el comportamiento actual: quien ya veía "eventos" sigue viendo
-- todos los eventos existentes hasta que el super-admin restrinja manualmente.
update access_requests ar
set allowed_events = (
  select coalesce(array_agg(distinct eu.enrollment_code), '{}')
  from event_users eu
)
where ar.status = 'approved' and 'eventos' = any(ar.allowed_sections);
```

Sin cambios de RLS — sigue siendo `auth.role() = 'authenticated'` en `events`/`event_users`/`event_guests`, igual que hoy.

### 2. Sesión: llevar `allowed_events` del login al cliente

Mismo patrón exacto que `allowed_sections`:

- `src/views/LoginView.tsx` (`handleLogin`): extender `.select("email, allowed_sections")` → `.select("email, allowed_sections, allowed_events")`; persistir `allowedEvents: rows?.[0]?.allowed_events ?? []` en `localStorage["aivi_team_session"]`. La rama del super-admin (`ADMIN_EMAIL`) no necesita poblarlo — `isAdmin` bypassa el filtro en el siguiente paso.
- `src/hooks/useAuth.ts`: `StoredSession` gana `allowedEvents?: string[]`; el hook expone `allowedEvents: string[]` (`useState<string[]>([])` por defecto), reseteado en `signOut` y cuando no hay sesión — mismo manejo que `allowedSections`.
- `src/App.tsx`: obtener `allowedEvents` de `useAuth()` y pasarlo como prop nueva a `<EventosView allowedEvents={allowedEvents} ...>`.

### 3. Filtrar eventos visibles + ocultar "Subir CSV" a no-admins

En `src/views/EventosView.tsx`:

- Nueva prop `allowedEvents?: string[]` (default `[]`) en `EventosViewProps`.
- `const visibleEvents = isAdmin ? events : events.filter(e => allowedEvents.includes(e.code));` — reemplaza el uso directo de `events` en:
  - el selector de chips de eventos (línea ~288),
  - la inicialización/reselección de `selectedCode` en `loadEvents()` (línea ~76), que hoy cae al primero de la lista sin filtrar.
- El botón "Subir CSV" y su `<input type="file">` (líneas ~251-267) se envuelven en `{isAdmin && (...)}`. Los admins de evento restringidos nunca crean ni re-suben eventos — todo el ingreso de datos por CSV queda centralizado en el super-admin.
- `getEventsSummary()` y `getEventDetail()` en `src/services/events.ts` no cambian — siguen trayendo todos los eventos; el filtro es de presentación en la vista, igual que `Sidebar.tsx` ya filtra `NAV_ITEMS` por `allowedSections`.

### 4. Sección "Administradores" (solo super-admin)

Nuevo servicio `src/services/eventAdmins.ts` (mismo estilo que `eventGuests.ts`):

```ts
export interface EventAdmin { id: string; email: string; }

export async function listEventAdmins(code: string): Promise<EventAdmin[]> {
  // access_requests: status = 'approved' AND allowed_events @> [code]
  // .select("id, email").eq("status", "approved").contains("allowed_events", [code])
}

export async function listEligibleTeamMembers(): Promise<{ id: string; email: string }[]> {
  // access_requests: status = 'approved' AND 'eventos' = any(allowed_sections)
}

export async function addEventAdmin(code: string, email: string): Promise<void> {
  // lee allowed_events actual de la fila por email (status=approved),
  // agrega `code` si no está, hace update
}

export async function removeEventAdmin(code: string, email: string): Promise<void> {
  // lee allowed_events actual, quita `code`, hace update
}
```

En `EventosView.tsx`, nueva sección "Administradores" dentro del panel del evento seleccionado (mismo maquetado/posición que "Invitados", visible **solo si `isAdmin`**):

- Lista de emails con acceso a `selectedCode` (de `listEventAdmins`), cada fila con botón "Quitar" (icono `Trash2`, mismo estilo que en Invitados).
- Botón "Agregar administrador" que abre un `<select>` poblado con `listEligibleTeamMembers()` menos los ya listados en la sección; al confirmar, llama `addEventAdmin(selectedCode, email)` y recarga la lista.
- Sin flujo de contraseña ni Edge Function — a diferencia de `event_guests`, esto solo modifica una fila de `access_requests` que ya existe (el usuario ya tiene su propio login de equipo).

### 5. Casos borde

- **Usuario nuevo con `eventos` pero `allowed_events = []`** (aprobado después de esta migración, sin backfill retroactivo): hoy el mensaje vacío dice "Todavía no hay eventos cargados. Sube un CSV para empezar." — ambiguo si sí existen eventos pero ninguno asignado. Ajuste: si `!isAdmin && allowedEvents.length === 0`, mostrar en su lugar "No tienes eventos asignados todavía. Pídele acceso al administrador."
- **Cambio de permisos con sesión activa:** si el super-admin quita un evento del `allowed_events` de alguien, el cambio aplica en su próximo login (igual que `allowed_sections` hoy — no hay revalidación en caliente).
- **Selección de evento no visible:** si `selectedCode` (persistido en estado local del componente) queda apuntando a un código fuera de `visibleEvents` tras un refresh de permisos, `loadEvents()` ya reselecciona al primero de `visibleEvents` — mismo mecanismo que hoy usa para `events`.

---

## Lo que NO cambia

- El modelo de autenticación compartida (`portal@aivicore.app`) y el hecho de que el control de acceso es de aplicación, no RLS por fila — misma limitación aceptada en el spec de secciones.
- `event_guests` (invitados externos, solo lectura) — sigue siendo un sistema aparte, no se fusiona con `allowed_events`.
- `getEventsSummary()` / `getEventDetail()` — siguen devolviendo todos los eventos; el filtrado es responsabilidad de la vista.
- La gestión de "Invitados" dentro de un evento — sigue disponible para cualquiera que vea ese evento (no se restringe a super-admin), sin cambios.

---

## Archivos a crear / modificar

| Archivo | Acción |
|---|---|
| `supabase/migrations/<ts>_add_allowed_events_to_access_requests.sql` | Crear: columna `allowed_events` + backfill de aprobados con `eventos` |
| `src/views/LoginView.tsx` | Leer y persistir `allowed_events` en el login |
| `src/hooks/useAuth.ts` | Exponer `allowedEvents: string[]` |
| `src/App.tsx` | Pasar `allowedEvents` a `EventosView` |
| `src/services/eventAdmins.ts` | Crear: `listEventAdmins`, `listEligibleTeamMembers`, `addEventAdmin`, `removeEventAdmin` |
| `src/views/EventosView.tsx` | Prop `allowedEvents`; filtrar `visibleEvents`; ocultar "Subir CSV" a no-admins; sección "Administradores" (solo `isAdmin`) |

---

## Criterios de éxito

- Un usuario con `eventos` habilitado pero sin eventos asignados en `allowed_events` no ve ningún evento (ni sus datos), solo el mensaje de "sin eventos asignados".
- Un admin de evento restringido, al entrar, solo ve los chips y el dashboard de los eventos listados en su `allowed_events`.
- Ese mismo admin no ve el botón "Subir CSV" en ningún momento.
- El super-admin (`isAdmin`) sigue viendo y pudiendo subir todos los eventos, sin restricción, como hoy.
- Desde el evento seleccionado, el super-admin puede agregar/quitar administradores de ese evento específico desde la sección "Administradores", y el cambio se refleja en el `allowed_events` de la fila correspondiente en `access_requests`.
- Los usuarios aprobados que ya tenían `eventos` antes de esta migración no pierden acceso a ningún evento existente al momento del despliegue (backfill).
