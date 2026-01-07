/**
 * Login API Route - Admin Platform
 * Authenticates against Factory Supabase users table
 * Only allows super_admin and admin roles
 * Last Modified: January 2026
 */

import { NextResponse } from 'next/server';
import { getFactorySupabase } from '@/lib/factory-supabase';
import bcrypt from 'bcryptjs';
import { ADMIN_PORTAL_ROLES } from '@/lib/auth';

/**
 * Verify password against hash (supports legacy plain text)
 */
async function verifyPassword(plainPassword: string, storedPassword: string): Promise<boolean> {
  // bcrypt hashes start with $2a$, $2b$, or $2y$
  if (!storedPassword.startsWith('$2')) {
    // Legacy plain text password
    return plainPassword === storedPassword;
  }
  return bcrypt.compare(plainPassword, storedPassword);
}

export async function POST(request: Request) {
  try {
    const { email, password } = await request.json();

    if (!email || !password) {
      return NextResponse.json(
        { success: false, error: 'Email and password are required' },
        { status: 400 }
      );
    }

    const supabase = getFactorySupabase();

    // Fetch user from Factory database
    const { data: userData, error: userError } = await supabase
      .from('users')
      .select('*')
      .eq('email', email.toLowerCase().trim())
      .single();

    if (userError || !userData) {
      return NextResponse.json(
        { success: false, error: 'Invalid email or password' },
        { status: 401 }
      );
    }

    // Check if user has admin role
    if (!ADMIN_PORTAL_ROLES.includes(userData.role)) {
      return NextResponse.json(
        { success: false, error: 'Access denied. Admin privileges required.' },
        { status: 403 }
      );
    }

    // Verify password
    const isValid = await verifyPassword(password, userData.password);
    if (!isValid) {
      return NextResponse.json(
        { success: false, error: 'Invalid email or password' },
        { status: 401 }
      );
    }

    // Build user object (exclude password)
    const user = {
      id: userData.id,
      email: userData.email,
      name: userData.name,
      role: userData.role,
      phone_number: userData.phone_number,
      logo_url: userData.logo_url,
      created_at: userData.created_at,
      updated_at: userData.updated_at,
    };

    return NextResponse.json({ success: true, user });
  } catch (error) {
    console.error('Login error:', error);
    return NextResponse.json(
      { success: false, error: 'An error occurred during authentication' },
      { status: 500 }
    );
  }
}
