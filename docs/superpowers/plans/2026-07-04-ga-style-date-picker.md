# GA-Style Date Picker Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the simple 6-preset dropdown `DateRangePicker` with a Google-Analytics-style panel: 13 radio-button presets, two visual month calendars with click-to-select range, a visual-only "Comparar" checkbox, and explicit Cancelar/Actualizar confirmation instead of instant-apply.

**Architecture:** `PeriodKey` and `buildRange` in `src/services/analytics.ts` are extended to 13 presets (calendar-week/calendar-month variants added alongside existing rolling-window ones) plus a new `formatDateEs` formatter. A new standalone `MonthCalendar` component renders one month's day grid from props only (no internal state). `DateRangePicker` is rewritten around a "draft" state model — every interaction (preset click, calendar day click, date input edit) mutates local draft state; only clicking "Actualizar" calls the existing `onSelect(key, custom?)` callback and closes the panel; "Cancelar" discards the draft.

**Tech Stack:** React 19 + TypeScript (Vite SPA). No new dependencies — hand-built calendar grid, no calendar library. No test framework in this repo — verify with `npm run build` (tsc type-check) plus manual browser check per this project's CLAUDE.md instruction to test UI changes in-browser before claiming completion.

## Global Constraints

- No new npm dependencies — hand-built calendar grid.
- No DB migrations, no Supabase Edge Function changes — 100% `src/` frontend.
- No test framework exists in this repo — verify via `npm run build` and manual browser checks only.
- All Spanish-language UI copy stays in Spanish; month abbreviations/names and day-of-week labels are Spanish.
- Weeks start on Monday (Lun-Dom), matching the reference image.
- Reuse existing color tokens from `src/tokens.ts` (`C.orange`, `C.white`, `C.mutedLight`, `C.mutedMid`, `C.border`, `C.panel`, `C.bgSecondary`) — do not hardcode new hex colors.
- Preserve the existing "Colombia timezone" date-computation convention already in `buildRange` (`now.getTime() - 5 * 60 * 60 * 1000`) — do not change how "today" is computed.
- Nothing is applied to the parent (`onSelect` is not called) until the user clicks "Actualizar". "Cancelar" must not call `onSelect` at all.
- The "Comparar" checkbox has zero effect on any calculation — it is local UI state only.

---

### Task 1: Extend `PeriodKey`/`buildRange`/add `formatDateEs` in `analytics.ts`, update labels in `useAnalyticsData.ts`

**Files:**
- Modify: `src/services/analytics.ts:6` (the `PeriodKey` type)
- Modify: `src/services/analytics.ts:10-41` (the `buildRange` function)
- Modify: `src/hooks/useAnalyticsData.ts` (the `labels` record inside `runAIAnalysis`)

**Interfaces:**
- Produces: `PeriodKey = "hoy" | "ayer" | "hoyAyer" | "7dias" | "14dias" | "28dias" | "30dias" | "estaSemana" | "semanaPasada" | "esteMes" | "mesPasado" | "maximo" | "custom"`, `buildRange` handling all 13 keys, and `export function formatDateEs(dateStr: string): string` — all consumed by Task 3 (`DateRangePicker`).

- [ ] **Step 1: Replace the `PeriodKey` type**

Replace:

```typescript
export type PeriodKey = "hoy" | "ayer" | "7dias" | "mes" | "3meses" | "total" | "custom";
```

with:

```typescript
export type PeriodKey =
  | "hoy" | "ayer" | "hoyAyer"
  | "7dias" | "14dias" | "28dias" | "30dias"
  | "estaSemana" | "semanaPasada"
  | "esteMes" | "mesPasado"
  | "maximo" | "custom";
```

- [ ] **Step 2: Replace `buildRange` and add `formatDateEs`**

Replace the entire function:

