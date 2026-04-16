CREATE TABLE IF NOT EXISTS items (
  id SERIAL PRIMARY KEY,
  sku VARCHAR(32) UNIQUE NOT NULL,
  name TEXT NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 0,
  unit VARCHAR(16) NOT NULL DEFAULT 'шт',
  location VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS movements (
  id BIGSERIAL PRIMARY KEY,
  item_id INTEGER NOT NULL REFERENCES items(id) ON DELETE CASCADE,
  move_type VARCHAR(8) NOT NULL CHECK (move_type IN ('in', 'out')),
  amount INTEGER NOT NULL CHECK (amount > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO items (sku, name, quantity, unit, location)
VALUES
  ('EL-1001', 'Сканер штрихкодов', 16, 'шт', 'A-01'),
  ('EL-1002', 'Термопринтер', 9, 'шт', 'A-03'),
  ('PK-2001', 'Коробка 400x300', 140, 'шт', 'B-02'),
  ('PK-2002', 'Пленка стрейч', 52, 'рул', 'B-05')
ON CONFLICT (sku) DO NOTHING;
