/**
 * Auth Types for Admin Platform
 * Shared with Factory Orders
 * Last Modified: January 2026
 */

export type UserRole = 'super_admin' | 'admin' | 'order_creator' | 'order_approver' | 'manufacturer' | 'client';

// Roles that can access Admin Platform
export const ADMIN_PORTAL_ROLES: UserRole[] = ['super_admin', 'admin'];

export interface AuthUser {
  id: string;
  email: string;
  name: string;
  role: UserRole;
  phone_number?: string;
  logo_url?: string;
  manufacturer_id?: string;
  created_by?: string;
  created_at?: string;
  updated_at?: string;
}

export interface Session {
  user: AuthUser;
  expiresAt: string;
}
