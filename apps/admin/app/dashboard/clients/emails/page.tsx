/**
 * Client Requests - Review Emails Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { Mail } from 'lucide-react';

export default function ClientEmailsPage() {
  return (
    <ComingSoon
      title="Review Client Emails"
      description="Review and manage client email communications."
      icon={Mail}
      color="teal"
    />
  );
}
