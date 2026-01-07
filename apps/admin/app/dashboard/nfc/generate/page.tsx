/**
 * NFC Generate Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { Plus } from 'lucide-react';

export default function NFCGeneratePage() {
  return (
    <ComingSoon
      title="Generate NFC Tags"
      description="Create new NFC tag assignments for products and clients."
      icon={Plus}
      color="cyan"
    />
  );
}
