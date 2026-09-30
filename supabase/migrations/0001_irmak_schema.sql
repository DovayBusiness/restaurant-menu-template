-- Irmak Restaurant QR ordering schema. Run in a NEW Supabase project only.
create extension if not exists pgcrypto;

create table if not exists public.tables (
  id uuid primary key default gen_random_uuid(),
  number integer not null unique check (number between 1 and 999),
  qr_code text not null,
  is_occupied boolean not null default false,
  created_at timestamptz not null default now()
);
create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  name_en text not null,
  name_tr text not null,
  slug text not null unique,
  created_at timestamptz not null default now()
);
create table if not exists public.menu_items (
  id uuid primary key default gen_random_uuid(),
  name_en text not null,
  name_tr text not null,
  desc_en text not null default '',
  desc_tr text not null default '',
  price integer not null check (price >= 0),
  image_url text not null default '',
  category_id uuid not null references public.categories(id) on delete restrict,
  tags text[] not null default '{}',
  is_available boolean not null default true,
  is_popular boolean not null default false,
  created_at timestamptz not null default now()
);
create table if not exists public.orders (
  id text primary key,
  table_number integer not null references public.tables(number),
  items jsonb not null check (jsonb_typeof(items) = 'array'),
  total integer not null check (total >= 0),
  note text not null default '',
  status text not null default 'New' check (status in ('New','Preparing','Ready','Served')),
  created_at timestamptz not null default now()
);
create table if not exists public.waiter_calls (
  id uuid primary key default gen_random_uuid(),
  table_number integer not null references public.tables(number),
  called_at timestamptz not null default now(),
  acknowledged_at timestamptz,
  status text not null default 'pending' check (status in ('pending','acknowledged','completed'))
);
create index if not exists orders_status_created_idx on public.orders(status,created_at desc);
create index if not exists waiter_calls_status_called_idx on public.waiter_calls(status,called_at desc);
create index if not exists menu_items_category_idx on public.menu_items(category_id,is_available);

-- Enforce the 60-second per-table waiter-call cooldown in the database too.
create or replace function public.irmak_enforce_waiter_call_cooldown() returns trigger
language plpgsql security definer set search_path = public
as $$
begin
  perform pg_advisory_xact_lock(hashtext(NEW.table_number::text)::bigint);
  if exists (
    select 1 from public.waiter_calls wc
    where wc.table_number = NEW.table_number
      and wc.called_at > now() - interval '60 seconds'
  ) then
    raise exception 'Please wait before calling a waiter again.';
  end if;
  return NEW;
end;
$$;
drop trigger if exists waiter_call_cooldown on public.waiter_calls;
create trigger waiter_call_cooldown before insert on public.waiter_calls
for each row execute function public.irmak_enforce_waiter_call_cooldown();

-- Do not trust prices or totals posted by a guest's browser.
create or replace function public.irmak_validate_order() returns trigger
language plpgsql security definer set search_path = public
as $$
declare
  item jsonb;
  normalized_items jsonb := '[]'::jsonb;
  item_id uuid;
  item_qty integer;
  item_price integer;
  item_name text;
  item_available boolean;
  computed_total bigint := 0;
begin
  if jsonb_typeof(NEW.items) is distinct from 'array'
     or jsonb_array_length(NEW.items) < 1
     or jsonb_array_length(NEW.items) > 50 then
    raise exception 'An order must contain between 1 and 50 items.';
  end if;
  for item in select value from jsonb_array_elements(NEW.items)
  loop
    if jsonb_typeof(item) is distinct from 'object' then
      raise exception 'Invalid order item.';
    end if;
    begin
      item_id := (item->>'id')::uuid;
      item_qty := (item->>'qty')::integer;
    exception when invalid_text_representation or numeric_value_out_of_range then
      raise exception 'Invalid menu item or quantity.';
    end;
    if item_qty < 1 or item_qty > 99 then
      raise exception 'Item quantity must be between 1 and 99.';
    end if;
    select mi.price, mi.name_en, mi.is_available into item_price, item_name, item_available
      from public.menu_items mi where mi.id = item_id;
    if not found or not item_available then
      raise exception 'A selected dish is unavailable.';
    end if;
    computed_total := computed_total + item_qty::bigint * item_price::bigint;
    if computed_total > 2147483647 then
      raise exception 'Order total is too large.';
    end if;
    normalized_items := normalized_items || jsonb_build_array(item || jsonb_build_object('price', item_price, 'name', item_name));
  end loop;
  NEW.items := normalized_items;
  NEW.total := computed_total::integer;
  return NEW;
