/**
 * Coming Soon Placeholder Component
 * Clean animated placeholder for pages under development
 * Last Modified: January 2026
 */

'use client';

import { useEffect, useState } from 'react';
import { LucideIcon } from 'lucide-react';

interface ComingSoonProps {
  title: string;
  description?: string;
  icon: LucideIcon;
  color?: 'violet' | 'emerald' | 'cyan' | 'amber' | 'orange' | 'purple' | 'slate' | 'blue' | 'rose' | 'teal';
}

const colorClasses = {
  violet: { bg: 'bg-violet-50', icon: 'text-violet-500', ring: 'ring-violet-200', dot: 'bg-violet-400' },
  emerald: { bg: 'bg-emerald-50', icon: 'text-emerald-500', ring: 'ring-emerald-200', dot: 'bg-emerald-400' },
  cyan: { bg: 'bg-cyan-50', icon: 'text-cyan-500', ring: 'ring-cyan-200', dot: 'bg-cyan-400' },
  amber: { bg: 'bg-amber-50', icon: 'text-amber-500', ring: 'ring-amber-200', dot: 'bg-amber-400' },
  orange: { bg: 'bg-orange-50', icon: 'text-orange-500', ring: 'ring-orange-200', dot: 'bg-orange-400' },
  purple: { bg: 'bg-purple-50', icon: 'text-purple-500', ring: 'ring-purple-200', dot: 'bg-purple-400' },
  slate: { bg: 'bg-slate-50', icon: 'text-slate-500', ring: 'ring-slate-200', dot: 'bg-slate-400' },
  blue: { bg: 'bg-blue-50', icon: 'text-blue-500', ring: 'ring-blue-200', dot: 'bg-blue-400' },
  rose: { bg: 'bg-rose-50', icon: 'text-rose-500', ring: 'ring-rose-200', dot: 'bg-rose-400' },
  teal: { bg: 'bg-teal-50', icon: 'text-teal-500', ring: 'ring-teal-200', dot: 'bg-teal-400' },
};

export default function ComingSoon({ title, description, icon: Icon, color = 'blue' }: ComingSoonProps) {
  const [mounted, setMounted] = useState(false);
  const colors = colorClasses[color];

  useEffect(() => {
    setMounted(true);
  }, []);

  return (
    <div className="min-h-[calc(100vh-120px)] flex items-center justify-center p-4">
      <div
        className={`text-center transition-all duration-700 ${
          mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'
        }`}
      >
        {/* Animated Icon Container */}
        <div className="relative inline-flex items-center justify-center mb-6">
          {/* Pulsing rings */}
          <div className={`absolute w-24 h-24 rounded-full ${colors.bg} animate-ping opacity-20`} />
          <div className={`absolute w-20 h-20 rounded-full ${colors.bg} ring-2 ${colors.ring} animate-pulse`} />

          {/* Icon */}
          <div className={`relative w-16 h-16 rounded-full ${colors.bg} flex items-center justify-center`}>
            <Icon className={`w-8 h-8 ${colors.icon}`} />
          </div>
        </div>

        {/* Title */}
        <h1 className="text-xl font-semibold text-gray-900 mb-2">{title}</h1>

        {/* Description */}
        <p className="text-sm text-gray-500 mb-6 max-w-xs mx-auto">
          {description || 'This feature is coming soon. We\'re working hard to bring it to you.'}
        </p>

        {/* Animated dots */}
        <div className="flex items-center justify-center gap-1.5">
          <div className={`w-2 h-2 rounded-full ${colors.dot} animate-bounce`} style={{ animationDelay: '0ms' }} />
          <div className={`w-2 h-2 rounded-full ${colors.dot} animate-bounce`} style={{ animationDelay: '150ms' }} />
          <div className={`w-2 h-2 rounded-full ${colors.dot} animate-bounce`} style={{ animationDelay: '300ms' }} />
        </div>

        {/* Status badge */}
        <div className="mt-8">
          <span className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-medium ${colors.bg} ${colors.icon}`}>
            <span className={`w-1.5 h-1.5 rounded-full ${colors.dot} animate-pulse`} />
            In Development
          </span>
        </div>
      </div>
    </div>
  );
}
