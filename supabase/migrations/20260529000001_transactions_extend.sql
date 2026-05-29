-- Agrega campos de contacto, origen y tráfico a transactions
alter table public.transactions
  add column if not exists buyer_phone    text,
  add column if not exists buyer_country  text,
  add column if not exists offer_code     text,
  add column if not exists sale_origin    text,
  add column if not exists traffic_source text;

-- Índices para búsqueda frecuente
create index if not exists transactions_buyer_email_idx   on public.transactions(buyer_email);
create index if not exists transactions_buyer_country_idx on public.transactions(buyer_country);
create index if not exists transactions_event_type_idx    on public.transactions(event_type);
create index if not exists transactions_status_idx        on public.transactions(status);
create index if not exists transactions_created_at_idx    on public.transactions(created_at desc);
