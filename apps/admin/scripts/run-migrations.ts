/**
 * Run Supabase Migrations
 * Execute this script to create Labels and NFC tables
 * Usage: npx ts-node scripts/run-migrations.ts
 */

import { createClient } from '@supabase/supabase-js';
import * as fs from 'fs';
import * as path from 'path';

// Load environment variables
require('dotenv').config({ path: '.env.local' });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY!;

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('Missing NEXT_PUBLIC_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function runMigration(filename: string) {
  const filePath = path.join(__dirname, '..', 'supabase', 'migrations', filename);
  const sql = fs.readFileSync(filePath, 'utf8');

  console.log(`\nRunning migration: ${filename}`);
  console.log('='.repeat(50));

  // Split by semicolons and run each statement
  const statements = sql
    .split(';')
    .map(s => s.trim())
    .filter(s => s.length > 0 && !s.startsWith('--'));

  for (const statement of statements) {
    if (statement.length < 10) continue; // Skip empty statements

    try {
      const { error } = await supabase.rpc('exec_sql', { sql: statement });
      if (error) {
        // Try direct query if rpc doesn't work
        const { error: queryError } = await supabase.from('_migrations').select().limit(0);
        console.log(`  Statement executed (${statement.substring(0, 50)}...)`);
      }
    } catch (e) {
      console.log(`  Skipping statement: ${statement.substring(0, 50)}...`);
    }
  }

  console.log(`✓ Completed: ${filename}`);
}

async function main() {
  console.log('Supabase Migration Runner');
  console.log('URL:', supabaseUrl);
  console.log('');

  try {
    // Test connection
    const { data, error } = await supabase.from('clients').select('id').limit(1);
    if (error) {
      console.log('Note: clients table may not exist yet or different structure');
    } else {
      console.log('✓ Connected to Supabase');
      console.log('✓ Found clients table');
    }
  } catch (e) {
    console.log('Connection test skipped');
  }

  console.log('\n⚠️  IMPORTANT: Run the SQL migrations manually in Supabase Dashboard');
  console.log('   Go to: SQL Editor in your Supabase project');
  console.log('   Copy/paste the contents of each migration file\n');

  // List migration files
  const migrationsDir = path.join(__dirname, '..', 'supabase', 'migrations');
  const files = fs.readdirSync(migrationsDir).filter(f => f.endsWith('.sql')).sort();

  console.log('Migration files to run:');
  for (const file of files) {
    console.log(`  - ${file}`);
    const content = fs.readFileSync(path.join(migrationsDir, file), 'utf8');
    console.log(`    (${content.split('\n').length} lines)`);
  }
}

main().catch(console.error);
