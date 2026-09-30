import type { Metadata } from 'next';
import './globals.css';
export const metadata:Metadata={title:'Irmak Restaurant | Digital Menu',description:'Explore the Irmak Restaurant menu, order from your table, or call a waiter.'};
export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="en"><body>{children}</body></html>}
