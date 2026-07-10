# Spec: Renombrar eventos + acceso de invitados por evento

**Fecha:** 2026-07-09
**Estado:** Aprobado

---

## Contexto

Dos pedidos relacionados con `EventosView.tsx`:

1. El nombre que se ve por evento (ej. "CCCALI") se deriva automáticamente del `variacion` más frecuente del CSV — no hay forma de renombrarlo, ni se guarda en ningún lado.
2. El usuario quiere poder invitar personas externas (varias por evento) que entren con un usuario/contraseña que él asigna, y que vean **únicamente** el tablero de ese evento — sin sidebar, sin subir CSV, sin cambiar de evento, sin ver el resto de AIVI Core.

El segundo punto es un sistema de acceso nuevo, separado del que ya existe para el equipo (`access_requests` + sesión compartida de Supabase Auth, ver spec `2026-07-08-per-user-section-permissions-design.md`). No se reutiliza esa infraestructura porque los invitados no son parte del equipo ni deben ver ninguna otra sección — es más simple y más seguro tratarlo como un sistema aparte.

---

## Solución

### 1. Renombrar eventos

**Migración** — nueva tabla `events`:
```sql
create table events (
  enrollment_code text primary key,
  display_name    text,
  created_at      timestamptz not null default now()
);
alter table events enable row level security;
create policy "auth_all_events" on events for all using (auth.role() = 'authenticated');
```

`src/services/events.ts`:
- `setEventDisplayName(code: string, name: string): Promise<void>` — upsert en `events`.
- `getEventsSummary()` se extiende: trae también `events` y, si existe `display_name` para un `enrollment_code`, lo usa como `label` en vez del `variacion` más frecuente.

`EventosView.tsx`: junto al nombre del evento seleccionado (arriba de los KPIs), un botón de lápiz que activa edición inline (input + guardar/cancelar), llama `setEventDisplayName` y refresca la lista.

### 2. Acceso de invitados por evento

**Migración** — nueva tabla `event_guests`:
```sql
create table event_guests (
  id               uuid primary key default gen_random_uuid(),
  enrollment_code  text not null,
  username         text not null unique,
  password_hash    text not null,
  label            text,
  created_at       timestamptz not null default now(),
  last_login_at    timestamptz
);
create index event_guests_enrollment_code_idx on event_guests(enrollment_code);
alter table event_guests enable row level security;
create policy "auth_all_event_guests" on event_guests for all using (auth.role() = 'authenticated');
```
Sin política para `anon` — los invitados nunca consultan esta tabla directamente, solo la Edge Function (con `service_role`, que ignora RLS) la lee para verificar login.

**Nueva dependencia:** `bcryptjs` (funciona igual en el navegador y en Deno vía `npm:` specifier) — para hashear contraseñas. Nunca se guarda ni se transmite texto plano salvo en el momento en que el admin la asigna.

**Crear invitado** (`src/services/eventGuests.ts`, admin, sesión de equipo ya autenticada):
- `createEventGuest(code, username, password, label?)`: hashea con `bcryptjs` en el cliente (costo 10) e inserta en `event_guests`. Protegido por la misma RLS que el resto del panel admin — solo el equipo autenticado puede llegar a esta pantalla.
- `listEventGuests(code)`: trae `id, username, label, created_at, last_login_at` (sin `password_hash`).
- `deleteEventGuest(id)`.

**Login de invitado** — nueva Edge Function `supabase/functions/event-guest-login/index.ts` (mismo patrón que `invite-user`: Deno.serve, CORS, cliente `service_role`):
- Recibe `{ username, password }`.
- Busca la fila por `username`, compara con `bcrypt.compare`.
- Si coincide: actualiza `last_login_at`, responde `{ enrollment_code, label }` (200).
- Si no: responde genérico `{ error: "Usuario o contraseña incorrectos" }` (401) — nunca revela si falló el usuario o la contraseña.

