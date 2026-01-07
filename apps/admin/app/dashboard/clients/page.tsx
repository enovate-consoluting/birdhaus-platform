/**
 * Clients Page - Admin Platform
 * Grid of client cards with action icons
 * Last Modified: January 2026
 */

'use client';

import { useState } from 'react';
import { Search, Link2, Settings, RefreshCw, Shield, MoreHorizontal } from 'lucide-react';

// Placeholder client data - will be replaced with real data from Supabase
const placeholderClients = [
  { id: '1', name: '9ines', logo: null, active: true },
  { id: '2', name: 'Ace of Spades', logo: null, active: true },
  { id: '3', name: 'Akashic', logo: null, active: true },
  { id: '4', name: 'Aloha', logo: null, active: false },
  { id: '5', name: 'ANF Inc', logo: null, active: true },
  { id: '6', name: 'Arcadia', logo: null, active: false },
  { id: '7', name: 'Astro', logo: null, active: true },
  { id: '8', name: 'Aura', logo: null, active: false },
  { id: '9', name: 'Automatik', logo: null, active: false },
  { id: '10', name: 'Baby Vapes', logo: null, active: true },
  { id: '11', name: 'Backpack Boyz', logo: null, active: true },
  { id: '12', name: 'Baked Bar', logo: null, active: false },
  { id: '13', name: 'Balanse', logo: null, active: true },
  { id: '14', name: 'Baller Brand', logo: null, active: false },
  { id: '15', name: 'Bang Bar', logo: null, active: true },
  { id: '16', name: 'Barbas', logo: null, active: true },
];

export default function ClientsPage() {
  const [searchQuery, setSearchQuery] = useState('');
  const [clients] = useState(placeholderClients);

  const filteredClients = clients.filter((client) =>
    client.name.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <div className="p-4 lg:p-6">
      {/* Header with Search */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
        <div>
          <h1 className="text-lg font-semibold text-gray-900">Clients</h1>
          <p className="text-sm text-gray-500">{clients.length} total clients</p>
        </div>
        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
          <input
            type="text"
            placeholder="Search by company..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="pl-9 pr-4 py-2 w-full sm:w-64 text-sm border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
        </div>
      </div>

      {/* Client Grid - 4 across on large screens */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
        {filteredClients.map((client) => (
          <ClientCard key={client.id} client={client} />
        ))}
      </div>

      {filteredClients.length === 0 && (
        <div className="text-center py-12">
          <p className="text-gray-500">No clients found matching your search.</p>
        </div>
      )}
    </div>
  );
}

interface ClientCardProps {
  client: {
    id: string;
    name: string;
    logo: string | null;
    active: boolean;
  };
}

function ClientCard({ client }: ClientCardProps) {
  const [isActive, setIsActive] = useState(client.active);

  return (
    <div className="bg-white rounded-xl border border-gray-200 shadow-sm hover:shadow-md transition-shadow">
      {/* Top Row - Link icon and Toggle */}
      <div className="flex items-center justify-between px-4 pt-3">
        <button className="p-1.5 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors">
          <Link2 className="w-4 h-4" />
        </button>
        <button
          onClick={() => setIsActive(!isActive)}
          className={`relative w-10 h-5 rounded-full transition-colors ${
            isActive ? 'bg-blue-600' : 'bg-gray-300'
          }`}
        >
          <span
            className={`absolute top-0.5 w-4 h-4 bg-white rounded-full shadow transition-transform ${
              isActive ? 'left-5' : 'left-0.5'
            }`}
          />
        </button>
      </div>

      {/* Logo Area */}
      <div className="px-4 py-6 flex items-center justify-center min-h-[120px]">
        {client.logo ? (
          <img
            src={client.logo}
            alt={client.name}
            className="max-w-[120px] max-h-[80px] object-contain"
          />
        ) : (
          <div className="w-24 h-16 bg-gray-100 rounded-lg flex items-center justify-center">
            <span className="text-xs text-gray-400 text-center px-2">Your Logo Here</span>
          </div>
        )}
      </div>

      {/* Client Name */}
      <div className="px-4 pb-3 text-center">
        <h3 className="text-sm font-medium text-gray-900 truncate">{client.name}</h3>
      </div>

      {/* Action Icons Row */}
      <div className="flex items-center justify-between px-4 py-3 border-t border-gray-100">
        <button className="p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors" title="Security">
          <Shield className="w-4 h-4" />
        </button>
        <button className="p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors" title="More Options">
          <MoreHorizontal className="w-4 h-4" />
        </button>
        <button className="p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors" title="Settings">
          <Settings className="w-4 h-4" />
        </button>
        <button className="p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors" title="Sync">
          <RefreshCw className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
}
