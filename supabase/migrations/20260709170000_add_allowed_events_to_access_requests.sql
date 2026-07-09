-- Acceso restringido por evento: cada admin de equipo solo ve los eventos
-- listados en su allowed_events (el super-admin siempre ve todos, sin
-- depender de esta columna — ver App.tsx `isAdmin`).
-- Backfill: quien ya tenía "eventos" en allowed_sections conserva acceso
-- a todos los eventos existentes hasta que el super-admin restrinja
-- manualmente desde la nueva sección "Administradores" en EventosView.

alter table access_requests
  add column allowed_events text[] not null default '{}'::text[];

update access_requests ar
set allowed_events = (
  select coalesce(array_agg(distinct eu.enrollment_code), '{}')
  from event_users eu
)
where ar.status = 'approved' and 'eventos' = any(ar.allowed_sections);
