export default function LebaneseFlag({ className = '' }: { className?: string }) {
  return (
    <span className={`inline-flex shrink-0 overflow-hidden rounded-md border border-black/10 bg-white shadow-sm ${className}`} role="img" aria-label="Lebanese flag with cedar tree">
      <svg viewBox="0 0 60 36" className="h-full w-full" aria-hidden="true">
        <rect width="60" height="36" fill="#FFFFFF" />
        <path d="M0 0h60v6H0zM0 30h60v6H0z" fill="#CE1126" />
        <path d="M30 6 26 12h2l-5 5h3l-6 5h7v6h6v-6h7l-6-5h3l-5-5h2z" fill="#007A3D" />
        <path d="M28 26h4v4h-4z" fill="#007A3D" />
      </svg>
    </span>
  );
}
