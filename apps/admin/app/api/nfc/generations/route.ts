/**
 * NFC Generations API
 * Fetches NFC generation batches from Legacy MySQL
 * Last Modified: January 2026
 */

import { NextResponse } from 'next/server';
import { getNfcGenerations } from '@/lib/legacy-db';

export async function GET() {
  try {
    const generations = await getNfcGenerations();
    return NextResponse.json({ success: true, data: generations });
  } catch (error) {
    console.error('Error fetching NFC generations:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch NFC generations' },
      { status: 500 }
    );
  }
}