```typescript
export function buildRange(key: PeriodKey, custom?: { from: string; to: string }): DateRange {
  const now    = new Date();
  const colMs  = now.getTime() - 5 * 60 * 60 * 1000; // UTC → Colombia (UTC-5), sin depender del timezone del browser
  const col    = new Date(colMs);
  const pad    = (n: number) => String(n).padStart(2, "0");
  const ymd    = (d: Date) => `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`;

  const today     = ymd(col);
  const yesterday = ymd(new Date(col.getTime() - 86400000));

  if (key === "custom" && custom) {
    return { from: custom.from, to: custom.to, fromTs: `${custom.from}T00:00:00`, toTs: `${custom.to}T23:59:59` };
  }
  if (key === "ayer")   return { from: yesterday, to: yesterday, fromTs: `${yesterday}T00:00:00`, toTs: `${yesterday}T23:59:59` };
  if (key === "7dias") {
    const from7 = ymd(new Date(col.getTime() - 6 * 86400000));
    return { from: from7, to: today, fromTs: `${from7}T00:00:00`, toTs: `${today}T23:59:59` };
  }
  if (key === "mes") {
    const from30 = ymd(new Date(col.getTime() - 29 * 86400000));
    return { from: from30, to: today, fromTs: `${from30}T00:00:00`, toTs: `${today}T23:59:59` };
  }
  if (key === "3meses") {
    const from90 = ymd(new Date(col.getTime() - 89 * 86400000));
    return { from: from90, to: today, fromTs: `${from90}T00:00:00`, toTs: `${today}T23:59:59` };
  }
  if (key === "total") {
    return { from: "2020-01-01", to: today, fromTs: "2020-01-01T00:00:00", toTs: `${today}T23:59:59` };
  }
  // default: "hoy"
  return { from: today, to: today, fromTs: `${today}T00:00:00`, toTs: `${today}T23:59:59` };
}
```

with:

```typescript
const MESES_ES = ["ene", "feb", "mar", "abr", "may", "jun", "jul", "ago", "sep", "oct", "nov", "dic"];

export function formatDateEs(dateStr: string): string {
  const [y, m, d] = dateStr.split("-").map(Number);
  return `${d} ${MESES_ES[m - 1]} ${y}`;
}

export function buildRange(key: PeriodKey, custom?: { from: string; to: string }): DateRange {
  const now    = new Date();
  const colMs  = now.getTime() - 5 * 60 * 60 * 1000; // UTC → Colombia (UTC-5), sin depender del timezone del browser
  const col    = new Date(colMs);
  const pad    = (n: number) => String(n).padStart(2, "0");
  const ymd    = (d: Date) => `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`;
  const range  = (from: string, to: string): DateRange => ({ from, to, fromTs: `${from}T00:00:00`, toTs: `${to}T23:59:59` });

  const today     = ymd(col);
  const yesterday = ymd(new Date(col.getTime() - 86400000));

  if (key === "custom" && custom) return range(custom.from, custom.to);
  if (key === "ayer")    return range(yesterday, yesterday);
  if (key === "hoyAyer") return range(yesterday, today);
  if (key === "7dias")   return range(ymd(new Date(col.getTime() - 6  * 86400000)), today);
  if (key === "14dias")  return range(ymd(new Date(col.getTime() - 13 * 86400000)), today);
  if (key === "28dias")  return range(ymd(new Date(col.getTime() - 27 * 86400000)), today);
  if (key === "30dias")  return range(ymd(new Date(col.getTime() - 29 * 86400000)), today);
  if (key === "estaSemana" || key === "semanaPasada") {
    const dow          = col.getDay(); // 0=Dom..6=Sáb
    const diffToMonday = (dow + 6) % 7;
    const thisMonday   = new Date(col.getTime() - diffToMonday * 86400000);
    if (key === "estaSemana") return range(ymd(thisMonday), today);
    const lastMonday = new Date(thisMonday.getTime() - 7 * 86400000);
    const lastSunday  = new Date(thisMonday.getTime() - 1 * 86400000);
    return range(ymd(lastMonday), ymd(lastSunday));
  }
  if (key === "esteMes" || key === "mesPasado") {
    const firstOfThisMonth = new Date(col.getFullYear(), col.getMonth(), 1);
    if (key === "esteMes") return range(ymd(firstOfThisMonth), today);
    const firstOfLastMonth = new Date(col.getFullYear(), col.getMonth() - 1, 1);
    const lastOfLastMonth  = new Date(col.getFullYear(), col.getMonth(), 0);
    return range(ymd(firstOfLastMonth), ymd(lastOfLastMonth));
  }
  if (key === "maximo") return range("2020-01-01", today);
  // default: "hoy"
  return range(today, today);
}
```

