import type { Config } from 'tailwindcss';
const config: Config = { content: ['./app/**/*.{ts,tsx}', './components/**/*.{ts,tsx}'], theme: { extend: { colors: { ink:'#173D2E', paper:'#F1E7D7', ember:'#C7353D', cedar:'#087A43', muted:'#716B62' }, fontFamily:{display:['"Playfair Display"','serif']}, boxShadow: { soft:'0 18px 50px rgba(28,25,23,.08)' } } }, plugins: [] };
export default config;
