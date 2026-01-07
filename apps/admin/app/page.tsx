/**
 * Admin Dashboard - Landing Page
 * Shows overview and quick access to features
 * Roles: Super Admin, Admin+
 * Last Modified: January 2026
 */

export default function AdminDashboard() {
  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center space-x-4">
              <h1 className="text-xl font-semibold text-gray-900">
                Birdhaus Admin
              </h1>
              {/* Mode Switcher will go here */}
              <div className="ml-4 px-3 py-1 bg-blue-100 text-blue-800 text-sm rounded-full">
                Admin Mode
              </div>
            </div>
            <div className="flex items-center space-x-4">
              <span className="text-sm text-gray-500">Super Admin</span>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Welcome Section */}
        <div className="mb-8">
          <h2 className="text-2xl font-bold text-gray-900">Welcome to Birdhaus Admin</h2>
          <p className="mt-1 text-gray-500">
            Manage clients, labels, NFC tags, and platform settings.
          </p>
        </div>

        {/* Quick Stats */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <div className="card">
            <div className="text-sm font-medium text-gray-500">Total Clients</div>
            <div className="mt-1 text-3xl font-semibold text-gray-900">145</div>
          </div>
          <div className="card">
            <div className="text-sm font-medium text-gray-500">Active Labels</div>
            <div className="mt-1 text-3xl font-semibold text-gray-900">--</div>
          </div>
          <div className="card">
            <div className="text-sm font-medium text-gray-500">NFC Registrations</div>
            <div className="mt-1 text-3xl font-semibold text-gray-900">--</div>
          </div>
          <div className="card">
            <div className="text-sm font-medium text-gray-500">Pending Orders</div>
            <div className="mt-1 text-3xl font-semibold text-gray-900">--</div>
          </div>
        </div>

        {/* Feature Cards */}
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Admin Features</h3>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {/* Client Dashboard */}
          <div className="card hover:shadow-md transition-shadow cursor-pointer">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                <svg className="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
              </div>
              <div>
                <h4 className="font-medium text-gray-900">Client Dashboard</h4>
                <p className="text-sm text-gray-500">View and manage all clients</p>
              </div>
            </div>
          </div>

          {/* Labels Management */}
          <div className="card hover:shadow-md transition-shadow cursor-pointer">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
                <svg className="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
                </svg>
              </div>
              <div>
                <h4 className="font-medium text-gray-900">Labels</h4>
                <p className="text-sm text-gray-500">Manage label inventory</p>
              </div>
            </div>
          </div>

          {/* NFC Management */}
          <div className="card hover:shadow-md transition-shadow cursor-pointer">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center">
                <svg className="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z" />
                </svg>
              </div>
              <div>
                <h4 className="font-medium text-gray-900">NFC Tags</h4>
                <p className="text-sm text-gray-500">NFC registration admin</p>
              </div>
            </div>
          </div>
        </div>

        {/* Mode Switcher Preview */}
        <div className="mt-8 p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
          <div className="flex items-start space-x-3">
            <svg className="w-5 h-5 text-yellow-600 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <div>
              <h4 className="font-medium text-yellow-800">Mode Switcher Coming Soon</h4>
              <p className="text-sm text-yellow-700 mt-1">
                Switch between Admin and Factory Orders modes from the header.
                Factory Orders will open in the same browser session.
              </p>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
