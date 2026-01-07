/**
 * Admin Dashboard - Compact design
 * Stats, quick actions, activity feed
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
  TrendingDown,
  Activity,
  AlertTriangle,
  ArrowRight,
} from 'lucide-react';

const stats = [
  { name: 'Clients', value: '145', icon: Users, color: 'bg-blue-500', trend: '+12%', up: true },
  { name: 'Labels', value: '2,847', icon: Tag, color: 'bg-emerald-500', trend: '+8%', up: true },
  { name: 'NFC Tags', value: '1,203', icon: Smartphone, color: 'bg-violet-500', trend: '+23%', up: true },
  { name: 'Pending', value: '18', icon: Package, color: 'bg-amber-500', trend: '-5%', up: false },
];

const quickActions = [
  { name: 'Generate Labels', href: '/dashboard/labels/generate', icon: Plus, color: 'text-emerald-600 bg-emerald-50' },
  { name: 'Manage Labels', href: '/dashboard/labels/manage', icon: List, color: 'text-blue-600 bg-blue-50' },
  { name: 'Validation', href: '/dashboard/labels/validation', icon: CheckCircle, color: 'text-violet-600 bg-violet-50' },
  { name: 'NFC Identify', href: '/dashboard/nfc/identify', icon: Fingerprint, color: 'text-amber-600 bg-amber-50' },
];

const recentActivity = [
  { id: 1, action: 'New client', client: 'Backpack Boyz', time: '2m' },
  { id: 2, action: 'Labels generated', client: '9ines', count: 500, time: '15m' },
  { id: 3, action: 'NFC assigned', client: 'Astro', count: 100, time: '1h' },
  { id: 4, action: 'Validation done', client: 'Baby Vapes', time: '2h' },
  { id: 5, action: 'New client', client: 'Aura', time: '3h' },
];

export default function DashboardPage() {
  return (
    <div className="p-3 lg:p-4 space-y-4">
      {/* Stats Row */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-2">
        {stats.map((stat) => (
          <div key={stat.name} className="bg-white rounded-lg border border-gray-100 p-3">
            <div className="flex items-center justify-between mb-2">
              <div className={`w-8 h-8 ${stat.color} rounded-lg flex items-center justify-center`}>
                <stat.icon className="w-4 h-4 text-white" />
              </div>
              <div className={`flex items-center gap-0.5 text-[10px] font-medium ${stat.up ? 'text-emerald-600' : 'text-red-500'}`}>
                {stat.up ? <TrendingUp className="w-3 h-3" /> : <TrendingDown className="w-3 h-3" />}
                {stat.trend}
              </div>
            </div>
            <p className="text-xl font-semibold text-gray-900">{stat.value}</p>
            <p className="text-[11px] text-gray-500">{stat.name}</p>
          </div>
        ))}
      </div>

      {/* Quick Actions */}
      <div>
        <div className="flex items-center justify-between mb-2">
          <h2 className="text-xs font-semibold text-gray-700 uppercase tracking-wide">Quick Actions</h2>
        </div>
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-2">
          {quickActions.map((action) => (
            <Link
              key={action.name}
              href={action.href}
              className="bg-white rounded-lg border border-gray-100 p-3 hover:border-gray-200 hover:shadow-sm transition-all group"
            >
              <div className="flex items-center gap-2">
                <div className={`w-8 h-8 rounded-lg flex items-center justify-center ${action.color}`}>
                  <action.icon className="w-4 h-4" />
                </div>
                <span className="text-xs font-medium text-gray-700 group-hover:text-gray-900">{action.name}</span>
              </div>
            </Link>
          ))}
        </div>
      </div>

      {/* Two Column Layout */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-3">
        {/* Recent Activity */}
        <div className="bg-white rounded-lg border border-gray-100">
          <div className="px-3 py-2 border-b border-gray-50 flex items-center justify-between">
            <div className="flex items-center gap-1.5">
              <Activity className="w-3.5 h-3.5 text-gray-400" />
              <h3 className="text-xs font-semibold text-gray-700">Recent Activity</h3>
            </div>
            <Link href="/dashboard/activity" className="text-[10px] text-blue-600 hover:text-blue-700 flex items-center gap-0.5">
              View all <ArrowRight className="w-3 h-3" />
            </Link>
          </div>
          <div className="divide-y divide-gray-50">
            {recentActivity.map((item) => (
              <div key={item.id} className="px-3 py-2 flex items-center justify-between">
                <div>
                  <p className="text-xs text-gray-800">{item.action}</p>
                  <p className="text-[10px] text-gray-500">
                    {item.client}{item.count && ` • ${item.count}`}
                  </p>
                </div>
                <span className="text-[10px] text-gray-400">{item.time}</span>
              </div>
            ))}
          </div>
        </div>

        {/* System Status */}
        <div className="bg-white rounded-lg border border-gray-100">
          <div className="px-3 py-2 border-b border-gray-50 flex items-center gap-1.5">
            <TrendingUp className="w-3.5 h-3.5 text-gray-400" />
            <h3 className="text-xs font-semibold text-gray-700">System Status</h3>
          </div>
          <div className="p-3 space-y-2">
            <div className="flex items-center justify-between p-2 bg-emerald-50 rounded-lg">
              <div className="flex items-center gap-2">
                <div className="w-1.5 h-1.5 bg-emerald-500 rounded-full" />
                <span className="text-xs text-emerald-800">Label Service</span>
              </div>
              <span className="text-[10px] text-emerald-600">Operational</span>
            </div>
            <div className="flex items-center justify-between p-2 bg-emerald-50 rounded-lg">
              <div className="flex items-center gap-2">
                <div className="w-1.5 h-1.5 bg-emerald-500 rounded-full" />
                <span className="text-xs text-emerald-800">NFC Service</span>
              </div>
              <span className="text-[10px] text-emerald-600">Operational</span>
            </div>
            <div className="flex items-center justify-between p-2 bg-amber-50 rounded-lg">
              <div className="flex items-center gap-1.5">
                <AlertTriangle className="w-3.5 h-3.5 text-amber-600" />
                <span className="text-xs text-amber-800">3 pending validations</span>
              </div>
              <Link href="/dashboard/labels/validation" className="text-[10px] text-amber-600 hover:text-amber-700">
                Review
              </Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
