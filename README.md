# Irmak Restaurant — QR Menu, Ordering & Irmak Screen

Responsive Next.js 14 + TypeScript + Tailwind app for a bilingual Turkish restaurant menu, table QR codes, no-payment orders, waiter calls, and a realtime kitchen/floor dashboard.

## Routes

- `/menu?table=5` — English/Turkish menu, search and categories, cart, kitchen note, submit order, and call waiter. Guests can choose a table if no table number is in the URL.
- `/admin` — staff sign-in and Irmak Screen (live orders, order status workflow, waiter calls, menu/category management, tables).
- `/qr-print` — print QR codes for all tables; `/qr-print?table=5` prints a single table code.

## Local setup

1. Install Node.js 20+ and run `npm install`.
2. Copy `.env.example` to `.env.local` and set `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` from a **new Supabase project dedicated to Irmak**.
3. In that new project's SQL Editor, run `supabase/migrations/0001_irmak_schema.sql`. It creates and seeds the schema, access policies, waiter-call cooldown trigger, and Realtime publication membership.
4. Create an Auth user for each staff member. Set that user's server-managed `app_metadata.role` to `admin` using a trusted server/admin process (never expose a service-role key in the browser).
5. Run `npm run dev` and open `http://localhost:3000/menu?table=5`.

Without Supabase environment variables, the customer menu and dashboard use sample/mock data for preview. **Demo mode does not persist, transmit, or send orders or waiter calls.** With Supabase connected, guests can place orders without online payment; guests pay at the cashier. No payment gateway or card collection is included.

The seeded Turkish menu, TRY prices, and Unsplash food photography are sample content; replace these with the restaurant's approved menu and images before launch.

## Supabase and security

- Use a separate, fresh Supabase project for Irmak. This migration is specifically intended for that database and must not be run against another product's project.
- Only the public URL and anon/publishable key belong in `NEXT_PUBLIC_*`. Never commit a service-role key, Supabase management token, or staff credentials.
- RLS restricts menu/table writes and dashboard reads/updates to authenticated users whose trusted `app_metadata.role` is `admin`; guest order and waiter-call inserts are allowed. The database enforces the 60-second per-table waiter-call cooldown as well as the UI timer.
- `orders` and `waiter_calls` are members of `supabase_realtime`. Enable/confirm Realtime for those tables in the separate project if the project-level configuration requires it.

## Deploy

Import `DovayBusiness/restaurant-menu-template` into Vercel as a Next.js app, use the repository root as the project root, and configure the two `NEXT_PUBLIC_SUPABASE_*` environment variables there. Apply the Supabase migration and set up the trusted admin account before using live ordering. QR codes should be generated/printed from the deployed Vercel or custom-domain origin.

**GitHub Pages is not the deployment target for this Next.js application.** The repository's existing root `index.html` has been preserved for the earlier static Pages demo; Pages will continue serving that static file. Use Vercel (or another Next.js-capable host) to run the app and its client-side Supabase/Realtime integration.