- [ ] **Step 3: Update the `labels` record in `useAnalyticsData.ts`**

Replace:

```typescript
      const labels: Record<PeriodKey, string> = {
        hoy: "Hoy", ayer: "Ayer", "7dias": "Últimos 7 días", mes: "Último mes", "3meses": "Últimos 3 meses", total: "Total", custom: "Rango personalizado",
      };
```

with:

```typescript
      const labels: Record<PeriodKey, string> = {
        hoy: "Hoy", ayer: "Ayer", hoyAyer: "Hoy y ayer",
        "7dias": "Últimos 7 días", "14dias": "Últimos 14 días", "28dias": "Últimos 28 días", "30dias": "Últimos 30 días",
        estaSemana: "Esta semana", semanaPasada: "La semana pasada",
        esteMes: "Este mes", mesPasado: "El mes pasado",
        maximo: "Máximo", custom: "Rango personalizado",
      };
```

- [ ] **Step 4: Type-check**

Run: `npm run build`
Expected: This will currently FAIL with TypeScript errors in `src/components/analytics/DateRangePicker.tsx` (it still references removed keys like `"mes"`/`"3meses"`/`"total"` and its own stale `PRESETS`/`PRESET_LABEL` records). That's expected — Task 3 rewrites that file. Confirm the *only* errors are in `DateRangePicker.tsx`. If `analytics.ts` or `useAnalyticsData.ts` themselves have any error, that IS a real problem — investigate and report BLOCKED with details.

- [ ] **Step 5: Commit**

```bash
git add src/services/analytics.ts src/hooks/useAnalyticsData.ts
git commit -m "feat(analytics): expand date presets to 13 GA-style options, add formatDateEs"
```

---

### Task 2: Create the `MonthCalendar` component

**Files:**
- Create: `src/components/analytics/MonthCalendar.tsx`

**Interfaces:**
- Produces: `export function MonthCalendar({ year, month, rangeStart, rangeEnd, onDayClick }: Props)` where `Props = { year: number; month: number; rangeStart: string | null; rangeEnd: string | null; onDayClick: (dateStr: string) => void }` — consumed by Task 3 (`DateRangePicker.tsx`).

- [ ] **Step 1: Write the component**

Create `src/components/analytics/MonthCalendar.tsx` with this exact content:

