/**
 * Label Details API
 * Fetches label password details from Supabase
 * Last Modified: January 2026
 */

import { NextResponse } from 'next/server';
import { getLabelPassDetails } from '@/lib/supabase-db';

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const labelPassDetailId = searchParams.get('id');
    const clientId = searchParams.get('client_id');

    const details = await getLabelPassDetails(
      labelPassDetailId ? parseInt(labelPassDetailId) : undefined,
      clientId ? parseInt(clientId) : undefined
    );

    return NextResponse.json({
      success: true,
      data: details,
    });
  } catch (error) {
    console.error('Error fetching label details:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch label details' },
      { status: 500 }
    );
  }
}
