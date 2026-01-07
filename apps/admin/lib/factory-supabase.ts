/**
 * Supabase Client - Factory Database (Secondary)
 * Used for: orders, order_products, manufacturers (if needed)
 * Last Modified: January 2026
 */

import { createClient } from '@supabase/supabase-js';

const factoryUrl = process.env.FACTORY_SUPABASE_URL!;
const factoryServiceKey = process.env.FACTORY_SUPABASE_SERVICE_ROLE_KEY!;

// Factory database client (server-side only - uses service role)
export function getFactorySupabase() {
  return createClient(factoryUrl, factoryServiceKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  });
}
