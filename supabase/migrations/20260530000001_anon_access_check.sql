-- Permite a visitantes anónimos verificar si su email está aprobado.
-- Solo expone filas con status='approved'; pending/rejected quedan ocultos.
create policy "anon_check_approved_email"
  on public.access_requests
  for select
  to anon
  using (status = 'approved');

-- Otorgar privilegio SELECT al rol anon (la tabla solo otorgaba insert a anon)
grant select on public.access_requests to anon;
