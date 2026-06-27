export const C = {
  // ── Backgrounds ──────────────────────────────────────────
  bg:          "#101010",
  bgSecondary: "#141414",
  nav:         "#141414",
  sidebar:     "#141414",
  panel:       "#1A1A1A",
  card:        "#1E1E1E",
  cardHover:   "#242424",
  card2:       "#222222",

  // ── Borders ───────────────────────────────────────────────
  border:      "rgba(255,255,255,0.08)",
  borderMid:   "rgba(255,255,255,0.12)",
  borderHover: "rgba(254,128,63,0.45)",

  // ── Text ──────────────────────────────────────────────────
  white:       "#FAFAFA",
  muted:       "#707087",
  mutedMid:    "#9898AA",
  mutedLight:  "#ABABBE",
  label:       "#7878A0",

  // ── Accents (brand guide: #FFC252 → #FE803F → #FF413B) ───
  orange:      "#FE803F",
  orangeLight: "#FFB07A",
  orangeDark:  "#C04A18",

  yellow:      "#FFC252",
  green:       "#30D158",   // real semantic green — positive states
  greenSoft:   "rgba(48,209,88,0.12)",
  blue:        "#FE803F",   // chart revenue bars = brand orange
  red:         "#FF413B",
  teal:        "#2DD4BF",
  purple:      "#A78BFA",   // chart investment line — distinct from orange/yellow
  pink:        "#FF413B",

  // ── Gradients (brand palette: yellow → orange → red) ─────
  grad:        "linear-gradient(135deg, #FFC252, #FE803F, #FF413B)",
  gradBtn:     "linear-gradient(135deg, #FFC252 0%, #FE803F 50%, #FF413B 100%)",

  /** Hero KPI card — bold orange fill */
  gradCard:    "linear-gradient(135deg, rgba(254,128,63,0.35) 0%, rgba(80,28,12,0.38) 60%, #1E1E1E 100%)",

  /** LTV / financial highlight panel */
  gradFinance: "linear-gradient(135deg, rgba(254,128,63,0.18) 0%, rgba(30,30,30,0.95) 100%)",

  /** Retention progress bar */
  gradRetention: "linear-gradient(90deg, #FFC252, #FE803F, #FF413B)",
} as const;

export const FONT = "'Hanken Grotesk', sans-serif";
