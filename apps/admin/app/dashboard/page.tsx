/**
 * Admin Dashboard - Main overview page
 * Stats and quick functions
 * Roles: Super Admin, Admin+
 * Last Modified: January 2026
 */

'use client';

import Link from 'next/link';
import {
  Users,
  Tag,
  Smartphone,
  Package,
  Plus,
  List,
  CheckCircle,
  Fingerprint,
  TrendingUp,
  Activity,
  AlertTriangle,
} from 'lucide-react';

const stats = [
  { name: 'Total Clients', value: '145', icon: Users, color: 'bg-blue-500', trend: '+12%' },
  { name: 'Active Labels', value: '2,847', icon: Tag, color: 'bg-green-500', trend: '+8%' },
  { name: 'NFC Tags', value: '1,203', icon: Smartphone, color: 'bg-purple-500', trend: '+23%' },
  { name: 'Pending Orders', value: '18', icon: Package, color: 'bg-orange-500', trend: '-5%' },
];

const quickActions = [
  { name: 'Generate Labels', href: '/dashboard/labels/generate', icon: Plus, color: 'bg-green-100 text-green-600' },
  { name: 'Manage Labels', href: '/dashboard/labels/manage', icon: List, color: 'bg-blue-100 text-blue-600' },
  { name: 'Validate Labels', href: '/dashboard/labels/validation', icon: CheckCircle, color: 'bg-purple-100 text-purple-600' },
  { name: 'NFC Identify', href: '/dashboard/nfc/identify', icon: Fingerprint, color: 'bg-orange-100 text-orange-600' },
];

const recentActivity = [
  { id: 1, action: 'New client registered', client: 'Backpack Boyz', time: '2 mins ago' },
  { id: 2, action: 'Labels generated', client: '9ines', count: 500, time: '15 mins ago' },
  { id: 3, action: 'NFC tags assigned', client: 'Astro', count: 100, time: '1 hour ago' },
  { id: 4, action: 'Label validation completed', client: 'Baby Vapes', time: '2 hours ago' },
  { id: 5, action: 'New client registered', client: 'Aura', time: '3 hours ago' },
];

export default function DashboardPage() {
  return (
    <div className="p-4 lg:p-6 space-y-6">
      {/* Stats Grid */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
        {stats.map((stat) => (
          <div
            key={stat.name}
            className="bg-white rounded-lg border border-gray-100 p-4 shadow-sm"
          >
            <div className="flex items-start justify-between">
              <div className={`w-10 h-10 ${stat.color} rounded-lg flex items-center justify-center`}>
                <stat.icon className="w-5 h-5 text-white" />
              </div>
              <span className={`text-xs font-medium ${stat.trend.startsWith('+') ? 'text-green-600' : 'text-red-600'}`}>
                {stat.trend}
              </span>
            </div>
            <div className="mt-3">
              <p className="text-2xl font-semibold text-gray-900">{stat.value}</p>
              <p className="text-xs text-gray-500 mt-1">{stat.name}</p>
            </div>
          </div>
        ))}
      </div>

      {/* Quick Actions */}
      <div>
        <h2 className="text-sm font-semibold text-gray-900 mb-3">Quick Actions</h2>
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
          {quickActions.map((action) => (
            <Link
              key={action.name}
              href={action.href}
              className="bg-white rounded-lg border border-gray-100 p-4 shadow-sm hover:shadow-md hover:border-gray-200 transition-all flex items-center gap-3"
            >
              <div className={`w-10 h-10 ${action.color} rounded-lg flex items-center justify-center`}>
                <action.icon className="w-5 h-5" />
              </div>
              <span className="text-sm font-medium text-gray-900">{action.name}</span>
            </Link>
          ))}
        </div>
      </div>

      {/* Bottom Row: Recent Activity + Alerts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
        {/* Recent Activity */}
        <div className="bg-white rounded-lg border border-gray-100 shadow-sm">
          <div className="px-4 py-3 border-b border-gray-100 flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Activity className="w-4 h-4 text-gray-400" />
              <h3 className="text-sm font-semibold text-gray-900">Recent Activity</h3>
            </div>
            <Link href="/dashboard/activity" className="text-xs text-blue-600 hover:text-blue-700">
              View all
            </Link>
          </div>
          <div className="divide-y divide-gray-50">
            {recentActivity.map((item) => (
              <div key={item.id} className="px-4 py-3 flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-900">{item.action}</p>
                  <p className="text-xs text-gray-500">
                    {item.client}
                    {item.count && ` - ${item.count} items`}
                  </p>
                </div>
                <span className="text-xs text-gray-400">{item.time}</span>
              </div>
            ))}
          </div>
        </div>

        {/* System Status / Alerts */}
        <div className="bg-white rounded-lg border border-gray-100 shadow-sm">
          <div className="px-4 py-3 border-b border-gray-100 flex items-center gap-2">
            <TrendingUp className="w-4 h-4 text-gray-400" />
            <h3 className="text-sm font-semibold text-gray-900">System Status</h3>
          </div>
          <div className="p-4 space-y-3">
            <div className="flex items-center justify-between p-3 bg-green-50 rounded-lg">
              <div className="flex items-center gap-2">
                <div className="w-2 h-2 bg-green-500 rounded-full" />
                <span className="text-sm text-green-800">Label Service</span>
              </div>
              <span className="text-xs text-green-600">Operational</span>
            </div>
            <div className="flex items-center justify-between p-3 bg-green-50 rounded-lg">
              <div className="flex items-center gap-2">
                <div className="w-2 h-2 bg-green-500 rounded-full" />
                <span className="text-sm text-green-800">NFC Service</span>
              </div>
              <span className="text-xs text-green-600">Operational</span>
            </div>
            <div className="flex items-center justify-between p-3 bg-yellow-50 rounded-lg">
              <div className="flex items-center gap-2">
                <AlertTriangle className="w-4 h-4 text-yellow-600" />
                <span className="text-sm text-yellow-800">3 pending validations</span>
              </div>
              <Link href="/dashboard/labels/validation" className="text-xs text-yellow-600 hover:text-yellow-700">
                Review
              </Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
