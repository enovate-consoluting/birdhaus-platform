-- ============================================
-- TEST DATA FOR LABELS & NFC
-- Run this after the schema migration
-- Created: January 2026
-- ============================================

-- ============================================
-- SAMPLE LABEL DATA
-- ============================================

-- Label Pass Details (Label Configurations)
INSERT INTO label_pass_detail (client_id, video_url, verify_once, label_validation_msg, label_note)
SELECT id, 'https://youtube.com/watch?v=sample1', 'N', 'Thank you for verifying!', 'Test label batch 1'
FROM clients WHERE company_name = 'Test Client' LIMIT 1;

INSERT INTO label_pass_detail (client_id, video_url, verify_once, verify_once_msg, label_validation_msg, label_note)
SELECT id, 'https://youtube.com/watch?v=sample2', 'Y', 'This label has already been verified.', 'Product verified!', 'Test label batch 2 - verify once'
FROM clients WHERE company_name = 'Test Client' LIMIT 1;

-- Label Pass Generations
INSERT INTO label_pass_generation (label_pass_detail_id, client_id, num_passwords, password_length, first_serial_num, last_serial_num, spreadsheet_name)
SELECT
  lpd.label_pass_detail_id,
  lpd.client_id,
  100,
  8,
  'TEST0001',
  'TEST0100',
  'test_labels_batch_1.xlsx'
FROM label_pass_detail lpd
LIMIT 1;

-- Sample Label Passwords
INSERT INTO label_password (label_pass_detail_id, label_pass_gen_id, password, serial_num)
SELECT
  lpd.label_pass_detail_id,
  lpg.label_pass_gen_id,
  'TESTAB01',
  'TEST0001'
FROM label_pass_detail lpd
JOIN label_pass_generation lpg ON lpg.label_pass_detail_id = lpd.label_pass_detail_id
LIMIT 1;

INSERT INTO label_password (label_pass_detail_id, label_pass_gen_id, password, serial_num)
SELECT
  lpd.label_pass_detail_id,
  lpg.label_pass_gen_id,
  'TESTAB02',
  'TEST0002'
FROM label_pass_detail lpd
JOIN label_pass_generation lpg ON lpg.label_pass_detail_id = lpd.label_pass_detail_id
LIMIT 1;

INSERT INTO label_password (label_pass_detail_id, label_pass_gen_id, password, serial_num)
SELECT
  lpd.label_pass_detail_id,
  lpg.label_pass_gen_id,
  'TESTAB03',
  'TEST0003'
FROM label_pass_detail lpd
JOIN label_pass_generation lpg ON lpg.label_pass_detail_id = lpd.label_pass_detail_id
LIMIT 1;

-- Sample Label Validations
INSERT INTO label_password_validation (label_pass_detail_id, password, ip_addr)
SELECT label_pass_detail_id, 'TESTAB01', '192.168.1.100'
FROM label_pass_detail LIMIT 1;

INSERT INTO label_password_validation (label_pass_detail_id, password, ip_addr)
SELECT label_pass_detail_id, 'TESTAB01', '10.0.0.50'
FROM label_pass_detail LIMIT 1;

-- ============================================
-- SAMPLE NFC DATA
-- ============================================

-- NFC Spools
INSERT INTO nfc_spool (client_id, num_tags, active)
SELECT id, 500, 1 FROM clients WHERE company_name = 'Test Client' LIMIT 1;

INSERT INTO nfc_spool (client_id, num_tags, active)
SELECT id, 500, 1 FROM clients WHERE company_name = 'Test Client' LIMIT 1;

INSERT INTO nfc_spool (client_id, num_tags, active)
SELECT id, 250, 0 FROM clients WHERE company_name = 'Test Client' LIMIT 1;

-- NFC Generation
INSERT INTO nfc_generation (client_id, first_spool_id, last_spool_id, num_tags, nfcs_per_spool, spreadsheet_name, note)
SELECT
  s.client_id,
  MIN(s.spool_id),
  MAX(s.spool_id),
  1000,
  500,
  'nfc_batch_test_001.xlsx',
  'Test NFC generation batch'
FROM nfc_spool s
GROUP BY s.client_id
LIMIT 1;

-- NFC Tags
INSERT INTO nfc_tag (spool_id, client_id, seq_num, product_page, video_url, live)
SELECT
  s.spool_id,
  s.client_id,
  1000001,
  'https://example.com/product/1',
  'https://youtube.com/watch?v=nfc1',
  1
FROM nfc_spool s LIMIT 1;

INSERT INTO nfc_tag (spool_id, client_id, seq_num, product_page, video_url, live)
SELECT
  s.spool_id,
  s.client_id,
  1000002,
  'https://example.com/product/2',
  'https://youtube.com/watch?v=nfc2',
  1
FROM nfc_spool s LIMIT 1;

INSERT INTO nfc_tag (spool_id, client_id, seq_num, product_page, live)
SELECT
  s.spool_id,
  s.client_id,
  1000003,
  'https://example.com/product/3',
  0
FROM nfc_spool s LIMIT 1;

-- NFC Tap Locations (Scan Records)
INSERT INTO nfc_tap_location (tag_id, ip_addr, city, country)
SELECT tag_id, '203.0.113.50', 'New York', 'USA'
FROM nfc_tag WHERE seq_num = 1000001;

INSERT INTO nfc_tap_location (tag_id, ip_addr, city, country)
SELECT tag_id, '198.51.100.25', 'Los Angeles', 'USA'
FROM nfc_tag WHERE seq_num = 1000001;

INSERT INTO nfc_tap_location (tag_id, ip_addr, city, country)
SELECT tag_id, '192.0.2.100', 'London', 'UK'
FROM nfc_tag WHERE seq_num = 1000002;

-- NFC Error Log Samples
INSERT INTO nfc_error_log (client_app, serial_no, nfc_url, seq_num, our_domain, message)
VALUES
  ('iPhone Safari', 'ABC123', 'https://nfc.example.com/1000001', 1000001, 1, 'Tag scanned successfully'),
  ('Android Chrome', 'DEF456', 'https://wrong-domain.com/tag', NULL, 0, 'Unknown domain'),
  ('iPhone Safari', 'GHI789', 'https://https://nfc.example.com', 1000002, 1, 'Double HTTPS detected');

UPDATE nfc_error_log SET double_https = 1 WHERE message LIKE '%Double HTTPS%';
