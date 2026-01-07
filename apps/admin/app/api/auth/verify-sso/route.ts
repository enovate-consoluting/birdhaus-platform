/**
 * SSO Token Verification API
 * Verifies JWT token from Factory and returns user data
 * Last Modified: January 2026
 */

import { NextResponse } from 'next/server';
import { jwtVerify } from 'jose';

const SSO_SECRET = new TextEncoder().encode(
  process.env.SSO_SECRET || 'birdhaus-sso-secret-key-change-in-production'
);

export async function POST(request: Request) {
  try {
    const { token } = await request.json();

    if (!token) {
      return NextResponse.json(
        { success: false, error: 'Token required' },
        { status: 400 }
      );
    }

    // Verify the JWT
    const { payload } = await jwtVerify(token, SSO_SECRET);

    // Check if user has admin role
    if (payload.role !== 'super_admin' && payload.role !== 'admin') {
      return NextResponse.json(
        { success: false, error: 'Admin access required' },
        { status: 403 }
      );
    }

    // Return user data
    const user = {
      id: payload.id,
      email: payload.email,
      name: payload.name,
      role: payload.role,
    };

    return NextResponse.json({ success: true, user });
  } catch (error) {
    console.error('SSO verification error:', error);
    return NextResponse.json(
      { success: false, error: 'Invalid or expired token' },
      { status: 401 }
    );
  }
}
