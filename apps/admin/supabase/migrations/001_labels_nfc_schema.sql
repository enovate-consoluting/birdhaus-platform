-- ============================================
-- BIRDHAUS ADMIN - LABELS & NFC SCHEMA
-- Supabase Migration
-- Created: January 2026
-- ============================================

-- ============================================
-- LABELS TABLES
-- ============================================

-- Label Pass Detail (Label Configurations)
CREATE TABLE IF NOT EXISTS label_pass_detail (
  label_pass_detail_id SERIAL PRIMARY KEY,
  client_id INTEGER NOT NULL REFERENCES clients(id),
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
  label_pass_detail_id INTEGER REFERENCES label_pass_detail(label_pass_detail_id),
  client_id INTEGER NOT NULL REFERENCES clients(id),
  num_passwords INTEGER NOT NULL,
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
  owner_label_pass_gen_id INTEGER REFERENCES label_pass_generation(label_pass_gen_id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Label Password (Individual Labels)
CREATE TABLE IF NOT EXISTS label_password (
  label_pass_id SERIAL PRIMARY KEY,
  label_pass_detail_id INTEGER NOT NULL REFERENCES label_pass_detail(label_pass_detail_id),
  label_pass_gen_id INTEGER REFERENCES label_pass_generation(label_pass_gen_id),
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
  label_pass_detail_id INTEGER NOT NULL REFERENCES label_pass_detail(label_pass_detail_id),
  password VARCHAR(50) NOT NULL,
  ip_addr VARCHAR(50),
  user_agent TEXT,
  create_dt TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Legacy Label Range (for backward compatibility)
CREATE TABLE IF NOT EXISTS label_range (
  range_id SERIAL PRIMARY KEY,
  client_id INTEGER NOT NULL REFERENCES clients(id),
  start_code VARCHAR(50),
  end_code VARCHAR(50),
  verify_once VARCHAR(1) DEFAULT 'N',
  active VARCHAR(1) DEFAULT 'Y',
  create_dt TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Legacy Label Validation (for backward compatibility)
CREATE TABLE IF NOT EXISTS label_validation (
  validation_id SERIAL PRIMARY KEY,
  range_id INTEGER REFERENCES label_range(range_id),
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
  client_id INTEGER REFERENCES clients(id),
  num_tags INTEGER NOT NULL DEFAULT 0,
  active SMALLINT DEFAULT 1,
  create_dt TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- NFC Generation (Generation Batches)
CREATE TABLE IF NOT EXISTS nfc_generation (
  nfc_gen_id SERIAL PRIMARY KEY,
  client_id INTEGER REFERENCES clients(id),
  first_spool_id INTEGER REFERENCES nfc_spool(spool_id),
  last_spool_id INTEGER REFERENCES nfc_spool(spool_id),
  num_tags INTEGER NOT NULL,
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
  spool_id INTEGER NOT NULL REFERENCES nfc_spool(spool_id),
  client_id INTEGER REFERENCES clients(id),
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
  tag_id INTEGER NOT NULL REFERENCES nfc_tag(tag_id),
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
-- INDEXES FOR PERFORMANCE
-- ============================================

-- Labels indexes
CREATE INDEX IF NOT EXISTS idx_label_pass_detail_client ON label_pass_detail(client_id);
CREATE INDEX IF NOT EXISTS idx_label_pass_generation_client ON label_pass_generation(client_id);
CREATE INDEX IF NOT EXISTS idx_label_pass_generation_detail ON label_pass_generation(label_pass_detail_id);
CREATE INDEX IF NOT EXISTS idx_label_password_detail ON label_password(label_pass_detail_id);
CREATE INDEX IF NOT EXISTS idx_label_password_password ON label_password(password);
CREATE INDEX IF NOT EXISTS idx_label_password_validation_detail ON label_password_validation(label_pass_detail_id);
CREATE INDEX IF NOT EXISTS idx_label_password_validation_password ON label_password_validation(password);
CREATE INDEX IF NOT EXISTS idx_label_validation_code ON label_validation(validation_code);

-- NFC indexes
CREATE INDEX IF NOT EXISTS idx_nfc_spool_client ON nfc_spool(client_id);
CREATE INDEX IF NOT EXISTS idx_nfc_generation_client ON nfc_generation(client_id);
CREATE INDEX IF NOT EXISTS idx_nfc_tag_spool ON nfc_tag(spool_id);
CREATE INDEX IF NOT EXISTS idx_nfc_tag_client ON nfc_tag(client_id);
CREATE INDEX IF NOT EXISTS idx_nfc_tag_seq_num ON nfc_tag(seq_num);
CREATE INDEX IF NOT EXISTS idx_nfc_tap_location_tag ON nfc_tap_location(tag_id);
CREATE INDEX IF NOT EXISTS idx_nfc_error_log_create_dt ON nfc_error_log(create_dt);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on all tables
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

-- Policies for service role (full access)
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
-- UPDATED_AT TRIGGER
-- ============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger to tables with updated_at
CREATE TRIGGER update_label_pass_detail_updated_at BEFORE UPDATE ON label_pass_detail FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_label_pass_generation_updated_at BEFORE UPDATE ON label_pass_generation FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_label_password_updated_at BEFORE UPDATE ON label_password FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_label_range_updated_at BEFORE UPDATE ON label_range FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_nfc_spool_updated_at BEFORE UPDATE ON nfc_spool FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_nfc_generation_updated_at BEFORE UPDATE ON nfc_generation FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_nfc_tag_updated_at BEFORE UPDATE ON nfc_tag FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
