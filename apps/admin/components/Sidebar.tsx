/**
 * Admin Sidebar Component
 * Navigation and mode switcher
 * Last Modified: January 2026
 */

'use client';

import { useState } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { logout, AuthUser } from '@/lib/auth';
import {
  LayoutDashboard,
  Users,
  Tag,
  Smartphone,
  Settings,
  LogOut,
  ChevronDown,
  Factory,
  Shield,
} from 'lucide-react';

interface NavItem {
  name: string;
  href: string;
  icon: React.ElementType;
}

const adminNavItems: NavItem[] = [
  { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
  { name: 'Clients', href: '/dashboard/clients', icon: Users },
  { name: 'Labels', href: '/dashboard/labels', icon: Tag },
  { name: 'NFC Tags', href: '/dashboard/nfc', icon: Smartphone },
  { name: 'Settings', href: '/dashboard/settings', icon: Settings },
];

interface SidebarProps {
  user: AuthUser;
}

export default function Sidebar({ user }: SidebarProps) {
  const pathname = usePathname();
  const [modeOpen, setModeOpen] = useState(false);

  const handleLogout = () => {
    logout('/login');
  };

  const handleSwitchToFactory = () => {
    // Open Factory Orders in same tab
    window.location.href = 'https://birdhausapp.com';
  };

  return (
    <div className="w-64 bg-gray-900 text-white flex flex-col h-screen">
      {/* Header with Mode Switcher */}
      <div className="p-4 border-b border-gray-800">
        <div className="relative">
          <button
            onClick={() => setModeOpen(!modeOpen)}
            className="w-full flex items-center justify-between p-3 rounded-xl bg-gray-800 hover:bg-gray-700 transition-colors"
          >
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center">
                <Shield className="w-4 h-4" />
              </div>
              <div className="text-left">
                <div className="font-semibold text-sm">Admin</div>
                <div className="text-xs text-gray-400">Birdhaus Platform</div>
              </div>
            </div>
            <ChevronDown className={`w-4 h-4 text-gray-400 transition-transform ${modeOpen ? 'rotate-180' : ''}`} />
          </button>

          {/* Mode Dropdown */}
          {modeOpen && (
            <div className="absolute top-full left-0 right-0 mt-2 bg-gray-800 rounded-xl border border-gray-700 shadow-xl z-50 overflow-hidden">
              <button
                onClick={handleSwitchToFactory}
                className="w-full flex items-center gap-3 p-3 hover:bg-gray-700 transition-colors"
              >
                <div className="w-8 h-8 bg-orange-600 rounded-lg flex items-center justify-center">
                  <Factory className="w-4 h-4" />
                </div>
                <div className="text-left">
                  <div className="font-semibold text-sm">Factory Orders</div>
                  <div className="text-xs text-gray-400">Manufacturing</div>
                </div>
              </button>
            </div>
          )}
        </div>
      </div>

      {/* Navigation */}
      <nav className="flex-1 p-4 space-y-1">
        {adminNavItems.map((item) => {
          const isActive = pathname === item.href || pathname.startsWith(item.href + '/');
          return (
            <Link
              key={item.name}
              href={item.href}
              className={`flex items-center gap-3 px-3 py-2.5 rounded-lg transition-colors ${
                isActive
                  ? 'bg-blue-600 text-white'
                  : 'text-gray-400 hover:text-white hover:bg-gray-800'
              }`}
            >
              <item.icon className="w-5 h-5" />
              <span className="font-medium">{item.name}</span>
            </Link>
          );
        })}
      </nav>

      {/* User Section */}
      <div className="p-4 border-t border-gray-800">
        <div className="mb-3 px-3">
          <div className="text-sm font-medium text-white">{user.name}</div>
          <div className="text-xs text-gray-400">{user.email}</div>
        </div>
        <button
          onClick={handleLogout}
          className="w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-gray-400 hover:text-white hover:bg-gray-800 transition-colors"
        >
          <LogOut className="w-5 h-5" />
          <span className="font-medium">Sign Out</span>
        </button>
      </div>
    </div>
  );
}
