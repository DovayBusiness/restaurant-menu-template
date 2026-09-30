-- Rebrand the seeded restaurant menu as Arze Lebanese Kitchen.
-- Keeps the existing UUIDs, table QR codes, order history, and staff accounts.
update public.categories as c
set name_en = x.name_en, name_tr = x.name_tr, slug = x.slug
from (values
  ('10000000-0000-4000-8000-000000000001'::uuid, 'Mezze', 'Mezeler', 'mezze'),
  ('10000000-0000-4000-8000-000000000002'::uuid, 'Grills', 'Izgaralar', 'grills'),
  ('10000000-0000-4000-8000-000000000003'::uuid, 'Lebanese Plates', 'Lübnan Tabakları', 'lebanese-plates'),
  ('10000000-0000-4000-8000-000000000004'::uuid, 'Manakish', 'Manakish', 'manakish'),
  ('10000000-0000-4000-8000-000000000005'::uuid, 'Wraps', 'Dürümler', 'wraps'),
  ('10000000-0000-4000-8000-000000000006'::uuid, 'Drinks', 'İçecekler', 'drinks'),
  ('10000000-0000-4000-8000-000000000007'::uuid, 'Desserts', 'Tatlılar', 'desserts')
) as x(id, name_en, name_tr, slug)
where c.id = x.id;

update public.menu_items as m
set name_en = x.name_en,
    name_tr = x.name_tr,
    desc_en = x.desc_en,
    desc_tr = x.desc_tr,
    price = x.price,
    image_url = x.image_url,
    category_id = x.category_id,
    tags = x.tags,
    is_available = true,
    is_popular = x.is_popular
from (values
  ('20000000-0000-4000-8000-000000000001'::uuid, 'Hummus bi Tahini', 'Tahinli Humus', 'Whipped chickpeas, tahini, lemon and Lebanese olive oil.', 'Tahin, limon ve Lübnan zeytinyağıyla hazırlanan humus.', 220, 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=82', '10000000-0000-4000-8000-000000000001'::uuid, array['Vegetarian','Mezze']::text[], true),
  ('20000000-0000-4000-8000-000000000002'::uuid, 'Tabbouleh', 'Tabbule', 'Parsley, tomato, fine bulgur, mint and lemon.', 'Maydanoz, domates, ince bulgur, nane ve limon.', 190, 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=82', '10000000-0000-4000-8000-000000000001'::uuid, array['Vegetarian','Fresh']::text[], true),
  ('20000000-0000-4000-8000-000000000003'::uuid, 'Baba Ghanouj', 'Babagannuş', 'Smoky eggplant, tahini, garlic and pomegranate.', 'Köz patlıcan, tahin, sarımsak ve nar ekşisi.', 210, 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=900&q=82', '10000000-0000-4000-8000-000000000001'::uuid, array['Vegetarian','Mezze']::text[], false),
  ('20000000-0000-4000-8000-000000000004'::uuid, 'Kibbeh', 'İçli Köfte', 'Crisp bulgur shell filled with spiced beef and pine nuts.', 'Baharatlı dana eti ve çam fıstıklı çıtır bulgur köftesi.', 290, 'https://images.unsplash.com/photo-1534939561126-855b8675edd7?auto=format&fit=crop&w=900&q=82', '10000000-0000-4000-8000-000000000001'::uuid, array['Lebanese classic']::text[], true),
  ('20000000-0000-4000-8000-000000000005'::uuid, 'Mixed Grill', 'Karışık Lübnan Izgara', 'Kafta, shish taouk and lamb, hot from the charcoal grill.', 'Kafta, tavuk şiş ve kuzu eti, közden sıcak servis.', 620, 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=900&q=82', '10000000-0000-4000-8000-000000000002'::uuid, array['Grilled','Chef special']::text[], true),
  ('20000000-0000-4000-8000-000000000006'::uuid, 'Shish Taouk', 'Şiş Tavuk', 'Garlic-marinated chicken, toum, pickles and warm pita.', 'Sarımsaklı marine tavuk, toum, turşu ve sıcak pita.', 480, 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=900&q=82', '10000000-0000-4000-8000-000000000002'::uuid, array['Grilled','Popular']::text[], true),
  ('20000000-0000-4000-8000-000000000007'::uuid, 'Kafta Meshwi', 'Izgara Kafta', 'Parsley and spice-seasoned beef kafta with grilled vegetables.', 'Maydanozlu baharatlı dana kafta ve köz sebzeler.', 470, 'https://images.unsplash.com/photo-1534939561126-855b8675edd7?auto=format&fit=crop&w=900&q=82', '10000000-0000-4000-8000-000000000002'::uuid, array['Grilled']::text[], false),
  ('20000000-0000-4000-8000-000000000008'::uuid, 'Chicken Shawarma Plate', 'Tavuk Şavurma Tabağı', 'Shawarma-spiced chicken, toum, pickles and rice.', 'Şavurma baharatlı tavuk, toum, turşu ve pilav.', 430, 'https://images.unsplash.com/photo-1513558161293-cdaf765edfd7?auto=format&fit=crop&w=900&q=82', '10000000-0000-4000-8000-000000000003'::uuid, array['Popular']::text[], true),
  ('20000000-0000-4000-8000-000000000009'::uuid, 'Zaatar Manoushe', 'Za’atar Manuşe', 'Baked flatbread with za’atar, sumac, sesame and olive oil.', 'Za’atar, sumak, susam ve zeytinyağlı fırın ekmeği.', 180, 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=900&q=82', '10000000-0000-4000-8000-000000000004'::uuid, array['Vegetarian','Baked fresh']::text[], true),
  ('20000000-0000-4000-8000-000000000010'::uuid, 'Falafel Wrap', 'Falafel Dürüm', 'Chickpea falafel, tahini, pickles and fresh herbs in pita.', 'Nohut falafeli, tahin, turşu ve taze otlarla pita dürüm.', 320, 'https://images.unsplash.com/photo-1532634896-26909d0d4b8c?auto=format&fit=crop&w=900&q=82', '10000000-0000-4000-8000-000000000005'::uuid, array['Vegetarian']::text[], false),
  ('20000000-0000-4000-8000-000000000011'::uuid, 'Mint Lemonade', 'Naneli Limonata', 'Fresh lemon, garden mint and a touch of sweetness.', 'Taze limon, nane ve hafif şekerle hazırlanır.', 160, 'https://images.unsplash.com/photo-1544145945-f90425340c7e?auto=format&fit=crop&w=900&q=82', '10000000-0000-4000-8000-000000000006'::uuid, array['House favorite']::text[], true),
  ('20000000-0000-4000-8000-000000000012'::uuid, 'Lebanese Baklava', 'Lübnan Baklavası', 'Delicate pastry, pistachio and fragrant syrup.', 'İnce yufka, Antep fıstığı ve aromalı şerbet.', 210, 'https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=900&q=82', '10000000-0000-4000-8000-000000000007'::uuid, array['Dessert']::text[], true)
) as x(id, name_en, name_tr, desc_en, desc_tr, price, image_url, category_id, tags, is_popular)
where m.id = x.id;
