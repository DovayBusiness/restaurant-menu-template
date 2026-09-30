export type Category = { id:string; slug:string; name_en:string; name_tr:string };
export type Dish = { id:string; name_en:string; name_tr:string; desc_en:string; desc_tr:string; price:number; image_url:string; category_id:string; tags:string[]; is_available:boolean; is_popular:boolean };
export const demoCategories:Category[] = [
 {id:'cat-1',slug:'mezze',name_en:'Mezze',name_tr:'Mezeler'},
 {id:'cat-2',slug:'grills',name_en:'Grills',name_tr:'Izgaralar'},
 {id:'cat-3',slug:'lebanese-plates',name_en:'Lebanese Plates',name_tr:'Lübnan Tabakları'},
 {id:'cat-4',slug:'manakish',name_en:'Manakish',name_tr:'Manakish'},
 {id:'cat-5',slug:'wraps',name_en:'Wraps',name_tr:'Dürümler'},
 {id:'cat-6',slug:'drinks',name_en:'Drinks',name_tr:'İçecekler'},
 {id:'cat-7',slug:'desserts',name_en:'Desserts',name_tr:'Tatlılar'}
];
const photos=['arze-hummus.jpg','arze-tabbouleh.jpg','arze-baba-ghanouj.jpg','arze-kibbeh.jpg','arze-mixed-grill.jpg','arze-shish-taouk.jpg','arze-kafta.jpg','arze-chicken-shawarma.jpg','arze-zaatar-manoushe.jpg','arze-falafel-wrap.jpg','arze-mint-lemonade.jpg','photo-1488477181946-6428a0291777'];
const imageBase=`${process.env.NEXT_PUBLIC_BASE_PATH||''}/images/`;
const dishSeed=[
 ['Hummus bi Tahini','Tahinli Humus','Whipped chickpeas, tahini, lemon and Lebanese olive oil.','Tahin, limon ve Lübnan zeytinyağıyla hazırlanan humus.',220,0,['Vegetarian','Mezze'],true],
 ['Tabbouleh','Tabbule','Parsley, tomato, fine bulgur, mint and lemon.','Maydanoz, domates, ince bulgur, nane ve limon.',190,0,['Vegetarian','Fresh'],true],
 ['Baba Ghanouj','Babagannuş','Smoky eggplant, tahini, garlic and pomegranate.','Köz patlıcan, tahin, sarımsak ve nar ekşisi.',210,0,['Vegetarian','Mezze'],false],
 ['Kibbeh','İçli Köfte','Crisp bulgur shell filled with spiced beef and pine nuts.','Baharatlı dana eti ve çam fıstıklı çıtır bulgur köftesi.',290,0,['Lebanese classic'],true],
 ['Mixed Grill','Karışık Lübnan Izgara','Kafta, shish taouk and lamb, hot from the charcoal grill.','Kafta, tavuk şiş ve kuzu eti, közden sıcak servis.',620,1,['Grilled','Chef special'],true],
 ['Shish Taouk','Şiş Tavuk','Garlic-marinated chicken, toum, pickles and warm pita.','Sarımsaklı marine tavuk, toum, turşu ve sıcak pita.',480,1,['Grilled','Popular'],true],
 ['Kafta Meshwi','Izgara Kafta','Parsley and spice-seasoned beef kafta with grilled vegetables.','Maydanozlu baharatlı dana kafta ve köz sebzeler.',470,1,['Grilled'],false],
 ['Chicken Shawarma Plate','Tavuk Şavurma Tabağı','Shawarma-spiced chicken, toum, pickles and rice.','Şavurma baharatlı tavuk, toum, turşu ve pilav.',430,2,['Popular'],true],
 ['Zaatar Manoushe','Za’atar Manuşe','Baked flatbread with za’atar, sumac, sesame and olive oil.','Za’atar, sumak, susam ve zeytinyağlı fırın ekmeği.',180,3,['Vegetarian','Baked fresh'],true],
 ['Falafel Wrap','Falafel Dürüm','Chickpea falafel, tahini, pickles and fresh herbs in pita.','Nohut falafeli, tahin, turşu ve taze otlarla pita dürüm.',320,4,['Vegetarian'],false],
 ['Mint Lemonade','Naneli Limonata','Fresh lemon, garden mint and a touch of sweetness.','Taze limon, nane ve hafif şekerle hazırlanır.',160,5,['House favorite'],true],
 ['Lebanese Baklava','Lübnan Baklavası','Delicate pastry, pistachio and fragrant syrup.','İnce yufka, Antep fıstığı ve aromalı şerbet.',210,6,['Dessert'],true]
] as const;
export const demoDishes:Dish[]=dishSeed.map((d,i)=>({id:`dish-${i+1}`,name_en:d[0],name_tr:d[1],desc_en:d[2],desc_tr:d[3],price:d[4],image_url:photos[i].startsWith('photo-')?`https://images.unsplash.com/${photos[i]}?auto=format&fit=crop&w=900&q=82`:`${imageBase}${photos[i]}`,category_id:`cat-${d[5]+1}`,tags:[...d[6]],is_available:true,is_popular:d[7]}));
