import { useState, useEffect } from "react";
import { C, FONT } from "../../tokens";
import type { PeriodKey, DateRange } from "../../services/analytics";

interface Props {
  period:   PeriodKey;
  range:    DateRange | null;
  onSelect: (key: PeriodKey, custom?: { from: string; to: string }) => void;
}

type PresetKey = Exclude<PeriodKey, "custom">;

const PRESETS: { key: PresetKey; label: string }[] = [
  { key: "hoy",    label: "Hoy" },
  { key: "ayer",   label: "Ayer" },
  { key: "7dias",  label: "Últimos 7 días" },
  { key: "mes",    label: "Último mes" },
  { key: "3meses", label: "Últimos 3 meses" },
  { key: "total",  label: "Total" },
];

const PRESET_LABEL: Record<PresetKey, string> = {
  hoy: "Hoy", ayer: "Ayer", "7dias": "Últimos 7 días",
  mes: "Último mes", "3meses": "Últimos 3 meses", total: "Total",
};

function formatShort(dateStr: string): string {
  const parts = dateStr.split("-");
  return `${parts[2]}/${parts[1]}`;
}

export function DateRangePicker({ period, range, onSelect }: Props) {
  const [open,       setOpen]       = useState(false);
  const [customFrom, setCustomFrom] = useState("");
  const [customTo,   setCustomTo]   = useState("");

  useEffect(() => {
    if (open && period === "custom" && range) {
      setCustomFrom(range.from);
      setCustomTo(range.to);
    }
  }, [open, period, range]);

  const buttonLabel = period === "custom" && range
    ? `${formatShort(range.from)} - ${formatShort(range.to)}`
    : PRESET_LABEL[period as PresetKey] ?? "Hoy";

  const handlePreset = (key: PresetKey) => {
    onSelect(key);
    setOpen(false);
  };

  const handleApply = () => {
    if (!customFrom || !customTo) return;
    const from = customFrom <= customTo ? customFrom : customTo;
    const to   = customFrom <= customTo ? customTo   : customFrom;
    onSelect("custom", { from, to });
    setOpen(false);
  };

  const dateInputStyle: React.CSSProperties = {
    background: C.bgSecondary, border: `1px solid ${C.border}`, borderRadius: 6,
    padding: "6px 8px", color: C.white, fontSize: 12, fontFamily: FONT, width: "100%",
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
          <div style={{ position: "fixed", inset: 0, zIndex: 90 }} onClick={() => setOpen(false)} />
          <div style={{
            position: "absolute", top: "calc(100% + 6px)", right: 0, zIndex: 100,
            background: C.panel, border: `1px solid ${C.border}`, borderRadius: 12,
            padding: 14, width: 220, boxShadow: "0 8px 24px rgba(0,0,0,0.4)",
          }}>
            <div style={{ display: "flex", flexDirection: "column", gap: 4 }}>
              {PRESETS.map(p => (
                <button
                  key={p.key}
                  onClick={() => handlePreset(p.key)}
                  style={{
                    background: period === p.key ? "rgba(254,128,63,0.12)" : "transparent",
                    border: "none", borderRadius: 8, padding: "8px 10px",
                    fontSize: 12, textAlign: "left", cursor: "pointer", fontFamily: FONT,
                    color: period === p.key ? C.orange : C.mutedLight,
                  }}
                >
                  {p.label}
                </button>
              ))}
            </div>

            <div style={{ borderTop: `1px solid ${C.border}`, marginTop: 10, paddingTop: 10 }}>
              <div style={{ fontSize: 11, color: C.mutedMid, marginBottom: 8 }}>Rango personalizado</div>
              <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
                <div>
                  <div style={{ fontSize: 10, color: C.mutedMid, marginBottom: 4 }}>Desde</div>
                  <input type="date" value={customFrom} onChange={e => setCustomFrom(e.target.value)} style={dateInputStyle} />
                </div>
                <div>
                  <div style={{ fontSize: 10, color: C.mutedMid, marginBottom: 4 }}>Hasta</div>
                  <input type="date" value={customTo} onChange={e => setCustomTo(e.target.value)} style={dateInputStyle} />
                </div>
                <button
                  onClick={handleApply}
                  disabled={!customFrom || !customTo}
                  style={{
                    background: C.orange, border: "none", borderRadius: 8, padding: "8px 0",
                    color: C.white, fontSize: 12, fontWeight: 600, cursor: "pointer", fontFamily: FONT,
                    opacity: !customFrom || !customTo ? 0.5 : 1,
                  }}
                >
                  Aplicar
                </button>
              </div>
            </div>
          </div>
        </>
      )}
    </div>
  );
}
