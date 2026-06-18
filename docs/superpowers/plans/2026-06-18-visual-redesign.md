# Visual Redesign: Brand Alignment — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Calibrate AIVI Core dashboard colors to the official brand guide and add Exo 2 as the display font for KPI values, MRR/ARR, the clock, and the "CORE" logo label.

**Architecture:** Pure visual layer changes — no logic, no data, no layout restructuring. Two token files (`tokens.ts` + `index.css`) plus three component files receive surgical edits. The `C` object and CSS `:root` variables remain the single source of truth for colors; `FONT_DISPLAY` joins `FONT` as the typography source of truth.

**Tech Stack:** React 18, TypeScript, Vite, inline styles (`C` tokens), global CSS classes (`.aivi-card`, `.aivi-btn-primary`, etc.), Google Fonts (Exo 2 + Hanken Grotesk).

## Global Constraints

- Dark mode only — no light theme changes.
- All color values come verbatim from the brand guide PDF (AV-GuiaDeUso.pdf, April 2026).
- Exo 2 is used **only** for display/numeric contexts: KPI values, MRR/ARR, clock, "CORE" label.
- Hanken Grotesk remains the default for all UI text, labels, buttons, and body.
- Do not touch: views, hooks, services, AdminPanel, LoginView, UsersTable, ChartPanel, CountriesPanel, AtRiskPanel, DelayedPanel, DashFooter.
- Commit after each task.

---

## File Map

| File | Role | Task |
|---|---|---|
| `src/tokens.ts` | TypeScript color/font constants consumed by all components | Task 1 |
| `src/index.css` | Global CSS variables + utility class styles | Task 2 |
| `src/components/layout/Sidebar.tsx` | Logo "CORE" label + MRR/ARR value spans | Task 3 |
| `src/components/dashboard/KPIRow.tsx` | KPI value `div` inside `KPICard` | Task 4 |
| `src/components/dashboard/TopNav.tsx` | Clock `span` at end of nav | Task 4 |

---

## Task 1: Update `tokens.ts` — Colors + FONT_DISPLAY

**Files:**
- Modify: `src/tokens.ts`

**Interfaces:**
- Produces: `C` object with updated color values; `FONT_DISPLAY` string export consumed by Tasks 3 and 4.

- [ ] **Step 1: Replace the entire contents of `src/tokens.ts`**

  Open `src/tokens.ts` and replace its entire content with:

  ```typescript
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
    borderHover: "rgba(241,90,36,0.45)",

    // ── Text ──────────────────────────────────────────────────
    white:       "#F4F4F5",
    muted:       "#5E5E70",
    mutedMid:    "#8E8EA0",
    mutedLight:  "#A0A0B4",
    label:       "#6F6F85",

    // ── Accents ───────────────────────────────────────────────
    orange:      "#F15A24",
    orangeLight: "#FE803F",
    orangeDark:  "#8A2E14",

    yellow:      "#FFC252",
    green:       "#7AC943",
    greenSoft:   "rgba(122,201,67,0.12)",
    blue:        "#3FA9F5",
    red:         "#FF413B",
    teal:        "#2DD4BF",
    purple:      "#A78BFA",
    pink:        "#F472B6",

    // ── Gradients ─────────────────────────────────────────────
    grad:        "linear-gradient(135deg, #FFC252, #F15A24, #FF413B)",
    gradBtn:     "linear-gradient(135deg, #F15A24 0%, #8A2E14 100%)",

    /** Hero KPI card — bold orange fill */
    gradCard:    "linear-gradient(135deg, rgba(241,90,36,0.35) 0%, rgba(80,28,12,0.38) 60%, #1E1E1E 100%)",

    /** LTV / financial highlight panel */
    gradFinance: "linear-gradient(135deg, rgba(241,90,36,0.18) 0%, rgba(30,30,30,0.95) 100%)",

    /** Retention progress bar */
    gradRetention: "linear-gradient(90deg, #7AC943, #B6E85C, #FFB84D)",
  } as const;

  export const FONT = "'Hanken Grotesk', sans-serif";
  export const FONT_DISPLAY = "'Exo 2', sans-serif";
  ```

- [ ] **Step 2: Verify the app still compiles**

  ```bash
  cd /Users/jheitrujillo/Proyectos/aivi_core
  npm run build 2>&1 | tail -20
  ```

  Expected: no TypeScript errors. If you see "Property X does not exist on type C", a token was renamed — check the diff and restore the original name.

