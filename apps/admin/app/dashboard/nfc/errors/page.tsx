/**
 * NFC Errors Page
 * View and manage NFC error logs
 * Last Modified: January 2026
 */

'use client';

import { useEffect, useState } from 'react';
import {
  RefreshCw,
  Archive,
  Loader2,
  AlertTriangle,
  Check,
  X,
} from 'lucide-react';

interface NfcError {
  log_id: number;
  client_app: string;
  serial_no: string;
  nfc_url: string;
  seq_num: number;
  our_domain: number;
  double_https: number;
  active: number;
  message: string;
  create_dt: string;
  archived: number;
}

export default function NfcErrorsPage() {
  const [errors, setErrors] = useState<NfcError[]>([]);
  const [loading, setLoading] = useState(true);
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [showArchived, setShowArchived] = useState(false);

  useEffect(() => {
    fetchErrors();
  }, []);

  const fetchErrors = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (startDate) params.set('start_date', startDate);
      if (endDate) params.set('end_date', endDate);
      if (showArchived) params.set('archived', '1');

      const res = await fetch(`/api/nfc/errors?${params.toString()}`);
      const data = await res.json();
      if (data.success) {
        setErrors(data.data);
      }
    } catch (error) {
      console.error('Error fetching errors:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleFilter = (e: React.FormEvent) => {
    e.preventDefault();
    fetchErrors();
  };

  const formatDate = (dateStr: string) => {
    return new Date(dateStr).toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  };

  const handleArchive = (logId: number) => {
    alert(`Archive error ${logId} requires write access`);
  };

  const activeErrors = errors.filter((e) => !e.archived).length;

  return (
    <div className="p-3 lg:p-4">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4">
        <div>
          <h1 className="text-sm font-semibold text-gray-900">NFC Error Logs</h1>
          <p className="text-[11px] text-gray-500">
            {errors.length} errors &bull; {activeErrors} active
          </p>
        </div>
        <button
          onClick={fetchErrors}
          className="p-1.5 text-gray-400 hover:text-blue-500 hover:bg-blue-50 rounded-lg transition-colors"
        >
          <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin' : ''}`} />
        </button>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-lg border border-gray-100 mb-3">
        <div className="px-3 py-2 border-b border-gray-50">
          <h2 className="text-xs font-semibold text-gray-700">Filter Errors</h2>
        </div>
        <form onSubmit={handleFilter} className="p-3">
          <div className="flex flex-wrap items-end gap-2">
            <div>
              <label className="block text-[10px] font-semibold text-gray-500 uppercase mb-1">
                Start Date
              </label>
              <input
                type="date"
                value={startDate}
                onChange={(e) => setStartDate(e.target.value)}
                className="px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
              />
            </div>
            <div>
              <label className="block text-[10px] font-semibold text-gray-500 uppercase mb-1">
                End Date
              </label>
              <input
                type="date"
                value={endDate}
                onChange={(e) => setEndDate(e.target.value)}
                className="px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
              />
            </div>
            <label className="flex items-center gap-1.5 text-xs text-gray-600 cursor-pointer">
              <input
                type="checkbox"
                checked={showArchived}
                onChange={(e) => setShowArchived(e.target.checked)}
                className="w-3.5 h-3.5 text-blue-600 border-gray-300 rounded focus:ring-blue-500"
              />
              Show Archived
            </label>
            <div className="flex-1" />
            <button
              type="submit"
              className="px-3 py-1.5 text-xs text-white bg-blue-500 hover:bg-blue-600 rounded-lg transition-colors"
            >
              Apply Filter
            </button>
          </div>
        </form>
      </div>

      {/* Errors Table */}
      <div className="bg-white rounded-lg border border-gray-100 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-gray-100 bg-gray-50/50">
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">ID</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Client App</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Serial</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">NFC URL</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Seq #</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Our Domain</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">2x HTTPS</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Active</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Message</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Created</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Action</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-50">
              {loading ? (
                <tr>
                  <td colSpan={11} className="px-3 py-8 text-center">
                    <div className="flex items-center justify-center gap-2 text-gray-400 text-xs">
                      <Loader2 className="w-3.5 h-3.5 animate-spin" />
                      Loading...
                    </div>
                  </td>
                </tr>
              ) : errors.length === 0 ? (
                <tr>
                  <td colSpan={11} className="px-3 py-8 text-center text-xs text-gray-400">
                    No errors found
                  </td>
                </tr>
              ) : (
                errors.map((err) => (
                  <tr
                    key={err.log_id}
                    className={`hover:bg-gray-50/50 ${err.archived ? 'opacity-50' : ''}`}
                  >
                    <td className="px-3 py-2 text-xs font-medium text-gray-900">{err.log_id}</td>
                    <td className="px-3 py-2 text-xs text-gray-600">{err.client_app || '-'}</td>
                    <td className="px-3 py-2 text-[10px] text-gray-500 font-mono">{err.serial_no || '-'}</td>
                    <td className="px-3 py-2 text-xs text-gray-600 max-w-[150px] truncate">{err.nfc_url || '-'}</td>
                    <td className="px-3 py-2 text-xs text-gray-600">{err.seq_num || '-'}</td>
                    <td className="px-3 py-2">
                      {err.our_domain ? (
                        <Check className="w-3 h-3 text-emerald-500" />
                      ) : (
                        <X className="w-3 h-3 text-gray-300" />
                      )}
                    </td>
                    <td className="px-3 py-2">
                      {err.double_https ? (
                        <AlertTriangle className="w-3 h-3 text-amber-500" />
                      ) : (
                        <span className="text-gray-300">-</span>
                      )}
                    </td>
                    <td className="px-3 py-2">
                      {err.active ? (
                        <span className="text-emerald-600 text-[10px]">Yes</span>
                      ) : (
                        <span className="text-gray-300 text-[10px]">No</span>
                      )}
                    </td>
                    <td className="px-3 py-2 text-[10px] text-gray-500 max-w-[120px] truncate">
                      {err.message || '-'}
                    </td>
                    <td className="px-3 py-2 text-[10px] text-gray-500">{formatDate(err.create_dt)}</td>
                    <td className="px-3 py-2">
                      {!err.archived && (
                        <button
                          onClick={() => handleArchive(err.log_id)}
                          className="p-1 text-gray-400 hover:text-blue-500 hover:bg-blue-50 rounded transition-colors"
                          title="Archive"
                        >
                          <Archive className="w-3.5 h-3.5" />
                        </button>
                      )}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
        {!loading && errors.length > 0 && (
          <div className="px-3 py-2 bg-gray-50/50 border-t border-gray-100 text-[10px] text-gray-500">
            Showing {errors.length} errors
          </div>
        )}
      </div>
    </div>
  );
}
