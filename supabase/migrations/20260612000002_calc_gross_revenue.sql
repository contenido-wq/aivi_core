-- Función que calcula facturación bruta neta por moneda, filtrando por producto.
-- Evita el cap de 1000 filas de PostgREST haciendo la agregación en la DB.
CREATE OR REPLACE FUNCTION calc_gross_revenue(filter_type text)
RETURNS TABLE (currency text, net_amount numeric)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    t.currency,
    SUM(CASE WHEN t.status IN ('active', 'delayed')         THEN t.amount ELSE 0 END) -
    SUM(CASE WHEN t.status IN ('refunded', 'chargeback')    THEN t.amount ELSE 0 END)
      AS net_amount
  FROM transactions t
  WHERE
       filter_type IN ('todos', 'multiProducto')
    OR (filter_type = 'AIVI'    AND t.plan_name ILIKE 'AIVI%')
    OR (filter_type = 'MV3'     AND (t.plan_name ILIKE 'Método V3%' OR t.plan_name ILIKE 'MV3%'))
    OR (filter_type = 'Reto15D' AND (t.plan_name ILIKE 'Reto 15D%'  OR t.plan_name ILIKE 'Reto15D%'))
    OR (filter_type = 'sinAIVI' AND t.plan_name NOT ILIKE 'AIVI%')
  GROUP BY t.currency
  HAVING
    SUM(CASE WHEN t.status IN ('active', 'delayed')         THEN t.amount ELSE 0 END) -
    SUM(CASE WHEN t.status IN ('refunded', 'chargeback')    THEN t.amount ELSE 0 END) != 0;
$$;

GRANT EXECUTE ON FUNCTION calc_gross_revenue(text) TO anon, authenticated;
