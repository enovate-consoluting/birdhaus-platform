/**
 * NFC Errors API
 * Fetches NFC error logs from Supabase
 * Last Modified: January 2026
 */

import { NextResponse } from 'next/server';
import { getNfcErrorLogs } from '@/lib/supabase-db';

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const startDate = searchParams.get('start_date') || undefined;
    const endDate = searchParams.get('end_date') || undefined;
    const showArchived = searchParams.get('archived') === '1';

    const errors = await getNfcErrorLogs(startDate, endDate, showArchived);

    return NextResponse.json({ success: true, data: errors });
  } catch (error) {
    console.error('Error fetching NFC errors:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch NFC errors' },
      { status: 500 }
    );
  }
}
