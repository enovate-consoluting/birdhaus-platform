/**
 * NFC Manage Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { List } from 'lucide-react';

export default function NFCManagePage() {
  return (
    <ComingSoon
      title="Manage NFC Tags"
      description="View, edit, and organize all NFC tags in the system."
      icon={List}
      color="cyan"
    />
  );
}
