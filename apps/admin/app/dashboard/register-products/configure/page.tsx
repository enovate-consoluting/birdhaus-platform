/**
 * Register Products - Configure Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { Settings } from 'lucide-react';

export default function ConfigurePage() {
  return (
    <ComingSoon
      title="Configure"
      description="Configure product registration settings and options."
      icon={Settings}
      color="amber"
    />
  );
}
