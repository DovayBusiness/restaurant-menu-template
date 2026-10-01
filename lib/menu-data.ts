import menuSeed from './menu-seed.json';
export type MenuSeedItem = { id:number; category:string; name_en:string; name_ar:string; description:string; ingredients:string; price_tl:number; tags:string[]; image_url:string };
export type Category = { id:string; slug:string; name_en:string; name_ar:string; name_tr:string };
export type Dish = { id:string; menu_number:number|null; category:string; name_en:string; name_ar:string; description:string; ingredients:string; price_tl:number; image_url:string; category_id:string; tags:string[]; is_available:boolean; is_popular:boolean; name_tr:string; desc_en:string; desc_tr:string; price:number };
export const MENU = menuSeed as MenuSeedItem[];
const categoryNames = [
 {id:'cat-1',slug:'01-cold-mezze',name_en:"Cold Mezze",name_ar:"مقبلات باردة",name_tr:"مقبلات باردة"},
 {id:'cat-2',slug:'02-salads',name_en:"Salads",name_ar:"سلطات",name_tr:"سلطات"},
 {id:'cat-3',slug:'03-hot-mezze',name_en:"Hot Mezze",name_ar:"مقبلات ساخنة",name_tr:"مقبلات ساخنة"},
 {id:'cat-4',slug:'04-manakish-breads',name_en:"Manakish & Breads",name_ar:"مناقيش وخبز",name_tr:"مناقيش وخبز"},
 {id:'cat-5',slug:'05-grills',name_en:"Grills",name_ar:"مشاوي",name_tr:"مشاوي"},
 {id:'cat-6',slug:'06-main-dishes',name_en:"Main Dishes",name_ar:"أطباق رئيسية",name_tr:"أطباق رئيسية"},
 {id:'cat-7',slug:'07-desserts',name_en:"Desserts",name_ar:"حلويات",name_tr:"حلويات"},
 {id:'cat-8',slug:'08-drinks',name_en:"Drinks",name_ar:"مشروبات",name_tr:"مشروبات"},
] as const;
export const demoCategories:Category[]=categoryNames as unknown as Category[];
const categoryId:Record<string,string>={"Cold Mezze":'cat-1',"Salads":'cat-2',"Hot Mezze":'cat-3',"Manakish & Breads":'cat-4',"Grills":'cat-5',"Main Dishes":'cat-6',"Desserts":'cat-7',"Drinks":'cat-8'};
export const demoDishes:Dish[]=MENU.map(item=>({id:`demo-${item.id}`,menu_number:item.id,category:item.category,name_en:item.name_en,name_ar:item.name_ar,description:item.description,ingredients:item.ingredients,price_tl:item.price_tl,image_url:item.image_url,category_id:categoryId[item.category],tags:[...item.tags],is_available:true,is_popular:item.tags.includes('Popular'),name_tr:item.name_ar,desc_en:item.description,desc_tr:item.description,price:item.price_tl}));
