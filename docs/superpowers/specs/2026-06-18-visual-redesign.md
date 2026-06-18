# AIVI Core — Visual Redesign: Brand Alignment

**Date:** 2026-06-18  
**Approach:** Brand Alignment (A) — calibrate tokens to brand guide, add Exo 2 as display font  
**Scope:** 5 files — tokens, CSS, Sidebar, KPIRow, TopNav  
**Reference:** AV-GuiaDeUso.pdf (brand guide, April 2026)

---

## 1. Design System — Tokens

### Color Changes (`src/tokens.ts`)

#### Backgrounds
| Token | Old | New | Reason |
|---|---|---|---|
| `bg` | `#050507` | `#101010` | Brand guide dark (warmer, less cold) |
| `bgSecondary` / `nav` / `sidebar` | `#08080A` | `#141414` | Consistent with brand guide |
| `panel` | `#111114` | `#1A1A1A` | Brand guide midtone |
| `card` | `#171719` | `#1E1E1E` | Brand guide card surface |

#### Orange Accent
| Token | Old | New | Reason |
|---|---|---|---|
| `orange` | `#FF6B2C` | `#F15A24` | Official AIVI orange from brand guide PDF swatch |
| `orangeLight` | `#FF8A3D` | `#FE803F` | Brand guide light orange |
| `orangeDark` | `#8A3418` | `#8A2E14` | Proportional adjustment |

#### Semantic Colors
| Token | Old | New | Reason |
|---|---|---|---|
| `green` | `#22C55E` | `#7AC943` | Brand guide — more vivid lime-green |
| `blue` | `#2FB7FF` | `#3FA9F5` | Brand guide — warmer cyan-blue |
| `yellow` | `#FFC247` | `#FFC252` | Near-identical, aligned to brand guide |
| `red` / `pink` | unchanged | unchanged | Already match brand guide |

#### Updated Gradients
```typescript
grad:        "linear-gradient(135deg, #FFC252, #F15A24, #FF413B)"
gradBtn:     "linear-gradient(135deg, #F15A24 0%, #8A2E14 100%)"
gradCard:    "linear-gradient(135deg, rgba(241,90,36,0.35) 0%, rgba(80,28,12,0.38) 60%, #1E1E1E 100%)"
gradFinance: "linear-gradient(135deg, rgba(241,90,36,0.18) 0%, rgba(30,30,30,0.95) 100%)"
```

### Typography Changes (`src/index.css`)

Add **Exo 2** as display font via Google Fonts import:

```css
@import url('https://fonts.googleapis.com/css2?family=Exo+2:wght@700;800;900&family=Hanken+Grotesk:wght@300;400;500;600;700;800;900&display=swap');
```

**Usage rules:**
- `Exo 2` (700–900): KPI values, logo "CORE" label, clock/time displays
- `Hanken Grotesk` (400–800): All UI text, labels, buttons, body

---

## 2. Component Specifications

### `src/tokens.ts` — FONT constant
Add:
```typescript
export const FONT_DISPLAY = "'Exo 2', sans-serif";
```

### `src/index.css` — CSS variable updates
Update CSS variables to match new token values. Also update `.aivi-card` hover:
```css
.aivi-card:hover {
  border-color: rgba(241, 90, 36, 0.30) !important;  /* was 0.22 */
}
.aivi-card-highlight {
  border-color: rgba(241, 90, 36, 0.50) !important;  /* was 0.45 */
}
```

Update `.aivi-btn-primary`:
```css
.aivi-btn-primary {
  background: linear-gradient(135deg, #F15A24 0%, #8A2E14 100%);  /* updated orange */
}
```

Update scrollbar hover:
```css
::-webkit-scrollbar-thumb:hover {
  background: rgba(241, 90, 36, 0.3);  /* was 255,107,44 */
}
```

### `src/components/layout/Sidebar.tsx`

**Logo area changes:**
- `AIVI` text: keep Hanken Grotesk 900, brand gradient (updated to new orange)
- `CORE` label: switch to `fontFamily: FONT_DISPLAY` (Exo 2), weight 800, color `C.orange`

**Product filter pills:**
- Active state: pill-shaped border `rgba(241,90,36,0.35)`, bg `rgba(241,90,36,0.12)`
- Keep existing `○`/`●` prefix (no change needed)

**MRR/ARR values in footer:**
- Apply `fontFamily: FONT_DISPLAY` to the value `<span>` elements

### `src/components/dashboard/KPIRow.tsx`

**KPI value display:**
- Apply `fontFamily: FONT_DISPLAY` to the value `div` inside `KPICard`
- Use `font-variant-numeric: tabular-nums` (already present, keep)
- Weight: 900

**Hero card glow:**
- `box-shadow` inner glow uses `rgba(241,90,36,...)` (updated orange)

### `src/components/dashboard/TopNav.tsx`

**Clock/time display:**
- Apply `fontFamily: FONT_DISPLAY` to time string
- Keep existing size/weight

---

## 3. File Change Summary

| File | What changes |
|---|---|
| `src/tokens.ts` | Color values + new `FONT_DISPLAY` export |
| `src/index.css` | Font import, CSS variables, card hover border, btn gradient |
| `src/components/layout/Sidebar.tsx` | CORE label font, MRR/ARR font, filter pill style |
| `src/components/dashboard/KPIRow.tsx` | KPI value font-family |
| `src/components/dashboard/TopNav.tsx` | Clock font-family |

**Files NOT changed:** All views, hooks, services, AdminPanel, LoginView, UsersTable, ChartPanel, CountriesPanel, AtRiskPanel, DelayedPanel, DashFooter.

---

## 4. Design Rationale

- **Why Exo 2?** It appears in the official brand guide PDF (AV-GuiaDeUso.pdf, April 2026) alongside Hanken Grotesk. Its geometric, futuristic character is appropriate for numeric display — KPIs, MRR, time — giving them visual weight and distinctiveness.
- **Why change orange?** The PDF swatch `R=241 G=90 B=36` (#F15A24) is the documented AIVI orange. The current #FF6B2C is warmer/brighter and not in the brand guide.
- **Why change green?** Brand guide uses `#7AC943` (lime-green) vs. the current Tailwind green `#22C55E`. The brand guide color feels more energetic and brand-consistent.
- **Why minimal scope?** The layout, data logic, and component structure are already solid. The visual impact of font + color calibration achieves the "new visual direction" without architectural risk.
