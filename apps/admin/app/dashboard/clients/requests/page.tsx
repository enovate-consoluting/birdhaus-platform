/**
 * Client Requests - New Requests Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { UserPlus } from 'lucide-react';

export default function ClientRequestsPage() {
  return (
    <ComingSoon
      title="New Client Requests"
      description="Review and process new client onboarding requests."
      icon={UserPlus}
      color="teal"
    />
  );
}
