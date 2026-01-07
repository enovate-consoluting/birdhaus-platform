/**
 * BBSimon Orders Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { ShoppingCart } from 'lucide-react';

export default function BBSimonOrdersPage() {
  return (
    <ComingSoon
      title="BBSimon Orders"
      description="Manage BBSimon product orders and fulfillment."
      icon={ShoppingCart}
      color="rose"
    />
  );
}
