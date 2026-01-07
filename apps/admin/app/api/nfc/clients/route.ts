/**
 * NFC Clients API
 * Fetches clients that have NFC tags from Legacy MySQL
 * Last Modified: January 2026
 */

import { NextResponse } from 'next/server';
import { getClientsWithNfc } from '@/lib/legacy-db';

export async function GET() {
  try {
    const clients = await getClientsWithNfc();

    return NextResponse.json({ success: true, data: clients });
  } catch (error) {
    console.error('Error fetching NFC clients:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch NFC clients' },
      { status: 500 }
    );
  }
}