- [ ] **Step 3: Commit**

  ```bash
  git add src/tokens.ts
  git commit -m "feat(design): update color tokens to brand guide + add FONT_DISPLAY"
  ```

---

## Task 2: Update `index.css` — Font Import + CSS Variables + Component Styles

**Files:**
- Modify: `src/index.css`

**Interfaces:**
- Consumes: brand guide color values (same as Task 1).
- Produces: updated `--orange`, `--green`, `--blue`, `--bg`, etc. CSS variables; updated `.aivi-card:hover`, `.aivi-card-highlight`, `.aivi-btn-primary`, `.aivi-btn-ghost`, `.aivi-input:focus`, and scrollbar thumb hover.

- [ ] **Step 1: Update the Google Fonts import (line 1)**

  Replace:
  ```css
  @import url('https://fonts.googleapis.com/css2?family=Hanken+Grotesk:wght@300;400;500;600;700;800;900&display=swap');
  ```

  With:
  ```css
  @import url('https://fonts.googleapis.com/css2?family=Exo+2:wght@700;800;900&family=Hanken+Grotesk:wght@300;400;500;600;700;800;900&display=swap');
  ```

- [ ] **Step 2: Update the `:root` CSS variables block (lines 4–26)**

  Replace the entire `:root { ... }` block with:
  ```css
  :root {
    --bg:             #101010;
    --bg-secondary:   #141414;
    --panel:          #1A1A1A;
    --card:           #1E1E1E;
    --card-2:         #222222;
    --border:         rgba(255,255,255,0.08);
    --border-mid:     rgba(255,255,255,0.12);
    --orange:         #F15A24;
    --orange-light:   #FE803F;
    --orange-dark:    #8A2E14;
    --green:          #7AC943;
    --blue:           #3FA9F5;
    --yellow:         #FFC252;
    --red:            #FF413B;
    --text:           #F4F4F5;
    --text-muted:     #8E8EA0;
    --text-soft:      #5E5E70;
    --text-label:     #6F6F85;
    --radius-card:    16px;
    --radius-inner:   12px;
    --radius-sm:      8px;
  }
  ```

- [ ] **Step 3: Update scrollbar thumb hover color**

  Find:
  ```css
  ::-webkit-scrollbar-thumb:hover {
    background: rgba(255,107,44,0.3);
  }
  ```

  Replace with:
  ```css
  ::-webkit-scrollbar-thumb:hover {
    background: rgba(241,90,36,0.3);
  }
  ```

- [ ] **Step 4: Update `.aivi-card` background gradient**

  Find:
  ```css
  .aivi-card {
    background: linear-gradient(135deg, #18181B 0%, #101014 100%);
  ```

  Replace that `background` line only with:
  ```css
    background: linear-gradient(135deg, #1E1E1E 0%, #141414 100%);
  ```

- [ ] **Step 5: Update `.aivi-card:hover` — orange border + glow**

  Find:
  ```css
    .aivi-card:hover {
      border-color: rgba(255,107,44,0.22) !important;
      box-shadow:
        0 2px 0 0 rgba(255,255,255,0.04) inset,
        0 0 0 1px rgba(255,107,44,0.08) inset,
        0 20px 45px rgba(0,0,0,0.35),
        0 6px 14px rgba(0,0,0,0.25) !important;
      transform: translateY(-1px);
    }
  ```

  Replace with:
  ```css
    .aivi-card:hover {
      border-color: rgba(241,90,36,0.30) !important;
      box-shadow:
        0 2px 0 0 rgba(255,255,255,0.04) inset,
        0 0 0 1px rgba(241,90,36,0.10) inset,
        0 20px 45px rgba(0,0,0,0.35),
        0 6px 14px rgba(0,0,0,0.25) !important;
      transform: translateY(-1px);
    }
  ```

- [ ] **Step 6: Update `.aivi-card-highlight`**

  Find:
  ```css
  .aivi-card-highlight {
    border-color: rgba(255,107,44,0.45) !important;
    box-shadow:
      0 0 0 1px rgba(255,107,44,0.1) inset,
      0 0 25px rgba(255,107,44,0.15),
      0 12px 30px rgba(0,0,0,0.25) !important;
  }
  ```

  Replace with:
  ```css
  .aivi-card-highlight {
    border-color: rgba(241,90,36,0.50) !important;
    box-shadow:
      0 0 0 1px rgba(241,90,36,0.12) inset,
      0 0 25px rgba(241,90,36,0.18),
      0 12px 30px rgba(0,0,0,0.25) !important;
  }
  ```

