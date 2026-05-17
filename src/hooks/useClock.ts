import { useState, useEffect } from "react";

export function useClock(): string {
  const [time, setTime] = useState("");

  useEffect(() => {
    const tick = () => {
      const n  = new Date();
      const h  = n.getHours() % 12 || 12;
      const m  = String(n.getMinutes()).padStart(2, "0");
      const ap = n.getHours() >= 12 ? "p. m." : "a. m.";
      setTime(`${String(h).padStart(2, "0")}:${m} ${ap}`);
    };
    tick();
    const iv = setInterval(tick, 1000);
    return () => clearInterval(iv);
  }, []);

  return time;
}
