import type { CSSProperties, ReactNode } from "react";

interface CardProps { children: ReactNode; style?: CSSProperties; className?: string; }

export function Card({ children, style = {}, className = "" }: CardProps) {
  return (
    <div className={`aivi-card ${className}`} style={{ overflow: "hidden", ...style }}>
      {children}
    </div>
  );
}
