export type Category = { id:string; slug:string; name_en:string; name_tr:string };
export type Dish = { id:string; name_en:string; name_tr:string; desc_en:string; desc_tr:string; price:number; image_url:string; category_id:string; tags:string[]; is_available:boolean; is_popular:boolean };
export const demoCategories:Category[] = [
 {id:'cat-1',slug:'starters',name_en:'Starters',name_tr:'Başlangıçlar'},
 {id:'cat-2',slug:'kebabs',name_en:'Kebabs',name_tr:'Kebaplar'},
 {id:'cat-3',slug:'mains',name_en:'Mains',name_tr:'Ana Yemekler'},
 {id:'cat-4',slug:'pizzas',name_en:'Pizzas',name_tr:'Pizzalar'},
 {id:'cat-5',slug:'burgers',name_en:'Burgers',name_tr:'Burgerler'},
 {id:'cat-6',slug:'drinks',name_en:'Drinks',name_tr:'İçecekler'},
 {id:'cat-7',slug:'desserts',name_en:'Desserts',name_tr:'Tatlılar'}
];
const photos=['photo-1547592180-85f173990554','photo-1544025162-d76694265947','photo-1534939561126-855b8675edd7','photo-1473093295043-cdd812d0e601','photo-1555396273-367ea4eb4db5','photo-1513558161293-cdaf765edfd7','photo-1578985545062-69928b1d9587','photo-1532634896-26909d0d4b8c','photo-1546069901-ba9599a7e63c','photo-1547592180-85f173990554','photo-1544145945-f90425340c7e','photo-1488477181946-6428a0291777'];
const dishSeed=[
 ['Smoky Eggplant Dip','Köz Patlıcan Ezmesi','Charred eggplant, tahini, warm pita.','Köz patlıcan, tahin, sıcak pide.',180,0,['Veg 🌱'],true],
 ['Crispy Halloumi','Çıtır Hellim','Golden halloumi, honey, sesame.','Altın hellim, bal, susam.',220,0,['Veg 🌱'],false],
 ['Adana Kebab','Adana Kebap','Hand-minced lamb, grilled pepper, lavash.','Zırh kıyması kuzu, köz biber, lavaş.',380,1,['Spicy 🌶️','Popular'],true],
 ['Chicken Shish','Tavuk Şiş','Marinated chicken, rice, grilled tomato.','Marine tavuk, pilav, köz domates.',340,1,['Popular'],true],
 ['Lamb Iskender','Kuzu İskender','Sliced lamb, tomato butter, yogurt.','Dilim kuzu, domatesli tereyağı, yoğurt.',440,2,['Chef Special 👨‍🍳'],true],
 ['Mushroom Pide','Mantarlı Pide','Wood-fired pide, mushrooms, kasar cheese.','Taş fırın pide, mantar, kaşar peyniri.',310,2,['Veg 🌱'],true],
 ['Margherita','Margherita','Tomato, mozzarella, fresh basil.','Domates, mozzarella, taze fesleğen.',320,3,['Veg 🌱'],true],
 ['Sucuk Pizza','Sucuklu Pizza','Turkish sausage, mozzarella, pepper.','Sucuk, mozzarella, biber.',390,3,['Popular'],true],
 ['Irmak Burger','Irmak Burger','Grilled beef, aged cheddar, house sauce.','Izgara dana, cheddar, özel sos.',360,4,['Popular'],true],
 ['Garden Burger','Bahçe Burger','Crispy chickpea patty, pickled onion.','Nohut köftesi, turşu soğan.',300,4,['Veg 🌱'],true],
 ['Mint Ayran','Naneli Ayran','Chilled yogurt drink, fresh mint.','Soğuk yoğurt içeceği, taze nane.',80,5,['Popular'],true],
 ['Baklava & Ice Cream','Dondurmalı Baklava','Pistachio baklava, vanilla ice cream.','Fıstıklı baklava, vanilyalı dondurma.',190,6,['Chef Special 👨‍🍳'],true]
] as const;
export const demoDishes:Dish[]=dishSeed.map((d,i)=>({id:`dish-${i+1}`,name_en:d[0],name_tr:d[1],desc_en:d[2],desc_tr:d[3],price:d[4],image_url:`https://images.unsplash.com/${photos[i]}?auto=format&fit=crop&w=900&q=82`,category_id:`cat-${d[5]+1}`,tags:[...d[6]],is_available:true,is_popular:d[7]}));
