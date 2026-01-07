/**
 * Dashboard Layout - Admin Platform
 * Matches Factory Orders styling
 * Last Modified: January 2026
 */

'use client';

import { useEffect, useState } from 'react';
import { useRouter, usePathname } from 'next/navigation';
import Link from 'next/link';
import { isSessionValid, getCurrentUser, AuthUser, logout } from '@/lib/auth';
import {
  LayoutDashboard,
  Users,
  Tag,
  Smartphone,
  Settings,
  LogOut,
  Menu,
  X,
  ChevronDown,
  Factory,
  Shield,
} from 'lucide-react';

const adminNavItems = [
  { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
  { type: 'section', label: 'Management' },
  { name: 'Clients', href: '/dashboard/clients', icon: Users },
  { name: 'Labels', href: '/dashboard/labels', icon: Tag },
  { name: 'NFC Tags', href: '/dashboard/nfc', icon: Smartphone },
  { type: 'section', label: 'Settings' },
  { name: 'Settings', href: '/dashboard/settings', icon: Settings },
];

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const router = useRouter();
  const pathname = usePathname();
  const [loading, setLoading] = useState(true);
  const [user, setUser] = useState<AuthUser | null>(null);
  const [showMobileMenu, setShowMobileMenu] = useState(false);
  const [modeOpen, setModeOpen] = useState(false);

  useEffect(() => {
    if (!isSessionValid()) {
      router.push('/login?message=session_expired');
      return;
    }

    const currentUser = getCurrentUser();
    if (!currentUser) {
      router.push('/login');
      return;
    }

    setUser(currentUser);
    setLoading(false);
  }, [router]);

  // Close mobile menu when route changes
  useEffect(() => {
    setShowMobileMenu(false);
  }, [pathname]);

  // Prevent body scroll when mobile menu is open
  useEffect(() => {
    if (showMobileMenu) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = 'unset';
    }
    return () => {
      document.body.style.overflow = 'unset';
    };
  }, [showMobileMenu]);

  const handleLogout = () => {
    logout('/login');
  };

  const handleSwitchToFactory = () => {
    window.location.href = 'https://birdhausapp.com';
  };

  const getPageTitle = () => {
    if (pathname === '/dashboard') return 'Dashboard';
    if (pathname === '/dashboard/clients') return 'Client Management';
    if (pathname === '/dashboard/labels') return 'Labels';
    if (pathname === '/dashboard/nfc') return 'NFC Tags';
    if (pathname === '/dashboard/settings') return 'Settings';
    return 'Admin';
  };

  const getInitial = (name: string) => {
    return name ? name.charAt(0).toUpperCase() : 'U';
  };

  const formatRole = (role: string) => {
    const roleDisplay: Record<string, string> = {
      super_admin: 'Super Admin',
      admin: 'Admin',
    };
    return roleDisplay[role] || role.replace(/_/g, ' ');
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-gray-600">Loading...</div>
      </div>
    );
  }

  if (!user) {
    return null;
  }

  const SidebarContent = ({ onLinkClick, onClose }: { onLinkClick?: () => void; onClose?: () => void }) => (
    <div className="flex flex-col h-full">
      {/* Logo Section */}
      <div className="h-16 px-4 border-b border-gray-100 flex items-center justify-between">
        <Link
          href="/dashboard"
          onClick={onLinkClick}
          className="flex-1 text-center lg:text-left hover:opacity-80 transition-opacity cursor-pointer"
        >
          <h1 className="text-xl font-bold text-gray-900">BirdHaus</h1>
          <p className="text-xs text-gray-500">Admin Platform</p>
        </Link>
        {onClose && (
          <button
            onClick={onClose}
            className="lg:hidden p-1.5 hover:bg-gray-100 rounded-lg transition-colors"
            aria-label="Close sidebar"
          >
            <X className="w-5 h-5 text-gray-600" />
          </button>
        )}
      </div>

      {/* User Profile Section */}
      <div className="px-6 py-4 border-b border-gray-100">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 bg-blue-500 rounded-full flex items-center justify-center text-white font-semibold flex-shrink-0">
            {getInitial(user?.name || '')}
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-sm font-medium text-gray-900 truncate">{user?.name}</p>
            <p className="text-xs text-gray-500">{formatRole(user?.role || '')}</p>
          </div>
        </div>
      </div>

      {/* Mode Switcher */}
      <div className="px-4 py-3 border-b border-gray-100">
        <div className="relative">
          <button
            onClick={() => setModeOpen(!modeOpen)}
            className="w-full flex items-center justify-between p-3 rounded-xl bg-gray-50 hover:bg-gray-100 transition-colors"
          >
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center">
                <Shield className="w-4 h-4 text-white" />
              </div>
              <div className="text-left">
                <div className="font-semibold text-sm text-gray-900">Admin</div>
                <div className="text-xs text-gray-500">Platform Settings</div>
              </div>
            </div>
            <ChevronDown className={`w-4 h-4 text-gray-400 transition-transform ${modeOpen ? 'rotate-180' : ''}`} />
          </button>

          {modeOpen && (
            <div className="absolute top-full left-0 right-0 mt-2 bg-white rounded-xl border border-gray-200 shadow-xl z-50 overflow-hidden">
              <button
                onClick={handleSwitchToFactory}
                className="w-full flex items-center gap-3 p-3 hover:bg-gray-50 transition-colors"
              >
                <div className="w-8 h-8 bg-orange-500 rounded-lg flex items-center justify-center">
                  <Factory className="w-4 h-4 text-white" />
                </div>
                <div className="text-left">
                  <div className="font-semibold text-sm text-gray-900">Factory Orders</div>
                  <div className="text-xs text-gray-500">Manufacturing</div>
                </div>
              </button>
            </div>
          )}
        </div>
      </div>

      {/* Navigation */}
      <nav className="flex-1 overflow-y-auto py-4">
        {adminNavItems.map((item, index) => {
          if (item.type === 'section') {
            return (
              <div key={`section-${index}`} className="px-6 py-3">
                <p className="text-xs font-semibold text-gray-400 uppercase tracking-wider">
                  {item.label}
                </p>
              </div>
            );
          }

          const Icon = item.icon!;
          const isActive = pathname === item.href || (item.href !== '/dashboard' && pathname.startsWith(item.href + '/'));

          return (
            <div key={item.href} className="mb-1">
              <Link
                href={item.href!}
                onClick={onLinkClick}
                className={`flex items-center gap-3 px-6 pl-10 py-2.5 text-sm transition-colors ${
                  isActive
                    ? 'text-blue-600 bg-blue-50 border-r-2 border-blue-600'
                    : 'text-gray-700 hover:bg-gray-50 hover:text-gray-900'
                }`}
              >
                <Icon className={`w-5 h-5 flex-shrink-0 ${isActive ? 'text-blue-600' : 'text-gray-400'}`} />
                <span className="font-medium truncate">{item.name}</span>
              </Link>
            </div>
          );
        })}
      </nav>

      {/* Logout Section */}
      <div className="p-4 border-t border-gray-100">
        <button
          onClick={() => {
            handleLogout();
            onLinkClick?.();
          }}
          className="w-full flex items-center gap-3 px-4 py-2.5 text-sm text-gray-700 hover:bg-gray-50 rounded-lg transition-colors"
        >
          <div className="w-10 h-10 bg-gray-900 rounded-full flex items-center justify-center flex-shrink-0">
            <span className="text-white font-semibold">{getInitial(user?.name || '')}</span>
          </div>
          <span className="flex-1 text-left font-medium truncate">Logout</span>
        </button>
      </div>
    </div>
  );

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Desktop Sidebar */}
      <aside className="hidden lg:fixed lg:inset-y-0 lg:left-0 lg:z-40 lg:w-72 lg:bg-white lg:border-r lg:border-gray-100 lg:flex lg:flex-col">
        <SidebarContent />
      </aside>

      {/* Mobile Sidebar */}
      <div className={`lg:hidden fixed inset-0 z-50 transition-opacity duration-300 ${showMobileMenu ? 'opacity-100 pointer-events-auto' : 'opacity-0 pointer-events-none'}`}>
        <div
          className="absolute inset-0 bg-black bg-opacity-50 transition-opacity"
          onClick={() => setShowMobileMenu(false)}
        />
        <aside className={`absolute left-0 top-0 h-full w-full bg-white shadow-lg transform transition-transform duration-300 ${showMobileMenu ? 'translate-x-0' : '-translate-x-full'}`}>
          <SidebarContent
            onLinkClick={() => setShowMobileMenu(false)}
            onClose={() => setShowMobileMenu(false)}
          />
        </aside>
      </div>

      {/* Main Content */}
      <div className="lg:pl-72 flex flex-col min-h-screen">
        {/* Top Bar */}
        <header className="sticky top-0 z-30 bg-white border-b border-gray-100 shadow-sm">
          <div className="flex items-center justify-between px-4 lg:px-6 h-16">
            {/* Mobile Menu Button */}
            <button
              onClick={() => setShowMobileMenu(true)}
              className="lg:hidden p-2 rounded-lg hover:bg-gray-100 transition-colors"
              aria-label="Open menu"
            >
              <Menu className="w-6 h-6 text-gray-700" />
            </button>

            {/* Page Title */}
            <div className="flex-1 lg:flex-none text-center lg:text-left">
              <h1 className="text-base lg:text-lg font-medium text-gray-900 truncate px-2">
                {getPageTitle()}
              </h1>
            </div>

            {/* Spacer for mobile */}
            <div className="lg:hidden w-10" />
          </div>
        </header>

        {/* Main Content Area */}
        <main className="flex-1 bg-gray-50">
          {children}
        </main>
      </div>
    </div>
  );
}
