/**
 * Labels Validation Page
 * Search and manage label validations from Legacy MySQL
 * Last Modified: January 2026
 */

'use client';

import { useState } from 'react';
import {
  Search,
  CheckCircle,
  RefreshCw,
  Loader2,
  AlertCircle,
  Check,
  X,
  RotateCcw,
} from 'lucide-react';

interface LegacyValidation {
  validation_id: number;
  range_id: number;
  create_dt: string;
  IP_addr: string;
  validation_code: string;
  reset: number;
  verify_once: string;
  company_name: string;
}

interface PasswordValidation {
  label_pass_val_id: number;
  label_pass_detail_id: number;
  client_id: number;
  create_dt: string;
  IP_addr: string;
  password: string;
  verify_once: string;
  verify_once_override: string;
  company_name: string;
}

interface PasswordDetail {
  label_pass_detail_id: number;
  client_id: number;
  verify_once: string;
  verify_once_override: string;
  company_name: string;
}

interface ValidationResult {
  type: 'legacy' | 'password';
  validations: LegacyValidation[] | PasswordValidation[];
  detail?: PasswordDetail;
}

export default function LabelsValidationPage() {
  const [searchCode, setSearchCode] = useState('');
  const [searching, setSearching] = useState(false);
  const [result, setResult] = useState<ValidationResult | null>(null);
  const [searched, setSearched] = useState(false);
  const [verifyOnceOverride, setVerifyOnceOverride] = useState(false);

  const handleSearch = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!searchCode.trim()) return;

    setSearching(true);
    setSearched(true);
    setResult(null);

    try {
      const res = await fetch(`/api/labels/validations?code=${encodeURIComponent(searchCode)}`);
      const data = await res.json();

      if (data.success) {
        if (data.type === 'legacy') {
          setResult({
            type: 'legacy',
            validations: data.validations,
          });
        } else if (data.type === 'password') {
          setResult({
            type: 'password',
            validations: data.validations,
            detail: data.detail,
          });
          // Set initial verify once override state
          if (data.detail) {
            setVerifyOnceOverride(
              data.detail.verify_once_override === 'Y' ||
                (data.detail.verify_once === 'Y' && data.detail.verify_once_override !== 'N')
            );
          }
        }
      }
    } catch (error) {
      console.error('Error searching validations:', error);
    } finally {
      setSearching(false);
    }
  };

  const handleResetValidation = () => {
    // TODO: Implement reset (read-only for now)
    alert('Reset functionality requires write access to the database');
  };

  const handleSaveOverride = () => {
    // TODO: Implement save override (read-only for now)
    alert(`Save verify once override (${verifyOnceOverride ? 'Yes' : 'No'}) requires write access to the database`);
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

  const hasValidations = result && result.validations.length > 0;
  const isVerifyOnce =
    result?.type === 'password'
      ? result.detail?.verify_once === 'Y' && result.detail?.verify_once_override !== 'N'
      : (result?.validations[0] as LegacyValidation)?.verify_once === 'Y';

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center gap-3">
        <div className="p-2 bg-violet-100 rounded-lg">
          <Search className="h-6 w-6 text-violet-600" />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Manage Validations</h1>
          <p className="text-gray-500">Search and manage label validation history</p>
        </div>
      </div>

      {/* Search Section */}
      <div className="bg-white rounded-xl border border-gray-200 overflow-hidden">
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <h2 className="font-semibold text-gray-900">Search Label</h2>
        </div>
        <div className="p-4">
          <form onSubmit={handleSearch}>
            <div className="flex gap-2">
              <div className="relative flex-1">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                <input
                  type="text"
                  value={searchCode}
                  onChange={(e) => setSearchCode(e.target.value)}
                  placeholder="Enter label code or password"
                  className="w-full pl-10 pr-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-violet-500 focus:border-transparent"
                />
              </div>
              <button
                type="submit"
                disabled={searching || !searchCode.trim()}
                className="flex items-center gap-2 px-4 py-2 bg-violet-600 text-white rounded-lg hover:bg-violet-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
              >
                {searching ? (
                  <Loader2 className="h-4 w-4 animate-spin" />
                ) : (
                  <Search className="h-4 w-4" />
                )}
                Search
              </button>
            </div>
          </form>
        </div>
      </div>

      {/* Results */}
      {searched && (
        <>
          {/* Verify Once Section */}
          {result && result.type === 'password' && (
            <div className="bg-white rounded-xl border border-gray-200 overflow-hidden">
              <div className="px-4 py-3 bg-gray-50 border-b border-gray-200 flex items-center justify-between">
                <h2 className="font-semibold text-gray-900">Verify Once</h2>
                {isVerifyOnce && hasValidations && (
                  <button
                    onClick={handleResetValidation}
                    className="flex items-center gap-2 px-3 py-1.5 text-sm bg-orange-100 text-orange-700 hover:bg-orange-200 rounded-lg transition-colors"
                  >
                    <RotateCcw className="h-4 w-4" />
                    Reset Validation
                  </button>
                )}
              </div>
              <div className="p-4 space-y-4">
                <label className="flex items-center gap-3 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={verifyOnceOverride}
                    onChange={(e) => setVerifyOnceOverride(e.target.checked)}
                    className="w-4 h-4 text-violet-600 border-gray-300 rounded focus:ring-violet-500"
                  />
                  <span className="text-sm text-gray-700">Verify once?</span>
                </label>

                <button
                  onClick={handleSaveOverride}
                  className="flex items-center gap-2 px-4 py-2 bg-violet-600 text-white rounded-lg hover:bg-violet-700 transition-colors"
                >
                  <CheckCircle className="h-4 w-4" />
                  Save
                </button>
              </div>
            </div>
          )}

          {/* Validations Table */}
          {hasValidations ? (
            <div className="bg-white rounded-xl border border-gray-200 overflow-hidden">
              <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
                <h2 className="font-semibold text-gray-900">
                  Validation History ({result.validations.length}{' '}
                  {result.validations.length === 1 ? 'record' : 'records'})
                </h2>
              </div>
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead className="bg-gray-50 border-b border-gray-200">
                    <tr>
                      <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Date
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Client
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        IP Address
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Label
                      </th>
                      <th className="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Reset
                      </th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {result.type === 'legacy'
                      ? (result.validations as LegacyValidation[]).map((v) => (
                          <tr key={v.validation_id} className="hover:bg-gray-50">
                            <td className="px-4 py-3 text-sm text-gray-600 whitespace-nowrap">
                              {formatDate(v.create_dt)}
                            </td>
                            <td className="px-4 py-3 text-sm text-gray-700">
                              {v.company_name}
                            </td>
                            <td className="px-4 py-3 text-sm text-gray-600 font-mono">
                              {v.IP_addr}
                            </td>
                            <td className="px-4 py-3 text-sm font-medium text-gray-900">
                              {v.validation_code}
                            </td>
                            <td className="px-4 py-3 text-sm">
                              {v.reset ? (
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
                          </tr>
                        ))
                      : (result.validations as PasswordValidation[]).map((v) => (
                          <tr key={v.label_pass_val_id} className="hover:bg-gray-50">
                            <td className="px-4 py-3 text-sm text-gray-600 whitespace-nowrap">
                              {formatDate(v.create_dt)}
                            </td>
                            <td className="px-4 py-3 text-sm text-gray-700">
                              {v.company_name}
                            </td>
                            <td className="px-4 py-3 text-sm text-gray-600 font-mono">
                              {v.IP_addr}
                            </td>
                            <td className="px-4 py-3 text-sm font-medium text-gray-900">
                              {v.password}
                            </td>
                            <td className="px-4 py-3 text-sm">
                              <span className="text-gray-400">-</span>
                            </td>
                          </tr>
                        ))}
                  </tbody>
                </table>
              </div>
            </div>
          ) : (
            <div className="bg-white rounded-xl border border-gray-200 p-8 text-center">
              <AlertCircle className="h-12 w-12 text-gray-300 mx-auto mb-3" />
              <p className="text-gray-600">
                No validations found for label <strong className="text-gray-900">{searchCode}</strong>
              </p>
              <p className="text-sm text-gray-400 mt-1">
                Try searching with a different code or password
              </p>
            </div>
          )}
        </>
      )}
    </div>
  );
}
