/**
 * NFC Generate Page
 * Generate NFC tags, view generation batches
 * Last Modified: January 2026
 */

'use client';

import { useEffect, useState } from 'react';
import {
  Plus,
  RefreshCw,
  FileSpreadsheet,
  Upload,
  Trash2,
  Loader2,
  ExternalLink,
} from 'lucide-react';

interface NfcGeneration {
  nfc_gen_id: number;
  first_spool_id: number;
  last_spool_id: number;
  client_id: number;
  num_tags: number;
  create_dt: string;
  spreadsheet_name: string;
  nfcs_per_spool: number;
  note: string;
  company_name: string;
  video_url?: string;
}

export default function NfcGeneratePage() {
  const [generations, setGenerations] = useState<NfcGeneration[]>([]);
  const [loading, setLoading] = useState(true);
  const [selected, setSelected] = useState<number[]>([]);

  useEffect(() => {
    fetchGenerations();
  }, []);

  const fetchGenerations = async () => {
    setLoading(true);
    try {
      const res = await fetch('/api/nfc/generations');
      const data = await res.json();
      if (data.success) {
        setGenerations(data.data);
      }
    } catch (error) {
      console.error('Error fetching generations:', error);
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

  const toggleSelect = (id: number) => {
    setSelected((prev) =>
      prev.includes(id) ? prev.filter((i) => i !== id) : [...prev, id]
    );
  };

  return (
    <div className="p-3 lg:p-4">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4">
        <div>
          <h1 className="text-sm font-semibold text-gray-900">Generate NFCs</h1>
          <p className="text-[11px] text-gray-500">{generations.length} generation batches</p>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => alert('Add New requires write access')}
            className="flex items-center gap-1.5 px-3 py-1.5 text-xs text-white bg-blue-500 hover:bg-blue-600 rounded-lg transition-colors"
          >
            <Plus className="w-3.5 h-3.5" />
            Add New
          </button>
          <button
            onClick={() => alert('Import Serial Numbers requires write access')}
            className="flex items-center gap-1.5 px-3 py-1.5 text-xs text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors"
          >
            <Upload className="w-3.5 h-3.5" />
            Import
          </button>
          <button
            onClick={() => {
              if (selected.length === 0) {
                alert('Select at least one batch');
                return;
              }
              alert('Delete Tags requires write access');
            }}
            className="flex items-center gap-1.5 px-3 py-1.5 text-xs text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors"
          >
            <Trash2 className="w-3.5 h-3.5" />
            Delete
          </button>
          <button
            onClick={fetchGenerations}
            className="p-1.5 text-gray-400 hover:text-blue-500 hover:bg-blue-50 rounded-lg transition-colors"
          >
            <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin' : ''}`} />
          </button>
        </div>
      </div>

      {/* Generation List */}
      <div className="bg-white rounded-lg border border-gray-100 overflow-hidden">
        <div className="px-3 py-2 border-b border-gray-50">
          <h2 className="text-xs font-semibold text-gray-700">NFC Generation List</h2>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-gray-100 bg-gray-50/50">
                <th className="px-3 py-2 text-left w-8"></th>
                <th className="px-3 py-2 text-left w-8"></th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Client</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Spool Number(s)</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase"># NFCs</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Note</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Video URL</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Created</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-50">
              {loading ? (
                <tr>
                  <td colSpan={9} className="px-3 py-8 text-center">
                    <div className="flex items-center justify-center gap-2 text-gray-400 text-xs">
                      <Loader2 className="w-3.5 h-3.5 animate-spin" />
                      Loading...
                    </div>
                  </td>
                </tr>
              ) : generations.length === 0 ? (
                <tr>
                  <td colSpan={9} className="px-3 py-8 text-center text-xs text-gray-400">
                    No NFC generations found
                  </td>
                </tr>
              ) : (
                generations.map((gen) => (
                  <tr key={gen.nfc_gen_id} className="hover:bg-gray-50/50">
                    <td className="px-3 py-2">
                      <input
                        type="checkbox"
                        checked={selected.includes(gen.nfc_gen_id)}
                        onChange={() => toggleSelect(gen.nfc_gen_id)}
                        className="w-3.5 h-3.5 text-blue-600 border-gray-300 rounded focus:ring-blue-500"
                      />
                    </td>
                    <td className="px-3 py-2">
                      {gen.spreadsheet_name && (
                        <button
                          onClick={() => alert('Download spreadsheet')}
                          className="text-emerald-600 hover:text-emerald-700"
                          title="Download spreadsheet"
                        >
                          <FileSpreadsheet className="w-4 h-4" />
                        </button>
                      )}
                    </td>
                    <td className="px-3 py-2 text-xs font-medium text-gray-900">
                      {gen.company_name || '-'}
                    </td>
                    <td className="px-3 py-2 text-xs text-gray-600">
                      {gen.first_spool_id === gen.last_spool_id
                        ? `${gen.first_spool_id} (${gen.nfcs_per_spool}/spool)`
                        : `${gen.first_spool_id} - ${gen.last_spool_id} (${gen.nfcs_per_spool}/spool)`}
                    </td>
                    <td className="px-3 py-2 text-xs text-gray-600">
                      {gen.num_tags?.toLocaleString()}
                    </td>
                    <td className="px-3 py-2 text-xs text-gray-500 max-w-[120px] truncate">
                      {gen.note || '-'}
                    </td>
                    <td className="px-3 py-2 text-xs">
                      {gen.video_url ? (
                        <a
                          href={gen.video_url}
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
                    <td className="px-3 py-2 text-[11px] text-gray-500">
                      {formatDate(gen.create_dt)}
                    </td>
                    <td className="px-3 py-2">
                      <button
                        onClick={() => alert(`View sequence numbers for batch ${gen.nfc_gen_id}`)}
                        className="px-2 py-1 text-[10px] text-blue-600 hover:bg-blue-50 rounded transition-colors"
                      >
                        View Seq
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
        {!loading && generations.length > 0 && (
          <div className="px-3 py-2 bg-gray-50/50 border-t border-gray-100 text-[10px] text-gray-500">
            {selected.length > 0 ? `${selected.length} selected` : `${generations.length} batches`}
          </div>
        )}
      </div>
    </div>
  );
}
