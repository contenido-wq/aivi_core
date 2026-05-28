export const C = {
  // ── Backgrounds ──────────────────────────────────────────
  bg:          "#050507",
  bgSecondary: "#08080A",
  nav:         "#08080A",
  sidebar:     "#08080A",
  panel:       "#111114",
  card:        "#171719",
  cardHover:   "#1E1E22",
  card2:       "#1C1C1F",

  // ── Borders ───────────────────────────────────────────────
  border:      "rgba(255,255,255,0.08)",
  borderMid:   "rgba(255,255,255,0.12)",
  borderHover: "rgba(255,107,44,0.45)",

  // ── Text ──────────────────────────────────────────────────
  white:       "#F4F4F5",
  muted:       "#5E5E70",
  mutedMid:    "#8E8EA0",
  mutedLight:  "#A0A0B4",
  label:       "#6F6F85",

  // ── Accents ───────────────────────────────────────────────
  orange:      "#FF6B2C",
  orangeLight: "#FF8A3D",
  orangeDark:  "#8A3418",

  yellow:      "#FFC247",
  green:       "#22C55E",
  greenSoft:   "rgba(34,197,94,0.12)",
  blue:        "#2FB7FF",
  red:         "#FF413B",
  teal:        "#2DD4BF",
  purple:      "#A78BFA",
  pink:        "#F472B6",

  // ── Gradients ─────────────────────────────────────────────
  grad:        "linear-gradient(135deg, #FFC247, #FF6B2C, #FF413B)",
  gradBtn:     "linear-gradient(135deg, #FF6B2C 0%, #8A3418 100%)",

  /** Hero KPI card — bold orange fill */
  gradCard:    "linear-gradient(135deg, rgba(255,107,44,0.32) 0%, rgba(83,31,15,0.35) 60%, #171719 100%)",

  /** LTV / financial highlight panel */
  gradFinance: "linear-gradient(135deg, rgba(255,107,44,0.18) 0%, rgba(23,23,25,0.95) 100%)",

  /** Retention progress bar */
  gradRetention: "linear-gradient(90deg, #22C55E, #B6E85C, #FFB84D)",
} as const;

export const FONT = "'Hanken Grotesk', sans-serif";
