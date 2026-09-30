# Irmak Restaurant — QR Menu, Ordering & Irmak Screen

Responsive Next.js 14 + TypeScript + Tailwind app for a bilingual Turkish restaurant menu, table QR codes, no-payment orders, waiter calls, and a realtime kitchen/floor dashboard.

## Routes

- `/menu?table=5` — English/Turkish menu, search, categories, cart, kitchen note, no-payment order and waiter call.
- `/admin` — staff sign-in and Irmak Screen for live orders, waiter calls, menu/categories and tables.
- `/qr-print` — print QR codes for all tables; `/qr-print?table=5` prints one.

## Hosting and setup

This repository deploys the static Next.js export to GitHub Pages. The GitHub Actions workflow builds the app and publishes the `out/` directory. Supabase supplies the database, authentication and Realtime; no Vercel server is used.

The Irmak database is provisioned in its own Supabase project. Its SQL migration is in `supabase/migrations/0001_irmak_schema.sql`; it creates and seeds the restaurant tables, access policies, order validation, waiter-call cooldown and Realtime publication.

For local development, install Node.js 20+, run `npm install`, copy `.env.example` to `.env.local`, then run `npm run dev`. The deployed Pages app uses the project URL and public anon key supplied at build time in the workflow. The anon key is public by design; never use a service-role key in a browser or GitHub Pages build.

Before staff use, create staff Auth users and grant trusted `app_metadata.role=admin` through a secure server/admin process. Set the Supabase Auth Site URL and allowed redirect URLs to the GitHub Pages app URL. Replace sample menu content and confirm prices before launch.

Without Supabase configuration the app uses mock data only; demo mode does not send orders or waiter calls. With Supabase connected, guests pay at the cashier. No payment gateway or card collection is included.