end;
$$;
drop trigger if exists validate_order on public.orders;
create trigger validate_order before insert on public.orders
for each row execute function public.irmak_validate_order();

create or replace function public.irmak_is_admin() returns boolean
language sql stable security definer set search_path = public
as $$ select coalesce(auth.jwt()->'app_metadata'->>'role' = 'admin', false); $$;

alter table public.tables enable row level security;
alter table public.categories enable row level security;
alter table public.menu_items enable row level security;
alter table public.orders enable row level security;
alter table public.waiter_calls enable row level security;

drop policy if exists "public reads tables" on public.tables;
create policy "public reads tables" on public.tables for select to anon, authenticated using (true);
drop policy if exists "admins manage tables" on public.tables;
create policy "admins manage tables" on public.tables for all to authenticated using (public.irmak_is_admin()) with check (public.irmak_is_admin());
drop policy if exists "public reads categories" on public.categories;
create policy "public reads categories" on public.categories for select to anon, authenticated using (true);
drop policy if exists "admins manage categories" on public.categories;
create policy "admins manage categories" on public.categories for all to authenticated using (public.irmak_is_admin()) with check (public.irmak_is_admin());
drop policy if exists "public reads available menu" on public.menu_items;
drop policy if exists "public reads all menu" on public.menu_items;
create policy "public reads all menu" on public.menu_items for select to anon, authenticated using (true);
drop policy if exists "admins manage menu" on public.menu_items;
create policy "admins manage menu" on public.menu_items for all to authenticated using (public.irmak_is_admin()) with check (public.irmak_is_admin());
drop policy if exists "guests place orders" on public.orders;
create policy "guests place orders" on public.orders for insert to anon, authenticated with check (status = 'New' and exists (select 1 from public.tables t where t.number = table_number));
drop policy if exists "admins read orders" on public.orders;
create policy "admins read orders" on public.orders for select to authenticated using (public.irmak_is_admin());
drop policy if exists "admins update orders" on public.orders;
create policy "admins update orders" on public.orders for update to authenticated using (public.irmak_is_admin()) with check (public.irmak_is_admin());
drop policy if exists "guests call waiter" on public.waiter_calls;
create policy "guests call waiter" on public.waiter_calls for insert to anon, authenticated with check (status = 'pending' and exists (select 1 from public.tables t where t.number = table_number));
drop policy if exists "admins read waiter calls" on public.waiter_calls;
create policy "admins read waiter calls" on public.waiter_calls for select to authenticated using (public.irmak_is_admin());
drop policy if exists "admins update waiter calls" on public.waiter_calls;
create policy "admins update waiter calls" on public.waiter_calls for update to authenticated using (public.irmak_is_admin()) with check (public.irmak_is_admin());

insert into public.categories(id,name_en,name_tr,slug) values
('10000000-0000-4000-8000-000000000001','Starters','Başlangıçlar','starters'),
('10000000-0000-4000-8000-000000000002','Kebabs','Kebaplar','kebabs'),
('10000000-0000-4000-8000-000000000003','Mains','Ana Yemekler','mains'),
('10000000-0000-4000-8000-000000000004','Pizzas','Pizzalar','pizzas'),
('10000000-0000-4000-8000-000000000005','Burgers','Burgerler','burgers'),
('10000000-0000-4000-8000-000000000006','Drinks','İçecekler','drinks'),
('10000000-0000-4000-8000-000000000007','Desserts','Tatlılar','desserts')
on conflict (slug) do nothing;

