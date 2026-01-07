/**
 * Legacy MySQL Database Connection
 * Connects to Scanacart MySQL database (read-only)
 * Last Modified: January 2026
 */

import mysql from 'mysql2/promise';

// Connection pool configuration
const poolConfig = {
  host: process.env.LEGACY_MYSQL_HOST || '5.10.25.108',
  port: parseInt(process.env.LEGACY_MYSQL_PORT || '3306'),
  database: process.env.LEGACY_MYSQL_DATABASE || 'scanacart',
  user: process.env.LEGACY_MYSQL_USER || 'readonly',
  password: process.env.LEGACY_MYSQL_PASSWORD || '3c0@2bGJjeUj',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
};

// Create connection pool
let pool: mysql.Pool | null = null;

export function getPool(): mysql.Pool {
  if (!pool) {
    pool = mysql.createPool(poolConfig);
  }
  return pool;
}

// Helper to execute queries
export async function query<T>(sql: string, params?: unknown[]): Promise<T[]> {
  const pool = getPool();
  const [rows] = await pool.execute(sql, params);
  return rows as T[];
}

// Helper to execute single result query
export async function queryOne<T>(sql: string, params?: unknown[]): Promise<T | null> {
  const results = await query<T>(sql, params);
  return results[0] || null;
}

// ============================================
// LABELS QUERIES
// ============================================

export interface Client {
  client_id: number;
  company_name: string;
  status: string;
}

export interface LabelPassGeneration {
  label_pass_gen_id: number;
  label_pass_detail_id: number;
  client_id: number;
  num_passwords: number;
  password_length: number;
  include_alpha: string;
  alpha_char: string;
  alpha_random_ind: string;
  alpha_position: string;
  create_dt: Date;
  create_user_id: number;
  first_serial_num: string;
  last_serial_num: string;
  spreadsheet_name: string;
  company_name: string;
  num_sub_spreadsheets: number;
}

export interface LabelPassDetail {
  label_pass_detail_id: number;
  client_id: number;
  create_dt: Date;
  video_url: string;
  verify_once: string;
  verify_once_msg: string;
  label_validation_msg: string;
  label_note: string;
  exclude_from_stats: number;
  company_name: string;
}

export interface LabelValidation {
  validation_id: number;
  range_id: number;
  create_dt: Date;
  IP_addr: string;
  validation_code: string;
  reset: number;
  verify_once: string;
  company_name: string;
}

export interface PasswordValidation {
  label_pass_val_id: number;
  label_pass_detail_id: number;
  client_id: number;
  create_dt: Date;
  IP_addr: string;
  password: string;
  verify_once: string;
  verify_once_override: string;
  company_name: string;
}

// Get all approved clients
export async function getClients(page?: string): Promise<Client[]> {
  let sql = `
    SELECT client_id, company_name, status
    FROM client
    WHERE status = 'Approved'
  `;
  if (page !== 'labels-add') {
    sql += ` AND company_name != 'M80'`;
  }
  sql += ` ORDER BY company_name`;

  return query<Client>(sql);
}

// Get password generation list
export async function getPassGenerations(search?: string): Promise<LabelPassGeneration[]> {
  let sql = `
    SELECT
      lpg.label_pass_gen_id,
      lpg.label_pass_detail_id,
      lpg.client_id,
      lpg.num_passwords,
      lpg.password_length,
      lpg.include_alpha,
      lpg.alpha_char,
      lpg.alpha_random_ind,
      lpg.alpha_position,
      lpg.create_dt,
      lpg.create_user_id,
      lpg.first_serial_num,
      lpg.last_serial_num,
      lpg.spreadsheet_name,
      (SELECT c.company_name FROM client c WHERE c.client_id = lpg.client_id) as company_name,
      (SELECT count(1) FROM label_pass_generation sub WHERE sub.owner_label_pass_gen_id = lpg.label_pass_gen_id) as num_sub_spreadsheets
    FROM label_pass_generation lpg
  `;

  if (search) {
    sql += `
      , label_password lp
      WHERE lpg.label_pass_detail_id = lp.label_pass_detail_id
      AND lp.password = ?
    `;
    sql += ` ORDER BY lpg.create_dt DESC`;
    return query<LabelPassGeneration>(sql, [search.toUpperCase().trim()]);
  } else {
    sql += ` WHERE lpg.owner_label_pass_gen_id IS NULL`;
    sql += ` ORDER BY lpg.create_dt DESC`;
    return query<LabelPassGeneration>(sql);
  }
}

// Get label pass details (manage labels)
export async function getLabelPassDetails(labelPassDetailId?: number, clientId?: number): Promise<LabelPassDetail[]> {
  let sql = `
    SELECT
      lpd.label_pass_detail_id,
      lpd.client_id,
      lpd.create_dt,
      lpd.video_url,
      lpd.verify_once,
      lpd.verify_once_msg,
      lpd.label_validation_msg,
      lpd.label_note,
      lpd.exclude_from_stats,
      c.company_name
    FROM label_password_detail lpd
    JOIN client c ON c.client_id = lpd.client_id
    WHERE lpd.active = 'Y'
  `;

  const params: unknown[] = [];

  if (labelPassDetailId) {
    sql += ` AND lpd.label_pass_detail_id = ?`;
    params.push(labelPassDetailId);
  }

  if (clientId) {
    sql += ` AND c.client_id = ?`;
    params.push(clientId);
  }

  sql += ` ORDER BY lpd.create_dt DESC`;

  return query<LabelPassDetail>(sql, params);
}

// Get label validations (legacy)
export async function getLabelValidations(code: string): Promise<LabelValidation[]> {
  const sql = `
    SELECT
      lv.validation_id,
      lv.range_id,
      lv.create_dt,
      lv.IP_addr,
      lv.validation_code,
      lv.reset,
      lr.verify_once,
      c.company_name
    FROM label_validation lv
    JOIN label_range lr ON lv.range_id = lr.range_id
    JOIN client c ON c.client_id = lr.client_id
    WHERE lv.validation_code = ?
    ORDER BY lv.validation_id DESC
  `;

  return query<LabelValidation>(sql, [code.trim()]);
}

// Get password validations
export async function getPasswordValidations(code: string): Promise<PasswordValidation[]> {
  const sql = `
    SELECT
      lpv.label_pass_val_id,
      lpd.label_pass_detail_id,
      lpd.client_id,
      lpv.create_dt,
      lpv.IP_addr,
      lpv.password,
      lpd.verify_once,
      lp.verify_once_override,
      c.company_name
    FROM label_password_validation lpv
    JOIN label_password lp ON lp.password = lpv.password
    JOIN label_password_detail lpd ON lpd.label_pass_detail_id = lpv.label_pass_detail_id
    JOIN client c ON c.client_id = lpd.client_id
    WHERE lpv.password = ?
    ORDER BY lpv.label_pass_val_id DESC
  `;

  return query<PasswordValidation>(sql, [code.toUpperCase().trim()]);
}

// Get password detail by code
export async function getPasswordDetail(code: string): Promise<{
  label_pass_detail_id: number;
  client_id: number;
  verify_once: string;
  verify_once_override: string;
  company_name: string;
} | null> {
  const sql = `
    SELECT
      lpd.label_pass_detail_id,
      lpd.client_id,
      lpd.verify_once,
      lp.verify_once_override,
      c.company_name
    FROM label_password_detail lpd
    JOIN label_password lp ON lpd.label_pass_detail_id = lp.label_pass_detail_id
    JOIN client c ON c.client_id = lpd.client_id
    WHERE lp.password = ?
  `;

  return queryOne(sql, [code.trim()]);
}
