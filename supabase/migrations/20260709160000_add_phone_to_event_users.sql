-- Teléfono editable/asignable manualmente por evento — no viene en el CSV,
-- el admin lo agrega o corrige desde el panel de detalle. Se sigue cruzando
-- con transactions.buyer_phone como respaldo cuando esta columna está vacía.
alter table public.event_users add column if not exists phone text;