insert into public.menu_items(id,name_en,name_tr,desc_en,desc_tr,price,image_url,category_id,tags,is_available,is_popular) values
('20000000-0000-4000-8000-000000000001','Smoky Eggplant Dip','Köz Patlıcan Ezmesi','Charred eggplant, tahini, warm pita.','Köz patlıcan, tahin, sıcak pide.',180,'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=82','10000000-0000-4000-8000-000000000001',array['Veg 🌱'],true,true),
('20000000-0000-4000-8000-000000000002','Crispy Halloumi','Çıtır Hellim','Golden halloumi, honey, sesame.','Altın hellim, bal, susam.',220,'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=900&q=82','10000000-0000-4000-8000-000000000001',array['Veg 🌱'],true,false),
('20000000-0000-4000-8000-000000000003','Adana Kebab','Adana Kebap','Hand-minced lamb, grilled pepper, lavash.','Zırh kıyması kuzu, köz biber, lavaş.',380,'https://images.unsplash.com/photo-1534939561126-855b8675edd7?auto=format&fit=crop&w=900&q=82','10000000-0000-4000-8000-000000000002',array['Spicy 🌶️','Popular'],true,true),
('20000000-0000-4000-8000-000000000004','Chicken Shish','Tavuk Şiş','Marinated chicken, rice, grilled tomato.','Marine tavuk, pilav, köz domates.',340,'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=900&q=82','10000000-0000-4000-8000-000000000002',array['Popular'],true,true),
('20000000-0000-4000-8000-000000000005','Lamb Iskender','Kuzu İskender','Sliced lamb, tomato butter, yogurt.','Dilim kuzu, domatesli tereyağı, yoğurt.',440,'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=900&q=82','10000000-0000-4000-8000-000000000003',array['Chef Special 👨‍🍳'],true,true),
('20000000-0000-4000-8000-000000000006','Mushroom Pide','Mantarlı Pide','Wood-fired pide, mushrooms, kasar cheese.','Taş fırın pide, mantar, kaşar peyniri.',310,'https://images.unsplash.com/photo-1513558161293-cdaf765edfd7?auto=format&fit=crop&w=900&q=82','10000000-0000-4000-8000-000000000003',array['Veg 🌱'],true,false),
('20000000-0000-4000-8000-000000000007','Margherita','Margherita','Tomato, mozzarella, fresh basil.','Domates, mozzarella, taze fesleğen.',320,'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=900&q=82','10000000-0000-4000-8000-000000000004',array['Veg 🌱'],true,true),
('20000000-0000-4000-8000-000000000008','Sucuk Pizza','Sucuklu Pizza','Turkish sausage, mozzarella, pepper.','Sucuk, mozzarella, biber.',390,'https://images.unsplash.com/photo-1532634896-26909d0d4b8c?auto=format&fit=crop&w=900&q=82','10000000-0000-4000-8000-000000000004',array['Popular'],true,true),
('20000000-0000-4000-8000-000000000009','Irmak Burger','Irmak Burger','Grilled beef, aged cheddar, house sauce.','Izgara dana, cheddar, özel sos.',360,'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=82','10000000-0000-4000-8000-000000000005',array['Popular'],true,true),
('20000000-0000-4000-8000-000000000010','Garden Burger','Bahçe Burger','Crispy chickpea patty, pickled onion.','Nohut köftesi, turşu soğan.',300,'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=82','10000000-0000-4000-8000-000000000005',array['Veg 🌱'],true,false),
('20000000-0000-4000-8000-000000000011','Mint Ayran','Naneli Ayran','Chilled yogurt drink, fresh mint.','Soğuk yoğurt içeceği, taze nane.',80,'https://images.unsplash.com/photo-1544145945-f90425340c7e?auto=format&fit=crop&w=900&q=82','10000000-0000-4000-8000-000000000006',array['Popular'],true,true),
('20000000-0000-4000-8000-000000000012','Baklava & Ice Cream','Dondurmalı Baklava','Pistachio baklava, vanilla ice cream.','Fıstıklı baklava, vanilyalı dondurma.',190,'https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=900&q=82','10000000-0000-4000-8000-000000000007',array['Chef Special 👨‍🍳'],true,true)
on conflict (id) do nothing;

insert into public.tables(number,qr_code) select n,'/menu?table='||n from generate_series(1,30) n on conflict (number) do nothing;

do $$ begin
  alter publication supabase_realtime add table public.orders;
exception when duplicate_object then null; when undefined_object then null; end $$;
do $$ begin
  alter publication supabase_realtime add table public.waiter_calls;
exception when duplicate_object then null; when undefined_object then null; end $$;
