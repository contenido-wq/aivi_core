import { C, FONT } from "../../tokens";

export function LiveBadge() {
  return (
    <span style={{
      display:       "inline-flex",
      alignItems:    "center",
      gap:           5,
      background:    `${C.green}12`,
      border:        `1px solid ${C.green}50`,
      borderRadius:  2,
      padding:       "2px 8px",
      fontFamily:    FONT,
      fontSize:      11,
      letterSpacing: "0.14em",
      color:         C.green,
    }}>
      <span style={{
        width: 5, height: 5, borderRadius: "50%",
        background: C.green, display: "inline-block",
        animation: "pulse-dot 1.4s ease-in-out infinite",
      }} />
      + API EN VIVO
    </span>
  );
}
