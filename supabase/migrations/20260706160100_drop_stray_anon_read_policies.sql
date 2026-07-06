-- La migración anterior (20260706160000) no cerraba el acceso anónimo porque
-- existían políticas paralelas creadas directo en el SQL editor de Supabase,
-- fuera de cualquier migración versionada: "anon_read_transactions" y
-- "anon_read_investment" (ambas `USING (true)` para el rol `public`).
--
-- Postgres combina políticas PERMISSIVE con OR — cualquier policy que
-- permita el acceso lo permite, sin importar cuántas otras lo restrinjan.
-- Confirmado vía `select * from pg_policies where tablename in
-- ('transactions','investment_data')` contra la base remota.

drop policy if exists "anon_read_transactions" on public.transactions;
drop policy if exists "anon_read_investment"   on public.investment_data;
