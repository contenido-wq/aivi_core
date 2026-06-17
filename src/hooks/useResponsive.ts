import { useState, useEffect, useCallback } from "react";

export type Breakpoint = "mobile" | "tablet" | "desktop";

interface ResponsiveState {
  bp: Breakpoint;
  isMobile: boolean;
  isTablet: boolean;
  isDesktop: boolean;
  isShortScreen: boolean;
  /** true when width >= 1440px (monitor externo, TV conectado a Mac) */
  isLarge: boolean;
  /** true when width >= 1920px (full HD+ o 4K) */
  isXLarge: boolean;
  width: number;
  height: number;
}

export function useResponsive(): ResponsiveState {
  const calc = useCallback((): ResponsiveState => {
    const w = typeof window !== "undefined" ? window.innerWidth  : 1200;
    const h = typeof window !== "undefined" ? window.innerHeight : 900;
    const isShortScreen = h < 820;
    const isLarge  = w >= 1440;
    const isXLarge = w >= 1920;
    if (w < 768)  return { bp: "mobile",  isMobile: true,  isTablet: false, isDesktop: false, isShortScreen, isLarge, isXLarge, width: w, height: h };
    if (w < 1024) return { bp: "tablet",  isMobile: false, isTablet: true,  isDesktop: false, isShortScreen, isLarge, isXLarge, width: w, height: h };
    return                { bp: "desktop", isMobile: false, isTablet: false, isDesktop: true,  isShortScreen, isLarge, isXLarge, width: w, height: h };
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
