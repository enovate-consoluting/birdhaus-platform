/**
 * Users Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { Users } from 'lucide-react';

export default function UsersPage() {
  return (
    <ComingSoon
      title="Users"
      description="Manage platform users, roles, and access permissions."
      icon={Users}
      color="blue"
    />
  );
}
