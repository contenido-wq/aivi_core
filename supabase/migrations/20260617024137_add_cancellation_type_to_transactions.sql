ALTER TABLE transactions
  ADD COLUMN IF NOT EXISTS cancellation_type TEXT;
