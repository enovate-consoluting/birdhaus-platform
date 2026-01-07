/**
 * Clients Page - Compact grid with hover actions
 * Last Modified: January 2026
 */

'use client';

import { useState } from 'react';
import { Search, Link2, Settings, RefreshCw, Shield, MoreHorizontal, Tag, Smartphone } from 'lucide-react';

// Placeholder data - will connect to Supabase
const placeholderClients = [
  { id: '1', name: '9ines', logo: null, active: true, labels: 245, nfc: 50 },
  { id: '2', name: 'Ace of Spades', logo: null, active: true, labels: 180, nfc: 30 },
  { id: '3', name: 'Akashic', logo: null, active: true, labels: 320, nfc: 75 },
  { id: '4', name: 'Aloha', logo: null, active: false, labels: 0, nfc: 0 },
  { id: '5', name: 'ANF Inc', logo: null, active: true, labels: 156, nfc: 42 },
  { id: '6', name: 'Arcadia', logo: null, active: false, labels: 89, nfc: 0 },
  { id: '7', name: 'Astro', logo: null, active: true, labels: 412, nfc: 100 },
  { id: '8', name: 'Aura', logo: null, active: false, labels: 67, nfc: 15 },
  { id: '9', name: 'Automatik', logo: null, active: false, labels: 0, nfc: 0 },
  { id: '10', name: 'Baby Vapes', logo: null, active: true, labels: 523, nfc: 120 },
  { id: '11', name: 'Backpack Boyz', logo: null, active: true, labels: 890, nfc: 200 },
  { id: '12', name: 'Baked Bar', logo: null, active: false, labels: 45, nfc: 10 },
  { id: '13', name: 'Balanse', logo: null, active: true, labels: 234, nfc: 55 },
  { id: '14', name: 'Baller Brand', logo: null, active: false, labels: 123, nfc: 25 },
  { id: '15', name: 'Bang Bar', logo: null, active: true, labels: 345, nfc: 80 },
  { id: '16', name: 'Barbas', logo: null, active: true, labels: 198, nfc: 45 },
];

export default function ClientsPage() {
  const [searchQuery, setSearchQuery] = useState('');
  const [clients] = useState(placeholderClients);

  const filteredClients = clients.filter((client) =>
    client.name.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const activeCount = clients.filter(c => c.active).length;

  return (
    <div className="p-3 lg:p-4">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4">
        <div>
          <h1 className="text-sm font-semibold text-gray-900">Clients</h1>
          <p className="text-[11px] text-gray-500">{clients.length} total • {activeCount} active</p>
        </div>
        <div className="relative">
          <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-gray-400" />
          <input
            type="text"
            placeholder="Search by company..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="pl-8 pr-3 py-1.5 w-full sm:w-52 text-xs border border-gray-200 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500"
          />
        </div>
      </div>

      {/* Client Grid - More columns */}
      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 2xl:grid-cols-6 gap-2">
        {filteredClients.map((client) => (
          <ClientCard key={client.id} client={client} />
        ))}
      </div>

      {filteredClients.length === 0 && (
        <div className="text-center py-8">
          <p className="text-xs text-gray-500">No clients found.</p>
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
    labels: number;
    nfc: number;
  };
}

function ClientCard({ client }: ClientCardProps) {
  const [isActive, setIsActive] = useState(client.active);
  const [isHovered, setIsHovered] = useState(false);

  return (
    <div
      className="bg-white rounded-lg border border-gray-100 hover:border-gray-200 hover:shadow-sm transition-all relative group"
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
    >
      {/* Top Row */}
      <div className="flex items-center justify-between px-2.5 pt-2">
        <button className="p-1 text-gray-300 hover:text-blue-500 rounded transition-colors">
          <Link2 className="w-3 h-3" />
        </button>
        <button
          onClick={() => setIsActive(!isActive)}
          className={`relative w-7 h-4 rounded-full transition-colors ${isActive ? 'bg-blue-500' : 'bg-gray-300'}`}
        >
          <span className={`absolute top-0.5 w-3 h-3 bg-white rounded-full shadow transition-transform ${isActive ? 'left-3.5' : 'left-0.5'}`} />
        </button>
      </div>

      {/* Logo */}
      <div className="px-2.5 py-3 flex items-center justify-center min-h-[70px]">
        {client.logo ? (
          <img src={client.logo} alt={client.name} className="max-w-[70px] max-h-[50px] object-contain" />
        ) : (
          <div className="w-16 h-10 bg-gray-50 rounded flex items-center justify-center">
            <span className="text-[9px] text-gray-400">Logo</span>
          </div>
        )}
      </div>

      {/* Name + Stats */}
      <div className="px-2.5 pb-2 text-center">
        <h3 className="text-[11px] font-medium text-gray-900 truncate">{client.name}</h3>
        <div className="flex items-center justify-center gap-2 mt-1">
          <span className="flex items-center gap-0.5 text-[9px] text-gray-400">
            <Tag className="w-2.5 h-2.5" />
            {client.labels}
          </span>
          <span className="flex items-center gap-0.5 text-[9px] text-gray-400">
            <Smartphone className="w-2.5 h-2.5" />
            {client.nfc}
          </span>
        </div>
      </div>

      {/* Hover Actions Overlay */}
      <div className={`absolute inset-x-0 bottom-0 bg-white border-t border-gray-100 rounded-b-lg flex items-center justify-around py-1.5 transition-opacity ${isHovered ? 'opacity-100' : 'opacity-0'}`}>
        <button className="p-1.5 text-gray-400 hover:text-blue-500 hover:bg-blue-50 rounded transition-colors" title="Security">
          <Shield className="w-3 h-3" />
        </button>
        <button className="p-1.5 text-gray-400 hover:text-blue-500 hover:bg-blue-50 rounded transition-colors" title="Options">
          <MoreHorizontal className="w-3 h-3" />
        </button>
        <button className="p-1.5 text-gray-400 hover:text-blue-500 hover:bg-blue-50 rounded transition-colors" title="Settings">
          <Settings className="w-3 h-3" />
        </button>
        <button className="p-1.5 text-gray-400 hover:text-blue-500 hover:bg-blue-50 rounded transition-colors" title="Sync">
          <RefreshCw className="w-3 h-3" />
        </button>
      </div>
    </div>
  );
}
