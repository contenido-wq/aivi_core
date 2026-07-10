-- Permisos por sección para usuarios de access_requests.
-- Filas ya aprobadas conservan acceso a las 5 secciones (comportamiento actual);
-- filas nuevas quedan sin secciones hasta que el admin las asigne explícitamente.

alter table access_requests
  add column allowed_sections text[] not null default '{}'::text[];

update access_requests
  set allowed_sections = array['dashboard','usuarios','transacciones','analytics','admin']
  where status = 'approved';
