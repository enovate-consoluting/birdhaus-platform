/**
 * Register Products - Requests Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { FileText } from 'lucide-react';

export default function RegisterRequestsPage() {
  return (
    <ComingSoon
      title="Register Requests"
      description="Review and process new product registration requests."
      icon={FileText}
      color="amber"
    />
  );
}
