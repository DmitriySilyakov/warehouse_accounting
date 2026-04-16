CREATE TABLE IF NOT EXISTS cutting_tools (
  id SERIAL PRIMARY KEY,
  sku VARCHAR(32) UNIQUE NOT NULL,
  name TEXT NOT NULL,
  tool_type VARCHAR(32) NOT NULL,
  material VARCHAR(32) NOT NULL,
  coating VARCHAR(32),
  diameter_mm NUMERIC(10,2),
  working_length_mm NUMERIC(10,2),
  overall_length_mm NUMERIC(10,2),
  shank_diameter_mm NUMERIC(10,2),
  teeth_count INTEGER,
  quantity INTEGER NOT NULL DEFAULT 0,
  unit VARCHAR(16) NOT NULL DEFAULT 'шт',
  location VARCHAR(32) NOT NULL,
  manufacturer VARCHAR(64),
  note TEXT
);

CREATE TABLE IF NOT EXISTS tool_movements (
  id BIGSERIAL PRIMARY KEY,
  tool_id INTEGER NOT NULL REFERENCES cutting_tools(id) ON DELETE CASCADE,
  move_type VARCHAR(8) NOT NULL CHECK (move_type IN ('in', 'out')),
  amount INTEGER NOT NULL CHECK (amount > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO cutting_tools (
  sku, name, tool_type, material, coating,
  diameter_mm, working_length_mm, overall_length_mm, shank_diameter_mm,
  teeth_count, quantity, unit, location, manufacturer, note
)
VALUES
  (
    'FR-1001',
    'Фреза концевая твердосплавная Ø10',
    'фреза концевая',
    'твердый сплав',
    'TiAlN',
    10.00, 25.00, 75.00, 10.00,
    4, 16, 'шт', 'T-01', 'Sandvik', 'Для обработки стали'
  ),
  (
    'DR-1002',
    'Сверло спиральное Ø8',
    'сверло',
    'HSS-Co',
    'TiN',
    8.00, 50.00, 117.00, 8.00,
    NULL, 24, 'шт', 'T-02', 'Dormer', 'Для нержавеющей стали'
  ),
  (
    'TP-2001',
    'Токарная пластина CNMG 120408',
    'токарная пластина',
    'твердый сплав',
    'CVD',
    NULL, NULL, NULL, NULL,
    NULL, 140, 'шт', 'P-01', 'ISCAR', 'Черновая обработка'
  ),
  (
    'EM-3001',
    'Метчик машинный М10',
    'метчик',
    'HSS-E',
    'TiN',
    10.00, 24.00, 80.00, 8.00,
    NULL, 12, 'шт', 'T-05', 'Guhring', 'Резьба М10'
  )
ON CONFLICT (sku) DO NOTHING;