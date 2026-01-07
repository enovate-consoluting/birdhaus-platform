/**
 * NFC Demo Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { PlayCircle } from 'lucide-react';

export default function NFCDemoPage() {
  return (
    <ComingSoon
      title="NFC Demo"
      description="Interactive demo for testing NFC functionality and client presentations."
      icon={PlayCircle}
      color="cyan"
    />
  );
}
