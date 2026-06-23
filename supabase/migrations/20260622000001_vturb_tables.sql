create table if not exists public.vturb_analytics (
  id             uuid primary key default gen_random_uuid(),
  video_id       text not null,
  video_name     text,
  date           date not null,
  plays          integer default 0,
  views          integer default 0,
  play_rate      numeric(5,2),
  avg_watch_time integer,
  button_clicks  integer default 0,
  created_at     timestamptz default now(),
  unique(video_id, date)
);

create table if not exists public.vturb_retention (
  id         uuid primary key default gen_random_uuid(),
  video_id   text not null,
  date       date not null,
  second     integer not null,
  percentage numeric(5,2),
  created_at timestamptz default now(),
  unique(video_id, date, second)
);

alter table public.vturb_analytics enable row level security;
alter table public.vturb_retention  enable row level security;

create policy "service_all_vturb_analytics" on public.vturb_analytics
  for all using (auth.role() = 'service_role');

create policy "auth_read_vturb_analytics" on public.vturb_analytics
  for select using (auth.role() = 'authenticated');

create policy "service_all_vturb_retention" on public.vturb_retention
  for all using (auth.role() = 'service_role');

create policy "auth_read_vturb_retention" on public.vturb_retention
  for select using (auth.role() = 'authenticated');
