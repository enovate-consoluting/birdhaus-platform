/**
 * NFC Tracking API
 * Fetches NFC tracking/identify data from Supabase
 * Last Modified: January 2026
 */

import { NextResponse } from 'next/server';
import { getNfcTracking, getClientsWithNfc } from '@/lib/supabase-db';

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const clientName = searchParams.get('client') || undefined;
    const scanCount = searchParams.get('scan_count');
    const status = searchParams.get('status') || undefined;
    const seqNum = searchParams.get('seq_num');

    const tracking = await getNfcTracking(
      clientName,
      scanCount ? parseInt(scanCount) : undefined,
      status,
      seqNum ? parseInt(seqNum) : undefined
    );

    const clients = await getClientsWithNfc();

    return NextResponse.json({
      success: true,
      data: tracking,
      clients: clients
    });
  } catch (error) {
    console.error('Error fetching NFC tracking:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch NFC tracking' },
      { status: 500 }
    );
  }
}
