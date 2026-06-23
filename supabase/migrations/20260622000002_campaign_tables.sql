create table if not exists public.campaign_investment_data (
  id            uuid primary key default gen_random_uuid(),
  campaign_id   text not null,
  campaign_name text,
  date          date not null,
  platform      text default 'facebook',
  investment    numeric(10,2) default 0,
  impressions   integer default 0,
  clicks        integer default 0,
  synced_at     timestamptz,
  created_at    timestamptz default now(),
  unique(campaign_id, date, platform)
);

create table if not exists public.campaign_vsl_mapping (
  campaign_name text primary key,
  video_id      text not null,
  video_name    text,
  created_at    timestamptz default now()
);

alter table public.campaign_investment_data enable row level security;
alter table public.campaign_vsl_mapping     enable row level security;

create policy "service_all_campaign_investment" on public.campaign_investment_data
  for all using (auth.role() = 'service_role');

create policy "auth_read_campaign_investment" on public.campaign_investment_data
  for select using (auth.role() = 'authenticated');

create policy "service_all_vsl_mapping" on public.campaign_vsl_mapping
  for all using (auth.role() = 'service_role');

create policy "auth_all_vsl_mapping" on public.campaign_vsl_mapping
  for all using (auth.role() = 'authenticated');
