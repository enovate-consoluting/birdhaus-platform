/**
 * NFC Identify Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { Fingerprint } from 'lucide-react';

export default function NFCIdentifyPage() {
  return (
    <ComingSoon
      title="NFC Identify"
      description="Scan and identify NFC tags to verify authenticity and view details."
      icon={Fingerprint}
      color="cyan"
    />
  );
}
