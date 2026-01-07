/**
 * Dashboard Layout - Admin Platform
 * Full nav structure with color-accented icons
 * Last Modified: January 2026
 */

'use client';

import { useEffect, useState } from 'react';
import { useRouter, usePathname } from 'next/navigation';
import Link from 'next/link';
import { isSessionValid, getCurrentUser, AuthUser, logout } from '@/lib/auth';
import {
  LayoutDashboard,
  Menu,
  X,
  Factory,
  Shield,
  ChevronDown,
  ChevronRight,
  Tag,
  QrCode,
  FlaskConical,
  Nfc,
  Users,
  Package,
  Globe,
  ShoppingCart,
  Gift,
  Trophy,
  Settings,
  Plus,
  List,
  CheckCircle,
  Fingerprint,
  PlayCircle,
  AlertTriangle,
  Box,
  Ticket,
  UserPlus,
  Mail,
  FileText,
  UserCog,
  Sparkles,
} from 'lucide-react';

interface NavChild {
  name: string;
  href: string;
  icon: React.ElementType;
}

interface NavItem {
  name: string;
  href?: string;
  icon: React.ElementType;
  iconColor?: string;
  children?: NavChild[];
}

const adminNavItems: NavItem[] = [
  { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
  { name: 'Clients', href: '/dashboard/clients', icon: Globe },
  {
    name: 'Labels',
    icon: Tag,
    iconColor: 'text-violet-500',
    children: [
      { name: 'Generate', href: '/dashboard/labels/generate', icon: Plus },
      { name: 'Manage', href: '/dashboard/labels/manage', icon: List },
      { name: 'Add New', href: '/dashboard/labels/add', icon: Plus },
      { name: 'Validation', href: '/dashboard/labels/validation', icon: CheckCircle },
    ],
  },
  { name: 'QR Codes', href: '/dashboard/qr-codes', icon: QrCode, iconColor: 'text-emerald-500' },
  { name: 'Test Results', href: '/dashboard/test-results', icon: FlaskConical },
  {
    name: 'NFC',
    icon: Nfc,
    iconColor: 'text-cyan-500',
    children: [
      { name: 'Inventory', href: '/dashboard/nfc/inventory', icon: Package },
      { name: 'Generate', href: '/dashboard/nfc/generate', icon: Plus },
      { name: 'Manage NFC Tag', href: '/dashboard/nfc/manage', icon: List },
      { name: 'Identify', href: '/dashboard/nfc/identify', icon: Fingerprint },
      { name: 'Demo', href: '/dashboard/nfc/demo', icon: PlayCircle },
      { name: 'Error Logs', href: '/dashboard/nfc/errors', icon: AlertTriangle },
    ],
  },
  { name: 'Users', href: '/dashboard/users', icon: Users },
  {
    name: 'Register Products',
    icon: Package,
    iconColor: 'text-amber-500',
    children: [
      { name: 'Products', href: '/dashboard/register-products/products', icon: Box },
      { name: 'Redeem', href: '/dashboard/register-products/redeem', icon: Ticket },
      { name: 'Members', href: '/dashboard/register-products/members', icon: Users },
      { name: 'Orders', href: '/dashboard/register-products/orders', icon: ShoppingCart },
      { name: 'Register-Requests', href: '/dashboard/register-products/requests', icon: FileText },
      { name: 'Configure', href: '/dashboard/register-products/configure', icon: Settings },
    ],
  },
  {
    name: 'Client Requests',
    icon: UserPlus,
    children: [
      { name: 'New Requests', href: '/dashboard/clients/requests', icon: UserPlus },
      { name: 'Review Emails', href: '/dashboard/clients/emails', icon: Mail },
      { name: 'Client Settings', href: '/dashboard/clients/settings', icon: Settings },
    ],
  },
  { name: 'BBSimon Orders', href: '/dashboard/bbsimon-orders', icon: ShoppingCart },
  {
    name: 'Rewards',
    icon: Gift,
    iconColor: 'text-orange-500',
    children: [],
  },
  {
    name: 'Prize',
    icon: Trophy,
    children: [],
  },
  {
    name: 'App Settings',
    icon: Settings,
    iconColor: 'text-slate-500',
    children: [
      { name: 'Verification Templates', href: '/dashboard/app-settings/verification-templates', icon: FileText },
    ],
  },
  {
    name: 'Settings',
    icon: UserCog,
    children: [
      { name: 'Users', href: '/dashboard/settings/users', icon: Users },
    ],
  },
  {
    name: 'AI Assistant',
    href: '/dashboard/ai',
    icon: Sparkles,
    iconColor: 'text-purple-500',
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
  const [expandedSections, setExpandedSections] = useState<Set<string>>(new Set());

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

  useEffect(() => {
    setShowMobileMenu(false);
  }, [pathname]);

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
    if (pathname.includes('/clients')) return 'Clients';
    if (pathname.includes('/labels')) return 'Labels';
    if (pathname.includes('/nfc')) return 'NFC';
    if (pathname.includes('/qr-codes')) return 'QR Codes';
    if (pathname.includes('/test-results')) return 'Test Results';
    if (pathname.includes('/users')) return 'Users';
    if (pathname.includes('/register-products')) return 'Register Products';
    if (pathname.includes('/bbsimon')) return 'BBSimon Orders';
    if (pathname.includes('/rewards')) return 'Rewards';
    if (pathname.includes('/prize')) return 'Prize';
    if (pathname.includes('/app-settings')) return 'App Settings';
    if (pathname.includes('/settings')) return 'Settings';
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
        <div className="text-gray-500 text-sm">Loading...</div>
      </div>
    );
  }

  if (!user) {
    return null;
  }

  const SidebarContent = ({ onLinkClick, onClose }: { onLinkClick?: () => void; onClose?: () => void }) => (
    <div className="flex flex-col h-full text-[13px]">
      {/* Logo Section */}
      <div className="h-12 px-3 border-b border-gray-100 flex items-center justify-between">
        <Link href="/dashboard" onClick={onLinkClick} className="hover:opacity-80 transition-opacity">
          <h1 className="text-base font-bold text-gray-900">BirdHaus</h1>
        </Link>
        {onClose && (
          <button onClick={onClose} className="lg:hidden p-1 hover:bg-gray-100 rounded">
            <X className="w-4 h-4 text-gray-500" />
          </button>
        )}
      </div>

      {/* User Profile */}
      <div className="px-3 py-2 border-b border-gray-100">
        <div className="flex items-center gap-2">
          <div className="w-7 h-7 bg-blue-500 rounded-full flex items-center justify-center text-white font-medium text-xs">
            {getInitial(user?.name || '')}
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-xs font-medium text-gray-900 truncate">{user?.name}</p>
            <p className="text-[10px] text-gray-500">{formatRole(user?.role || '')}</p>
          </div>
        </div>
      </div>

      {/* Mode Switcher */}
      <div className="px-3 py-2 border-b border-gray-100">
        <div className="flex gap-1">
          <button
            onClick={handleSwitchToFactory}
            className="flex-1 flex items-center justify-center gap-1.5 px-2 py-1.5 bg-gray-100 text-gray-600 text-xs font-medium rounded hover:bg-gray-200 transition-colors"
          >
            <Factory className="w-3 h-3" />
            Factory
          </button>
          <button className="flex-1 flex items-center justify-center gap-1.5 px-2 py-1.5 bg-blue-600 text-white text-xs font-medium rounded">
            <Shield className="w-3 h-3" />
            Admin
          </button>
        </div>
      </div>

      {/* Navigation */}
      <nav className="flex-1 overflow-y-auto py-1">
        {adminNavItems.map((item) => {
          const Icon = item.icon;
          const hasChildren = item.children && item.children.length > 0;
          const isExpanded = expandedSections.has(item.name);
          const isActive = item.href
            ? pathname === item.href
            : item.children?.some((c) => pathname === c.href || pathname.startsWith(c.href + '/'));

          // Items with empty children array are collapsible but empty
          const isCollapsible = item.children !== undefined;

          if (isCollapsible) {
            return (
              <div key={item.name}>
                <button
                  onClick={() => toggleSection(item.name)}
                  className={`w-full flex items-center justify-between px-3 py-1.5 transition-colors ${
                    isActive ? 'bg-blue-50' : 'hover:bg-gray-50'
                  }`}
                >
                  <div className="flex items-center gap-2">
                    <Icon className={`w-4 h-4 ${isActive ? 'text-blue-600' : item.iconColor || 'text-gray-400'}`} />
                    <span className={`font-medium ${isActive ? 'text-blue-600' : 'text-gray-700'}`}>{item.name}</span>
                  </div>
                  {hasChildren && (
                    isExpanded ? (
                      <ChevronDown className="w-3 h-3 text-gray-400" />
                    ) : (
                      <ChevronRight className="w-3 h-3 text-gray-400" />
                    )
                  )}
                  {!hasChildren && <ChevronRight className="w-3 h-3 text-gray-300" />}
                </button>
                {isExpanded && hasChildren && (
                  <div className="ml-3 border-l border-gray-200">
                    {item.children!.map((child) => {
                      const ChildIcon = child.icon;
                      const isChildActive = pathname === child.href || pathname.startsWith(child.href + '/');
                      return (
                        <Link
                          key={child.href}
                          href={child.href}
                          onClick={onLinkClick}
                          className={`flex items-center gap-2 px-3 py-1.5 transition-colors ${
                            isChildActive ? 'text-blue-600 bg-blue-50' : 'text-gray-500 hover:bg-gray-50 hover:text-gray-700'
                          }`}
                        >
                          <ChildIcon className={`w-3.5 h-3.5 ${isChildActive ? 'text-blue-600' : 'text-gray-400'}`} />
                          <span className="text-[12px]">{child.name}</span>
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
              className={`flex items-center gap-2 px-3 py-1.5 transition-colors ${
                isActive ? 'bg-blue-50' : 'hover:bg-gray-50'
              }`}
            >
              <Icon className={`w-4 h-4 ${isActive ? 'text-blue-600' : item.iconColor || 'text-gray-400'}`} />
              <span className={`font-medium ${isActive ? 'text-blue-600' : 'text-gray-700'}`}>{item.name}</span>
            </Link>
          );
        })}
      </nav>

      {/* Logout */}
      <div className="p-2 border-t border-gray-100">
        <button
          onClick={() => { handleLogout(); onLinkClick?.(); }}
          className="w-full flex items-center gap-2 px-2 py-1.5 text-xs text-gray-600 hover:bg-gray-50 rounded transition-colors"
        >
          <div className="w-6 h-6 bg-gray-800 rounded-full flex items-center justify-center">
            <span className="text-white font-medium text-[10px]">{getInitial(user?.name || '')}</span>
          </div>
          <span>Logout</span>
        </button>
      </div>
    </div>
  );

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Desktop Sidebar */}
      <aside className="hidden lg:fixed lg:inset-y-0 lg:left-0 lg:z-40 lg:w-52 lg:bg-white lg:border-r lg:border-gray-100 lg:flex lg:flex-col">
        <SidebarContent />
      </aside>

      {/* Mobile Sidebar */}
      <div className={`lg:hidden fixed inset-0 z-50 transition-opacity duration-300 ${showMobileMenu ? 'opacity-100 pointer-events-auto' : 'opacity-0 pointer-events-none'}`}>
        <div className="absolute inset-0 bg-black/50" onClick={() => setShowMobileMenu(false)} />
        <aside className={`absolute left-0 top-0 h-full w-52 bg-white shadow-lg transform transition-transform duration-300 ${showMobileMenu ? 'translate-x-0' : '-translate-x-full'}`}>
          <SidebarContent onLinkClick={() => setShowMobileMenu(false)} onClose={() => setShowMobileMenu(false)} />
        </aside>
      </div>

      {/* Main Content */}
      <div className="lg:pl-52 flex flex-col min-h-screen">
        {/* Top Bar */}
        <header className="sticky top-0 z-30 bg-white border-b border-gray-100">
          <div className="flex items-center justify-between px-3 lg:px-4 h-11">
            <button
              onClick={() => setShowMobileMenu(true)}
              className="lg:hidden p-1.5 rounded hover:bg-gray-100"
            >
              <Menu className="w-4 h-4 text-gray-600" />
            </button>
            <h1 className="text-sm font-medium text-gray-900">{getPageTitle()}</h1>
            <div className="lg:hidden w-8" />
          </div>
        </header>

        {/* Main Content Area */}
        <main className="flex-1 bg-gray-50">{children}</main>
      </div>
    </div>
  );
}
