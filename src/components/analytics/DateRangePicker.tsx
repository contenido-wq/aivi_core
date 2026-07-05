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
    setCompare(false);
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

  const canUpdate = pendingKey !== "custom" || (!!pendingFrom && !!pendingTo);

  const radioStyle = (checked: boolean): React.CSSProperties => ({
    appearance: "none", WebkitAppearance: "none", margin: 0, flexShrink: 0,
    width: 16, height: 16, borderRadius: "50%", cursor: "pointer",
    border: `2px solid ${checked ? C.orange : C.mutedMid}`,
    background: checked ? C.orange : "transparent",
    boxShadow: checked ? `inset 0 0 0 3px ${C.panel}` : "none",
  });

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
          <div style={{ position: "fixed", inset: 0, zIndex: 90, background: "rgba(0,0,0,0.95)" }} onClick={handleCancel} />
          <div style={{
            position: "absolute", top: "calc(100% + 6px)", right: 0, zIndex: 100,
            background: C.panel, border: `1px solid ${C.border}`, borderRadius: 12,
            padding: 16, width: 620, maxWidth: "calc(100vw - 252px)", overflowX: "auto",
            boxShadow: "0 8px 24px rgba(0,0,0,0.4)",
            display: "flex", gap: 20,
          }}>
            <div style={{ display: "flex", flexDirection: "column", gap: 2, minWidth: 140, flexShrink: 0 }}>
              {PRESETS.map(p => (
                <label key={p.key} style={{ display: "flex", alignItems: "center", gap: 8, cursor: "pointer", padding: "5px 6px", borderRadius: 6 }}>
                  <input
                    type="radio" name="date-preset" checked={pendingKey === p.key}
                    onChange={() => handlePreset(p.key)}
                    style={radioStyle(pendingKey === p.key)}
                  />
                  <span style={{ fontSize: 12, color: pendingKey === p.key ? C.white : C.mutedLight }}>{p.label}</span>
                </label>
              ))}
              <label style={{ display: "flex", alignItems: "center", gap: 8, cursor: "pointer", padding: "5px 6px", borderRadius: 6 }}>
                <input
                  type="radio" name="date-preset" checked={pendingKey === "custom"}
                  onChange={() => setPendingKey("custom")}
                  style={radioStyle(pendingKey === "custom")}
                />
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
                <div style={{ position: "relative", width: 16, height: 16, flexShrink: 0 }}>
                  <input
                    type="checkbox" checked={compare} onChange={e => setCompare(e.target.checked)}
                    style={{
                      appearance: "none", WebkitAppearance: "none", margin: 0, cursor: "pointer",
                      width: 16, height: 16, borderRadius: 4,
                      border: `2px solid ${compare ? C.orange : C.mutedMid}`,
                      background: compare ? C.orange : "transparent",
                    }}
                  />
                  {compare && (
                    <span style={{ position: "absolute", top: -2, left: 2, fontSize: 11, color: C.white, fontWeight: 700, pointerEvents: "none" }}>✓</span>
                  )}
                </div>
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
                <button onClick={handleUpdate} disabled={!canUpdate} style={{
                  background: C.orange, border: "none", borderRadius: 8,
                  padding: "6px 16px", fontSize: 12, fontWeight: 600, color: C.white,
                  cursor: canUpdate ? "pointer" : "not-allowed", opacity: canUpdate ? 1 : 0.5,
                }}>Actualizar</button>
              </div>
            </div>
          </div>
        </>
      )}
    </div>
  );
}
