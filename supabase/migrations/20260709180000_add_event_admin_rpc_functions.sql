-- Funciones atómicas para mutar allowed_events. Antes, addEventAdmin/
-- removeEventAdmin hacían un select del array + update en el cliente
-- (leer-y-luego-escribir), lo que permite que dos llamadas concurrentes para
-- el mismo email se pisen entre sí y una de las dos quede perdida en
-- silencio. Un solo UPDATE con array_append/array_remove es atómico a nivel
-- de fila y elimina esa condición de carrera.

create or replace function add_event_admin(_email text, _code text)
returns void
language plpgsql
as $$
begin
  update access_requests
  set allowed_events = array(select distinct unnest(allowed_events || array[_code]))
  where email = _email and status = 'approved';
end;
$$;

create or replace function remove_event_admin(_email text, _code text)
returns void
language plpgsql
as $$
begin
  update access_requests
  set allowed_events = array_remove(allowed_events, _code)
  where email = _email and status = 'approved';
end;
$$;
