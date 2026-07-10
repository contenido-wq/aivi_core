-- ── vturb_by_country ──────────────────────────────────────────────────────────
create table if not exists public.vturb_by_country (
  id           uuid primary key default gen_random_uuid(),
  video_id     text not null,
  date         date not null,
  country_code text not null,
  country_name text,
  plays        integer default 0,
  views        integer default 0,
  created_at   timestamptz default now(),
  unique(video_id, date, country_code)
);
create index if not exists vturb_by_country_vid_date_idx
  on public.vturb_by_country(video_id, date);

alter table public.vturb_by_country enable row level security;
create policy "service_all_vturb_by_country" on public.vturb_by_country
  for all using (auth.role() = 'service_role');
create policy "auth_read_vturb_by_country" on public.vturb_by_country
  for select using (auth.role() = 'authenticated');

-- ── vturb_by_device ───────────────────────────────────────────────────────────
create table if not exists public.vturb_by_device (
  id          uuid primary key default gen_random_uuid(),
  video_id    text not null,
  date        date not null,
  device_type text not null,
  plays       integer default 0,
  views       integer default 0,
  created_at  timestamptz default now(),
  unique(video_id, date, device_type)
);
create index if not exists vturb_by_device_vid_date_idx
  on public.vturb_by_device(video_id, date);

alter table public.vturb_by_device enable row level security;
create policy "service_all_vturb_by_device" on public.vturb_by_device
  for all using (auth.role() = 'service_role');
create policy "auth_read_vturb_by_device" on public.vturb_by_device
  for select using (auth.role() = 'authenticated');

-- ── vturb_by_os ───────────────────────────────────────────────────────────────
create table if not exists public.vturb_by_os (
  id         uuid primary key default gen_random_uuid(),
  video_id   text not null,
  date       date not null,
  os_name    text not null,
  plays      integer default 0,
  views      integer default 0,
  created_at timestamptz default now(),
  unique(video_id, date, os_name)
);
create index if not exists vturb_by_os_vid_date_idx
  on public.vturb_by_os(video_id, date);

alter table public.vturb_by_os enable row level security;
create policy "service_all_vturb_by_os" on public.vturb_by_os
  for all using (auth.role() = 'service_role');
create policy "auth_read_vturb_by_os" on public.vturb_by_os
  for select using (auth.role() = 'authenticated');

-- ── vturb_by_browser ──────────────────────────────────────────────────────────
create table if not exists public.vturb_by_browser (
  id           uuid primary key default gen_random_uuid(),
  video_id     text not null,
  date         date not null,
  browser_name text not null,
  plays        integer default 0,
  views        integer default 0,
  created_at   timestamptz default now(),
  unique(video_id, date, browser_name)
);
create index if not exists vturb_by_browser_vid_date_idx
  on public.vturb_by_browser(video_id, date);

alter table public.vturb_by_browser enable row level security;
create policy "service_all_vturb_by_browser" on public.vturb_by_browser
  for all using (auth.role() = 'service_role');
create policy "auth_read_vturb_by_browser" on public.vturb_by_browser
  for select using (auth.role() = 'authenticated');