- [ ] **Step 7: Update `.badge-active` to new green**

  Find:
  ```css
  .badge-active {
    background: rgba(34,197,94,0.12);
    border: 1px solid rgba(34,197,94,0.35);
    color: #22C55E;
  }
  ```

  Replace with:
  ```css
  .badge-active {
    background: rgba(122,201,67,0.12);
    border: 1px solid rgba(122,201,67,0.35);
    color: #7AC943;
  }
  ```

- [ ] **Step 8: Update `.aivi-input:focus`**

  Find:
  ```css
  .aivi-input:focus {
    border-color: rgba(255,107,44,0.5);
    box-shadow: 0 0 0 3px rgba(255,107,44,0.08);
  }
  ```

  Replace with:
  ```css
  .aivi-input:focus {
    border-color: rgba(241,90,36,0.5);
    box-shadow: 0 0 0 3px rgba(241,90,36,0.08);
  }
  ```

- [ ] **Step 9: Update `.aivi-btn-primary` gradient**

  Find:
  ```css
  .aivi-btn-primary {
    background: linear-gradient(135deg, #FF6B2C 0%, #8A3418 100%);
  ```

  Replace that `background` line only with:
  ```css
    background: linear-gradient(135deg, #F15A24 0%, #8A2E14 100%);
  ```

- [ ] **Step 10: Update `.aivi-btn-ghost` hover**

  Find:
  ```css
  .aivi-btn-ghost:hover {
    border-color: rgba(255,107,44,0.35);
    color: var(--text);
    background: rgba(255,107,44,0.05);
  }
  ```

  Replace with:
  ```css
  .aivi-btn-ghost:hover {
    border-color: rgba(241,90,36,0.35);
    color: var(--text);
    background: rgba(241,90,36,0.05);
  }
  ```

- [ ] **Step 11: Update `.aivi-retention-bar` to new green**

  Find:
  ```css
  .aivi-retention-bar {
    background: linear-gradient(90deg, #22C55E, #B6E85C, #FFB84D);
  }
  ```

  Replace with:
  ```css
  .aivi-retention-bar {
    background: linear-gradient(90deg, #7AC943, #B6E85C, #FFB84D);
  }
  ```

- [ ] **Step 12: Verify in the browser**

  ```bash
  npm run dev
  ```

  Open `http://localhost:5173` and check:
  - Background is `#101010` (slightly warmer than before — noticeable)
  - Orange accent on nav items, KPI hero card reads as `#F15A24`
  - Hover any `.aivi-card` → border glow is orange

- [ ] **Step 13: Commit**

  ```bash
  git add src/index.css
  git commit -m "feat(design): update CSS variables and component styles to brand guide"
  ```

---

## Task 3: Update `Sidebar.tsx` — CORE Label + MRR/ARR Values

**Files:**
- Modify: `src/components/layout/Sidebar.tsx`

**Interfaces:**
- Consumes: `FONT_DISPLAY` from `src/tokens.ts` (added in Task 1); `C.orange`, `C.green` (updated in Task 1).

- [ ] **Step 1: Add `FONT_DISPLAY` to the import from tokens**

  Find the import at the top of `src/components/layout/Sidebar.tsx`:
  ```tsx
  import { C } from "../../tokens";
  ```

  Replace with:
  ```tsx
  import { C, FONT_DISPLAY } from "../../tokens";
  ```

- [ ] **Step 2: Apply Exo 2 to the "CORE" label**

  Find the `CORE` label `div` in the logo section (inside the logo `div` block):
  ```tsx
            <div style={{ fontSize: 9, fontWeight: 800, color: C.orange, letterSpacing: "0.14em", marginTop: 1 }}>CORE</div>
  ```

  Replace with:
  ```tsx
            <div style={{ fontSize: 9, fontWeight: 800, color: C.orange, letterSpacing: "0.14em", marginTop: 1, fontFamily: FONT_DISPLAY }}>CORE</div>
  ```

- [ ] **Step 3: Apply Exo 2 to MRR and ARR values in the footer**

  Find the MRR/ARR value `<span>` inside the footer map. The relevant line is:
  ```tsx
              <span style={{ fontSize: 14, fontWeight: 900, color: col, letterSpacing: "-.02em" }}>{v}</span>
  ```

  Replace with:
  ```tsx
              <span style={{ fontSize: 14, fontWeight: 900, color: col, letterSpacing: "-.02em", fontFamily: FONT_DISPLAY }}>{v}</span>
  ```

