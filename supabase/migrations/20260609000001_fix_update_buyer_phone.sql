-- Reemplaza update_buyer_phone para actualizar tanto NULL como string vacío
CREATE OR REPLACE FUNCTION update_buyer_phone(p_email TEXT, p_phone TEXT)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  rows_updated INTEGER;
BEGIN
  UPDATE transactions
  SET    buyer_phone = p_phone
  WHERE  LOWER(TRIM(buyer_email)) = LOWER(TRIM(p_email))
    AND  (buyer_phone IS NULL OR TRIM(buyer_phone) = '' OR buyer_phone = '—');

  GET DIAGNOSTICS rows_updated = ROW_COUNT;
  RETURN rows_updated;
END;
$$;
