/**
 * Admin Dashboard - Main overview page
 * Shows stats and quick access to features
 * Roles: Super Admin, Admin+
 * Last Modified: January 2026
 */

'use client';

import { Users, Tag, Smartphone, Package } from 'lucide-react';
import Link from 'next/link';

const stats = [
  { name: 'Total Clients', value: '145', icon: Users, color: 'bg-blue-500' },
  { name: 'Active Labels', value: '--', icon: Tag, color: 'bg-green-500' },
  { name: 'NFC Registrations', value: '--', icon: Smartphone, color: 'bg-purple-500' },
  { name: 'Pending Orders', value: '--', icon: Package, color: 'bg-orange-500' },
] as const;

const features = [
  {
    name: 'Client Dashboard',
    description: 'View and manage all clients',
    href: '/dashboard/clients',
    icon: Users,
    color: 'bg-blue-100 text-blue-600',
  },
  {
    name: 'Labels',
    description: 'Manage label inventory',
    href: '/dashboard/labels',
    icon: Tag,
    color: 'bg-green-100 text-green-600',
  },
  {
    name: 'NFC Tags',
    description: 'NFC registration admin',
    href: '/dashboard/nfc',
    icon: Smartphone,
    color: 'bg-purple-100 text-purple-600',
  },
];

export default function DashboardPage() {
  return (
    <div className="p-4 lg:p-6">
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-lg font-semibold text-gray-900">Welcome to Birdhaus Admin</h1>
        <p className="text-sm text-gray-500">
          Manage clients, labels, NFC tags, and platform settings.
        </p>
      </div>

      {/* Stats Grid - Compact */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3 mb-6">
        {stats.map((stat) => (
          <div
            key={stat.name}
            className="bg-white rounded-lg shadow-sm border border-gray-100 p-4"
          >
            <div className="flex items-center gap-3">
              <div className={`w-9 h-9 ${stat.color} rounded-lg flex items-center justify-center`}>
                <stat.icon className="w-4 h-4 text-white" />
              </div>
              <div>
                <p className="text-xs font-medium text-gray-500">{stat.name}</p>
                <p className="text-lg font-semibold text-gray-900">{stat.value}</p>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Feature Cards - Compact */}
      <h2 className="text-sm font-semibold text-gray-900 mb-3">Quick Access</h2>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
        {features.map((feature) => (
          <Link
            key={feature.name}
            href={feature.href}
            className="bg-white rounded-lg shadow-sm border border-gray-100 p-4 hover:shadow-md hover:border-gray-200 transition-all"
          >
            <div className="flex items-center gap-3">
              <div className={`w-9 h-9 ${feature.color} rounded-lg flex items-center justify-center`}>
                <feature.icon className="w-4 h-4" />
              </div>
              <div>
                <h3 className="text-sm font-medium text-gray-900">{feature.name}</h3>
                <p className="text-xs text-gray-500">{feature.description}</p>
              </div>
            </div>
          </Link>
        ))}
      </div>
    </div>
  );
}
