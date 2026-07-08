-- Usuarios que entraron a AIVI con un código de evento (presencial o virtual),
-- con su uso real de cada módulo. Alimentada por CSVs exportados desde AIVI
-- y subidos manualmente desde la vista "Eventos".

create table if not exists public.event_users (
  id                            uuid primary key default gen_random_uuid(),
  enrollment_code               text not null,
  variacion                     text,
  external_user_id              text,
  nombre                        text,
  email                         text not null,
  usuario_activo                boolean default false,
  verificado                    boolean default false,
  registrado_el                 date,
  plan                          text,
  estado_plan                   text,
  ciclo_inicio                  date,
  ciclo_fin                     date,
  tokens_plan_consumidos_ciclo  integer default 0,
  tokens_plan_consumidos_total  integer default 0,
  adn_creator_exitosas          integer default 0, adn_creator_ultima          date,
  adn_view_exitosas             integer default 0, adn_view_ultima             date,
  analista_exitosas             integer default 0, analista_ultima             date,
  calendar_exitosas             integer default 0, calendar_ultima             date,
  carousel_generator_exitosas   integer default 0, carousel_generator_ultima   date,
  carousel_pro_exitosas         integer default 0, carousel_pro_ultima         date,
  chat_response_exitosas        integer default 0, chat_response_ultima        date,
  espia_ai_exitosas             integer default 0, espia_ai_ultima             date,
  referente_search_exitosas     integer default 0, referente_search_ultima     date,
  sales_simulator_exitosas      integer default 0, sales_simulator_ultima      date,
  script_generator_exitosas     integer default 0, script_generator_ultima     date,
  transcriptor_exitosas         integer default 0, transcriptor_ultima         date,
  viral_ideas_exitosas          integer default 0, viral_ideas_ultima          date,
  uploaded_at                   timestamptz not null default now(),
  unique (enrollment_code, email)
);

create index if not exists event_users_enrollment_code_idx on public.event_users(enrollment_code);

alter table public.event_users enable row level security;

create policy "auth_all_event_users" on public.event_users
  for all using (auth.role() = 'authenticated');
