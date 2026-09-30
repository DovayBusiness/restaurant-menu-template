import type { Metadata } from 'next';
import './globals.css';
export const metadata:Metadata={title:'Arze Lebanese Restaurant | Digital Menu',description:'Lebanese mezze, charcoal grills and a warm welcome. Browse the Arze menu, order from your table or call a waiter.'};
export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="en"><body>{children}</body></html>}
