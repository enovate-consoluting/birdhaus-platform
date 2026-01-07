/**
 * SSO Token Generation API (Admin -> Factory)
 * Generates a short-lived JWT for cross-app authentication
 * Last Modified: January 2026
 */

import { NextResponse } from 'next/server';
import { SignJWT } from 'jose';

const SSO_SECRET = new TextEncoder().encode(
  process.env.SSO_SECRET || 'birdhaus-sso-secret-key-change-in-production'
);

export async function POST(request: Request) {
  try {
    const { user } = await request.json();

    if (!user || !user.id || !user.email) {
      return NextResponse.json(
        { success: false, error: 'User data required' },
        { status: 400 }
      );
    }

    // Create a short-lived JWT (30 seconds)
    const token = await new SignJWT({
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
    })
      .setProtectedHeader({ alg: 'HS256' })
      .setIssuedAt()
      .setExpirationTime('30s')
      .sign(SSO_SECRET);

    return NextResponse.json({ success: true, token });
  } catch (error) {
    console.error('SSO token generation error:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to generate SSO token' },
      { status: 500 }
    );
  }
}
