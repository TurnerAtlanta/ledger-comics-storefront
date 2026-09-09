CREATE TABLE IF NOT EXISTS products (
  id TEXT PRIMARY KEY,
  slug TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  issue_number INTEGER NOT NULL,
  author TEXT NOT NULL,
  price_cents INTEGER NOT NULL,
  stripe_price_id TEXT NOT NULL,
  r2_key TEXT NOT NULL,
  active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
  id TEXT PRIMARY KEY,
  stripe_session_id TEXT NOT NULL UNIQUE,
  email TEXT NOT NULL,
  product_id TEXT NOT NULL,
  amount_total_cents INTEGER NOT NULL,
  currency TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'paid',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE IF NOT EXISTS download_tokens (
  id TEXT PRIMARY KEY,
  order_id TEXT NOT NULL,
  product_id TEXT NOT NULL,
  token_hash TEXT NOT NULL UNIQUE,
  expires_at TEXT NOT NULL,
  download_count INTEGER NOT NULL DEFAULT 0,
  max_downloads INTEGER NOT NULL DEFAULT 5,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE IF NOT EXISTS leads (
  id TEXT PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  source TEXT NOT NULL,
  consent_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_orders_email ON orders(email);
CREATE INDEX IF NOT EXISTS idx_orders_product_id ON orders(product_id);
CREATE INDEX IF NOT EXISTS idx_download_tokens_order_id ON download_tokens(order_id);
CREATE INDEX IF NOT EXISTS idx_download_tokens_expires_at ON download_tokens(expires_at);

INSERT OR IGNORE INTO products (
  id,
  slug,
  title,
  issue_number,
  author,
  price_cents,
  stripe_price_id,
  r2_key,
  active
) VALUES (
  'issue-01-digital',
  'the-money-disappearing-act',
  'The Money-Disappearing Act',
  1,
  'Grant Ledger',
  499,
  'price_1UDWfnLwfZ4YRJf5gsnyrRUU',
  'paid/LEDGER-Ch01_The-Money-Disappearing-Act.pdf',
  1
);
