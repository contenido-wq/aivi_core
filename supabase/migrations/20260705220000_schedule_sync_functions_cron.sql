-- Programa las funciones de sincronización (vturb-sync, hotmart-sync, utmify-sync)
-- vía pg_cron + pg_net.
--
-- Por qué: cada una de estas Edge Functions registra un Deno.cron(...) dentro de
-- su propio código esperando correr periódicamente, pero Supabase Edge Functions
-- no soporta Deno.cron — las funciones solo se ejecutan bajo demanda (HTTP), no
-- como procesos persistentes con temporizadores internos. Ese bloque nunca se
-- dispara solo, así que los datos únicamente entran cuando alguien llama la
-- función manualmente. Esto causó que vturb_analytics quedara sin datos nuevos
-- desde 2026-06-27.
--
-- Requiere un secreto en Supabase Vault llamado 'service_role_key' con el
-- SUPABASE_SERVICE_ROLE_KEY del proyecto (Project Settings → Vault → New
-- secret). Sin ese secreto, las llamadas HTTP fallarán con 401.

create extension if not exists pg_cron with schema extensions;
create extension if not exists pg_net  with schema extensions;

-- vturb-sync: cada hora en el minuto 30 (sincroniza el día de hoy)
select cron.schedule(
  'vturb-sync-hourly',
  '30 * * * *',
  $$
  select net.http_post(
    url     := 'https://jihyeeimmhfqlpzljrbu.supabase.co/functions/v1/vturb-sync',
    headers := jsonb_build_object(
      'Content-Type',  'application/json',
      'apikey',        (select decrypted_secret from vault.decrypted_secrets where name = 'service_role_key'),
      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'service_role_key')
    )
  );
  $$
);

-- hotmart-sync: diario a las 6:00 sobre una ventana de los últimos 3 días
-- (con solape), red de seguridad para renovaciones que el webhook en vivo
-- no haya recibido.
select cron.schedule(
  'hotmart-sync-daily',
  '0 6 * * *',
  $$
  select net.http_post(
    url := 'https://jihyeeimmhfqlpzljrbu.supabase.co/functions/v1/hotmart-sync?start='
           || (floor(extract(epoch from (now() - interval '3 days')) * 1000))::bigint::text
           || '&end='
           || (floor(extract(epoch from now()) * 1000))::bigint::text,
    headers := jsonb_build_object(
      'Content-Type',  'application/json',
      'apikey',        (select decrypted_secret from vault.decrypted_secrets where name = 'service_role_key'),
      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'service_role_key')
    )
  );
  $$
);

-- utmify-sync: cada hora en el minuto 0 (delta del día en curso)
select cron.schedule(
  'utmify-sync-hourly',
  '0 * * * *',
  $$
  select net.http_post(
    url     := 'https://jihyeeimmhfqlpzljrbu.supabase.co/functions/v1/utmify-sync',
    headers := jsonb_build_object(
      'Content-Type',  'application/json',
      'apikey',        (select decrypted_secret from vault.decrypted_secrets where name = 'service_role_key'),
      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'service_role_key')
    )
  );
  $$
);