```typescript
import { C, FONT } from "../../tokens";

interface Props {
  year:       number;
  month:      number; // 0-11
  rangeStart: string | null; // YYYY-MM-DD
  rangeEnd:   string | null; // YYYY-MM-DD
  onDayClick: (dateStr: string) => void;
}

const DIAS  = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];
const MESES = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"];

function pad(n: number) { return String(n).padStart(2, "0"); }

export function MonthCalendar({ year, month, rangeStart, rangeEnd, onDayClick }: Props) {
  const firstDay     = new Date(year, month, 1);
  const daysInMonth  = new Date(year, month + 1, 0).getDate();
  const firstDow     = (firstDay.getDay() + 6) % 7; // 0=Lun..6=Dom

  const cells: (number | null)[] = [];
  for (let i = 0; i < firstDow; i++) cells.push(null);
  for (let d = 1; d <= daysInMonth; d++) cells.push(d);

  const isInRange  = (dateStr: string) => !!rangeStart && !!rangeEnd && dateStr >= rangeStart && dateStr <= rangeEnd;
  const isBoundary = (dateStr: string) => dateStr === rangeStart || dateStr === rangeEnd;

  return (
    <div style={{ width: 220 }}>
      <div style={{ textAlign: "center", fontSize: 12, fontWeight: 600, color: C.white, marginBottom: 8, textTransform: "capitalize" }}>
        {MESES[month]} {year}
      </div>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(7, 1fr)", gap: 2, marginBottom: 4 }}>
        {DIAS.map(d => (
          <div key={d} style={{ fontSize: 9, color: C.mutedMid, textAlign: "center", fontWeight: 600 }}>{d}</div>
        ))}
      </div>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(7, 1fr)", gap: 2 }}>
        {cells.map((d, i) => {
          if (d === null) return <div key={`blank-${i}`} />;
          const dateStr  = `${year}-${pad(month + 1)}-${pad(d)}`;
          const inRange  = isInRange(dateStr);
          const boundary = isBoundary(dateStr);
          return (
            <button
              key={dateStr}
              onClick={() => onDayClick(dateStr)}
              style={{
                height: 26, borderRadius: 6, border: "none", cursor: "pointer",
                fontSize: 11, fontFamily: FONT,
                background: boundary ? C.orange : inRange ? "rgba(254,128,63,0.18)" : "transparent",
                color: boundary ? C.white : C.mutedLight,
                fontWeight: boundary ? 700 : 400,
              }}
            >
              {d}
            </button>
          );
        })}
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Type-check**

Run: `npm run build`
Expected: This file compiles cleanly on its own (it's not imported anywhere yet). Any remaining errors should be only the ones already expected from Task 1 (in `DateRangePicker.tsx`, which Task 3 fixes) — confirm no errors specifically inside `MonthCalendar.tsx`.

- [ ] **Step 3: Commit**

```bash
git add src/components/analytics/MonthCalendar.tsx
git commit -m "feat(analytics): add MonthCalendar component for date range picker"
```

---

### Task 3: Rewrite `DateRangePicker.tsx` with the draft/staging model

**Files:**
- Modify: `src/components/analytics/DateRangePicker.tsx` (full rewrite)

**Interfaces:**
- Consumes: `PeriodKey`, `DateRange`, `buildRange`, `formatDateEs` from `../../services/analytics` (Task 1); `MonthCalendar` from `./MonthCalendar` (Task 2).
- Produces: Same public `Props` shape as before — `{ period: PeriodKey; range: DateRange | null; onSelect: (key: PeriodKey, custom?: { from: string; to: string }) => void }` — no change needed in `AnalyticsView.tsx`, which already passes these three props.

- [ ] **Step 1: Replace the entire file content**

Replace the full contents of `src/components/analytics/DateRangePicker.tsx` with:

```typescript
import { useState, useEffect } from "react";
import { C, FONT } from "../../tokens";
import { buildRange, formatDateEs } from "../../services/analytics";
import type { PeriodKey, DateRange } from "../../services/analytics";
import { MonthCalendar } from "./MonthCalendar";

interface Props {
  period:   PeriodKey;
  range:    DateRange | null;
  onSelect: (key: PeriodKey, custom?: { from: string; to: string }) => void;
}

type PresetKey = Exclude<PeriodKey, "custom">;

const PRESETS: { key: PresetKey; label: string }[] = [
  { key: "hoy",          label: "Hoy" },
  { key: "ayer",         label: "Ayer" },
  { key: "hoyAyer",      label: "Hoy y ayer" },
  { key: "7dias",        label: "Últimos 7 días" },
  { key: "14dias",       label: "Últimos 14 días" },
  { key: "28dias",       label: "Últimos 28 días" },
  { key: "30dias",       label: "Últimos 30 días" },
  { key: "estaSemana",   label: "Esta semana" },
  { key: "semanaPasada", label: "La semana pasada" },
  { key: "esteMes",      label: "Este mes" },
  { key: "mesPasado",    label: "El mes pasado" },
  { key: "maximo",       label: "Máximo" },
];

