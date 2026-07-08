# Spec: Dashboard de Eventos (carga de CSV por evento)

**Fecha:** 2026-07-08
**Estado:** Aprobado

---

## Contexto

AIVI regala acceso (plan "Entry") a asistentes de eventos presenciales o virtuales a los que invitan a Jhei/AIVI (ej. MasterShop, CCCali, EFFI), usando un `enrollment_code` único por evento. La plataforma AIVI (proyecto Next.js separado) puede exportar un CSV con los usuarios que entraron por ese código, más su uso real de cada módulo (ADN Creator, ADN View, Analista, Calendario, Carrusel Generator, Carrusel Pro, Chat Response, Espía AI, Referente Search, Sales Simulator, Script Generator, Transcriptor, Viral Ideas), cada uno con veces exitosas y fecha de último uso.

Ejemplo real (`Usuarios por CODIGO EVENTO AIVI - Reporte.csv`, 299 filas, 3 eventos): `AIVI-CCCALI-20260625` (210), `AIVI-MASTERSHOP-20260618` (49), `EVENTO-AIVI-EFFI2606` (40).

El usuario quiere: subir este tipo de CSV y ver un dashboard por evento (cuánta gente entró, qué tan activa está, qué módulos usa), como una sección permanente y guardada en Supabase — no un análisis descartable.

Con el trabajo reciente de `allowed_sections` (spec `2026-07-08-per-user-section-permissions-design.md`), agregar una sección nueva es sencillo: por defecto nadie la ve hasta que se le otorgue explícitamente.

---

## Solución

### 1. Nueva dependencia: `papaparse`

`npm install papaparse @types/papaparse` — parseo de CSV robusto (comillas, comas dentro de campos), evita escribir un parser propio. Único uso: el importador de esta vista.

### 2. Nueva tabla `event_users`

`supabase/migrations/20260708010000_create_event_users.sql`:

```sql
create table if not exists public.event_users (
  id                            uuid primary key default gen_random_uuid(),
  enrollment_code               text not null,
  variacion                     text,
  external_user_id              text,
  nombre                        text,
  email                         text not null,
  usuario_activo                boolean default false,
  verificado                    boolean default false,
  registrado_el                 date,
  plan                          text,
  estado_plan                   text,
  ciclo_inicio                  date,
  ciclo_fin                     date,
  tokens_plan_consumidos_ciclo  integer default 0,
  tokens_plan_consumidos_total  integer default 0,
  adn_creator_exitosas          integer default 0, adn_creator_ultima          date,
  adn_view_exitosas             integer default 0, adn_view_ultima             date,
  analista_exitosas             integer default 0, analista_ultima             date,
  calendar_exitosas             integer default 0, calendar_ultima             date,
  carousel_generator_exitosas   integer default 0, carousel_generator_ultima   date,
  carousel_pro_exitosas         integer default 0, carousel_pro_ultima         date,
  chat_response_exitosas        integer default 0, chat_response_ultima        date,
  espia_ai_exitosas             integer default 0, espia_ai_ultima             date,
  referente_search_exitosas     integer default 0, referente_search_ultima     date,
  sales_simulator_exitosas      integer default 0, sales_simulator_ultima      date,
  script_generator_exitosas     integer default 0, script_generator_ultima     date,
  transcriptor_exitosas         integer default 0, transcriptor_ultima         date,
  viral_ideas_exitosas          integer default 0, viral_ideas_ultima          date,
  uploaded_at                   timestamptz not null default now(),
  unique (enrollment_code, email)
);

create index if not exists event_users_enrollment_code_idx on public.event_users(enrollment_code);

alter table public.event_users enable row level security;

create policy "auth_all_event_users" on public.event_users
  for all using (auth.role() = 'authenticated');
```

`unique(enrollment_code, email)` + upsert con `onConflict: "enrollment_code,email"` hace que volver a subir el CSV de un mismo evento actualice sus filas en vez de duplicarlas.

### 3. Nuevo tipo de sección: `"eventos"`

- `src/types.ts`: `AppView` pasa a `"dashboard" | "admin" | "usuarios" | "transacciones" | "analytics" | "eventos"`.
- Se integra directo con el trabajo de permisos ya hecho: se agrega a `SECTIONS` en `AdminPanel.tsx` (label "Eventos"), a `NAV_ITEMS`/`NAV` en `Sidebar.tsx`/`MobileBottomNav.tsx`, y a las ramas de `App.tsx`. Nadie la ve por defecto hasta que se le otorgue en "Solicitudes de acceso".

### 4. Servicio: `src/services/events.ts`

