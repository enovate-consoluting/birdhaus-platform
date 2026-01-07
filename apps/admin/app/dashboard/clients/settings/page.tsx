/**
 * Client Requests - Settings Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { Settings } from 'lucide-react';

export default function ClientSettingsPage() {
  return (
    <ComingSoon
      title="Client Settings"
      description="Configure client-related settings and defaults."
      icon={Settings}
      color="teal"
    />
  );
}