const PRESET_LABEL: Record<PeriodKey, string> = {
  hoy: "Hoy", ayer: "Ayer", hoyAyer: "Hoy y ayer",
  "7dias": "Últimos 7 días", "14dias": "Últimos 14 días", "28dias": "Últimos 28 días", "30dias": "Últimos 30 días",
  estaSemana: "Esta semana", semanaPasada: "La semana pasada",
  esteMes: "Este mes", mesPasado: "El mes pasado",
  maximo: "Máximo", custom: "Personalizado",
};

function todayYearMonth(): { year: number; month: number } {
  const d = new Date();
  return { year: d.getFullYear(), month: d.getMonth() };
}

function parseYearMonth(dateStr: string): { year: number; month: number } {
  const [y, m] = dateStr.split("-").map(Number);
  return { year: y, month: m - 1 };
}

export function DateRangePicker({ period, range, onSelect }: Props) {
  const [open,        setOpen]        = useState(false);
  const [pendingKey,  setPendingKey]  = useState<PeriodKey>(period);
  const [pendingFrom, setPendingFrom] = useState("");
  const [pendingTo,   setPendingTo]   = useState("");
  const [viewYear,    setViewYear]    = useState(() => todayYearMonth().year);
  const [viewMonth,   setViewMonth]   = useState(() => todayYearMonth().month);
  const [selecting,   setSelecting]   = useState<"start" | "end">("start");
  const [compare,     setCompare]     = useState(false);

  useEffect(() => {
    if (!open) return;
    setPendingKey(period);
    const initial = period === "custom" && range ? range : buildRange(period);
    setPendingFrom(initial.from);
    setPendingTo(initial.to);
    setSelecting("start");
    const { year, month } = parseYearMonth(initial.from);
    setViewYear(year);
    setViewMonth(month);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  const buttonLabel = range
    ? `${PRESET_LABEL[period]}: ${formatDateEs(range.from)} - ${formatDateEs(range.to)}`
    : "Cargando...";

  const handlePreset = (key: PresetKey) => {
    setPendingKey(key);
    const r = buildRange(key);
    setPendingFrom(r.from);
    setPendingTo(r.to);
    const { year, month } = parseYearMonth(r.from);
    setViewYear(year);
    setViewMonth(month);
  };

  const handleDayClick = (dateStr: string) => {
    setPendingKey("custom");
    if (selecting === "start" || !pendingFrom) {
      setPendingFrom(dateStr);
      setPendingTo("");
      setSelecting("end");
    } else {
      const from = pendingFrom <= dateStr ? pendingFrom : dateStr;
      const to   = pendingFrom <= dateStr ? dateStr     : pendingFrom;
      setPendingFrom(from);
      setPendingTo(to);
      setSelecting("start");
    }
  };

  const handlePrevMonth = () => {
    const d = new Date(viewYear, viewMonth - 1, 1);
    setViewYear(d.getFullYear());
    setViewMonth(d.getMonth());
  };
  const handleNextMonth = () => {
    const d = new Date(viewYear, viewMonth + 1, 1);
    setViewYear(d.getFullYear());
    setViewMonth(d.getMonth());
  };

  const rightYearMonth = (() => {
    const d = new Date(viewYear, viewMonth + 1, 1);
    return { year: d.getFullYear(), month: d.getMonth() };
  })();

  const handleUpdate = () => {
    if (pendingKey === "custom") {
      if (!pendingFrom || !pendingTo) return;
      onSelect("custom", { from: pendingFrom, to: pendingTo });
    } else {
      onSelect(pendingKey);
    }
    setOpen(false);
  };

  const handleCancel = () => setOpen(false);

  const dateInputStyle: React.CSSProperties = {
    background: C.bgSecondary, border: `1px solid ${C.border}`, borderRadius: 6,
    padding: "6px 8px", color: C.white, fontSize: 12, fontFamily: FONT, width: 118,
  };

  return (
    <div style={{ position: "relative" }}>
      <button
        onClick={() => setOpen(o => !o)}
        style={{
          background: "transparent", border: `1px solid ${C.border}`,
          borderRadius: 20, padding: "4px 14px", fontSize: 12,
          color: C.white, cursor: "pointer", fontFamily: FONT,
          display: "flex", alignItems: "center", gap: 6,
        }}
      >
        {buttonLabel} <span style={{ color: C.mutedMid, fontSize: 10 }}>▾</span>
      </button>

      {open && (
        <>
          <div style={{ position: "fixed", inset: 0, zIndex: 90 }} onClick={handleCancel} />
          <div style={{
            position: "absolute", top: "calc(100% + 6px)", right: 0, zIndex: 100,
            background: C.panel, border: `1px solid ${C.border}`, borderRadius: 12,
            padding: 16, width: 620, boxShadow: "0 8px 24px rgba(0,0,0,0.4)",
            display: "flex", gap: 20,
          }}>
            <div style={{ display: "flex", flexDirection: "column", gap: 2, minWidth: 140, flexShrink: 0 }}>
              {PRESETS.map(p => (
                <label key={p.key} style={{ display: "flex", alignItems: "center", gap: 8, cursor: "pointer", padding: "5px 6px", borderRadius: 6 }}>
                  <input
                    type="radio" name="date-preset" checked={pendingKey === p.key}
                    onChange={() => handlePreset(p.key)}
                  />
                  <span style={{ fontSize: 12, color: pendingKey === p.key ? C.white : C.mutedLight }}>{p.label}</span>
                </label>
              ))}
              <label style={{ display: "flex", alignItems: "center", gap: 8, cursor: "pointer", padding: "5px 6px", borderRadius: 6 }}>
                <input type="radio" name="date-preset" checked={pendingKey === "custom"} onChange={() => setPendingKey("custom")} />
                <span style={{ fontSize: 12, color: pendingKey === "custom" ? C.white : C.mutedLight }}>Personalizado</span>
              </label>
            </div>

            <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: 12 }}>
              <div style={{ display: "flex", alignItems: "flex-start", gap: 16 }}>
                <button onClick={handlePrevMonth} style={{ background: "transparent", border: "none", color: C.mutedLight, cursor: "pointer", fontSize: 16, marginTop: 4 }}>‹</button>
                <MonthCalendar year={viewYear} month={viewMonth} rangeStart={pendingFrom || null} rangeEnd={pendingTo || null} onDayClick={handleDayClick} />
                <MonthCalendar year={rightYearMonth.year} month={rightYearMonth.month} rangeStart={pendingFrom || null} rangeEnd={pendingTo || null} onDayClick={handleDayClick} />
                <button onClick={handleNextMonth} style={{ background: "transparent", border: "none", color: C.mutedLight, cursor: "pointer", fontSize: 16, marginTop: 4 }}>›</button>
              </div>

              <label style={{ display: "flex", alignItems: "center", gap: 8, cursor: "pointer" }}>
                <input type="checkbox" checked={compare} onChange={e => setCompare(e.target.checked)} />
                <span style={{ fontSize: 12, color: C.mutedLight }}>Comparar</span>
              </label>

              <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                <div style={{
                  background: C.bgSecondary, border: `1px solid ${C.border}`, borderRadius: 6,
                  padding: "6px 10px", fontSize: 12, color: C.mutedLight, flex: 1,
                }}>
                  {PRESET_LABEL[pendingKey]}
                </div>
                <input type="date" value={pendingFrom} onChange={e => { setPendingKey("custom"); setPendingFrom(e.target.value); }} style={dateInputStyle} />
                <span style={{ color: C.mutedMid }}>-</span>
                <input type="date" value={pendingTo} onChange={e => { setPendingKey("custom"); setPendingTo(e.target.value); }} style={dateInputStyle} />
              </div>

              <div style={{ fontSize: 11, color: C.mutedMid }}>Las fechas se muestran en la Hora de Bogotá</div>

              <div style={{ display: "flex", justifyContent: "flex-end", gap: 8 }}>
                <button onClick={handleCancel} style={{
                  background: "transparent", border: `1px solid ${C.border}`, borderRadius: 8,
                  padding: "6px 16px", fontSize: 12, color: C.mutedLight, cursor: "pointer",
                }}>Cancelar</button>
                <button onClick={handleUpdate} style={{
                  background: C.orange, border: "none", borderRadius: 8,
                  padding: "6px 16px", fontSize: 12, fontWeight: 600, color: C.white, cursor: "pointer",
                }}>Actualizar</button>
              </div>
            </div>
          </div>
        </>
      )}
    </div>
  );
}
```

- [ ] **Step 2: Type-check**

Run: `npm run build`
Expected: PASS with no TypeScript errors (this resolves the expected failures from Task 1 Step 4). This component uses `React.CSSProperties` without importing `React` as a value — this matches an existing, already-working pattern elsewhere in this codebase (e.g. `src/components/admin/AdminPanel.tsx`), so do not add `import React from "react"`.

- [ ] **Step 3: Commit**

```bash
git add src/components/analytics/DateRangePicker.tsx
git commit -m "feat(analytics): rewrite DateRangePicker with GA-style dual calendar and draft/confirm model"
```

---

### Task 4: Manual browser verification

**Files:** None (verification only).

- [ ] **Step 1: Start the dev server (skip if already running)**

Run: `npm run dev`
Expected: Vite starts without errors, prints a local URL (e.g. `http://localhost:5173`).

