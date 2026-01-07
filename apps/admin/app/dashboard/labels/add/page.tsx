/**
 * Labels Add Page
 * Upload Excel file with serial numbers and passwords
 * Last Modified: January 2026
 */

'use client';

import { useEffect, useState, useRef } from 'react';
import {
  Plus,
  Upload,
  FileSpreadsheet,
  Info,
  X,
  Loader2,
  AlertCircle,
} from 'lucide-react';

interface Client {
  client_id: number;
  company_name: string;
}

const DEFAULT_VERIFY_ONCE_MESSAGE =
  'This label has already been scanned. If this is the first time you are scanning this label, the product may be counterfeit.';

export default function LabelsAddPage() {
  const [clients, setClients] = useState<Client[]>([]);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [formData, setFormData] = useState({
    client: '',
    note: '',
    verifyOnce: false,
    verifyOnceMessage: DEFAULT_VERIFY_ONCE_MESSAGE,
    labelValidationMessage: '',
    excludeFromStats: false,
  });
  const [selectedFile, setSelectedFile] = useState<File | null>(null);

  useEffect(() => {
    fetchClients();
  }, []);

  const fetchClients = async () => {
    try {
      const res = await fetch('/api/labels/clients?page=labels-add');
      const data = await res.json();
      if (data.success) {
        setClients(data.data);
      }
    } catch (error) {
      console.error('Error fetching clients:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const validTypes = [
        'application/vnd.ms-excel',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      ];
      if (!validTypes.includes(file.type) && !file.name.match(/\.(xls|xlsx)$/i)) {
        setError('Please upload an Excel file (.xls or .xlsx)');
        setSelectedFile(null);
        return;
      }
      setError(null);
      setSelectedFile(file);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    if (!formData.client) {
      setError('Please select a client');
      return;
    }

    if (!selectedFile) {
      setError('Please select a spreadsheet');
      return;
    }

    setSubmitting(true);
    setTimeout(() => {
      setSubmitting(false);
      alert(
        'Upload requires write access.\n\n' +
          `Client: ${formData.client}\n` +
          `File: ${selectedFile.name}\n` +
          `Verify Once: ${formData.verifyOnce ? 'Yes' : 'No'}`
      );
    }, 1000);
  };

  const handleClear = () => {
    setFormData({
      client: '',
      note: '',
      verifyOnce: false,
      verifyOnceMessage: DEFAULT_VERIFY_ONCE_MESSAGE,
      labelValidationMessage: '',
      excludeFromStats: false,
    });
    setSelectedFile(null);
    setError(null);
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  return (
    <div className="p-3 lg:p-4">
      {/* Header */}
      <div className="mb-4">
        <h1 className="text-sm font-semibold text-gray-900">Add Labels</h1>
        <p className="text-[11px] text-gray-500">Upload Excel with serial numbers and passwords</p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-3">
        {/* Error */}
        {error && (
          <div className="flex items-center gap-2 px-3 py-2 bg-red-50 border border-red-100 rounded-lg text-xs text-red-600">
            <AlertCircle className="w-3.5 h-3.5 flex-shrink-0" />
            <span>{error}</span>
            <button type="button" onClick={() => setError(null)} className="ml-auto">
              <X className="w-3.5 h-3.5" />
            </button>
          </div>
        )}

        {/* Label Details */}
        <div className="bg-white rounded-lg border border-gray-100">
          <div className="px-3 py-2 border-b border-gray-50">
            <h2 className="text-xs font-semibold text-gray-700">Label Details</h2>
          </div>
          <div className="p-3">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              <div>
                <label className="block text-[10px] font-medium text-gray-500 uppercase mb-1">
                  Client <span className="text-red-400">*</span>
                </label>
                {loading ? (
                  <div className="flex items-center gap-2 text-xs text-gray-400">
                    <Loader2 className="w-3 h-3 animate-spin" /> Loading...
                  </div>
                ) : (
                  <select
                    value={formData.client}
                    onChange={(e) => setFormData({ ...formData, client: e.target.value })}
                    className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
                  >
                    <option value="">Select Client</option>
                    {clients.map((client) => (
                      <option key={client.client_id} value={client.client_id}>
                        {client.company_name}
                      </option>
                    ))}
                  </select>
                )}
              </div>
              <div>
                <label className="block text-[10px] font-medium text-gray-500 uppercase mb-1">Note</label>
                <input
                  type="text"
                  value={formData.note}
                  onChange={(e) => setFormData({ ...formData, note: e.target.value })}
                  maxLength={200}
                  className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
                  placeholder="Internal note (optional)"
                />
              </div>
            </div>
          </div>
        </div>

        {/* Spreadsheet */}
        <div className="bg-white rounded-lg border border-gray-100">
          <div className="px-3 py-2 border-b border-gray-50">
            <h2 className="text-xs font-semibold text-gray-700">Spreadsheet</h2>
          </div>
          <div className="p-3 space-y-3">
            {/* Info */}
            <div className="flex gap-2 p-2 bg-blue-50 rounded-lg">
              <Info className="w-3.5 h-3.5 text-blue-500 flex-shrink-0 mt-0.5" />
              <p className="text-[10px] text-blue-700">
                Excel file (.xls/.xlsx) with &quot;serial&quot; and &quot;password&quot; columns on the first sheet.
              </p>
            </div>

            {/* File Upload */}
            <div
              className={`relative border border-dashed rounded-lg p-4 text-center transition-colors cursor-pointer ${
                selectedFile ? 'border-blue-300 bg-blue-50/50' : 'border-gray-200 hover:border-gray-300'
              }`}
            >
              <input
                ref={fileInputRef}
                type="file"
                accept=".xls,.xlsx"
                onChange={handleFileChange}
                className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
              />
              {selectedFile ? (
                <div className="flex items-center justify-center gap-2">
                  <FileSpreadsheet className="w-5 h-5 text-blue-500" />
                  <div className="text-left">
                    <p className="text-xs font-medium text-gray-900">{selectedFile.name}</p>
                    <p className="text-[10px] text-gray-500">{(selectedFile.size / 1024).toFixed(1)} KB</p>
                  </div>
                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation();
                      setSelectedFile(null);
                      if (fileInputRef.current) fileInputRef.current.value = '';
                    }}
                    className="p-1 text-gray-400 hover:text-gray-600"
                  >
                    <X className="w-4 h-4" />
                  </button>
                </div>
              ) : (
                <>
                  <Upload className="w-6 h-6 text-gray-300 mx-auto mb-1" />
                  <p className="text-xs text-gray-500">
                    <span className="text-blue-500">Click to upload</span> or drag and drop
                  </p>
                </>
              )}
            </div>
          </div>
        </div>

        {/* Options */}
        <div className="bg-white rounded-lg border border-gray-100">
          <div className="px-3 py-2 border-b border-gray-50">
            <h2 className="text-xs font-semibold text-gray-700">Options</h2>
          </div>
          <div className="p-3 space-y-3">
            <div>
              <label className="block text-[10px] font-medium text-gray-500 uppercase mb-1">Verify Once Message</label>
              <textarea
                value={formData.verifyOnceMessage}
                onChange={(e) => setFormData({ ...formData, verifyOnceMessage: e.target.value })}
                maxLength={400}
                rows={2}
                className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500 resize-none"
              />
              <p className="text-[9px] text-gray-400 mt-0.5">{formData.verifyOnceMessage.length}/400</p>
            </div>

            <div>
              <label className="block text-[10px] font-medium text-gray-500 uppercase mb-1">Validation Message</label>
              <textarea
                value={formData.labelValidationMessage}
                onChange={(e) => setFormData({ ...formData, labelValidationMessage: e.target.value })}
                rows={2}
                className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500 resize-none"
                placeholder="Custom message (optional)"
              />
            </div>

            <div className="flex flex-col gap-2">
              <label className="flex items-center gap-2 cursor-pointer">
                <input
                  type="checkbox"
                  checked={formData.verifyOnce}
                  onChange={(e) => setFormData({ ...formData, verifyOnce: e.target.checked })}
                  className="w-3.5 h-3.5 text-blue-600 border-gray-300 rounded focus:ring-blue-500"
                />
                <span className="text-xs text-gray-600">Verify only once</span>
              </label>

              <label className="flex items-center gap-2 cursor-pointer">
                <input
                  type="checkbox"
                  checked={formData.excludeFromStats}
                  onChange={(e) => setFormData({ ...formData, excludeFromStats: e.target.checked })}
                  className="w-3.5 h-3.5 text-blue-600 border-gray-300 rounded focus:ring-blue-500"
                />
                <span className="text-xs text-gray-600">Exclude from statistics</span>
              </label>
            </div>
          </div>
        </div>

        {/* Buttons */}
        <div className="flex items-center gap-2">
          <button
            type="submit"
            disabled={submitting}
            className="flex items-center gap-1.5 px-3 py-1.5 text-xs text-white bg-blue-500 hover:bg-blue-600 disabled:opacity-50 rounded-lg transition-colors"
          >
            {submitting ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <Upload className="w-3.5 h-3.5" />}
            Save
          </button>
          <button
            type="button"
            onClick={handleClear}
            className="px-3 py-1.5 text-xs text-gray-600 hover:bg-gray-100 rounded-lg transition-colors"
          >
            Clear
          </button>
        </div>
      </form>
    </div>
  );
}