- [ ] **Step 4: Verify in browser**

  With `npm run dev` running, open the sidebar:
  - "CORE" label below the AIVI logo uses the geometric Exo 2 font (noticeably different from Hanken Grotesk).
  - MRR and ARR monetary values (`$X,XXX.XX`) use Exo 2 — tighter and more tabular.

- [ ] **Step 5: Commit**

  ```bash
  git add src/components/layout/Sidebar.tsx
  git commit -m "feat(design): apply Exo 2 display font to CORE label and MRR/ARR values"
  ```

---

## Task 4: Update `KPIRow.tsx` + `TopNav.tsx` — KPI Values + Clock

**Files:**
- Modify: `src/components/dashboard/KPIRow.tsx`
- Modify: `src/components/dashboard/TopNav.tsx`

**Interfaces:**
- Consumes: `FONT_DISPLAY` from `src/tokens.ts` (Task 1).

### KPIRow.tsx

- [ ] **Step 1: Add `FONT_DISPLAY` to the import**

  Find in `src/components/dashboard/KPIRow.tsx`:
  ```tsx
  import { C } from "../../tokens";
  ```

  Replace with:
  ```tsx
  import { C, FONT_DISPLAY } from "../../tokens";
  ```

- [ ] **Step 2: Apply Exo 2 to the KPI value `div` inside `KPICard`**

  Find the value display `div` inside `KPICard` (the large number):
  ```tsx
      <div style={{
        fontSize: compact ? 20 : 30, fontWeight: 900,
        color: hero ? "#fff" : valueColor,
        lineHeight: 1, letterSpacing: "-0.03em",
        overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
      }}>{value}</div>
  ```

  Replace with:
  ```tsx
      <div style={{
        fontSize: compact ? 20 : 30, fontWeight: 900,
        color: hero ? "#fff" : valueColor,
        lineHeight: 1, letterSpacing: "-0.03em",
        overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
        fontFamily: FONT_DISPLAY,
      }}>{value}</div>
  ```

### TopNav.tsx

- [ ] **Step 3: Add `FONT_DISPLAY` to the import**

  Find in `src/components/dashboard/TopNav.tsx`:
  ```tsx
  import { C } from "../../tokens";
  ```

  Replace with:
  ```tsx
  import { C, FONT_DISPLAY } from "../../tokens";
  ```

- [ ] **Step 4: Apply Exo 2 to the clock `span`**

  Find the time display `span` at the end of the nav (line ~126):
  ```tsx
        {!isMobile && <span style={{ color: C.mutedLight, fontVariantNumeric: "tabular-nums" }}>{time}</span>}
  ```

  Replace with:
  ```tsx
        {!isMobile && <span style={{ color: C.mutedLight, fontVariantNumeric: "tabular-nums", fontFamily: FONT_DISPLAY, fontWeight: 700 }}>{time}</span>}
  ```

- [ ] **Step 5: Verify in browser**

  With `npm run dev` running, look at the dashboard:
  - KPI values (Facturación Bruta, Inversión, ROAS, Activos/Cancel, Atrasados) all render in Exo 2 — geometric, tight numerals.
  - Clock in the top-right nav uses Exo 2 bold.
  - All labels, section headers, and button text remain in Hanken Grotesk.

- [ ] **Step 6: Commit**

  ```bash
  git add src/components/dashboard/KPIRow.tsx src/components/dashboard/TopNav.tsx
  git commit -m "feat(design): apply Exo 2 display font to KPI values and clock"
  ```

---

## Self-Review Notes

**Spec coverage:**
- ✅ `tokens.ts` — all color values updated (Task 1)
- ✅ `FONT_DISPLAY` export added (Task 1)
- ✅ `index.css` — font import, CSS variables, card hover, badge-active, input focus, btn-primary, btn-ghost, scrollbar, retention bar (Task 2)
- ✅ Sidebar CORE label + MRR/ARR values (Task 3)
- ✅ KPI values (Task 4 — KPIRow)
- ✅ Clock (Task 4 — TopNav)
- ✅ No untouched files from spec file list

**Placeholder scan:** No TBD, no "similar to", all code is complete.

**Type consistency:** `FONT_DISPLAY` referenced as `FONT_DISPLAY` in all tasks. `C.orange`, `C.green`, `C.grad` referenced correctly — no renamed tokens.
