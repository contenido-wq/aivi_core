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
