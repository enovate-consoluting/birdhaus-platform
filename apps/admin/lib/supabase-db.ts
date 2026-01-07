/**
 * Supabase Database Queries
 * Replaces Legacy MySQL - connects to Supabase PostgreSQL
 * Last Modified: January 2026
 */

import { getServiceSupabase } from './supabase';

// ============================================
// TYPES
// ============================================

export interface Client {
  client_id: number;
  company_name: string;
  status: string;
}

export interface LabelPassDetail {
  label_pass_detail_id: number;
  client_id: number;
  create_dt: string;
  video_url: string;
  verify_once: string;
  verify_once_msg: string;
  label_validation_msg: string;
  label_note: string;
  exclude_from_stats: number;
  company_name?: string;
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
  create_dt: string;
  create_user_id: number;
  first_serial_num: string;
  last_serial_num: string;
  spreadsheet_name: string;
  company_name?: string;
  num_sub_spreadsheets?: number;
}

export interface LabelPassword {
  label_pass_id: number;
  label_pass_detail_id: number;
  label_pass_gen_id: number;
  password: string;
  serial_num: string;
  verify_once_override: string;
}

export interface LabelValidation {
  validation_id: number;
  range_id: number;
  create_dt: string;
  ip_addr: string;
  validation_code: string;
  reset: number;
  verify_once: string;
  company_name: string;
}

export interface PasswordValidation {
  label_pass_val_id: number;
  label_pass_detail_id: number;
  client_id: number;
  create_dt: string;
  ip_addr: string;
  password: string;
  verify_once: string;
  verify_once_override: string;
  company_name: string;
}

export interface NfcGeneration {
  nfc_gen_id: number;
  first_spool_id: number;
  last_spool_id: number;
  client_id: number;
  num_tags: number;
  create_dt: string;
  create_user_id: number;
  spreadsheet_name: string;
  nfcs_per_spool: number;
  note: string;
  company_name?: string;
  video_url?: string;
}

export interface Spool {
  spool_id: number;
  num_tags: number;
  create_dt: string;
  active: number;
  client_id: number;
  company_name?: string;
  video_url?: string;
}

export interface NfcTag {
  tag_id: number;
  seq_num: number;
  spool_id: number;
  product_page: string;
  video_url: string;
  client_id: number;
  live: number;
  company_name?: string;
  scan_count?: number;
}

export interface NfcErrorLog {
  log_id: number;
  client_app: string;
  serial_no: string;
  nfc_url: string;
  seq_num: number;
  our_domain: number;
  double_https: number;
  active: number;
  message: string;
  create_dt: string;
  archived: number;
}

// ============================================
// LABELS QUERIES
// ============================================

// Get all approved clients
export async function getClients(page?: string): Promise<Client[]> {
  const supabase = getServiceSupabase();

  let query = supabase
    .from('clients')
    .select('client_id, company_name, status')
    .eq('status', 'Approved')
    .order('company_name');

  if (page !== 'labels-add') {
    query = query.neq('company_name', 'M80');
  }

  const { data, error } = await query;

  if (error) {
    console.error('Error fetching clients:', error);
    return [];
  }

  return data || [];
}

// Get password generation list
export async function getPassGenerations(search?: string): Promise<LabelPassGeneration[]> {
  const supabase = getServiceSupabase();

  if (search) {
    // Search by password
    const { data: passwordData } = await supabase
      .from('label_password')
      .select('label_pass_detail_id')
      .eq('password', search.toUpperCase().trim())
      .limit(1);

    if (!passwordData || passwordData.length === 0) {
      return [];
    }

    const detailId = passwordData[0].label_pass_detail_id;

    const { data, error } = await supabase
      .from('label_pass_generation')
      .select(`
        *,
        clients!inner(company_name)
      `)
      .eq('label_pass_detail_id', detailId)
      .order('create_dt', { ascending: false });

    if (error) {
      console.error('Error fetching generations:', error);
      return [];
    }

    return (data || []).map(row => ({
      ...row,
      company_name: row.clients?.company_name,
      num_sub_spreadsheets: 0
    }));
  }

  const { data, error } = await supabase
    .from('label_pass_generation')
    .select(`
      *,
      clients!inner(company_name)
    `)
    .is('owner_label_pass_gen_id', null)
    .order('create_dt', { ascending: false });

  if (error) {
    console.error('Error fetching generations:', error);
    return [];
  }

  return (data || []).map(row => ({
    ...row,
    company_name: row.clients?.company_name,
    num_sub_spreadsheets: 0
  }));
}

