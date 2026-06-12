-- Tabla de inversión publicitaria por plataforma y día.
-- La edge function utmify-sync escribe aquí cada vez que corre.
CREATE TABLE IF NOT EXISTS investment_data (
  id          uuid        DEFAULT gen_random_uuid() PRIMARY KEY,
  date        date        NOT NULL,
  platform    text        NOT NULL,  -- 'facebook' | 'google' | 'tiktok' | 'other'
  investment  numeric     DEFAULT 0,
  impressions numeric     DEFAULT 0,
  clicks      numeric     DEFAULT 0,
  raw_data    jsonb,
  synced_at   timestamptz,
  UNIQUE (date, platform)
);

ALTER TABLE investment_data ENABLE ROW LEVEL SECURITY;

-- Solo el service role (edge function) puede leer/escribir.
-- El frontend no necesita acceso directo a esta tabla.
CREATE POLICY "service role only"
  ON investment_data
  USING (false);
