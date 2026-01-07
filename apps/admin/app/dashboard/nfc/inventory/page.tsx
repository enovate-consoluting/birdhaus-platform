/**
 * NFC Inventory Page
 * View spool inventory
 * Last Modified: January 2026
 */

'use client';

import { useEffect, useState } from 'react';
import {
  RefreshCw,
  Edit,
  Loader2,
  ExternalLink,
  Check,
} from 'lucide-react';

interface Spool {
  spool_id: number;
  num_tags: number;
  create_dt: string;
  active: number;
  client_id: number;
  company_name: string;
  video_url?: string;
}

export default function NfcInventoryPage() {
  const [inventory, setInventory] = useState<Spool[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchInventory();
  }, []);

  const fetchInventory = async () => {
    setLoading(true);
    try {
      const res = await fetch('/api/nfc/inventory');
      const data = await res.json();
      if (data.success) {
        setInventory(data.data);
      }
    } catch (error) {
      console.error('Error fetching inventory:', error);
    } finally {
      setLoading(false);
    }
  };

  const formatDate = (dateStr: string) => {
    return new Date(dateStr).toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
    });
  };

  const totalTags = inventory.reduce((sum, s) => sum + (s.num_tags || 0), 0);
  const activeSpools = inventory.filter((s) => s.active).length;

  return (
    <div className="p-3 lg:p-4">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4">
        <div>
          <h1 className="text-sm font-semibold text-gray-900">NFC Inventory</h1>
          <p className="text-[11px] text-gray-500">
            {inventory.length} spools &bull; {totalTags.toLocaleString()} total tags &bull; {activeSpools} active
          </p>
        </div>
        <button
          onClick={fetchInventory}
          className="p-1.5 text-gray-400 hover:text-blue-500 hover:bg-blue-50 rounded-lg transition-colors"
        >
          <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin' : ''}`} />
        </button>
      </div>

      {/* Inventory Table */}
      <div className="bg-white rounded-lg border border-gray-100 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-gray-100 bg-gray-50/50">
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Spool ID</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Quantity</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Created</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Client</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Video URL</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Active</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-50">
              {loading ? (
                <tr>
                  <td colSpan={7} className="px-3 py-8 text-center">
                    <div className="flex items-center justify-center gap-2 text-gray-400 text-xs">
                      <Loader2 className="w-3.5 h-3.5 animate-spin" />
                      Loading...
                    </div>
                  </td>
                </tr>
              ) : inventory.length === 0 ? (
                <tr>
                  <td colSpan={7} className="px-3 py-8 text-center text-xs text-gray-400">
                    No inventory found
                  </td>
                </tr>
              ) : (
                inventory.map((spool) => (
                  <tr key={spool.spool_id} className="hover:bg-gray-50/50">
                    <td className="px-3 py-2 text-xs font-medium text-gray-900">{spool.spool_id}</td>
                    <td className="px-3 py-2 text-xs text-gray-600">{spool.num_tags?.toLocaleString()}</td>
                    <td className="px-3 py-2 text-[11px] text-gray-500">{formatDate(spool.create_dt)}</td>
                    <td className="px-3 py-2 text-xs text-gray-600">{spool.company_name}</td>
                    <td className="px-3 py-2 text-xs">
                      {spool.video_url ? (
                        <a
                          href={spool.video_url}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="inline-flex items-center gap-1 text-blue-600 hover:text-blue-700"
                        >
                          <ExternalLink className="w-3 h-3" />
                          <span className="text-[10px]">View</span>
                        </a>
                      ) : (
                        <span className="text-gray-300">-</span>
                      )}
                    </td>
                    <td className="px-3 py-2">
                      {spool.active ? (
                        <span className="inline-flex items-center gap-0.5 text-emerald-600 text-[10px]">
                          <Check className="w-3 h-3" /> Yes
                        </span>
                      ) : (
                        <span className="text-gray-300 text-[10px]">No</span>
                      )}
                    </td>
                    <td className="px-3 py-2">
                      <button
                        onClick={() => alert(`Edit spool ${spool.spool_id} requires write access`)}
                        className="p-1 text-gray-400 hover:text-blue-500 hover:bg-blue-50 rounded transition-colors"
                      >
                        <Edit className="w-3.5 h-3.5" />
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
        {!loading && inventory.length > 0 && (
          <div className="px-3 py-2 bg-gray-50/50 border-t border-gray-100 text-[10px] text-gray-500">
            Showing {inventory.length} spools
          </div>
        )}
      </div>
    </div>
  );
}
