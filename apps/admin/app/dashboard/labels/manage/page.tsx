/**
 * Labels Manage Page
 * Manage label password details from Legacy MySQL
 * Last Modified: January 2026
 */

'use client';

import { useEffect, useState } from 'react';
import {
  Tags,
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
      hour: 'numeric',
      minute: '2-digit',
    });
  };

  const formatVideoUrl = (url: string) => {
    if (!url) return '-';
    // Check if it's a relative URL that needs prefix
    if (url && !url.startsWith('http') && !url.startsWith('https://imagedelivery.net/')) {
      return `https://scanacart.com/labels/videos/${url}`;
    }
    return url;
  };

  // Filter details based on search term
  const filteredDetails = details.filter(
    (detail) =>
      detail.company_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      detail.label_note?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      detail.label_pass_detail_id.toString().includes(searchTerm)
  );

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="p-2 bg-violet-100 rounded-lg">
            <Tags className="h-6 w-6 text-violet-600" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Manage Labels</h1>
            <p className="text-gray-500">View and edit label password details</p>
          </div>
        </div>
        <button
          onClick={fetchDetails}
          className="flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
        >
          <RefreshCw className={`h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
          Refresh
        </button>
      </div>

      {/* Search Bar */}
      <div className="bg-white rounded-xl border border-gray-200 p-4">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
          <input
            type="text"
            placeholder="Search by client, note, or detail ID..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pl-10 pr-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500 focus:border-transparent"
          />
        </div>
      </div>

      {/* Data Table */}
      <div className="bg-white rounded-xl border border-gray-200 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Detail ID
                </th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Client
                </th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Note
                </th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Entered
                </th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Video URL
                </th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Verify Once
                </th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {loading ? (
                <tr>
                  <td colSpan={7} className="px-4 py-12 text-center">
                    <div className="flex items-center justify-center gap-2 text-gray-500">
                      <Loader2 className="h-5 w-5 animate-spin" />
                      Loading label details...
                    </div>
                  </td>
                </tr>
              ) : filteredDetails.length === 0 ? (
                <tr>
                  <td colSpan={7} className="px-4 py-12 text-center text-gray-500">
                    {searchTerm ? 'No matching labels found' : 'No label details found'}
                  </td>
                </tr>
              ) : (
                filteredDetails.map((detail) => (
                  <tr key={detail.label_pass_detail_id} className="hover:bg-gray-50">
                    <td className="px-4 py-3 text-sm font-medium text-gray-900">
                      {detail.label_pass_detail_id}
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-700">
                      {detail.company_name}
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-600 max-w-xs truncate">
                      {detail.label_note || '-'}
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-600 whitespace-nowrap">
                      {formatDate(detail.create_dt)}
                    </td>
                    <td className="px-4 py-3 text-sm text-gray-600">
                      {detail.video_url ? (
                        <a
                          href={formatVideoUrl(detail.video_url)}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="inline-flex items-center gap-1 text-blue-600 hover:text-blue-800 hover:underline max-w-[200px] truncate"
                        >
                          <ExternalLink className="h-3 w-3 flex-shrink-0" />
                          <span className="truncate">{detail.video_url}</span>
                        </a>
                      ) : (
                        <span className="text-gray-400">-</span>
                      )}
                    </td>
                    <td className="px-4 py-3 text-sm">
                      {detail.verify_once === 'Y' ? (
                        <span className="inline-flex items-center gap-1 text-green-600">
                          <Check className="h-4 w-4" />
                          Yes
                        </span>
                      ) : (
                        <span className="inline-flex items-center gap-1 text-gray-400">
                          <X className="h-4 w-4" />
                          No
                        </span>
                      )}
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-1">
                        <button
                          onClick={() => setEditingId(detail.label_pass_detail_id)}
                          className="p-2 text-gray-500 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                          title="Edit Detail"
                        >
                          <Edit className="h-4 w-4" />
                        </button>
                        <button
                          onClick={() => {
                            // TODO: Navigate to test results association
                            alert(`Associate label ${detail.label_pass_detail_id} with test results`);
                          }}
                          className="p-2 text-gray-500 hover:text-orange-600 hover:bg-orange-50 rounded-lg transition-colors"
                          title="Associate with Test Results"
                        >
                          <GitBranch className="h-4 w-4" />
                        </button>
                        <button
                          onClick={() => {
                            if (confirm(`Are you sure you want to delete label detail ${detail.label_pass_detail_id}?`)) {
                              // TODO: Implement delete (read-only for now)
                              alert('Delete functionality requires write access');
                            }
                          }}
                          className="p-2 text-gray-500 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                          title="Delete"
                        >
                          <Trash2 className="h-4 w-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>

        {/* Footer with count */}
        {!loading && filteredDetails.length > 0 && (
          <div className="px-4 py-3 bg-gray-50 border-t border-gray-200 text-sm text-gray-600">
            Showing {filteredDetails.length} of {details.length} label details
          </div>
        )}
      </div>

      {/* Edit Modal */}
      {editingId && (
        <EditLabelModal
          labelPassDetailId={editingId}
          onClose={() => setEditingId(null)}
          onSave={() => {
            setEditingId(null);
            fetchDetails();
          }}
        />
      )}
    </div>
  );
}

// Edit Modal Component
function EditLabelModal({
  labelPassDetailId,
  onClose,
  onSave,
}: {
  labelPassDetailId: number;
  onClose: () => void;
  onSave: () => void;
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
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
      <div className="bg-white rounded-xl shadow-xl w-full max-w-2xl mx-4 max-h-[90vh] overflow-y-auto">
        <div className="flex items-center justify-between p-4 border-b border-gray-200">
          <h2 className="text-lg font-semibold text-gray-900">
            Edit Label Detail #{labelPassDetailId}
          </h2>
          <button
            onClick={onClose}
            className="p-1 text-gray-400 hover:text-gray-600 rounded"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        {loading ? (
          <div className="p-8 flex items-center justify-center">
            <Loader2 className="h-6 w-6 animate-spin text-violet-600" />
          </div>
        ) : detail ? (
          <div className="p-4 space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Client
                </label>
                <input
                  type="text"
                  value={detail.company_name}
                  disabled
                  className="w-full px-3 py-2 bg-gray-100 border border-gray-200 rounded-lg text-gray-600"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Verify Once
                </label>
                <select
                  value={detail.verify_once}
                  onChange={(e) => setDetail({ ...detail, verify_once: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500"
                >
                  <option value="N">No</option>
                  <option value="Y">Yes</option>
                </select>
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Note
              </label>
              <input
                type="text"
                value={detail.label_note || ''}
                onChange={(e) => setDetail({ ...detail, label_note: e.target.value })}
                className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500"
                placeholder="Enter label note"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Video URL
              </label>
              <input
                type="text"
                value={detail.video_url || ''}
                onChange={(e) => setDetail({ ...detail, video_url: e.target.value })}
                className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500"
                placeholder="Enter video URL"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Verify Once Message
              </label>
              <textarea
                value={detail.verify_once_msg || ''}
                onChange={(e) => setDetail({ ...detail, verify_once_msg: e.target.value })}
                className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500"
                rows={2}
                placeholder="Message shown when verify once is triggered"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Label Validation Message
              </label>
              <textarea
                value={detail.label_validation_msg || ''}
                onChange={(e) => setDetail({ ...detail, label_validation_msg: e.target.value })}
                className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500"
                rows={2}
                placeholder="Custom validation message"
              />
            </div>

            <div className="flex items-center gap-2">
              <input
                type="checkbox"
                id="excludeStats"
                checked={detail.exclude_from_stats === 1}
                onChange={(e) =>
                  setDetail({ ...detail, exclude_from_stats: e.target.checked ? 1 : 0 })
                }
                className="w-4 h-4 text-violet-600 border-gray-300 rounded focus:ring-violet-500"
              />
              <label htmlFor="excludeStats" className="text-sm text-gray-700">
                Exclude from statistics
              </label>
            </div>

            <div className="flex justify-end gap-3 pt-4 border-t border-gray-200">
              <button
                onClick={onClose}
                className="px-4 py-2 text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={() => {
                  // TODO: Implement save (read-only for now)
                  alert('Save functionality requires write access to the database');
                }}
                className="px-4 py-2 text-white bg-violet-600 hover:bg-violet-700 rounded-lg transition-colors"
              >
                Save Changes
              </button>
            </div>
          </div>
        ) : (
          <div className="p-8 text-center text-gray-500">
            Label detail not found
          </div>
        )}
      </div>
    </div>
  );
}
