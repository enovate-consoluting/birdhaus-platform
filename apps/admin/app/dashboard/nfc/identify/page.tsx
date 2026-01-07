/**
 * NFC Identify / Tracking Page
 * Track NFC scans and identify tags
 * Last Modified: January 2026
 */

'use client';

import { useEffect, useState } from 'react';
import {
  Search,
  RefreshCw,
  Edit,
  Loader2,
  ExternalLink,
  Check,
} from 'lucide-react';

interface NfcTag {
  tag_id: number;
  seq_num: number;
  spool_id: number;
  product_page: string;
  video_url: string;
  client_id: number;
  live: number;
  company_name: string;
  scan_count: number;
}

interface Client {
  client_id: number;
  company_name: string;
}

export default function NfcIdentifyPage() {
  const [tags, setTags] = useState<NfcTag[]>([]);
  const [clients, setClients] = useState<Client[]>([]);
  const [loading, setLoading] = useState(true);

  // Filters
  const [clientFilter, setClientFilter] = useState('');
  const [scanCountMin, setScanCountMin] = useState('');
  const [statusFilter, setStatusFilter] = useState('');
  const [seqNumFilter, setSeqNumFilter] = useState('');

  useEffect(() => {
    fetchClients();
    fetchTags();
  }, []);

  const fetchClients = async () => {
    try {
      const res = await fetch('/api/nfc/clients');
      const data = await res.json();
      if (data.success) {
        setClients(data.data);
      }
    } catch (error) {
      console.error('Error fetching clients:', error);
    }
  };

  const fetchTags = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (clientFilter) params.set('client', clientFilter);
      if (scanCountMin) params.set('scan_count_min', scanCountMin);
      if (statusFilter) params.set('status', statusFilter);
      if (seqNumFilter) params.set('seq_num', seqNumFilter);

      const res = await fetch(`/api/nfc/tracking?${params.toString()}`);
      const data = await res.json();
      if (data.success) {
        setTags(data.data);
      }
    } catch (error) {
      console.error('Error fetching tags:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleFilter = (e: React.FormEvent) => {
    e.preventDefault();
    fetchTags();
  };

  const totalScans = tags.reduce((sum, t) => sum + (t.scan_count || 0), 0);
  const activeTags = tags.filter((t) => t.live).length;

  return (
    <div className="p-3 lg:p-4">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4">
        <div>
          <h1 className="text-sm font-semibold text-gray-900">NFC Tracking</h1>
          <p className="text-[11px] text-gray-500">
            {tags.length} tags &bull; {totalScans.toLocaleString()} total scans &bull; {activeTags} active
          </p>
        </div>
        <button
          onClick={fetchTags}
          className="p-1.5 text-gray-400 hover:text-blue-500 hover:bg-blue-50 rounded-lg transition-colors"
        >
          <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin' : ''}`} />
        </button>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-lg border border-gray-100 mb-3">
        <div className="px-3 py-2 border-b border-gray-50">
          <h2 className="text-xs font-semibold text-gray-700">Filter Tags</h2>
        </div>
        <form onSubmit={handleFilter} className="p-3">
          <div className="flex flex-wrap items-end gap-2">
            <div>
              <label className="block text-[10px] font-semibold text-gray-500 uppercase mb-1">
                Client
              </label>
              <select
                value={clientFilter}
                onChange={(e) => setClientFilter(e.target.value)}
                className="px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
              >
                <option value="">All Clients</option>
                {clients.map((c) => (
                  <option key={c.client_id} value={c.company_name}>
                    {c.company_name}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <label className="block text-[10px] font-semibold text-gray-500 uppercase mb-1">
                Min Scans
              </label>
              <input
                type="number"
                value={scanCountMin}
                onChange={(e) => setScanCountMin(e.target.value)}
                placeholder="0"
                className="w-20 px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
              />
            </div>
            <div>
              <label className="block text-[10px] font-semibold text-gray-500 uppercase mb-1">
                Status
              </label>
              <select
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
                className="px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
              >
                <option value="">All</option>
                <option value="active">Active</option>
                <option value="inactive">Inactive</option>
              </select>
            </div>
            <div>
              <label className="block text-[10px] font-semibold text-gray-500 uppercase mb-1">
                Seq Number
              </label>
              <input
                type="text"
                value={seqNumFilter}
                onChange={(e) => setSeqNumFilter(e.target.value)}
                placeholder="Search..."
                className="w-24 px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
              />
            </div>
            <div className="flex-1" />
            <button
              type="submit"
              className="flex items-center gap-1.5 px-3 py-1.5 text-xs text-white bg-blue-500 hover:bg-blue-600 rounded-lg transition-colors"
            >
              <Search className="w-3.5 h-3.5" />
              Search
            </button>
          </div>
        </form>
      </div>

      {/* Tags Table */}
      <div className="bg-white rounded-lg border border-gray-100 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-gray-100 bg-gray-50/50">
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Spool ID</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Seq Number</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Client</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Product Page</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Video</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Scan Count</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Active</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-50">
              {loading ? (
                <tr>
                  <td colSpan={8} className="px-3 py-8 text-center">
                    <div className="flex items-center justify-center gap-2 text-gray-400 text-xs">
                      <Loader2 className="w-3.5 h-3.5 animate-spin" />
                      Loading...
                    </div>
                  </td>
                </tr>
              ) : tags.length === 0 ? (
                <tr>
                  <td colSpan={8} className="px-3 py-8 text-center text-xs text-gray-400">
                    No tags found
                  </td>
                </tr>
              ) : (
                tags.map((tag) => (
                  <tr key={tag.tag_id} className="hover:bg-gray-50/50">
                    <td className="px-3 py-2 text-xs font-medium text-gray-900">{tag.spool_id}</td>
                    <td className="px-3 py-2 text-xs text-gray-600">{tag.seq_num}</td>
                    <td className="px-3 py-2 text-xs text-gray-600">{tag.company_name || '-'}</td>
                    <td className="px-3 py-2 text-xs text-gray-600 max-w-[200px] truncate">
                      {tag.product_page ? (
                        <a
                          href={tag.product_page}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="text-blue-600 hover:underline"
                        >
                          {tag.product_page}
                        </a>
                      ) : (
                        <span className="text-gray-300">-</span>
                      )}
                    </td>
                    <td className="px-3 py-2 text-xs">
                      {tag.video_url ? (
                        <a
                          href={tag.video_url}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="inline-flex items-center gap-1 text-blue-600 hover:text-blue-700"
                        >
                          <ExternalLink className="w-3 h-3" />
                        </a>
                      ) : (
                        <span className="text-gray-300">-</span>
                      )}
                    </td>
                    <td className="px-3 py-2 text-xs text-gray-600">
                      <span className={tag.scan_count > 0 ? 'text-emerald-600 font-medium' : ''}>
                        {tag.scan_count?.toLocaleString() || 0}
                      </span>
                    </td>
                    <td className="px-3 py-2">
                      {tag.live ? (
                        <span className="inline-flex items-center gap-0.5 text-emerald-600 text-[10px]">
                          <Check className="w-3 h-3" /> Yes
                        </span>
                      ) : (
                        <span className="text-gray-300 text-[10px]">No</span>
                      )}
                    </td>
                    <td className="px-3 py-2">
                      <button
                        onClick={() => alert(`Edit tag ${tag.seq_num} requires write access`)}
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
        {!loading && tags.length > 0 && (
          <div className="px-3 py-2 bg-gray-50/50 border-t border-gray-100 text-[10px] text-gray-500">
            Showing {tags.length} tags
          </div>
        )}
      </div>
    </div>
  );
}
