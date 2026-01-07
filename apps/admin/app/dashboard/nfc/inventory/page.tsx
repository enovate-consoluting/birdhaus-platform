/**
 * NFC Inventory Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { Package } from 'lucide-react';

export default function NFCInventoryPage() {
  return (
    <ComingSoon
      title="NFC Inventory"
      description="Track and manage your NFC tag inventory across all clients."
      icon={Package}
      color="cyan"
    />
  );
}
