-- Parche de emergencia de seguridad.
--
-- `transactions` no tenía ninguna política RLS versionada — era legible por
-- el rol `anon` (la anon key pública, embebida en el bundle del frontend)
-- sin ningún login, exponiendo raw_payload completo (nombre/email/ucode del
-- comprador) a cualquiera en internet. `investment_data` tenía una política
-- explícita "anyone can read" (20260612000003_investment_data_read.sql) que
-- abría el gasto publicitario de la misma forma.
--
-- Este parche las alinea con el patrón auth_read_*/service_all_* que ya usan
-- el resto de tablas de analytics (ver 20260622000001_vturb_tables.sql).
--
-- IMPORTANTE — esto es una mitigación interina, no el fix completo: el login
-- del portal (src/lib/authConfig.ts) usa una sola cuenta compartida cuyas
-- credenciales están en el bundle público y en el repo, así que el rol
-- `authenticated` es trivialmente alcanzable por cualquiera que las lea. Este
-- parche detiene el scraping no autenticado (bots/escáneres que solo prueban
-- la anon key sin credenciales), pero no a un atacante dirigido que también
-- encuentre la contraseña del portal. El fix real —reemplazar la cuenta
-- compartida por autenticación por persona— se aborda por separado.

-- ── transactions ──────────────────────────────────────────────────────────────

alter table public.transactions enable row level security;

drop policy if exists "service_all_transactions" on public.transactions;
drop policy if exists "auth_read_transactions"   on public.transactions;

create policy "service_all_transactions" on public.transactions
  for all using (auth.role() = 'service_role');

create policy "auth_read_transactions" on public.transactions
  for select using (auth.role() = 'authenticated');

-- ── investment_data ───────────────────────────────────────────────────────────

drop policy if exists "anyone can read"              on public.investment_data;
drop policy if exists "service role write"            on public.investment_data;
drop policy if exists "service_all_investment_data"   on public.investment_data;
drop policy if exists "auth_read_investment_data"     on public.investment_data;

create policy "service_all_investment_data" on public.investment_data
  for all using (auth.role() = 'service_role');

create policy "auth_read_investment_data" on public.investment_data
  for select using (auth.role() = 'authenticated');
