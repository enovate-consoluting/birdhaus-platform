# Admin Platform - Session Handoff
**Date:** January 7, 2026

---

## What Was Completed This Session

### 1. SSO (Single Sign-On) Between Apps
- **Factory Orders** (`birdhausapp.com`) ↔ **Admin** (`admin.birdhausapp.com`)
- Seamless switching - login once, toggle between apps without re-authenticating
- JWT tokens with 30-second expiration for security
- Mode switcher buttons in both app sidebars

**Key files:**
- Factory: `app/api/auth/sso-token/route.ts`, `app/api/auth/verify-sso/route.ts`, `app/auth/callback/page.tsx`
- Admin: Same structure in `apps/admin/app/api/auth/` and `apps/admin/app/auth/callback/`

**Environment variable needed:** `SSO_SECRET` (same value in both Vercel projects)

---

### 2. Admin Dashboard Layout
**Live at:** `admin.birdhausapp.com`

**Sidebar Navigation (collapsible sections):**
- Dashboard
- Clients
- Labels (expandable)
  - Generate
  - Manage
  - Add New
  - Validation
- NFC (expandable)
  - Inventory
  - Generate
  - Manage NFC Tag
  - Identify (fingerprint icon)
  - Demo
  - Error Logs

**Dashboard Page:**
- Stats cards with trends (Clients: 145, Labels: 2,847, NFC Tags: 1,203, Pending Orders: 18)
- Quick Actions grid (Generate Labels, Manage Labels, Validate Labels, NFC Identify)
- Recent Activity feed
- System Status panel

**Clients Page (`/dashboard/clients`):**
- Search bar (top right)
- 4-across grid of client cards
- Each card has:
  - Link icon (top left)
  - Toggle switch (top right)
  - Logo placeholder (center)
  - Company name
  - Action icons row: Shield, Menu, Settings, Sync

---

## Current File Structure

```
birdhaus-platform/
├── apps/
│   ├── admin/                    # Admin Platform (deployed)
│   │   ├── app/
│   │   │   ├── api/auth/         # SSO endpoints
│   │   │   ├── auth/callback/    # SSO callback page
│   │   │   ├── dashboard/
│   │   │   │   ├── layout.tsx    # Sidebar + layout
│   │   │   │   ├── page.tsx      # Dashboard
│   │   │   │   └── clients/
│   │   │   │       └── page.tsx  # Clients grid
│   │   │   └── login/
│   │   ├── lib/
│   │   │   ├── auth.ts           # Auth helpers
│   │   │   └── factory-supabase.ts
│   │   └── CLAUDE.md
│   └── factory/                  # Factory (local dev only, not deployed)
├── packages/
└── vercel.json                   # Build config for Admin only
```

**Production Factory Orders** is deployed from separate repo: `C:\Users\enova\projects\factory-orders`

---

## Deployments

| App | URL | Repo | Auto-deploy |
|-----|-----|------|-------------|
| Admin | admin.birdhausapp.com | birdhaus-platform (monorepo) | Yes (via Vercel CLI) |
| Factory Orders | birdhausapp.com | factory-orders | Yes (on git push) |

---

## Next Session - Where to Pick Up

### User Request:
> "I gave you a layout and you did it, it looks good, but I want to know - going to keep this layout as a backup - but I'm wondering if you think we should make something a little bit different or better for this layout. I'm open to it 'cause you're pretty slick when it comes to this stuff."

### Layout Suggestions to Discuss:
1. **Client cards** - Current design mirrors Scanacart. Consider:
   - Adding client stats (# of labels, last activity) on hover or in card
   - Color-coded status indicators
   - Quick action dropdown vs icon row

2. **Dashboard** - Could add:
   - Charts/graphs for trends over time
   - Filterable date ranges
   - Notifications panel

3. **Sidebar** - Currently functional. Could consider:
   - Favorites/pinned items
   - Recent items section
   - Collapsed icon-only mode

### Functionality to Build:
1. Connect Clients page to real Supabase data (Portal DB)
2. Labels pages (Generate, Manage, Add New, Validation)
3. NFC pages (Inventory, Generate, Manage, Identify, Demo, Error Logs)
4. Wire up action icons on client cards

---

## Commands to Resume

```bash
# Start Admin locally
cd C:\Users\enova\projects\birdhaus-platform
npm run dev:admin

# Start Factory locally (with prod data)
cd C:\Users\enova\projects\factory-orders
npm run dev:prod

# Deploy Admin manually
cd C:\Users\enova\projects\birdhaus-platform\apps\admin
npx vercel --prod --yes
```

---

## Key Credentials/Config

- **Admin Supabase:** Uses Portal DB (env vars in Vercel)
- **Factory Supabase:** env vars `FACTORY_SUPABASE_URL`, `FACTORY_SUPABASE_SERVICE_ROLE_KEY`
- **SSO Secret:** `SSO_SECRET` must match in both Vercel projects

---

*This document auto-generated for session handoff.*
