/**
 * NFC Demo Page
 * Configure demo NFC tags
 * Last Modified: January 2026
 */

'use client';

import { useState } from 'react';
import {
  Save,
  Upload,
  ExternalLink,
  Loader2,
} from 'lucide-react';

export default function NfcDemoPage() {
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({
    nfcUrl: '',
    companyName: '',
    websiteUrl: '',
    videoUrl: '',
    logoFile: null as File | null,
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    // Simulate save - requires write access
    setTimeout(() => {
      setLoading(false);
      alert('Demo tag setup requires write access');
    }, 500);
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      setFormData({ ...formData, logoFile: file });
    }
  };

  return (
    <div className="p-3 lg:p-4">
      {/* Header */}
      <div className="mb-4">
        <h1 className="text-sm font-semibold text-gray-900">Demo NFC Setup</h1>
        <p className="text-[11px] text-gray-500">Configure demo tags for client presentations</p>
      </div>

      {/* Demo Form */}
      <div className="bg-white rounded-lg border border-gray-100">
        <div className="px-3 py-2 border-b border-gray-50">
          <h2 className="text-xs font-semibold text-gray-700">Demo Tag Configuration</h2>
        </div>
        <form onSubmit={handleSubmit} className="p-3 space-y-3">
          {/* NFC URL */}
          <div>
            <label className="block text-[10px] font-semibold text-gray-500 uppercase mb-1">
              NFC URL
            </label>
            <input
              type="text"
              value={formData.nfcUrl}
              onChange={(e) => setFormData({ ...formData, nfcUrl: e.target.value })}
              placeholder="https://nfc.scanacart.com/..."
              className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
            />
          </div>

          {/* Company Name */}
          <div>
            <label className="block text-[10px] font-semibold text-gray-500 uppercase mb-1">
              Company Name
            </label>
            <input
              type="text"
              value={formData.companyName}
              onChange={(e) => setFormData({ ...formData, companyName: e.target.value })}
              placeholder="Enter company name"
              className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
            />
          </div>

          {/* Website URL */}
          <div>
            <label className="block text-[10px] font-semibold text-gray-500 uppercase mb-1">
              Website URL
            </label>
            <input
              type="text"
              value={formData.websiteUrl}
              onChange={(e) => setFormData({ ...formData, websiteUrl: e.target.value })}
              placeholder="https://example.com"
              className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
            />
          </div>

          {/* Video URL */}
          <div>
            <label className="block text-[10px] font-semibold text-gray-500 uppercase mb-1">
              Video URL
            </label>
            <input
              type="text"
              value={formData.videoUrl}
              onChange={(e) => setFormData({ ...formData, videoUrl: e.target.value })}
              placeholder="https://youtube.com/..."
              className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
            />
          </div>

          {/* Logo Upload */}
          <div>
            <label className="block text-[10px] font-semibold text-gray-500 uppercase mb-1">
              Company Logo
            </label>
            <div className="flex items-center gap-2">
              <label className="flex items-center gap-1.5 px-3 py-1.5 text-xs text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg cursor-pointer transition-colors">
                <Upload className="w-3.5 h-3.5" />
                Choose File
                <input
                  type="file"
                  accept="image/*"
                  onChange={handleFileChange}
                  className="hidden"
                />
              </label>
              {formData.logoFile && (
                <span className="text-[11px] text-gray-500">{formData.logoFile.name}</span>
              )}
            </div>
          </div>

          {/* Submit */}
          <div className="flex items-center justify-end gap-2 pt-2 border-t border-gray-100">
            <button
              type="submit"
              disabled={loading}
              className="flex items-center gap-1.5 px-3 py-1.5 text-xs text-white bg-blue-500 hover:bg-blue-600 disabled:opacity-50 rounded-lg transition-colors"
            >
              {loading ? (
                <Loader2 className="w-3.5 h-3.5 animate-spin" />
              ) : (
                <Save className="w-3.5 h-3.5" />
              )}
              Save Demo Tag
            </button>
          </div>
        </form>
      </div>

      {/* Demo Tag Preview */}
      <div className="mt-3 bg-white rounded-lg border border-gray-100">
        <div className="px-3 py-2 border-b border-gray-50">
          <h2 className="text-xs font-semibold text-gray-700">Active Demo Tags</h2>
        </div>
        <div className="p-4 text-center text-xs text-gray-400">
          <p>Demo tags will appear here once configured</p>
          <a
            href="#"
            className="inline-flex items-center gap-1 mt-2 text-blue-500 hover:text-blue-600"
          >
            <ExternalLink className="w-3 h-3" />
            Test Demo Experience
          </a>
        </div>
      </div>
    </div>
  );
}
