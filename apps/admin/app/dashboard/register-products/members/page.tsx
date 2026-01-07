/**
 * Register Products - Members Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { Users } from 'lucide-react';

export default function MembersPage() {
  return (
    <ComingSoon
      title="Members"
      description="Manage registered members and their product registrations."
      icon={Users}
      color="amber"
    />
  );
}
