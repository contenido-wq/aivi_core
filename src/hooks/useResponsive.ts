import { useState, useEffect, useCallback } from "react";

export type Breakpoint = "mobile" | "tablet" | "desktop";

interface ResponsiveState {
  /** Current breakpoint label */
  bp: Breakpoint;
  /** true when width < 768px */
  isMobile: boolean;
  /** true when 768px ≤ width < 1024px */
  isTablet: boolean;
  /** true when width ≥ 1024px */
  isDesktop: boolean;
  /** Viewport width in px */
  width: number;
}

/**
 * Detects the current viewport breakpoint with debounced resize listener.
 *
 * Breakpoints (matches common device widths):
 * - mobile:  < 768px   (phones: iPhone SE → iPhone 16 Pro Max, Pixel, Galaxy)
 * - tablet:  768–1023px (iPad Mini, iPad Air, Galaxy Tab, etc.)
 * - desktop: ≥ 1024px
 */
export function useResponsive(): ResponsiveState {
  const calc = useCallback((): ResponsiveState => {
    const w = typeof window !== "undefined" ? window.innerWidth : 1200;
    if (w < 768)  return { bp: "mobile",  isMobile: true,  isTablet: false, isDesktop: false, width: w };
    if (w < 1024) return { bp: "tablet",  isMobile: false, isTablet: true,  isDesktop: false, width: w };
    return                { bp: "desktop", isMobile: false, isTablet: false, isDesktop: true,  width: w };
  }, []);

  const [state, setState] = useState<ResponsiveState>(calc);

  useEffect(() => {
    let raf: number;
    const onResize = () => {
      cancelAnimationFrame(raf);
      raf = requestAnimationFrame(() => setState(calc()));
    };
    window.addEventListener("resize", onResize, { passive: true });
    // Also listen to orientation change for mobile devices
    window.addEventListener("orientationchange", onResize);
    return () => {
      cancelAnimationFrame(raf);
      window.removeEventListener("resize", onResize);
      window.removeEventListener("orientationchange", onResize);
    };
  }, [calc]);

  return state;
}
