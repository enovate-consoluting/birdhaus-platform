/**
 * NFC Manage Page
 * Find and manage individual NFC tags
 * Last Modified: January 2026
 */

'use client';

import { useState } from 'react';
import {
  Search,
  ArrowRight,
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
}

export default function NfcManagePage() {
  const [searchUrl, setSearchUrl] = useState('');
  const [searching, setSearching] = useState(false);
  const [tag, setTag] = useState<NfcTag | null>(null);
  const [searched, setSearched] = useState(false);

  const [tagFrom, setTagFrom] = useState('');
  const [tagTo, setTagTo] = useState('');
  const [redirectUrl, setRedirectUrl] = useState('');

  const handleSearch = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!searchUrl.trim()) return;

    setSearching(true);
    setSearched(true);
    setTag(null);

    try {
      const seqMatch = searchUrl.match(/\d+/);
      if (seqMatch) {
        const res = await fetch(`/api/nfc/tag?seq_num=${seqMatch[0]}`);
        const data = await res.json();
        if (data.success && data.data) {
          setTag(data.data);
        }
      }
    } catch (error) {
      console.error('Error searching:', error);
    } finally {
      setSearching(false);
    }
  };

  const handleBatchRedirect = (e: React.FormEvent) => {
    e.preventDefault();
    if (!tagFrom || !tagTo || !redirectUrl) {
      alert('Please fill all fields');
      return;
    }
    alert(`Set redirect for tags ${tagFrom}-${tagTo} to ${redirectUrl}\n\nRequires write access.`);
  };

  return (
    <div className="p-3 lg:p-4">
      {/* Header */}
      <div className="mb-4">
        <h1 className="text-sm font-semibold text-gray-900">Manage NFC Tags</h1>
        <p className="text-[11px] text-gray-500">Find and edit individual NFC tags</p>
      </div>

      {/* Find NFC */}
      <div className="bg-white rounded-lg border border-gray-100 mb-3">
        <div className="px-3 py-2 border-b border-gray-50">
          <h2 className="text-xs font-semibold text-gray-700">Find NFC</h2>
        </div>
        <div className="p-3">
          <form onSubmit={handleSearch} className="flex gap-2">
            <div className="relative flex-1">
              <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-gray-400" />
              <input
                type="text"
                value={searchUrl}
                onChange={(e) => setSearchUrl(e.target.value)}
                placeholder="Enter NFC URL or sequence number"
                className="w-full pl-8 pr-3 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
              />
            </div>
            <button
              type="submit"
              disabled={searching}
              className="flex items-center gap-1.5 px-3 py-1.5 text-xs text-white bg-blue-500 hover:bg-blue-600 disabled:opacity-50 rounded-lg transition-colors"
            >
              {searching ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <Search className="w-3.5 h-3.5" />}
            </button>
          </form>
        </div>

        {searched && (
          <div className="border-t border-gray-100">
            {tag ? (
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="border-b border-gray-100 bg-gray-50/50">
                      <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Tag Num</th>
                      <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Client</th>
                      <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">URL</th>
                      <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Video URL</th>
                      <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Active</th>
                      <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Edit</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr className="hover:bg-gray-50/50">
                      <td className="px-3 py-2 text-xs font-medium text-gray-900">{tag.seq_num}</td>
                      <td className="px-3 py-2 text-xs text-gray-600">{tag.company_name}</td>
                      <td className="px-3 py-2 text-xs text-gray-600 max-w-[200px] truncate">
                        {tag.product_page ? (
                          <a href={tag.product_page} target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:underline">
                            {tag.product_page}
                          </a>
                        ) : (
                          <span className="text-gray-400">Not Assigned</span>
                        )}
                      </td>
                      <td className="px-3 py-2 text-xs">
                        {tag.video_url ? (
                          <a href={tag.video_url} target="_blank" rel="noopener noreferrer" className="inline-flex items-center gap-1 text-blue-600">
                            <ExternalLink className="w-3 h-3" />
                          </a>
                        ) : (
                          <span className="text-gray-300">-</span>
                        )}
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
                          onClick={() => alert('Edit requires write access')}
                          className="p-1 text-gray-400 hover:text-blue-500 hover:bg-blue-50 rounded transition-colors"
                        >
                          <Edit className="w-3.5 h-3.5" />
                        </button>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            ) : (
              <div className="p-4 text-center text-xs text-gray-400">
                No tag found for &quot;{searchUrl}&quot;
              </div>
            )}
          </div>
        )}
      </div>

      {/* Batch URL Redirect */}
      <div className="bg-white rounded-lg border border-gray-100">
        <div className="px-3 py-2 border-b border-gray-50">
          <h2 className="text-xs font-semibold text-gray-700">Set NFC URL Redirect</h2>
        </div>
        <div className="p-3">
          <form onSubmit={handleBatchRedirect} className="flex flex-wrap items-center gap-2">
            <input
              type="text"
              placeholder="Tag Number From"
              value={tagFrom}
              onChange={(e) => setTagFrom(e.target.value)}
              className="w-32 px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
            />
            <input
              type="text"
              placeholder="Tag Number To"
              value={tagTo}
              onChange={(e) => setTagTo(e.target.value)}
              className="w-32 px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
            />
            <input
              type="text"
              placeholder="Redirect To URL"
              value={redirectUrl}
              onChange={(e) => setRedirectUrl(e.target.value)}
              className="flex-1 min-w-[200px] px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
            />
            <div className="flex-1" />
            <button
              type="submit"
              className="flex items-center gap-1.5 px-3 py-1.5 text-xs text-white bg-blue-500 hover:bg-blue-600 rounded-lg transition-colors"
            >
              <ArrowRight className="w-3.5 h-3.5" />
              Proceed
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}