// Get label pass details (manage labels)
export async function getLabelPassDetails(labelPassDetailId?: number, clientId?: number): Promise<LabelPassDetail[]> {
  const supabase = getServiceSupabase();

  let query = supabase
    .from('label_pass_detail')
    .select(`
      *,
      clients!inner(company_name)
    `)
    .eq('active', 'Y')
    .order('create_dt', { ascending: false });

  if (labelPassDetailId) {
    query = query.eq('label_pass_detail_id', labelPassDetailId);
  }

  if (clientId) {
    query = query.eq('client_id', clientId);
  }

  const { data, error } = await query;

  if (error) {
    console.error('Error fetching label details:', error);
    return [];
  }

  return (data || []).map(row => ({
    ...row,
    company_name: row.clients?.company_name
  }));
}

// Get label validations (legacy)
export async function getLabelValidations(code: string): Promise<LabelValidation[]> {
  const supabase = getServiceSupabase();

  const { data, error } = await supabase
    .from('label_validation')
    .select(`
      *,
      label_range!inner(
        verify_once,
        clients!inner(company_name)
      )
    `)
    .eq('validation_code', code.trim())
    .order('validation_id', { ascending: false });

  if (error) {
    console.error('Error fetching label validations:', error);
    return [];
  }

  return (data || []).map(row => ({
    ...row,
    verify_once: row.label_range?.verify_once,
    company_name: row.label_range?.clients?.company_name
  }));
}

// Get password validations
export async function getPasswordValidations(code: string): Promise<PasswordValidation[]> {
  const supabase = getServiceSupabase();

  const { data, error } = await supabase
    .from('label_password_validation')
    .select(`
      *,
      label_pass_detail!inner(
        verify_once,
        clients!inner(company_name)
      )
    `)
    .eq('password', code.toUpperCase().trim())
    .order('label_pass_val_id', { ascending: false });

  if (error) {
    console.error('Error fetching password validations:', error);
    return [];
  }

  // Get verify_once_override from label_password
  const { data: passwordData } = await supabase
    .from('label_password')
    .select('verify_once_override')
    .eq('password', code.toUpperCase().trim())
    .limit(1);

  const verifyOnceOverride = passwordData?.[0]?.verify_once_override || 'N';

  return (data || []).map(row => ({
    ...row,
    verify_once: row.label_pass_detail?.verify_once,
    verify_once_override: verifyOnceOverride,
    company_name: row.label_pass_detail?.clients?.company_name
  }));
}

