-- ============================================
-- BIRDHAUS ADMIN - STANDALONE LABELS & NFC SCHEMA
-- No foreign key constraints (for easier initial setup)
-- Created: January 2026
-- ============================================

-- ============================================
-- LABELS TABLES
-- ============================================

-- Label Pass Detail (Label Configurations)
CREATE TABLE IF NOT EXISTS label_pass_detail (
  label_pass_detail_id SERIAL PRIMARY KEY,
  client_id INTEGER,
  create_dt TIMESTAMPTZ DEFAULT NOW(),
  video_url TEXT,
  verify_once VARCHAR(1) DEFAULT 'N',
  verify_once_msg TEXT,
  label_validation_msg TEXT,
  label_note TEXT,
  exclude_from_stats SMALLINT DEFAULT 0,
  active VARCHAR(1) DEFAULT 'Y',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Label Pass Generation (Generation Batches)
CREATE TABLE IF NOT EXISTS label_pass_generation (
  label_pass_gen_id SERIAL PRIMARY KEY,
  label_pass_detail_id INTEGER,
  client_id INTEGER,
  num_passwords INTEGER NOT NULL DEFAULT 0,
  password_length INTEGER DEFAULT 8,
  include_alpha VARCHAR(1) DEFAULT 'N',
  alpha_char VARCHAR(10),
  alpha_random_ind VARCHAR(1) DEFAULT 'N',
  alpha_position VARCHAR(20),
  create_dt TIMESTAMPTZ DEFAULT NOW(),
  create_user_id INTEGER,
  first_serial_num VARCHAR(50),
  last_serial_num VARCHAR(50),
  spreadsheet_name VARCHAR(255),
  owner_label_pass_gen_id INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Label Password (Individual Labels)
CREATE TABLE IF NOT EXISTS label_password (
  label_pass_id SERIAL PRIMARY KEY,
  label_pass_detail_id INTEGER,
  label_pass_gen_id INTEGER,
  password VARCHAR(50) NOT NULL UNIQUE,
  serial_num VARCHAR(50),
  verify_once_override VARCHAR(1) DEFAULT 'N',
  active VARCHAR(1) DEFAULT 'Y',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Label Password Validation (Scan Records)
CREATE TABLE IF NOT EXISTS label_password_validation (
  label_pass_val_id SERIAL PRIMARY KEY,
  label_pass_detail_id INTEGER,
  password VARCHAR(50) NOT NULL,
  ip_addr VARCHAR(50),
  user_agent TEXT,
  create_dt TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Legacy Label Range
CREATE TABLE IF NOT EXISTS label_range (
  range_id SERIAL PRIMARY KEY,
  client_id INTEGER,
  start_code VARCHAR(50),
  end_code VARCHAR(50),
  verify_once VARCHAR(1) DEFAULT 'N',
  active VARCHAR(1) DEFAULT 'Y',
  create_dt TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Legacy Label Validation
CREATE TABLE IF NOT EXISTS label_validation (
  validation_id SERIAL PRIMARY KEY,
  range_id INTEGER,
  validation_code VARCHAR(50) NOT NULL,
  ip_addr VARCHAR(50),
  reset SMALLINT DEFAULT 0,
  create_dt TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- NFC TABLES
-- ============================================

-- Spool (NFC Spool Inventory)
CREATE TABLE IF NOT EXISTS nfc_spool (
  spool_id SERIAL PRIMARY KEY,
  client_id INTEGER,
  num_tags INTEGER NOT NULL DEFAULT 0,
  active SMALLINT DEFAULT 1,
  create_dt TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- NFC Generation (Generation Batches)
CREATE TABLE IF NOT EXISTS nfc_generation (
  nfc_gen_id SERIAL PRIMARY KEY,
  client_id INTEGER,
  first_spool_id INTEGER,
  last_spool_id INTEGER,
  num_tags INTEGER NOT NULL DEFAULT 0,
  nfcs_per_spool INTEGER DEFAULT 500,
  create_dt TIMESTAMPTZ DEFAULT NOW(),
  create_user_id INTEGER,
  spreadsheet_name VARCHAR(255),
  note TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- NFC Tag (Individual Tags)
CREATE TABLE IF NOT EXISTS nfc_tag (
  tag_id SERIAL PRIMARY KEY,
  spool_id INTEGER,
  client_id INTEGER,
  seq_num INTEGER NOT NULL UNIQUE,
  serial_no VARCHAR(100),
  product_page TEXT,
  video_url TEXT,
  live SMALLINT DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- NFC Tap Location (Scan Tracking)
CREATE TABLE IF NOT EXISTS nfc_tap_location (
  tap_loc_id SERIAL PRIMARY KEY,
  tag_id INTEGER,
  ip_addr VARCHAR(50),
  user_agent TEXT,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  city VARCHAR(100),
  country VARCHAR(100),
  create_dt TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- NFC Error Log
CREATE TABLE IF NOT EXISTS nfc_error_log (
  log_id SERIAL PRIMARY KEY,
  client_app VARCHAR(100),
  serial_no VARCHAR(100),
  nfc_url TEXT,
  seq_num INTEGER,
  our_domain SMALLINT DEFAULT 0,
  double_https SMALLINT DEFAULT 0,
  active SMALLINT DEFAULT 1,
  message TEXT,
  archived SMALLINT DEFAULT 0,
  create_dt TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX IF NOT EXISTS idx_label_pass_detail_client ON label_pass_detail(client_id);
CREATE INDEX IF NOT EXISTS idx_label_pass_generation_client ON label_pass_generation(client_id);
CREATE INDEX IF NOT EXISTS idx_label_pass_generation_detail ON label_pass_generation(label_pass_detail_id);
CREATE INDEX IF NOT EXISTS idx_label_password_detail ON label_password(label_pass_detail_id);
CREATE INDEX IF NOT EXISTS idx_label_password_password ON label_password(password);
CREATE INDEX IF NOT EXISTS idx_label_password_validation_detail ON label_password_validation(label_pass_detail_id);
CREATE INDEX IF NOT EXISTS idx_label_password_validation_password ON label_password_validation(password);
CREATE INDEX IF NOT EXISTS idx_label_validation_code ON label_validation(validation_code);
CREATE INDEX IF NOT EXISTS idx_nfc_spool_client ON nfc_spool(client_id);
CREATE INDEX IF NOT EXISTS idx_nfc_generation_client ON nfc_generation(client_id);
CREATE INDEX IF NOT EXISTS idx_nfc_tag_spool ON nfc_tag(spool_id);
CREATE INDEX IF NOT EXISTS idx_nfc_tag_client ON nfc_tag(client_id);
CREATE INDEX IF NOT EXISTS idx_nfc_tag_seq_num ON nfc_tag(seq_num);
CREATE INDEX IF NOT EXISTS idx_nfc_tap_location_tag ON nfc_tap_location(tag_id);
CREATE INDEX IF NOT EXISTS idx_nfc_error_log_create_dt ON nfc_error_log(create_dt);

-- ============================================
-- ROW LEVEL SECURITY
-- ============================================

ALTER TABLE label_pass_detail ENABLE ROW LEVEL SECURITY;
ALTER TABLE label_pass_generation ENABLE ROW LEVEL SECURITY;
ALTER TABLE label_password ENABLE ROW LEVEL SECURITY;
ALTER TABLE label_password_validation ENABLE ROW LEVEL SECURITY;
ALTER TABLE label_range ENABLE ROW LEVEL SECURITY;
ALTER TABLE label_validation ENABLE ROW LEVEL SECURITY;
ALTER TABLE nfc_spool ENABLE ROW LEVEL SECURITY;
ALTER TABLE nfc_generation ENABLE ROW LEVEL SECURITY;
ALTER TABLE nfc_tag ENABLE ROW LEVEL SECURITY;
ALTER TABLE nfc_tap_location ENABLE ROW LEVEL SECURITY;
ALTER TABLE nfc_error_log ENABLE ROW LEVEL SECURITY;

-- Allow service role full access
CREATE POLICY "Service role full access" ON label_pass_detail FOR ALL USING (true);
CREATE POLICY "Service role full access" ON label_pass_generation FOR ALL USING (true);
CREATE POLICY "Service role full access" ON label_password FOR ALL USING (true);
CREATE POLICY "Service role full access" ON label_password_validation FOR ALL USING (true);
CREATE POLICY "Service role full access" ON label_range FOR ALL USING (true);
CREATE POLICY "Service role full access" ON label_validation FOR ALL USING (true);
CREATE POLICY "Service role full access" ON nfc_spool FOR ALL USING (true);
CREATE POLICY "Service role full access" ON nfc_generation FOR ALL USING (true);
CREATE POLICY "Service role full access" ON nfc_tag FOR ALL USING (true);
CREATE POLICY "Service role full access" ON nfc_tap_location FOR ALL USING (true);
CREATE POLICY "Service role full access" ON nfc_error_log FOR ALL USING (true);

-- ============================================
-- TEST DATA
-- ============================================

-- Insert test label data
INSERT INTO label_pass_detail (client_id, video_url, verify_once, label_validation_msg, label_note)
VALUES (1, 'https://youtube.com/watch?v=sample1', 'N', 'Thank you for verifying!', 'Test label batch 1');

INSERT INTO label_pass_generation (label_pass_detail_id, client_id, num_passwords, password_length, first_serial_num, last_serial_num, spreadsheet_name)
VALUES (1, 1, 100, 8, 'TEST0001', 'TEST0100', 'test_labels_batch_1.xlsx');

INSERT INTO label_password (label_pass_detail_id, label_pass_gen_id, password, serial_num)
VALUES
  (1, 1, 'TESTAB01', 'TEST0001'),
  (1, 1, 'TESTAB02', 'TEST0002'),
  (1, 1, 'TESTAB03', 'TEST0003');

-- Insert test NFC data
INSERT INTO nfc_spool (client_id, num_tags, active)
VALUES
  (1, 500, 1),
  (1, 500, 1),
  (1, 250, 0);

INSERT INTO nfc_generation (client_id, first_spool_id, last_spool_id, num_tags, nfcs_per_spool, spreadsheet_name, note)
VALUES (1, 1, 2, 1000, 500, 'nfc_batch_test_001.xlsx', 'Test NFC generation batch');

INSERT INTO nfc_tag (spool_id, client_id, seq_num, product_page, video_url, live)
VALUES
  (1, 1, 1000001, 'https://example.com/product/1', 'https://youtube.com/watch?v=nfc1', 1),
  (1, 1, 1000002, 'https://example.com/product/2', 'https://youtube.com/watch?v=nfc2', 1),
  (1, 1, 1000003, 'https://example.com/product/3', NULL, 0);

INSERT INTO nfc_tap_location (tag_id, ip_addr, city, country)
VALUES
  (1, '203.0.113.50', 'New York', 'USA'),
  (1, '198.51.100.25', 'Los Angeles', 'USA'),
  (2, '192.0.2.100', 'London', 'UK');

INSERT INTO nfc_error_log (client_app, serial_no, nfc_url, seq_num, our_domain, message)
VALUES
  ('iPhone Safari', 'ABC123', 'https://nfc.example.com/1000001', 1000001, 1, 'Tag scanned successfully'),
  ('Android Chrome', 'DEF456', 'https://wrong-domain.com/tag', NULL, 0, 'Unknown domain'),
  ('iPhone Safari', 'GHI789', 'https://https://nfc.example.com', 1000002, 1, 'Double HTTPS detected');
