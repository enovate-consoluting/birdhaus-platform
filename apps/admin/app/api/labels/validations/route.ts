/**
 * Label Validations API
 * Fetches validation history from Supabase
 * Last Modified: January 2026
 */

import { NextResponse } from 'next/server';
import { getLabelValidations, getPasswordValidations, getPasswordDetail } from '@/lib/supabase-db';

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const code = searchParams.get('code');

    if (!code) {
      return NextResponse.json(
        { success: false, error: 'Code parameter required' },
        { status: 400 }
      );
    }

    // Try legacy labels first
    const legacyValidations = await getLabelValidations(code);

    // If no legacy results, try password-based
    if (legacyValidations.length === 0) {
      const passwordDetail = await getPasswordDetail(code);
      const passwordValidations = await getPasswordValidations(code);

      return NextResponse.json({
        success: true,
        type: 'password',
        detail: passwordDetail,
        validations: passwordValidations,
      });
    }

    return NextResponse.json({
      success: true,
      type: 'legacy',
      validations: legacyValidations,
    });
  } catch (error) {
    console.error('Error fetching validations:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch validations' },
      { status: 500 }
    );
  }
}