- `parseEventCSV(file: File): Promise<EventUserRow[]>` — usa `papaparse` (`Papa.parse(file, { header: true, skipEmptyLines: true })`), mapea cada fila del CSV a la forma de `event_users` (booleans desde `"TRUE"/"FALSE"`, fechas vacías → `null`, números vacíos → `0`).
- `uploadEventUsers(rows: EventUserRow[]): Promise<{ count: number }>` — `supabase.from("event_users").upsert(rows, { onConflict: "enrollment_code,email" })`, en lotes de 500 filas.
- `getEventsSummary(): Promise<EventSummary[]>` — trae todas las filas (`select * from event_users`, mismo patrón `.limit(50000)` que el resto del proyecto) y agrupa client-side por `enrollment_code`: `{ code, label, total, activos, verificados }`. `label` = el `variacion` más frecuente para ese código (o el propio código si no hay `variacion`).
- `getEventDetail(code: string): Promise<{ users: EventUserRow[]; moduleUsage: ModuleUsageRow[] }>` — filtra las filas de ese evento; calcula por cada uno de los 12 módulos: `{ label, usersWithUsage, pct, totalUses }`.

### 5. Nueva vista: `src/views/EventosView.tsx`

Sigue el patrón visual de `TransactionsView`/`UsersView` (Sidebar/MobileBottomNav condicional por breakpoint, header con acciones).

- **Selector de evento**: lista de eventos (de `getEventsSummary`) con nombre + conteo de usuarios; clic selecciona el evento activo.
- **Botón "Subir CSV"**: input de archivo oculto + botón visible; al elegir archivo llama `parseEventCSV` → `uploadEventUsers` → refresca `getEventsSummary`/`getEventDetail`. Muestra estado de carga y un mensaje de éxito/error (mismo patrón que `AdminPanel`'s `actionMsg`).
- **Dashboard del evento seleccionado**:
  - KPIs (mismo componente `KPICard` reutilizado de `components/dashboard/KPIRow.tsx` si es reutilizable, o una versión local simple): Total registrados, % Activos, % Verificados.
  - Tabla "Uso por módulo": Módulo | Usuarios que lo usaron | % | Usos totales — ordenada de mayor a menor por usuarios que lo usaron.
  - Tabla de usuarios: nombre, email, activo/verificado (badges), registrado el, plan, con buscador de texto (mismo patrón que `UsersView`).

### 6. Wiring existente

- `App.tsx`: nueva rama `if (effectiveView === "eventos") return <EventosView ... allowedSections={allowedSections} isAdmin={isAdmin} />`, con los mismos callbacks de navegación (`onDashboard`, `onUsers`, etc.) que ya reciben las demás vistas.
- `Sidebar.tsx` / `MobileBottomNav.tsx`: nuevo ítem `{ icon: Calendar, label: "Eventos", view: "eventos" }` (ícono `Calendar` de lucide-react, ya usado en otras partes del proyecto).

---

## Lo que NO cambia

- No se crea una tabla `events` separada con metadata editable (nombre bonito, fecha, ubicación) — el agrupador es directamente `enrollment_code` + el `variacion` más frecuente como label. Si más adelante se necesita metadata rica por evento, es una iteración futura.
- No se agrega comparación lado a lado entre eventos ni seguimiento de conversión a plan pago — el usuario confirmó que el alcance es solo KPIs + uso por módulo + tabla de usuarios, por evento individual.
- No se toca ningún dato de `access_requests`, `transactions`, ni otras tablas existentes.

---

## Archivos a crear / modificar

| Archivo | Acción |
|---|---|
| `package.json` | Agregar `papaparse` + `@types/papaparse` |
| `supabase/migrations/20260708010000_create_event_users.sql` | Crear tabla `event_users` + RLS |
| `src/types.ts` | Agregar `"eventos"` a `AppView` |
| `src/services/events.ts` | Crear: parseo CSV, upsert, resumen y detalle por evento |
| `src/views/EventosView.tsx` | Crear: selector de evento, subida de CSV, dashboard |
| `src/components/admin/AdminPanel.tsx` | Agregar "Eventos" a `SECTIONS` |
| `src/components/layout/Sidebar.tsx` | Agregar ítem "Eventos" a `NAV_ITEMS` |
| `src/components/layout/MobileBottomNav.tsx` | Agregar ítem "Eventos" a `NAV` |
| `src/App.tsx` | Nueva rama de rutable + wiring de `EventosView` |

---

## Criterios de éxito

- Subir el CSV de ejemplo crea/actualiza correctamente las filas de `event_users`, agrupadas por los 3 `enrollment_code` reales.
- Re-subir el mismo archivo no duplica usuarios (actualiza por `enrollment_code + email`).
- El selector de evento muestra los eventos con su conteo de usuarios.
- Al seleccionar un evento se ven sus KPIs, el uso por módulo (ordenado) y la tabla de usuarios.
- La sección "Eventos" respeta `allowed_sections` — no aparece para usuarios sin ese permiso otorgado.
