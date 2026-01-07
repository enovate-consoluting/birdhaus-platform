/**
 * Auth Module Exports for Admin Platform
 * Last Modified: January 2026
 */

export type { UserRole, AuthUser, Session } from './types';
export { ADMIN_PORTAL_ROLES } from './types';

export {
  getSession,
  getCurrentUser,
  isSessionValid,
  setSession,
  clearSession,
  logout,
} from './session';