- [ ] **Step 2: Open the date picker and check the button label format**

Navigate to Analytics. The button should show something like `"Últimos 30 días: 4 jun 2026 - 3 jul 2026"` (exact text depends on the current default period and today's date) — preset name, colon, then two dates in `D mon YYYY` format.

- [ ] **Step 3: Verify the panel layout**

Click the button. Expected: a panel opens with 13 radio-button presets on the left (Hoy through Máximo, plus Personalizado), two month calendars side by side on the right with the current range highlighted, a "Comparar" checkbox, a row showing the current preset name plus two date inputs, a timezone note, and Cancelar/Actualizar buttons.

- [ ] **Step 4: Verify draft behavior — preset selection does NOT apply until Actualizar**

Click a different preset (e.g. "Esta semana"). Expected: the radio selection changes, the calendars re-highlight to show that week, but the KPIs/charts on the page do NOT change yet (still reflecting the previously applied period). Click "Actualizar". Expected: the panel closes, the button label updates, and the page's data refreshes for the new period.

- [ ] **Step 5: Verify Cancelar discards changes**

Open the panel again, click a different preset, then click "Cancelar". Expected: the panel closes, the button label and page data remain unchanged from before you opened the panel.

- [ ] **Step 6: Verify calendar day-click range selection**

Open the panel, click "Personalizado" (or just start clicking calendar days), click one day in a calendar, then click a later day. Expected: after the first click, only that day is highlighted; after the second click, the full range between both days highlights, and the two boundary days appear more prominently styled (filled orange). Click "Actualizar" — the range should apply.

- [ ] **Step 7: Verify inverted day clicks self-correct**

Open the panel, click a later day first, then an earlier day. Expected: no crash — the range still highlights correctly in chronological order (earlier day as start, later day as end).

- [ ] **Step 8: Verify month navigation**

Open the panel, click the "‹" and "›" arrows. Expected: both calendars shift back/forward by one month together; any in-progress custom range selection is not lost.

- [ ] **Step 9: Verify "Comparar" has no side effects**

Toggle the "Comparar" checkbox on and off. Expected: no visible change anywhere else in the app (no KPI changes, no new UI appearing) — it's purely a local checkbox state.

- [ ] **Step 10: Verify "Esta semana"/"Este mes" are calendar-aligned, not rolling**

Select "Esta semana" and check the highlighted calendar range starts on the most recent Monday (not just "7 days ago"). Select "Este mes" and check it starts on the 1st of the current month.

- [ ] **Step 11: Final build check**

Run: `npm run build`
Expected: PASS, confirming the whole change set compiles cleanly end-to-end.
