/**
 * Dashboard Layout - Admin Platform
 * Collapsible sidebar navigation
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
  Menu,
  X,
  Factory,
  Shield,
  ChevronDown,
  ChevronRight,
  Plus,
  List,
  Search,
  CheckCircle,
  Package,
  Fingerprint,
  PlayCircle,
  AlertTriangle,
} from 'lucide-react';

interface NavItem {
  name: string;
  href?: string;
  icon: React.ElementType;
  children?: { name: string; href: string; icon: React.ElementType }[];
}

const adminNavItems: NavItem[] = [
  { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
  { name: 'Clients', href: '/dashboard/clients', icon: Users },
  {
    name: 'Labels',
    icon: Tag,
    children: [
      { name: 'Generate', href: '/dashboard/labels/generate', icon: Plus },
      { name: 'Manage', href: '/dashboard/labels/manage', icon: List },
      { name: 'Add New', href: '/dashboard/labels/add', icon: Plus },
      { name: 'Validation', href: '/dashboard/labels/validation', icon: CheckCircle },
    ],
  },
  {
    name: 'NFC',
    icon: Smartphone,
    children: [
      { name: 'Inventory', href: '/dashboard/nfc/inventory', icon: Package },
      { name: 'Generate', href: '/dashboard/nfc/generate', icon: Plus },
      { name: 'Manage NFC Tag', href: '/dashboard/nfc/manage', icon: List },
      { name: 'Identify', href: '/dashboard/nfc/identify', icon: Fingerprint },
      { name: 'Demo', href: '/dashboard/nfc/demo', icon: PlayCircle },
      { name: 'Error Logs', href: '/dashboard/nfc/errors', icon: AlertTriangle },
    ],
  },
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
  const [expandedSections, setExpandedSections] = useState<Set<string>>(new Set(['Labels', 'NFC']));

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

  const handleSwitchToFactory = async () => {
    try {
      const response = await fetch('/api/auth/sso-token', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ user }),
      });
      const result = await response.json();
      if (result.success && result.token) {
        window.location.href = `https://birdhausapp.com/auth/callback?token=${result.token}`;
      } else {
        window.location.href = 'https://birdhausapp.com';
      }
    } catch {
      window.location.href = 'https://birdhausapp.com';
    }
  };

  const toggleSection = (name: string) => {
    setExpandedSections((prev) => {
      const next = new Set(prev);
      if (next.has(name)) {
        next.delete(name);
      } else {
        next.add(name);
      }
      return next;
    });
  };

  const getPageTitle = () => {
    if (pathname === '/dashboard') return 'Dashboard';
    if (pathname === '/dashboard/clients') return 'Clients';
    if (pathname.startsWith('/dashboard/labels')) return 'Labels';
    if (pathname.startsWith('/dashboard/nfc')) return 'NFC';
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
      <div className="px-4 py-3 border-b border-gray-100">
        <div className="flex items-center gap-3">
          <div className="w-9 h-9 bg-blue-500 rounded-full flex items-center justify-center text-white font-semibold flex-shrink-0 text-sm">
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
        <div className="flex gap-2">
          <button
            onClick={handleSwitchToFactory}
            className="flex-1 flex items-center justify-center gap-2 px-3 py-2 bg-gray-100 text-gray-700 text-sm font-medium rounded-lg hover:bg-gray-200 transition-colors"
          >
            <Factory className="w-4 h-4" />
            Factory
          </button>
          <button
            className="flex-1 flex items-center justify-center gap-2 px-3 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg"
          >
            <Shield className="w-4 h-4" />
            Admin
          </button>
        </div>
      </div>

      {/* Navigation */}
      <nav className="flex-1 overflow-y-auto py-2">
        {adminNavItems.map((item) => {
          const Icon = item.icon;
          const isExpanded = expandedSections.has(item.name);
          const hasChildren = item.children && item.children.length > 0;
          const isActive = item.href ? pathname === item.href : item.children?.some(c => pathname === c.href || pathname.startsWith(c.href + '/'));

          if (hasChildren) {
            return (
              <div key={item.name} className="mb-1">
                <button
                  onClick={() => toggleSection(item.name)}
                  className={`w-full flex items-center justify-between px-4 py-2.5 text-sm transition-colors ${
                    isActive
                      ? 'text-blue-600 bg-blue-50'
                      : 'text-gray-700 hover:bg-gray-50'
                  }`}
                >
                  <div className="flex items-center gap-3">
                    <Icon className={`w-5 h-5 ${isActive ? 'text-blue-600' : 'text-gray-400'}`} />
                    <span className="font-medium">{item.name}</span>
                  </div>
                  {isExpanded ? (
                    <ChevronDown className="w-4 h-4 text-gray-400" />
                  ) : (
                    <ChevronRight className="w-4 h-4 text-gray-400" />
                  )}
                </button>
                {isExpanded && (
                  <div className="ml-4 border-l border-gray-200">
                    {item.children!.map((child) => {
                      const ChildIcon = child.icon;
                      const isChildActive = pathname === child.href || pathname.startsWith(child.href + '/');
                      return (
                        <Link
                          key={child.href}
                          href={child.href}
                          onClick={onLinkClick}
                          className={`flex items-center gap-3 px-4 py-2 text-sm transition-colors ${
                            isChildActive
                              ? 'text-blue-600 bg-blue-50'
                              : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
                          }`}
                        >
                          <ChildIcon className={`w-4 h-4 ${isChildActive ? 'text-blue-600' : 'text-gray-400'}`} />
                          <span>{child.name}</span>
                        </Link>
                      );
                    })}
                  </div>
                )}
              </div>
            );
          }

          return (
            <Link
              key={item.name}
              href={item.href!}
              onClick={onLinkClick}
              className={`flex items-center gap-3 px-4 py-2.5 text-sm transition-colors ${
                isActive
                  ? 'text-blue-600 bg-blue-50'
                  : 'text-gray-700 hover:bg-gray-50'
              }`}
            >
              <Icon className={`w-5 h-5 ${isActive ? 'text-blue-600' : 'text-gray-400'}`} />
              <span className="font-medium">{item.name}</span>
            </Link>
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
          className="w-full flex items-center gap-3 px-3 py-2 text-sm text-gray-700 hover:bg-gray-50 rounded-lg transition-colors"
        >
          <div className="w-8 h-8 bg-gray-900 rounded-full flex items-center justify-center flex-shrink-0">
            <span className="text-white font-semibold text-xs">{getInitial(user?.name || '')}</span>
          </div>
          <span className="font-medium">Logout</span>
        </button>
      </div>
    </div>
  );

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Desktop Sidebar */}
      <aside className="hidden lg:fixed lg:inset-y-0 lg:left-0 lg:z-40 lg:w-64 lg:bg-white lg:border-r lg:border-gray-100 lg:flex lg:flex-col">
        <SidebarContent />
      </aside>

      {/* Mobile Sidebar */}
      <div className={`lg:hidden fixed inset-0 z-50 transition-opacity duration-300 ${showMobileMenu ? 'opacity-100 pointer-events-auto' : 'opacity-0 pointer-events-none'}`}>
        <div
          className="absolute inset-0 bg-black bg-opacity-50 transition-opacity"
          onClick={() => setShowMobileMenu(false)}
        />
        <aside className={`absolute left-0 top-0 h-full w-64 bg-white shadow-lg transform transition-transform duration-300 ${showMobileMenu ? 'translate-x-0' : '-translate-x-full'}`}>
          <SidebarContent
            onLinkClick={() => setShowMobileMenu(false)}
            onClose={() => setShowMobileMenu(false)}
          />
        </aside>
      </div>

      {/* Main Content */}
      <div className="lg:pl-64 flex flex-col min-h-screen">
        {/* Top Bar */}
        <header className="sticky top-0 z-30 bg-white border-b border-gray-100 shadow-sm">
          <div className="flex items-center justify-between px-4 lg:px-6 h-14">
            {/* Mobile Menu Button */}
            <button
              onClick={() => setShowMobileMenu(true)}
              className="lg:hidden p-2 rounded-lg hover:bg-gray-100 transition-colors"
              aria-label="Open menu"
            >
              <Menu className="w-5 h-5 text-gray-700" />
            </button>

            {/* Page Title */}
            <div className="flex-1 lg:flex-none text-center lg:text-left">
              <h1 className="text-sm lg:text-base font-medium text-gray-900 truncate px-2">
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
