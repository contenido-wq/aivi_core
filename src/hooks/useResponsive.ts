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
  /** true when desktop but viewport height < 820px (laptops like 1366×768) */
  isShortScreen: boolean;
  /** Viewport width in px */
  width: number;
  /** Viewport height in px */
  height: number;
}

/**
 * Detects the current viewport breakpoint with debounced resize listener.
 *
 * Breakpoints (matches common device widths):
 * - mobile:  < 768px   (phones: iPhone SE → iPhone 16 Pro Max, Pixel, Galaxy)
 * - tablet:  768–1023px (iPad Mini, iPad Air, Galaxy Tab, etc.)
 * - desktop: ≥ 1024px
 *
 * isShortScreen: true when height < 820px (e.g. Windows laptops at 1366×768)
 */
export function useResponsive(): ResponsiveState {
  const calc = useCallback((): ResponsiveState => {
    const w = typeof window !== "undefined" ? window.innerWidth  : 1200;
    const h = typeof window !== "undefined" ? window.innerHeight : 900;
    const isShortScreen = h < 820;
    if (w < 768)  return { bp: "mobile",  isMobile: true,  isTablet: false, isDesktop: false, isShortScreen, width: w, height: h };
    if (w < 1024) return { bp: "tablet",  isMobile: false, isTablet: true,  isDesktop: false, isShortScreen, width: w, height: h };
    return                { bp: "desktop", isMobile: false, isTablet: false, isDesktop: true,  isShortScreen, width: w, height: h };
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
