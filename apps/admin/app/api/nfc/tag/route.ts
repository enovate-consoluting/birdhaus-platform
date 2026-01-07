/**
 * NFC Tag API
 * Fetches individual tag info from Legacy MySQL
 * Last Modified: January 2026
 */

import { NextResponse } from 'next/server';
import { getNfcTagBySeqNum } from '@/lib/legacy-db';

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const seqNum = searchParams.get('seq_num');

    if (!seqNum) {
      return NextResponse.json(
        { success: false, error: 'seq_num parameter required' },
        { status: 400 }
      );
    }

    const tag = await getNfcTagBySeqNum(parseInt(seqNum));

    return NextResponse.json({ success: true, data: tag });
  } catch (error) {
    console.error('Error fetching NFC tag:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch NFC tag' },
      { status: 500 }
    );
  }
}
