alter table public.transactions add column if not exists ad_id      text;
alter table public.transactions add column if not exists ad_name    text;
alter table public.transactions add column if not exists adset_id   text;
alter table public.transactions add column if not exists adset_name text;
alter table public.transactions add column if not exists placement  text;

alter table public.vturb_analytics add column if not exists unique_views  integer default 0;
alter table public.vturb_analytics add column if not exists unique_plays integer default 0;
alter table public.vturb_analytics add column if not exists pitch_second integer;

create table if not exists public.ad_investment_data (
  id            uuid primary key default gen_random_uuid(),
  ad_id         text not null,
  ad_name       text,
  campaign_id   text,
  date          date not null,
  platform      text default 'facebook',
  investment    numeric(10,2) default 0,
  impressions   integer default 0,
  clicks        integer default 0,
  synced_at     timestamptz default now(),
  unique(ad_id, date, platform)
);

create table if not exists public.ad_vsl_mapping (
  ad_id      text primary key,
  video_id   text not null,
  video_name text,
  created_at timestamptz default now()
);

alter table public.ad_investment_data enable row level security;
alter table public.ad_vsl_mapping     enable row level security;

create policy "service_all_ad_investment_data" on public.ad_investment_data
  for all using (auth.role() = 'service_role');

create policy "auth_read_ad_investment_data" on public.ad_investment_data
  for select using (auth.role() = 'authenticated');

create policy "service_all_ad_vsl_mapping" on public.ad_vsl_mapping
  for all using (auth.role() = 'service_role');

create policy "auth_all_ad_vsl_mapping" on public.ad_vsl_mapping
  for all using (auth.role() = 'authenticated');
