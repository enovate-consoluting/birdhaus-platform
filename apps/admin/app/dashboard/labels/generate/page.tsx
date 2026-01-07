/**
 * Labels Generate Page
 * Generate password batches, search, assign by serial range
 * Connected to Legacy MySQL (Scanacart)
 * Last Modified: January 2026
 */

'use client';

import { useState, useEffect } from 'react';
import {
  Search,
  Plus,
  FileSpreadsheet,
  ArrowRight,
  Edit2,
  X,
  Loader2,
  RefreshCw,
} from 'lucide-react';

interface Client {
  client_id: number;
  company_name: string;
}

interface Generation {
  label_pass_gen_id: number;
  label_pass_detail_id: number;
  client_id: number;
  num_passwords: number;
  password_length: number;
  alpha_char: string;
  create_dt: string;
  first_serial_num: string;
  last_serial_num: string;
  spreadsheet_name: string;
  company_name: string;
  num_sub_spreadsheets: number;
}

export default function LabelsGeneratePage() {
  const [searchQuery, setSearchQuery] = useState('');
  const [serialFrom, setSerialFrom] = useState('');
  const [serialTo, setSerialTo] = useState('');
  const [selectedClient, setSelectedClient] = useState('');
  const [overrideAssignment, setOverrideAssignment] = useState(false);
  const [showAddModal, setShowAddModal] = useState(false);

  const [clients, setClients] = useState<Client[]>([]);
  const [generations, setGenerations] = useState<Generation[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Add New form state
  const [newGen, setNewGen] = useState({
    client: '',
    numPasswords: '',
    passLength: '8',
    includeLetter: '0',
    letter: '',
    note: '',
    verifyOnce: false,
    excludeStats: false,
    includeSerial: true,
  });

  // Fetch clients
  useEffect(() => {
    async function fetchClients() {
      try {
        const res = await fetch('/api/labels/clients');
        const data = await res.json();
        if (data.success) {
          setClients(data.data);
        }
      } catch (err) {
        console.error('Error fetching clients:', err);
      }
    }
    fetchClients();
  }, []);

  // Fetch generations
  const fetchGenerations = async (search?: string) => {
    setLoading(true);
    setError(null);
    try {
      const url = search
        ? `/api/labels/generations?search=${encodeURIComponent(search)}`
        : '/api/labels/generations';
      const res = await fetch(url);
      const data = await res.json();
      if (data.success) {
        setGenerations(data.data);
      } else {
        setError(data.error || 'Failed to fetch data');
      }
    } catch (err) {
      setError('Failed to connect to database');
      console.error('Error fetching generations:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchGenerations();
  }, []);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    fetchGenerations(searchQuery || undefined);
  };

  const handleSeparateAssign = (e: React.FormEvent) => {
    e.preventDefault();
    // Will implement write operations later
    alert(`Assigning serials ${serialFrom}-${serialTo} to client ${selectedClient}`);
  };

  const handleAddNew = (e: React.FormEvent) => {
    e.preventDefault();
    // Will implement write operations later
    alert('Generating passwords... (Write operations coming soon)');
    setShowAddModal(false);
  };

  const formatDate = (dateStr: string) => {
    return new Date(dateStr).toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
      hour: 'numeric',
      minute: '2-digit',
    });
  };

  return (
    <div className="p-3 lg:p-4 space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-sm font-semibold text-gray-900">Generate Labels</h1>
          <p className="text-[11px] text-gray-500">
            Manage password generation batches • {generations.length} records
          </p>
        </div>
        <div className="flex gap-2">
          <button
            onClick={() => fetchGenerations()}
            className="flex items-center gap-1.5 px-3 py-1.5 bg-gray-100 text-gray-700 text-xs font-medium rounded-lg hover:bg-gray-200 transition-colors"
          >
            <RefreshCw className="w-3.5 h-3.5" />
            Refresh
          </button>
          <button
            onClick={() => setShowAddModal(true)}
            className="flex items-center gap-1.5 px-3 py-1.5 bg-blue-600 text-white text-xs font-medium rounded-lg hover:bg-blue-700 transition-colors"
          >
            <Plus className="w-3.5 h-3.5" />
            Add New
          </button>
        </div>
      </div>

      {/* Search Card */}
      <div className="bg-white rounded-lg border border-gray-100 p-3">
        <h3 className="text-xs font-semibold text-gray-700 mb-2">Locate Password</h3>
        <form onSubmit={handleSearch} className="flex gap-2">
          <div className="relative flex-1">
            <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-gray-400" />
            <input
              type="text"
              placeholder="Find by password or serial..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-8 pr-3 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
            />
          </div>
          <button
            type="submit"
            className="px-3 py-1.5 bg-blue-600 text-white text-xs font-medium rounded-lg hover:bg-blue-700 transition-colors"
          >
            <Search className="w-3.5 h-3.5" />
          </button>
          {searchQuery && (
            <button
              type="button"
              onClick={() => {
                setSearchQuery('');
                fetchGenerations();
              }}
              className="px-3 py-1.5 bg-gray-100 text-gray-700 text-xs font-medium rounded-lg hover:bg-gray-200 transition-colors"
            >
              Clear
            </button>
          )}
        </form>
      </div>

      {/* Separate/Assign Card */}
      <div className="bg-white rounded-lg border border-gray-100 p-3">
        <h3 className="text-xs font-semibold text-gray-700 mb-2">Separate/Assign by Serial Number</h3>
        <form onSubmit={handleSeparateAssign} className="flex flex-wrap items-center gap-2">
          <input
            type="text"
            placeholder="Serial From"
            value={serialFrom}
            onChange={(e) => setSerialFrom(e.target.value)}
            className="w-28 px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
          />
          <input
            type="text"
            placeholder="Serial To"
            value={serialTo}
            onChange={(e) => setSerialTo(e.target.value)}
            className="w-28 px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
          />
          <select
            value={selectedClient}
            onChange={(e) => setSelectedClient(e.target.value)}
            className="w-40 px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500 bg-white"
          >
            <option value="">Select Client</option>
            <option value="Unassigned">Unassigned</option>
            {clients.map((c) => (
              <option key={c.client_id} value={c.client_id}>{c.company_name}</option>
            ))}
          </select>
          <div className="flex-1" />
          <label className="flex items-center gap-1.5 text-xs text-gray-600">
            <input
              type="checkbox"
              checked={overrideAssignment}
              onChange={(e) => setOverrideAssignment(e.target.checked)}
              className="w-3.5 h-3.5 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
            />
            Override
          </label>
          <button
            type="submit"
            className="flex items-center gap-1.5 px-3 py-1.5 bg-blue-500 text-white text-xs font-medium rounded-lg hover:bg-blue-600 transition-colors"
          >
            <ArrowRight className="w-3.5 h-3.5" />
            Proceed
          </button>
        </form>
      </div>

      {/* Generation List Table */}
      <div className="bg-white rounded-lg border border-gray-100">
        <div className="px-3 py-2 border-b border-gray-100">
          <h3 className="text-xs font-semibold text-gray-700">Password Generation List</h3>
        </div>

        {loading ? (
          <div className="flex items-center justify-center py-12">
            <Loader2 className="w-5 h-5 text-blue-600 animate-spin" />
            <span className="ml-2 text-xs text-gray-500">Loading from database...</span>
          </div>
        ) : error ? (
          <div className="p-6 text-center">
            <p className="text-xs text-red-500">{error}</p>
            <button
              onClick={() => fetchGenerations()}
              className="mt-2 text-xs text-blue-600 hover:underline"
            >
              Try again
            </button>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-xs">
              <thead className="bg-gray-50 border-b border-gray-100">
                <tr>
                  <th className="px-3 py-2 text-left font-medium text-gray-600 w-10"></th>
                  <th className="px-3 py-2 text-left font-medium text-gray-600">Client</th>
                  <th className="px-3 py-2 text-left font-medium text-gray-600">Serial Numbers</th>
                  <th className="px-3 py-2 text-left font-medium text-gray-600"># Passwords</th>
                  <th className="px-3 py-2 text-left font-medium text-gray-600">Length</th>
                  <th className="px-3 py-2 text-left font-medium text-gray-600">Alpha</th>
                  <th className="px-3 py-2 text-left font-medium text-gray-600">Created</th>
                  <th className="px-3 py-2 text-left font-medium text-gray-600 w-16">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {generations.map((gen) => (
                  <tr key={gen.label_pass_gen_id} className="hover:bg-gray-50">
                    <td className="px-3 py-2">
                      {(gen.spreadsheet_name || gen.num_sub_spreadsheets > 0) && (
                        <button className="text-emerald-600 hover:text-emerald-700" title="Download spreadsheet">
                          <FileSpreadsheet className="w-4 h-4" />
                        </button>
                      )}
                    </td>
                    <td className="px-3 py-2 text-gray-900 font-medium">
                      {gen.num_sub_spreadsheets > 0 ? '-' : (gen.company_name || '-')}
                    </td>
                    <td className="px-3 py-2 text-gray-600">
                      {gen.num_sub_spreadsheets > 0
                        ? '-'
                        : gen.first_serial_num && gen.last_serial_num
                          ? `${gen.first_serial_num}-${gen.last_serial_num}`
                          : '-'}
                    </td>
                    <td className="px-3 py-2 text-gray-600">{gen.num_passwords?.toLocaleString() || 0}</td>
                    <td className="px-3 py-2 text-gray-600">{gen.password_length}</td>
                    <td className="px-3 py-2 text-gray-600">{gen.alpha_char || '-'}</td>
                    <td className="px-3 py-2 text-gray-500">{formatDate(gen.create_dt)}</td>
                    <td className="px-3 py-2">
                      <button className="p-1 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded transition-colors">
                        <Edit2 className="w-3.5 h-3.5" />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}

        {!loading && !error && generations.length === 0 && (
          <div className="p-6 text-center text-xs text-gray-500">
            No password generations found.
          </div>
        )}
      </div>

      {/* Add New Modal */}
      {showAddModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-lg max-h-[90vh] overflow-y-auto m-4">
            <div className="flex items-center justify-between px-4 py-3 border-b border-gray-100">
              <h3 className="text-sm font-semibold text-gray-900">Generate Labels</h3>
              <button onClick={() => setShowAddModal(false)} className="text-gray-400 hover:text-gray-600">
                <X className="w-4 h-4" />
              </button>
            </div>
            <form onSubmit={handleAddNew} className="p-4 space-y-4">
              <div>
                <h4 className="text-xs font-semibold text-gray-700 mb-3">Password Details</h4>
                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="block text-[11px] font-medium text-gray-600 mb-1">Client</label>
                    <select
                      value={newGen.client}
                      onChange={(e) => setNewGen({ ...newGen, client: e.target.value })}
                      className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500 bg-white"
                    >
                      <option value="">Choose Client</option>
                      {clients.map((c) => (
                        <option key={c.client_id} value={c.client_id}>{c.company_name}</option>
                      ))}
                    </select>
                  </div>
                  <div>
                    <label className="block text-[11px] font-medium text-gray-600 mb-1"># Passwords</label>
                    <input
                      type="text"
                      value={newGen.numPasswords}
                      onChange={(e) => setNewGen({ ...newGen, numPasswords: e.target.value })}
                      placeholder="Enter a number"
                      className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label className="block text-[11px] font-medium text-gray-600 mb-1">Password Length</label>
                    <select
                      value={newGen.passLength}
                      onChange={(e) => setNewGen({ ...newGen, passLength: e.target.value })}
                      className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500 bg-white"
                    >
                      {[...Array(30)].map((_, i) => (
                        <option key={i + 1} value={i + 1}>{i + 1}</option>
                      ))}
                    </select>
                  </div>
                  <div>
                    <label className="block text-[11px] font-medium text-gray-600 mb-1">Include Letter?</label>
                    <select
                      value={newGen.includeLetter}
                      onChange={(e) => setNewGen({ ...newGen, includeLetter: e.target.value })}
                      className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500 bg-white"
                    >
                      <option value="0">No</option>
                      <option value="1">Yes - Start with provided letter</option>
                      <option value="2">Yes - End with provided letter</option>
                      <option value="3">Yes - Start with random letter</option>
                      <option value="4">Yes - End with random letter</option>
                    </select>
                  </div>
                  <div>
                    <label className="block text-[11px] font-medium text-gray-600 mb-1">Letter</label>
                    <input
                      type="text"
                      maxLength={1}
                      value={newGen.letter}
                      onChange={(e) => setNewGen({ ...newGen, letter: e.target.value.toUpperCase() })}
                      placeholder="A-Z"
                      className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label className="block text-[11px] font-medium text-gray-600 mb-1">Note</label>
                    <input
                      type="text"
                      value={newGen.note}
                      onChange={(e) => setNewGen({ ...newGen, note: e.target.value })}
                      placeholder="Internal note"
                      className="w-full px-2.5 py-1.5 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
                    />
                  </div>
                </div>
              </div>

              <div>
                <h4 className="text-xs font-semibold text-gray-700 mb-3">Options</h4>
                <div className="space-y-2">
                  <label className="flex items-center gap-2 text-xs text-gray-600">
                    <input
                      type="checkbox"
                      checked={newGen.verifyOnce}
                      onChange={(e) => setNewGen({ ...newGen, verifyOnce: e.target.checked })}
                      className="w-3.5 h-3.5 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                    />
                    Verify Only Once?
                  </label>
                  <label className="flex items-center gap-2 text-xs text-gray-600">
                    <input
                      type="checkbox"
                      checked={newGen.excludeStats}
                      onChange={(e) => setNewGen({ ...newGen, excludeStats: e.target.checked })}
                      className="w-3.5 h-3.5 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                    />
                    Exclude from statistics?
                  </label>
                  <label className="flex items-center gap-2 text-xs text-gray-600">
                    <input
                      type="checkbox"
                      checked={newGen.includeSerial}
                      onChange={(e) => setNewGen({ ...newGen, includeSerial: e.target.checked })}
                      className="w-3.5 h-3.5 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                    />
                    Include Serial Number in spreadsheet?
                  </label>
                </div>
              </div>

              <div className="flex gap-2 pt-2">
                <button
                  type="submit"
                  className="flex-1 px-3 py-2 bg-blue-600 text-white text-xs font-medium rounded-lg hover:bg-blue-700 transition-colors"
                >
                  Generate
                </button>
                <button
                  type="button"
                  onClick={() => setShowAddModal(false)}
                  className="px-3 py-2 bg-gray-100 text-gray-700 text-xs font-medium rounded-lg hover:bg-gray-200 transition-colors"
                >
                  Cancel
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
