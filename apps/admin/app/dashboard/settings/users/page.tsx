/**
 * Settings - Users Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { Users } from 'lucide-react';

export default function SettingsUsersPage() {
  return (
    <ComingSoon
      title="Settings Users"
      description="Manage admin users and their access levels."
      icon={Users}
      color="slate"
    />
  );
}
