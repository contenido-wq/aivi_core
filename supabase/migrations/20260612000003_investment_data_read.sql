-- Permite al frontend leer investment_data (autenticado o anónimo con anon key).
-- La escritura sigue siendo solo para el service role (edge function).
DROP POLICY IF EXISTS "service role only" ON investment_data;

CREATE POLICY "service role write"
  ON investment_data
  FOR ALL
  USING (false)
  WITH CHECK (false);

CREATE POLICY "anyone can read"
  ON investment_data
  FOR SELECT
  USING (true);
