# CLAUDE.md - Birdhaus Admin Platform

**Last Updated:** January 2026

## Quick Start

```bash
# From monorepo root
npm run dev:admin

# Or from this directory
npm run dev
```

Runs on **port 3002** (factory is 3000, portal is 3001)

---

## Project Overview

**Birdhaus Admin Platform** - Internal administration for managing clients, labels, NFC tags, and platform settings.

| Tech | Version |
|------|---------|
| Framework | Next.js 15 (App Router) |
| Language | TypeScript |
| Database | Supabase PostgreSQL (Portal DB) |
| Styling | Tailwind CSS |
| Deployment | Vercel (admin.birdhausapp.com) |
| Auth | Supabase Auth |

---

## This App's Role

- **Who uses it:** Super Admins, Admin+ users (internal Birdhaus team)
- **What it does:** Manage all clients, labels, NFC features
- **Related apps:** Factory Orders (apps/factory), Portal (separate repo)

---

## Database Connections

### Primary: Portal Supabase
- Client management
- Labels
- NFC registrations (admin view)
- Portal users

### Secondary: Factory Supabase (if needed)
- Read orders data
- Already proven pattern in portal-birdhaus

---

## Code Rules

Same as factory-orders:

1. **Never remove existing functionality** unless asked
2. **File headers required** with description and last modified date
3. **Build before push:** `npm run build`
4. **TypeScript:** Use explicit types, avoid `any`
5. **Tailwind CSS only** for styling

---

## Features to Build

### Phase 1 (Priority)
- [ ] Labels Management - Create, edit, track labels
- [ ] NFC Admin - Manage NFC tags, view all registrations

### Phase 2
- [ ] Client Dashboard - Cards showing all 145+ clients
- [ ] Mode Switcher - Toggle between Admin and Factory Orders

### Phase 3
- [ ] Client Impersonation - Jump into client's portal view
- [ ] Reports/Analytics

---

## Project Structure

```
apps/admin/
├── app/
│   ├── layout.tsx          # Root layout
│   ├── page.tsx            # Dashboard home
│   ├── globals.css         # Global styles
│   ├── labels/             # Labels management (to build)
│   ├── nfc/                # NFC admin (to build)
│   └── clients/            # Client dashboard (to build)
├── components/
│   └── (shared components)
├── lib/
│   ├── supabase.ts         # Portal DB client
│   └── factory-supabase.ts # Factory DB client (if needed)
└── CLAUDE.md               # This file
```

---

## Environment Variables

```
NEXT_PUBLIC_SUPABASE_URL=        # Portal Supabase
NEXT_PUBLIC_SUPABASE_ANON_KEY=   # Portal Supabase
FACTORY_SUPABASE_URL=            # Factory Supabase (optional)
FACTORY_SUPABASE_SERVICE_ROLE_KEY= # Factory Supabase (optional)
```

---

## Related Documentation

- **Master Doc:** `/BIRDHAUS_PLATFORM.md` (monorepo root)
- **Factory Orders:** `apps/factory/CLAUDE.md`
- **Shared UI:** `packages/ui/`

---

*This file is the source of truth for the Admin app. Keep it updated.*
