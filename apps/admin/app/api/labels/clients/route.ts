/**
 * Clients API
 * Fetches approved clients from Supabase
 * Last Modified: January 2026
 */

import { NextResponse } from 'next/server';
import { getClients } from '@/lib/supabase-db';

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const page = searchParams.get('page') || undefined;

    const clients = await getClients(page);

    return NextResponse.json({
      success: true,
      data: clients,
    });
  } catch (error) {
    console.error('Error fetching clients:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch clients' },
      { status: 500 }
    );
  }
}
