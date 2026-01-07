/**
 * Labels Generations API
 * Fetches password generation batches from Legacy MySQL
 * Last Modified: January 2026
 */

import { NextResponse } from 'next/server';
import { getPassGenerations } from '@/lib/legacy-db';

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const search = searchParams.get('search') || undefined;

    const generations = await getPassGenerations(search);

    return NextResponse.json({
      success: true,
      data: generations,
    });
  } catch (error) {
    console.error('Error fetching generations:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch generations' },
      { status: 500 }
    );
  }
}
