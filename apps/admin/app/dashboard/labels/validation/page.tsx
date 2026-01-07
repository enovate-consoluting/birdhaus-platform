/**
 * Labels Validation Page
 * Search and manage label validations from Legacy MySQL
 * Last Modified: January 2026
 */

'use client';

import { useState } from 'react';
import {
  Search,
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
          setResult({ type: 'legacy', validations: data.validations });
        } else if (data.type === 'password') {
          setResult({ type: 'password', validations: data.validations, detail: data.detail });
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
    <div className="p-3 lg:p-4">
      {/* Header */}
      <div className="mb-4">
        <h1 className="text-sm font-semibold text-gray-900">Manage Validations</h1>
        <p className="text-[11px] text-gray-500">Search label validation history</p>
      </div>

      {/* Search */}
      <div className="bg-white rounded-lg border border-gray-100 mb-3">
        <div className="px-3 py-2 border-b border-gray-50">
          <h2 className="text-xs font-semibold text-gray-700">Search Label</h2>
        </div>
        <div className="p-3">
          <form onSubmit={handleSearch} className="flex gap-2">
            <div className="relative flex-1">
              <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-gray-400" />
              <input
                type="text"
                value={searchCode}
                onChange={(e) => setSearchCode(e.target.value)}
                placeholder="Enter label code or password"
                className="w-full pl-8 pr-3 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
              />
            </div>
            <button
              type="submit"
              disabled={searching || !searchCode.trim()}
              className="flex items-center gap-1.5 px-3 py-1.5 text-xs text-white bg-blue-500 hover:bg-blue-600 disabled:opacity-50 rounded-lg transition-colors"
            >
              {searching ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <Search className="w-3.5 h-3.5" />}
              Search
            </button>
          </form>
        </div>
      </div>

      {/* Results */}
      {searched && (
        <>
          {/* Verify Once Section */}
          {result && result.type === 'password' && (
            <div className="bg-white rounded-lg border border-gray-100 mb-3">
              <div className="px-3 py-2 border-b border-gray-50 flex items-center justify-between">
                <h2 className="text-xs font-semibold text-gray-700">Verify Once</h2>
                {isVerifyOnce && hasValidations && (
                  <button
                    onClick={() => alert('Reset requires write access')}
                    className="flex items-center gap-1 px-2 py-1 text-[10px] text-amber-700 bg-amber-50 hover:bg-amber-100 rounded transition-colors"
                  >
                    <RotateCcw className="w-3 h-3" />
                    Reset
                  </button>
                )}
              </div>
              <div className="p-3 flex items-center justify-between">
                <label className="flex items-center gap-2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={verifyOnceOverride}
                    onChange={(e) => setVerifyOnceOverride(e.target.checked)}
                    className="w-3.5 h-3.5 text-blue-600 border-gray-300 rounded focus:ring-blue-500"
                  />
                  <span className="text-xs text-gray-600">Verify once?</span>
                </label>
                <button
                  onClick={() => alert('Save requires write access')}
                  className="px-2.5 py-1 text-xs text-white bg-blue-500 hover:bg-blue-600 rounded-lg transition-colors"
                >
                  Save
                </button>
              </div>
            </div>
          )}

          {/* Validations Table */}
          {hasValidations ? (
            <div className="bg-white rounded-lg border border-gray-100 overflow-hidden">
              <div className="px-3 py-2 border-b border-gray-50">
                <h2 className="text-xs font-semibold text-gray-700">
                  Validation History ({result.validations.length})
                </h2>
              </div>
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="border-b border-gray-100 bg-gray-50/50">
                      <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Date</th>
                      <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Client</th>
                      <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">IP</th>
                      <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Label</th>
                      <th className="px-3 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase">Reset</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-50">
                    {result.type === 'legacy'
                      ? (result.validations as LegacyValidation[]).map((v) => (
                          <tr key={v.validation_id} className="hover:bg-gray-50/50">
                            <td className="px-3 py-2 text-[11px] text-gray-500">{formatDate(v.create_dt)}</td>
                            <td className="px-3 py-2 text-xs text-gray-900">{v.company_name}</td>
                            <td className="px-3 py-2 text-[11px] text-gray-500 font-mono">{v.IP_addr}</td>
                            <td className="px-3 py-2 text-xs font-medium text-gray-700">{v.validation_code}</td>
                            <td className="px-3 py-2">
                              {v.reset ? (
                                <span className="inline-flex items-center gap-0.5 text-emerald-600 text-[10px]">
                                  <Check className="w-3 h-3" /> Yes
                                </span>
                              ) : (
                                <span className="text-gray-300 text-[10px]">No</span>
                              )}
                            </td>
                          </tr>
                        ))
                      : (result.validations as PasswordValidation[]).map((v) => (
                          <tr key={v.label_pass_val_id} className="hover:bg-gray-50/50">
                            <td className="px-3 py-2 text-[11px] text-gray-500">{formatDate(v.create_dt)}</td>
                            <td className="px-3 py-2 text-xs text-gray-900">{v.company_name}</td>
                            <td className="px-3 py-2 text-[11px] text-gray-500 font-mono">{v.IP_addr}</td>
                            <td className="px-3 py-2 text-xs font-medium text-gray-700">{v.password}</td>
                            <td className="px-3 py-2 text-gray-300 text-[10px]">-</td>
                          </tr>
                        ))}
                  </tbody>
                </table>
              </div>
            </div>
          ) : (
            <div className="bg-white rounded-lg border border-gray-100 p-6 text-center">
              <AlertCircle className="w-8 h-8 text-gray-200 mx-auto mb-2" />
              <p className="text-xs text-gray-500">
                No validations found for <span className="font-medium text-gray-700">{searchCode}</span>
              </p>
            </div>
          )}
        </>
      )}
    </div>
  );
}
