/**
 * Register Products - Products Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { Box } from 'lucide-react';

export default function RegisterProductsPage() {
  return (
    <ComingSoon
      title="Products"
      description="View and manage all registered products in the system."
      icon={Box}
      color="amber"
    />
  );
}
