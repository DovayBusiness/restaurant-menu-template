import type { Config } from 'tailwindcss';
const config: Config = { content: ['./app/**/*.{ts,tsx}', './components/**/*.{ts,tsx}'], theme: { extend: { colors: { ink:'#111111', paper:'#FFFBF7', ember:'#FF6B00', muted:'#78716c' }, boxShadow: { soft:'0 18px 50px rgba(28,25,23,.08)' } } }, plugins: [] };
export default config;