**Entrada del invitado** (`src/views/LoginView.tsx`): tercera pestaña "Acceso a evento" (junto a "Iniciar sesión" / "Pedir acceso"), con campos usuario/contraseña. Llama la Edge Function vía `supabase.functions.invoke`. Al éxito, guarda `{ enrollment_code, label }` en `localStorage["aivi_event_guest_session"]` y notifica a `App.tsx` (prop `onGuestLogin`).

**Enrutamiento** (`src/App.tsx`): el chequeo de sesión de invitado va **antes** que el flujo normal de equipo (el invitado nunca obtiene una sesión de Supabase Auth, es un mecanismo aparte). Si hay `guestSession` en localStorage, se renderiza `EventGuestView` directamente, sin pasar por `useAuth`/`LoginView`/`allowedSections`.

**Nueva vista de solo lectura** (`src/views/EventGuestView.tsx`): header mínimo (AIVI Core + nombre del evento + botón salir), KPIs, dona de estado, barra de uso por módulo, tabla de usuarios con su panel de detalle — sin sidebar, sin selector de evento, sin botón de subir CSV. Reutiliza las piezas visuales ya construidas en `EventosView.tsx`.

**Refactor de soporte:** las piezas presentacionales de `EventosView.tsx` (`STATUS_COLOR`, `STATUS_SHORT_LABEL`, `fmtDate`, `KPITile`, `StatusTip`, `ModuleTip`, `StatusDonutChart`, `ModuleUsageChart`, `UserDetailPanel`) se mueven a `src/components/eventos/shared.tsx` para que `EventosView` y `EventGuestView` las compartan sin duplicar código.

**Gestión de invitados en `EventosView.tsx`:** dentro del evento seleccionado, una sección "Invitados" con la lista de invitados existentes (usuario, nota, último ingreso, botón quitar) y un botón "Agregar persona" que abre un formulario (usuario, contraseña, nota opcional). Al crear, la contraseña se muestra **una sola vez** en un aviso ("Guárdala, no se puede volver a ver") — después queda solo el hash.

---

## Lo que NO cambia

- El sistema de acceso del equipo (`access_requests`, `allowed_sections`, sesión compartida) — sin tocar.
- Los invitados no pueden hacer nada más que ver: sin subir CSV, sin editar el nombre del evento, sin ver otros eventos ni otras secciones.

---

## Archivos a crear / modificar

| Archivo | Acción |
|---|---|
| `supabase/migrations/<ts>_create_events_and_event_guests.sql` | Crear tablas `events` y `event_guests` + RLS |
| `supabase/functions/event-guest-login/index.ts` | Crear: verificación de login de invitado |
| `package.json` | Agregar `bcryptjs` + tipos |
| `src/services/events.ts` | `setEventDisplayName`, `getEventsSummary` usa `display_name` |
| `src/services/eventGuests.ts` | Crear: CRUD de invitados + `loginEventGuest` |
| `src/components/eventos/shared.tsx` | Crear: piezas visuales compartidas (extraídas de `EventosView.tsx`) |
| `src/views/EventosView.tsx` | Usar piezas compartidas; UI de renombrar; sección de Invitados |
| `src/views/EventGuestView.tsx` | Crear: tablero de solo lectura para un invitado |
| `src/views/LoginView.tsx` | Tercera pestaña "Acceso a evento" |
| `src/App.tsx` | Chequeo de `guestSession` antes del flujo de equipo |

---

## Criterios de éxito

- Renombrar un evento persiste y se ve así en próximas visitas (para todo el equipo).
- Un invitado creado con usuario/contraseña puede entrar por la pestaña "Acceso a evento" y ve solo ese tablero.
- El invitado no puede navegar a ninguna otra sección, evento, ni subir archivos.
- La contraseña se muestra una sola vez al crearla; en la base solo queda el hash.
- El equipo puede quitar el acceso de un invitado en cualquier momento.
