/**
 * AI Assistant Page
 * Last Modified: January 2026
 */

'use client';

import ComingSoon from '@/components/ComingSoon';
import { Sparkles } from 'lucide-react';

export default function AIAssistantPage() {
  return (
    <ComingSoon
      title="AI Assistant"
      description="Your intelligent assistant for managing clients, labels, and platform insights."
      icon={Sparkles}
      color="purple"
    />
  );
}
