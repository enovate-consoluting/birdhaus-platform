/**
 * Register Products - Orders Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { ShoppingCart } from 'lucide-react';

export default function RegisterOrdersPage() {
  return (
    <ComingSoon
      title="Orders"
      description="Track and manage product registration orders."
      icon={ShoppingCart}
      color="amber"
    />
  );
}
