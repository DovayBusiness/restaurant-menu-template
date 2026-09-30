import { createClient, SupabaseClient } from '@supabase/supabase-js';
let client: SupabaseClient | null | undefined;
export function getSupabase(): SupabaseClient | null {
  if (client !== undefined) return client;
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  client = url && key ? createClient(url, key, { auth: { persistSession: true, autoRefreshToken: true } }) : null;
  return client;
}
export const money = (amount: number) => new Intl.NumberFormat('tr-TR', { style:'currency', currency:'TRY', maximumFractionDigits:0 }).format(amount);
