import { useState } from "react";
import { Info } from "lucide-react";
import { C, FONT } from "../../tokens";

interface Props {
  text:   string;
  width?: number;
  align?: "center" | "left" | "right";
}

export function InfoTooltip({ text, width = 220, align = "center" }: Props) {
  const [open, setOpen] = useState(false);

  const horizontal =
    align === "left"  ? { left: 0 } :
    align === "right" ? { right: 0 } :
    { left: "50%", transform: "translateX(-50%)" };

  return (
    <span
      style={{ position: "relative", display: "inline-flex", verticalAlign: "middle", marginLeft: 5, cursor: "help" }}
      onMouseEnter={() => setOpen(true)}
      onMouseLeave={() => setOpen(false)}
    >
      <Info size={12} style={{ color: C.mutedMid }} />
      {open && (
        <div style={{
          position: "absolute", bottom: "calc(100% + 6px)", ...horizontal,
          width, padding: "9px 11px", borderRadius: 8,
          background: C.panel, border: `1px solid ${C.border}`,
          color: C.mutedLight, fontSize: 11, fontWeight: 400, lineHeight: 1.5,
          fontFamily: FONT, textTransform: "none", letterSpacing: "normal",
          zIndex: 60, boxShadow: "0 4px 16px rgba(0,0,0,0.4)",
          pointerEvents: "none",
        }}>
          {text}
        </div>
      )}
    </span>
  );
}
