/**
 * SSO Callback Page
 * Receives token from Factory, verifies it, creates session
 * Last Modified: January 2026
 */

'use client';

import { useEffect, useState, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { setSession } from '@/lib/auth';
import { Loader2 } from 'lucide-react';

function CallbackContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [error, setError] = useState('');

  useEffect(() => {
    async function verifyToken() {
      const token = searchParams.get('token');

      if (!token) {
        setError('No token provided');
        setTimeout(() => router.push('/login'), 2000);
        return;
      }

      try {
        // Verify token with our API
        const response = await fetch('/api/auth/verify-sso', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ token }),
        });

        const result = await response.json();

        if (result.success && result.user) {
          // Create session and redirect to dashboard
          setSession(result.user);
          router.push('/dashboard');
        } else {
          setError(result.error || 'Authentication failed');
          setTimeout(() => router.push('/login'), 2000);
        }
      } catch (err) {
        console.error('SSO callback error:', err);
        setError('Authentication failed');
        setTimeout(() => router.push('/login'), 2000);
      }
    }

    verifyToken();
  }, [router, searchParams]);

  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-xl shadow-lg w-full max-w-md p-8 text-center">
        {error ? (
          <>
            <div className="w-12 h-12 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg className="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </div>
            <h2 className="text-lg font-semibold text-gray-900 mb-2">Authentication Failed</h2>
            <p className="text-gray-600 text-sm">{error}</p>
            <p className="text-gray-400 text-xs mt-4">Redirecting to login...</p>
          </>
        ) : (
          <>
            <Loader2 className="w-8 h-8 animate-spin text-blue-600 mx-auto mb-4" />
            <h2 className="text-lg font-semibold text-gray-900 mb-2">Signing you in...</h2>
            <p className="text-gray-600 text-sm">Please wait while we verify your session.</p>
          </>
        )}
      </div>
    </div>
  );
}

export default function SSOCallbackPage() {
  return (
    <Suspense fallback={
      <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
        <Loader2 className="w-8 h-8 animate-spin text-blue-600" />
      </div>
    }>
      <CallbackContent />
    </Suspense>
  );
}
