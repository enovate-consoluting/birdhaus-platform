/**
 * NFC Error Logs Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { AlertTriangle } from 'lucide-react';

export default function NFCErrorsPage() {
  return (
    <ComingSoon
      title="NFC Error Logs"
      description="Monitor and troubleshoot NFC scanning errors and issues."
      icon={AlertTriangle}
      color="cyan"
    />
  );
}
