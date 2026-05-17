import { useState } from "react";
import { C } from "../../tokens";
import { MONTHS_LONG, DAYS_SHORT } from "../../data/mock";

interface MiniCalendarProps { date: Date; onSelect: (d: Date) => void; }

export function MiniCalendar({ date, onSelect }: MiniCalendarProps) {
  const [view, setView] = useState(new Date(date));
  const firstDay    = new Date(view.getFullYear(), view.getMonth(), 1);
  const startCol    = (firstDay.getDay() + 6) % 7;
  const daysInMonth = new Date(view.getFullYear(), view.getMonth() + 1, 0).getDate();
  const cells       = [...Array(startCol).fill(null), ...Array.from({ length: daysInMonth }, (_, i) => i + 1)];
  const isSel = (d: number | null) => d !== null && d === date.getDate() && view.getMonth() === date.getMonth() && view.getFullYear() === date.getFullYear();
  const isToday = (d: number | null) => { if (!d) return false; const t = new Date(); return d === t.getDate() && view.getMonth() === t.getMonth() && view.getFullYear() === t.getFullYear(); };
  const nav = (n: number) => setView(new Date(view.getFullYear(), view.getMonth() + n, 1));

  return (
    <div className="fade-in" style={{ position: "absolute", right: 0, top: "calc(100% + 6px)", zIndex: 300, background: "#17172A", border: `1px solid ${C.border}`, borderRadius: 12, padding: 16, width: 242, boxShadow: "0 24px 60px rgba(0,0,0,0.85)" }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 12 }}>
        <button onClick={() => nav(-1)} style={{ background: "none", border: "none", color: C.mutedLight, fontSize: 18, padding: "0 4px", lineHeight: 1 }}>‹</button>
        <span style={{ color: C.white, fontSize: 12, fontWeight: 700 }}>{MONTHS_LONG[view.getMonth()]} {view.getFullYear()}</span>
        <button onClick={() => nav(1)}  style={{ background: "none", border: "none", color: C.mutedLight, fontSize: 18, padding: "0 4px", lineHeight: 1 }}>›</button>
      </div>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(7,1fr)", gap: 1, marginBottom: 4 }}>
        {DAYS_SHORT.map(d => <div key={d} style={{ textAlign: "center", fontSize: 9, color: C.muted, fontWeight: 700, padding: "2px 0" }}>{d}</div>)}
      </div>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(7,1fr)", gap: 1 }}>
        {cells.map((d, i) => (
          <button key={i} onClick={() => d && onSelect(new Date(view.getFullYear(), view.getMonth(), d))} style={{ background: isSel(d) ? C.orange : isToday(d) ? `${C.orange}30` : "transparent", border: "none", color: d ? (isSel(d) ? "#fff" : C.white) : "transparent", borderRadius: 6, padding: "5px 1px", fontSize: 11, cursor: d ? "pointer" : "default", fontWeight: isSel(d) ? 800 : 400 }}>{d}</button>
        ))}
      </div>
    </div>
  );
}