// Get password detail by code
export async function getPasswordDetail(code: string): Promise<{
  label_pass_detail_id: number;
  client_id: number;
  verify_once: string;
  verify_once_override: string;
  company_name: string;
} | null> {
  const supabase = getServiceSupabase();

  const { data, error } = await supabase
    .from('label_password')
    .select(`
      label_pass_detail_id,
      verify_once_override,
      label_pass_detail!inner(
        client_id,
        verify_once,
        clients!inner(company_name)
      )
    `)
    .eq('password', code.trim())
    .limit(1);

  if (error || !data || data.length === 0) {
    return null;
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const row = data[0] as any;
  const detail = row.label_pass_detail;
  return {
    label_pass_detail_id: row.label_pass_detail_id,
    client_id: detail?.client_id,
    verify_once: detail?.verify_once,
    verify_once_override: row.verify_once_override,
    company_name: detail?.clients?.company_name
  };
}

// ============================================
// NFC QUERIES
// ============================================

// Get NFC generation list
export async function getNfcGenerations(): Promise<NfcGeneration[]> {
  const supabase = getServiceSupabase();

  const { data, error } = await supabase
    .from('nfc_generation')
    .select(`
      *,
      clients(company_name)
    `)
    .order('create_dt', { ascending: false });

  if (error) {
    console.error('Error fetching NFC generations:', error);
    return [];
  }

  // Get video_url from first tag of each generation
  const results = await Promise.all((data || []).map(async (row) => {
    let videoUrl = null;
    if (row.first_spool_id) {
      const { data: tagData } = await supabase
        .from('nfc_tag')
        .select('video_url')
        .eq('spool_id', row.first_spool_id)
        .not('video_url', 'is', null)
        .limit(1);
      videoUrl = tagData?.[0]?.video_url;
    }

    return {
      ...row,
      company_name: row.clients?.company_name || 'Unassigned',
      video_url: videoUrl
    };
  }));

  return results;
}

// Get spool inventory
export async function getSpoolInventory(): Promise<Spool[]> {
  const supabase = getServiceSupabase();

  const { data, error } = await supabase
    .from('nfc_spool')
    .select(`
      *,
      clients(company_name)
    `)
    .order('create_dt', { ascending: false });

  if (error) {
    console.error('Error fetching spool inventory:', error);
    return [];
  }

  // Get video_url from first tag of each spool
  const results = await Promise.all((data || []).map(async (row) => {
    const { data: tagData } = await supabase
      .from('nfc_tag')
      .select('video_url')
      .eq('spool_id', row.spool_id)
      .not('video_url', 'is', null)
      .limit(1);

    return {
      ...row,
      company_name: row.clients?.company_name || 'Unassigned',
      video_url: tagData?.[0]?.video_url
    };
  }));

  return results;
}

// Get NFC tag by seq_num
export async function getNfcTagBySeqNum(seqNum: number): Promise<NfcTag | null> {
  const supabase = getServiceSupabase();

  const { data, error } = await supabase
    .from('nfc_tag')
    .select(`
      *,
      clients(company_name)
    `)
    .eq('seq_num', seqNum)
    .limit(1);

  if (error || !data || data.length === 0) {
    return null;
  }

  return {
    ...data[0],
    company_name: data[0].clients?.company_name || 'Unassigned'
  };
}

// Get NFC tracking data with scan counts
export async function getNfcTracking(
  clientName?: string,
  scanCountMin?: number,
  status?: string,
  seqNum?: number
): Promise<NfcTag[]> {
  const supabase = getServiceSupabase();

  let query = supabase
    .from('nfc_tag')
    .select(`
      *,
      clients!inner(company_name),
      nfc_tap_location(count)
    `)
    .order('tag_id', { ascending: false })
    .limit(500);

  if (clientName) {
    query = query.eq('clients.company_name', clientName);
  }

  if (status === 'active') {
    query = query.eq('live', 1);
  } else if (status === 'inactive') {
    query = query.eq('live', 0);
  }

  if (seqNum) {
    query = query.eq('seq_num', seqNum);
  }

  const { data, error } = await query;

  if (error) {
    console.error('Error fetching NFC tracking:', error);
    return [];
  }

  let results = (data || []).map(row => ({
    ...row,
    company_name: row.clients?.company_name || 'Unassigned',
    scan_count: row.nfc_tap_location?.[0]?.count || 0
  }));

  // Filter by scan count if specified
  if (scanCountMin) {
    results = results.filter(r => r.scan_count >= scanCountMin);
  }

  // Sort by scan count descending
  results.sort((a, b) => (b.scan_count || 0) - (a.scan_count || 0));

  return results;
}

// Get NFC error logs
export async function getNfcErrorLogs(
  startDate?: string,
  endDate?: string,
  showArchived?: boolean
): Promise<NfcErrorLog[]> {
  const supabase = getServiceSupabase();

  let query = supabase
    .from('nfc_error_log')
    .select('*')
    .order('create_dt', { ascending: false })
    .limit(500);

  if (!showArchived) {
    query = query.or('archived.eq.0,archived.is.null');
  }

  if (startDate) {
    query = query.gte('create_dt', startDate);
  }

  if (endDate) {
    query = query.lte('create_dt', endDate + 'T23:59:59');
  }

  const { data, error } = await query;

  if (error) {
    console.error('Error fetching NFC error logs:', error);
    return [];
  }

  return data || [];
}

// Get approved clients with NFC tags
export async function getClientsWithNfc(): Promise<Client[]> {
  const supabase = getServiceSupabase();

  // Get distinct client IDs that have NFC tags
  const { data: tagClients } = await supabase
    .from('nfc_tag')
    .select('client_id')
    .not('client_id', 'is', null);

  const clientIds = [...new Set((tagClients || []).map(t => t.client_id))];

  if (clientIds.length === 0) {
    return [];
  }

  const { data, error } = await supabase
    .from('clients')
    .select('client_id, company_name, status')
    .eq('status', 'Approved')
    .in('client_id', clientIds)
    .order('company_name');

  if (error) {
    console.error('Error fetching NFC clients:', error);
    return [];
  }

  return data || [];
}
