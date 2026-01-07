'use client';

import { useEffect } from 'react';

export type NotificationType = 'success' | 'error' | 'info' | 'warning';

interface UINotificationProps {
  message: string;
  type: NotificationType;
  onClose: () => void;
  duration?: number;
}

// Icon components to avoid lucide-react type conflicts
function SuccessIcon() {
  return (
    <svg className="w-6 h-6 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>
  );
}

function ErrorIcon() {
  return (
    <svg className="w-6 h-6 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>
  );
}

function InfoIcon() {
  return (
    <svg className="w-6 h-6 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>
  );
}

function WarningIcon() {
  return (
    <svg className="w-6 h-6 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
    </svg>
  );
}

function CloseIcon() {
  return (
    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
    </svg>
  );
}

function NotificationIcon({ type }: { type: NotificationType }) {
  switch (type) {
    case 'success': return <SuccessIcon />;
    case 'error': return <ErrorIcon />;
    case 'info': return <InfoIcon />;
    case 'warning': return <WarningIcon />;
  }
}

const styles = {
  success: {
    bg: 'bg-gradient-to-r from-green-500 to-emerald-600',
    title: 'Success!'
  },
  error: {
    bg: 'bg-gradient-to-r from-red-500 to-rose-600',
    title: 'Error'
  },
  info: {
    bg: 'bg-gradient-to-r from-blue-500 to-cyan-600',
    title: 'Info'
  },
  warning: {
    bg: 'bg-gradient-to-r from-yellow-500 to-orange-600',
    title: 'Warning'
  }
};

export function UINotification({ message, type, onClose, duration = 5000 }: UINotificationProps) {
  useEffect(() => {
    const timer = setTimeout(onClose, duration);
    return () => clearTimeout(timer);
  }, [duration, onClose]);

  const config = styles[type];

  return (
    <div className="fixed top-4 right-4 z-50 animate-slide-in-right">
      <div className={`${config.bg} text-white rounded-lg shadow-2xl p-4 min-w-[320px] max-w-md`}>
        <div className="flex items-start gap-3">
          <NotificationIcon type={type} />
          <div className="flex-1">
            <p className="font-semibold text-sm">{config.title}</p>
            <p className="text-sm mt-1 opacity-95">{message}</p>
          </div>
          <button
            onClick={onClose}
            className="opacity-75 hover:opacity-100 transition-opacity"
          >
            <CloseIcon />
          </button>
        </div>
      </div>
    </div>
  );
}
