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
];

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
    <div className="p-8">
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-gray-900">Welcome to Birdhaus Admin</h1>
        <p className="mt-1 text-gray-500">
          Manage clients, labels, NFC tags, and platform settings.
        </p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        {stats.map((stat) => (
          <div
            key={stat.name}
            className="bg-white rounded-xl shadow-sm border border-gray-200 p-6"
          >
            <div className="flex items-center gap-4">
              <div className={`w-12 h-12 ${stat.color} rounded-xl flex items-center justify-center`}>
                <stat.icon className="w-6 h-6 text-white" />
              </div>
              <div>
                <p className="text-sm font-medium text-gray-500">{stat.name}</p>
                <p className="text-2xl font-bold text-gray-900">{stat.value}</p>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Feature Cards */}
      <h2 className="text-lg font-semibold text-gray-900 mb-4">Admin Features</h2>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {features.map((feature) => (
          <Link
            key={feature.name}
            href={feature.href}
            className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md hover:border-gray-300 transition-all"
          >
            <div className="flex items-center gap-4">
              <div className={`w-12 h-12 ${feature.color} rounded-xl flex items-center justify-center`}>
                <feature.icon className="w-6 h-6" />
              </div>
              <div>
                <h3 className="font-semibold text-gray-900">{feature.name}</h3>
                <p className="text-sm text-gray-500">{feature.description}</p>
              </div>
            </div>
          </Link>
        ))}
      </div>

      {/* Quick Info */}
      <div className="mt-8 p-4 bg-blue-50 border border-blue-200 rounded-xl">
        <div className="flex items-start gap-3">
          <div className="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center flex-shrink-0">
            <svg className="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <div>
            <h4 className="font-medium text-blue-900">Mode Switcher</h4>
            <p className="text-sm text-blue-700 mt-1">
              Use the dropdown in the sidebar to switch between Admin and Factory Orders.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
