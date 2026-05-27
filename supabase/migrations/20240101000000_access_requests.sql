-- Tabla de solicitudes de acceso por correo
create table if not exists public.access_requests (
  id           uuid        primary key default gen_random_uuid(),
  email        text        not null unique,
  status       text        not null default 'pending'
                           check (status in ('pending', 'approved', 'rejected')),
  requested_at timestamptz not null default now(),
  reviewed_at  timestamptz,
  reviewed_by  uuid        references auth.users(id) on delete set null
);

-- Índice para búsqueda por status
create index if not exists access_requests_status_idx
  on public.access_requests(status);

-- Habilitar RLS
alter table public.access_requests enable row level security;

-- Cualquier visitante puede insertar su solicitud
create policy "public_insert_access_request"
  on public.access_requests
  for insert
  with check (true);

-- Solo usuarios autenticados (admin) pueden leer
create policy "auth_select_access_requests"
  on public.access_requests
  for select
  using (auth.uid() is not null);

-- Solo usuarios autenticados (admin) pueden actualizar
create policy "auth_update_access_requests"
  on public.access_requests
  for update
  using (auth.uid() is not null)
  with check (auth.uid() is not null);

-- Permitir acceso a anon role para INSERT (solicitudes sin sesión)
grant insert on public.access_requests to anon;
grant select, update on public.access_requests to authenticated;
