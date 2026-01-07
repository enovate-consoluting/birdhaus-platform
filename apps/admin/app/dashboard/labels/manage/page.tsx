/**
 * Labels Manage Page
 * Manage label password details from Legacy MySQL
 * Last Modified: January 2026
 */

'use client';

import { useEffect, useState } from 'react';
import {
  Tag,
  Search,
  RefreshCw,
  Edit,
  Trash2,
  GitBranch,
  ExternalLink,
  Check,
  X,
  Loader2,
} from 'lucide-react';

interface LabelPassDetail {
  label_pass_detail_id: number;
  client_id: number;
  create_dt: string;
  video_url: string;
  verify_once: string;
  verify_once_msg: string;
  label_validation_msg: string;
  label_note: string;
  exclude_from_stats: number;
  company_name: string;
}

export default function LabelsManagePage() {
  const [details, setDetails] = useState<LabelPassDetail[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [editingId, setEditingId] = useState<number | null>(null);

  useEffect(() => {
    fetchDetails();
  }, []);

  const fetchDetails = async () => {
    setLoading(true);
    try {
      const res = await fetch('/api/labels/details');
      const data = await res.json();
      if (data.success) {
        setDetails(data.data);
      }
    } catch (error) {
      console.error('Error fetching details:', error);
    } finally {
      setLoading(false);
    }
  };

  const formatDate = (dateStr: string) => {
    const date = new Date(dateStr);
    return date.toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
    });
  };

  const formatVideoUrl = (url: string) => {
    if (!url) return '';
    if (url && !url.startsWith('http') && !url.startsWith('https://imagedelivery.net/')) {
      return `https://scanacart.com/labels/videos/${url}`;
    }
    return url;
  };

  const filteredDetails = details.filter(
    (detail) =>
      detail.company_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      detail.label_note?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      detail.label_pass_detail_id.toString().includes(searchTerm)
  );

  return (
    <div className="p-3 lg:p-4">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4">
        <div>
          <h1 className="text-sm font-semibold text-gray-900">Manage Labels</h1>
          <p className="text-[11px] text-gray-500">{details.length} label details</p>
        </div>
        <div className="flex items-center gap-2">
          <div className="relative">
            <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-gray-400" />
            <input
              type="text"
              placeholder="Search..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="pl-8 pr-3 py-1.5 w-full sm:w-48 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
            />
          </div>
          <button
            onClick={fetchDetails}
            className="p-1.5 text-gray-400 hover:text-blue-500 hover:bg-blue-50 rounded-lg transition-colors"
          >
            <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin' : ''}`} />
          </button>
        </div>
      </div>

      {/* Table */}
      <div className="bg-white rounded-lg border border-gray-100 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-gray-100 bg-gray-50/50">
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">ID</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Client</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Note</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Entered</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Video</th>
                <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Verify Once</th>
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
              ) : filteredDetails.length === 0 ? (
                <tr>
                  <td colSpan={7} className="px-3 py-8 text-center text-xs text-gray-400">
                    {searchTerm ? 'No matching labels' : 'No label details found'}
                  </td>
                </tr>
              ) : (
                filteredDetails.map((detail) => (
                  <tr key={detail.label_pass_detail_id} className="hover:bg-gray-50/50">
                    <td className="px-3 py-2 text-xs text-gray-600">{detail.label_pass_detail_id}</td>
                    <td className="px-3 py-2 text-xs font-medium text-gray-900">{detail.company_name}</td>
                    <td className="px-3 py-2 text-xs text-gray-500 max-w-[150px] truncate">
                      {detail.label_note || '-'}
                    </td>
                    <td className="px-3 py-2 text-[11px] text-gray-500">{formatDate(detail.create_dt)}</td>
                    <td className="px-3 py-2 text-xs">
                      {detail.video_url ? (
                        <a
                          href={formatVideoUrl(detail.video_url)}
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
                      {detail.verify_once === 'Y' ? (
                        <span className="inline-flex items-center gap-0.5 text-emerald-600 text-[10px]">
                          <Check className="w-3 h-3" /> Yes
                        </span>
                      ) : (
                        <span className="text-gray-300 text-[10px]">No</span>
                      )}
                    </td>
                    <td className="px-3 py-2">
                      <div className="flex items-center gap-0.5">
                        <button
                          onClick={() => setEditingId(detail.label_pass_detail_id)}
                          className="p-1 text-gray-400 hover:text-blue-500 hover:bg-blue-50 rounded transition-colors"
                          title="Edit"
                        >
                          <Edit className="w-3 h-3" />
                        </button>
                        <button
                          onClick={() => alert(`Associate label ${detail.label_pass_detail_id}`)}
                          className="p-1 text-gray-400 hover:text-amber-500 hover:bg-amber-50 rounded transition-colors"
                          title="Associate"
                        >
                          <GitBranch className="w-3 h-3" />
                        </button>
                        <button
                          onClick={() => {
                            if (confirm('Delete this label detail?')) {
                              alert('Delete requires write access');
                            }
                          }}
                          className="p-1 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded transition-colors"
                          title="Delete"
                        >
                          <Trash2 className="w-3 h-3" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
        {!loading && filteredDetails.length > 0 && (
          <div className="px-3 py-2 bg-gray-50/50 border-t border-gray-100 text-[10px] text-gray-500">
            Showing {filteredDetails.length} of {details.length}
          </div>
        )}
      </div>

      {/* Edit Modal */}
      {editingId && (
        <EditLabelModal
          labelPassDetailId={editingId}
          onClose={() => setEditingId(null)}
        />
      )}
    </div>
  );
}

function EditLabelModal({
  labelPassDetailId,
  onClose,
}: {
  labelPassDetailId: number;
  onClose: () => void;
}) {
  const [detail, setDetail] = useState<LabelPassDetail | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchDetail = async () => {
      try {
        const res = await fetch(`/api/labels/details?id=${labelPassDetailId}`);
        const data = await res.json();
        if (data.success && data.data.length > 0) {
          setDetail(data.data[0]);
        }
      } catch (error) {
        console.error('Error fetching detail:', error);
      } finally {
        setLoading(false);
      }
    };
    fetchDetail();
  }, [labelPassDetailId]);

  return (
    <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg shadow-lg w-full max-w-lg max-h-[85vh] overflow-y-auto">
        <div className="flex items-center justify-between px-4 py-3 border-b border-gray-100">
          <h2 className="text-sm font-semibold text-gray-900">Edit Label #{labelPassDetailId}</h2>
          <button onClick={onClose} className="p-1 text-gray-400 hover:text-gray-600 rounded">
            <X className="w-4 h-4" />
          </button>
        </div>

        {loading ? (
          <div className="p-8 flex items-center justify-center">
            <Loader2 className="w-4 h-4 animate-spin text-blue-500" />
          </div>
        ) : detail ? (
          <div className="p-4 space-y-3">
            <div className="grid grid-cols-2 gap-3">
              <div>
                <label className="block text-[10px] font-medium text-gray-500 uppercase mb-1">Client</label>
                <input
                  type="text"
                  value={detail.company_name}
                  disabled
                  className="w-full px-2.5 py-1.5 text-xs bg-gray-50 border border-gray-200 rounded-lg text-gray-500"
                />
              </div>
              <div>
                <label className="block text-[10px] font-medium text-gray-500 uppercase mb-1">Verify Once</label>
                <select
                  value={detail.verify_once}
                  onChange={(e) => setDetail({ ...detail, verify_once: e.target.value })}
                  className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
                >
                  <option value="N">No</option>
                  <option value="Y">Yes</option>
                </select>
              </div>
            </div>

            <div>
              <label className="block text-[10px] font-medium text-gray-500 uppercase mb-1">Note</label>
              <input
                type="text"
                value={detail.label_note || ''}
                onChange={(e) => setDetail({ ...detail, label_note: e.target.value })}
                className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
                placeholder="Internal note"
              />
            </div>

            <div>
              <label className="block text-[10px] font-medium text-gray-500 uppercase mb-1">Video URL</label>
              <input
                type="text"
                value={detail.video_url || ''}
                onChange={(e) => setDetail({ ...detail, video_url: e.target.value })}
                className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
                placeholder="Video URL"
              />
            </div>

            <div>
              <label className="block text-[10px] font-medium text-gray-500 uppercase mb-1">Verify Once Message</label>
              <textarea
                value={detail.verify_once_msg || ''}
                onChange={(e) => setDetail({ ...detail, verify_once_msg: e.target.value })}
                className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500 resize-none"
                rows={2}
              />
            </div>

            <div>
              <label className="block text-[10px] font-medium text-gray-500 uppercase mb-1">Validation Message</label>
              <textarea
                value={detail.label_validation_msg || ''}
                onChange={(e) => setDetail({ ...detail, label_validation_msg: e.target.value })}
                className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500 resize-none"
                rows={2}
              />
            </div>

            <label className="flex items-center gap-2 cursor-pointer">
              <input
                type="checkbox"
                checked={detail.exclude_from_stats === 1}
                onChange={(e) => setDetail({ ...detail, exclude_from_stats: e.target.checked ? 1 : 0 })}
                className="w-3.5 h-3.5 text-blue-600 border-gray-300 rounded focus:ring-blue-500"
              />
              <span className="text-xs text-gray-600">Exclude from statistics</span>
            </label>

            <div className="flex justify-end gap-2 pt-3 border-t border-gray-100">
              <button
                onClick={onClose}
                className="px-3 py-1.5 text-xs text-gray-600 hover:bg-gray-100 rounded-lg transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={() => alert('Save requires write access')}
                className="px-3 py-1.5 text-xs text-white bg-blue-500 hover:bg-blue-600 rounded-lg transition-colors"
              >
                Save
              </button>
            </div>
          </div>
        ) : (
          <div className="p-8 text-center text-xs text-gray-400">Not found</div>
        )}
      </div>
    </div>
  );
}
