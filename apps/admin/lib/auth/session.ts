/**
 * Client-side Session Management for Admin Platform
 * Uses localStorage (shared pattern with Factory)
 * Last Modified: January 2026
 */

import type { AuthUser, Session } from './types';

const USER_STORAGE_KEY = 'admin_user';
const SESSION_EXPIRY_KEY = 'admin_sessionExpiry';

// Session duration in days
const SESSION_DURATION_DAYS = 7;

/**
 * Get the current session from localStorage
 */
export function getSession(): Session | null {
  if (typeof window === 'undefined') return null;

  try {
    const userData = localStorage.getItem(USER_STORAGE_KEY);
    const expiryData = localStorage.getItem(SESSION_EXPIRY_KEY);

    if (!userData) return null;

    const user = JSON.parse(userData) as AuthUser;
    const expiresAt = expiryData || '';

    return { user, expiresAt };
  } catch (error) {
    console.error('Error reading session:', error);
    return null;
  }
}

/**
 * Get the current user from session
 */
export function getCurrentUser(): AuthUser | null {
  const session = getSession();
  return session?.user || null;
}

/**
 * Check if the session is valid (exists and not expired)
 */
export function isSessionValid(): boolean {
  if (typeof window === 'undefined') return false;

  const session = getSession();
  if (!session) return false;

  if (session.expiresAt) {
    const expiry = new Date(session.expiresAt);
    if (expiry < new Date()) {
      clearSession();
      return false;
    }
  }

  return true;
}

/**
 * Set the session (store user in localStorage)
 */
export function setSession(user: AuthUser): void {
  if (typeof window === 'undefined') return;

  try {
    localStorage.setItem(USER_STORAGE_KEY, JSON.stringify(user));

    // Set session expiry
    const expiryDate = new Date();
    expiryDate.setDate(expiryDate.getDate() + SESSION_DURATION_DAYS);
    localStorage.setItem(SESSION_EXPIRY_KEY, expiryDate.toISOString());
  } catch (error) {
    console.error('Error setting session:', error);
  }
}

/**
 * Clear the session (logout)
 */
export function clearSession(): void {
  if (typeof window === 'undefined') return;

  localStorage.removeItem(USER_STORAGE_KEY);
  localStorage.removeItem(SESSION_EXPIRY_KEY);
}

/**
 * Logout and redirect
 */
export function logout(redirectUrl?: string): void {
  clearSession();

  if (typeof window !== 'undefined' && redirectUrl) {
    window.location.href = redirectUrl;
  }
}
