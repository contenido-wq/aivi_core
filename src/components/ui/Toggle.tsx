import { C } from "../../tokens";

interface ToggleProps { on: boolean; onChange: () => void; color?: string; }

export function Toggle({ on, onChange, color = C.orange }: ToggleProps) {
  return (
    <div onClick={onChange} role="switch" aria-checked={on} style={{ width: 32, height: 18, borderRadius: 9, cursor: "pointer", position: "relative", flexShrink: 0, background: on ? color : "rgba(255,255,255,0.12)", transition: "background 0.25s" }}>
      <div style={{ position: "absolute", top: 2, left: on ? 15 : 2, width: 14, height: 14, borderRadius: "50%", background: "#fff", transition: "left 0.2s cubic-bezier(.4,0,.2,1)", boxShadow: "0 1px 4px rgba(0,0,0,0.5)" }} />
    </div>
  );
}
