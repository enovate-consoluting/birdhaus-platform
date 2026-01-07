/**
 * NFC Inventory API
 * Fetches spool inventory from Legacy MySQL
 * Last Modified: January 2026
 */

import { NextResponse } from 'next/server';
import { getSpoolInventory } from '@/lib/legacy-db';

export async function GET() {
  try {
    const inventory = await getSpoolInventory();
    return NextResponse.json({ success: true, data: inventory });
  } catch (error) {
    console.error('Error fetching NFC inventory:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch NFC inventory' },
      { status: 500 }
    );
  }
}
