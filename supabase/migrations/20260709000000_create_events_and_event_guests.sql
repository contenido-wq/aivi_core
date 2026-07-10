-- Nombre editable por evento (sobreescribe el derivado del CSV).
create table if not exists public.events (
  enrollment_code text primary key,
  display_name    text,
  created_at      timestamptz not null default now()
);

alter table public.events enable row level security;

create policy "auth_all_events" on public.events
  for all using (auth.role() = 'authenticated');

-- Invitados con acceso de solo lectura a un único evento (usuario/contraseña
-- propios, sin relación con el login compartido del equipo).
create table if not exists public.event_guests (
  id              uuid primary key default gen_random_uuid(),
  enrollment_code text not null,
  username        text not null unique,
  password_hash   text not null,
  label           text,
  created_at      timestamptz not null default now(),
  last_login_at   timestamptz
);

create index if not exists event_guests_enrollment_code_idx on public.event_guests(enrollment_code);

alter table public.event_guests enable row level security;

-- Solo el equipo (sesión compartida autenticada) puede gestionar invitados.
-- Los invitados nunca consultan esta tabla directamente: su login pasa por
-- la Edge Function event-guest-login, que usa service_role e ignora RLS.
create policy "auth_all_event_guests" on public.event_guests
  for all using (auth.role() = 'authenticated');
