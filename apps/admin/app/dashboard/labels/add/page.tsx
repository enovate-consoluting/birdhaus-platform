/**
 * Labels Add New Page
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
  CheckCircle,
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
  const [success, setSuccess] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  // Form state
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
      // Validate file type
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

    // Validation
    if (!formData.client) {
      setError('Please select a client');
      return;
    }

    if (!selectedFile) {
      setError('Please select a spreadsheet containing serial numbers and passwords');
      return;
    }

    setSubmitting(true);

    // Note: Since we have read-only access, we'll show a message instead of actually submitting
    setTimeout(() => {
      setSubmitting(false);
      // TODO: Implement actual file upload and processing when write access is available
      alert(
        'Upload functionality requires write access to the database.\n\n' +
          'Form data validated:\n' +
          `- Client ID: ${formData.client}\n` +
          `- Note: ${formData.note || '(none)'}\n` +
          `- File: ${selectedFile.name}\n` +
          `- Verify Once: ${formData.verifyOnce ? 'Yes' : 'No'}\n` +
          `- Exclude from Stats: ${formData.excludeFromStats ? 'Yes' : 'No'}`
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
    setSuccess(false);
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center gap-3">
        <div className="p-2 bg-violet-100 rounded-lg">
          <Plus className="h-6 w-6 text-violet-600" />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Add Labels</h1>
          <p className="text-gray-500">Upload an Excel file with serial numbers and passwords</p>
        </div>
      </div>

      <form onSubmit={handleSubmit}>
        {/* Error Alert */}
        {error && (
          <div className="flex items-center gap-3 p-4 bg-red-50 border border-red-200 rounded-xl text-red-700">
            <AlertCircle className="h-5 w-5 flex-shrink-0" />
            <span>{error}</span>
            <button
              type="button"
              onClick={() => setError(null)}
              className="ml-auto p-1 hover:bg-red-100 rounded"
            >
              <X className="h-4 w-4" />
            </button>
          </div>
        )}

        {/* Success Alert */}
        {success && (
          <div className="flex items-center gap-3 p-4 bg-green-50 border border-green-200 rounded-xl text-green-700">
            <CheckCircle className="h-5 w-5 flex-shrink-0" />
            <span>Labels uploaded successfully!</span>
            <button
              type="button"
              onClick={() => setSuccess(false)}
              className="ml-auto p-1 hover:bg-green-100 rounded"
            >
              <X className="h-4 w-4" />
            </button>
          </div>
        )}

        {/* Label Details Section */}
        <div className="bg-white rounded-xl border border-gray-200 overflow-hidden">
          <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
            <h2 className="font-semibold text-gray-900">Label Details</h2>
          </div>
          <div className="p-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Client <span className="text-red-500">*</span>
                </label>
                {loading ? (
                  <div className="flex items-center gap-2 px-3 py-2 text-gray-500">
                    <Loader2 className="h-4 w-4 animate-spin" />
                    Loading clients...
                  </div>
                ) : (
                  <select
                    value={formData.client}
                    onChange={(e) => setFormData({ ...formData, client: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500"
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
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Note
                </label>
                <input
                  type="text"
                  value={formData.note}
                  onChange={(e) => setFormData({ ...formData, note: e.target.value })}
                  maxLength={200}
                  className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500"
                  placeholder="Internal note (optional)"
                />
              </div>
            </div>
          </div>
        </div>

        {/* Spreadsheet Section */}
        <div className="bg-white rounded-xl border border-gray-200 overflow-hidden">
          <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
            <h2 className="font-semibold text-gray-900">Label Spreadsheet</h2>
          </div>
          <div className="p-4 space-y-4">
            {/* Info Toast */}
            <div className="flex gap-3 p-4 bg-blue-50 border border-blue-200 rounded-lg">
              <Info className="h-5 w-5 text-blue-600 flex-shrink-0 mt-0.5" />
              <div className="text-sm text-blue-800">
                <p className="font-medium">File Requirements</p>
                <p className="mt-1">
                  The file must be in Excel format (.xls or .xlsx), containing serial numbers
                  (numeric only) and passwords (alphanumeric) on the first sheet. Column names
                  must be &quot;serial&quot; and &quot;password&quot;.
                </p>
              </div>
            </div>

            {/* File Upload */}
            <div
              className={`relative border-2 border-dashed rounded-lg p-6 text-center transition-colors ${
                selectedFile
                  ? 'border-violet-300 bg-violet-50'
                  : 'border-gray-300 hover:border-gray-400'
              }`}
            >
              <input
                ref={fileInputRef}
                type="file"
                accept=".xls,.xlsx,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                onChange={handleFileChange}
                className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
              />
              {selectedFile ? (
                <div className="flex items-center justify-center gap-3">
                  <FileSpreadsheet className="h-8 w-8 text-violet-600" />
                  <div className="text-left">
                    <p className="font-medium text-gray-900">{selectedFile.name}</p>
                    <p className="text-sm text-gray-500">
                      {(selectedFile.size / 1024).toFixed(1)} KB
                    </p>
                  </div>
                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation();
                      setSelectedFile(null);
                      if (fileInputRef.current) {
                        fileInputRef.current.value = '';
                      }
                    }}
                    className="p-1 text-gray-400 hover:text-gray-600 hover:bg-gray-200 rounded"
                  >
                    <X className="h-5 w-5" />
                  </button>
                </div>
              ) : (
                <>
                  <Upload className="h-10 w-10 text-gray-400 mx-auto mb-3" />
                  <p className="text-gray-600">
                    <span className="font-medium text-violet-600">Click to upload</span> or drag
                    and drop
                  </p>
                  <p className="text-sm text-gray-400 mt-1">Excel files only (.xls, .xlsx)</p>
                </>
              )}
            </div>
          </div>
        </div>

        {/* Options Section */}
        <div className="bg-white rounded-xl border border-gray-200 overflow-hidden">
          <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
            <h2 className="font-semibold text-gray-900">Options</h2>
          </div>
          <div className="p-4 space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Verify Once Message
              </label>
              <textarea
                value={formData.verifyOnceMessage}
                onChange={(e) =>
                  setFormData({ ...formData, verifyOnceMessage: e.target.value })
                }
                maxLength={400}
                rows={3}
                className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500 resize-none"
                placeholder="Message shown when verify once is triggered"
              />
              <p className="text-xs text-gray-400 mt-1">
                {formData.verifyOnceMessage.length}/400 characters
              </p>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Label Validation Message
              </label>
              <textarea
                value={formData.labelValidationMessage}
                onChange={(e) =>
                  setFormData({ ...formData, labelValidationMessage: e.target.value })
                }
                rows={2}
                className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500 resize-none"
                placeholder="Custom validation message (optional)"
              />
            </div>

            <div className="flex flex-col gap-3">
              <label className="flex items-center gap-3 cursor-pointer">
                <input
                  type="checkbox"
                  checked={formData.verifyOnce}
                  onChange={(e) => setFormData({ ...formData, verifyOnce: e.target.checked })}
                  className="w-4 h-4 text-violet-600 border-gray-300 rounded focus:ring-violet-500"
                />
                <span className="text-sm text-gray-700">Verify Only Once?</span>
              </label>

              <label className="flex items-center gap-3 cursor-pointer">
                <input
                  type="checkbox"
                  checked={formData.excludeFromStats}
                  onChange={(e) =>
                    setFormData({ ...formData, excludeFromStats: e.target.checked })
                  }
                  className="w-4 h-4 text-violet-600 border-gray-300 rounded focus:ring-violet-500"
                />
                <span className="text-sm text-gray-700">Exclude from statistics?</span>
              </label>
            </div>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="flex items-center gap-3">
          <button
            type="submit"
            disabled={submitting}
            className="flex items-center gap-2 px-6 py-2.5 bg-violet-600 text-white rounded-lg hover:bg-violet-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
          >
            {submitting ? (
              <>
                <Loader2 className="h-4 w-4 animate-spin" />
                Uploading...
              </>
            ) : (
              <>
                <Upload className="h-4 w-4" />
                Save
              </>
            )}
          </button>
          <button
            type="button"
            onClick={handleClear}
            className="px-6 py-2.5 text-gray-700 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
          >
            Clear
          </button>
        </div>
      </form>
    </div>
  );
}
