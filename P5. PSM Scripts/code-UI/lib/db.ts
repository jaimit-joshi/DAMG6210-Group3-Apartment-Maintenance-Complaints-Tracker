// Database connection file
// This app now uses Supabase (PostgreSQL) instead of SQL Server
// For database operations, import supabase from '@/lib/supabase'

// Example usage:
// import { supabase } from '@/lib/supabase'
// const { data, error } = await supabase.from('buildings').select('*')

// Legacy exports for backward compatibility - use supabase client instead
export async function executeQuery(query: string, params?: any[]) {
  throw new Error(
    "SQL Server connection is deprecated. Use Supabase instead. Import { supabase } from '@/lib/supabase'",
  )
}

export async function getPool() {
  throw new Error("SQL Server pool is deprecated. Use Supabase instead. Import { supabase } from '@/lib/supabase'")
}
