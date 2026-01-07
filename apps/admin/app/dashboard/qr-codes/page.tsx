/**
 * QR Codes Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { QrCode } from 'lucide-react';

export default function QRCodesPage() {
  return (
    <ComingSoon
      title="QR Codes"
      description="Generate and manage QR codes for product authentication and tracking."
      icon={QrCode}
      color="emerald"
    />
  );
}
