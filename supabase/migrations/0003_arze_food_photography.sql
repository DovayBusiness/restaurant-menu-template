-- Use the cohesive, locally hosted Arze food-photo set for the first eleven sample dishes.
-- Baklava keeps its current dessert photo until Arze supplies an approved replacement.
update public.menu_items
set image_url = case id
  when '20000000-0000-4000-8000-000000000001'::uuid then 'https://dovaybusiness.github.io/restaurant-menu-template/images/arze-hummus.jpg'
  when '20000000-0000-4000-8000-000000000002'::uuid then 'https://dovaybusiness.github.io/restaurant-menu-template/images/arze-tabbouleh.jpg'
  when '20000000-0000-4000-8000-000000000003'::uuid then 'https://dovaybusiness.github.io/restaurant-menu-template/images/arze-baba-ghanouj.jpg'
  when '20000000-0000-4000-8000-000000000004'::uuid then 'https://dovaybusiness.github.io/restaurant-menu-template/images/arze-kibbeh.jpg'
  when '20000000-0000-4000-8000-000000000005'::uuid then 'https://dovaybusiness.github.io/restaurant-menu-template/images/arze-mixed-grill.jpg'
  when '20000000-0000-4000-8000-000000000006'::uuid then 'https://dovaybusiness.github.io/restaurant-menu-template/images/arze-shish-taouk.jpg'
  when '20000000-0000-4000-8000-000000000007'::uuid then 'https://dovaybusiness.github.io/restaurant-menu-template/images/arze-kafta.jpg'
  when '20000000-0000-4000-8000-000000000008'::uuid then 'https://dovaybusiness.github.io/restaurant-menu-template/images/arze-chicken-shawarma.jpg'
  when '20000000-0000-4000-8000-000000000009'::uuid then 'https://dovaybusiness.github.io/restaurant-menu-template/images/arze-zaatar-manoushe.jpg'
  when '20000000-0000-4000-8000-000000000010'::uuid then 'https://dovaybusiness.github.io/restaurant-menu-template/images/arze-falafel-wrap.jpg'
  when '20000000-0000-4000-8000-000000000011'::uuid then 'https://dovaybusiness.github.io/restaurant-menu-template/images/arze-mint-lemonade.jpg'
  else image_url
end
where id in (
  '20000000-0000-4000-8000-000000000001'::uuid,
  '20000000-0000-4000-8000-000000000002'::uuid,
  '20000000-0000-4000-8000-000000000003'::uuid,
  '20000000-0000-4000-8000-000000000004'::uuid,
  '20000000-0000-4000-8000-000000000005'::uuid,
  '20000000-0000-4000-8000-000000000006'::uuid,
  '20000000-0000-4000-8000-000000000007'::uuid,
  '20000000-0000-4000-8000-000000000008'::uuid,
  '20000000-0000-4000-8000-000000000009'::uuid,
  '20000000-0000-4000-8000-000000000010'::uuid,
  '20000000-0000-4000-8000-000000000011'::uuid
);
