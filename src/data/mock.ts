import type { Plan, HourlyPoint, AudioSetting } from "../types";

export const PLANS: Plan[] = [
  { name: "Creator Lite - Método V3", mens: 51, anual: 0, pagos: 51, cancel: 0 },
  { name: "Entry",                    mens: 3,  anual: 0, pagos: 3,  cancel: 1 },
  { name: "Creator Lite",             mens: 1,  anual: 0, pagos: 1,  cancel: 6 },
];

const seed = (n: number) => {
  const x = Math.sin(n + 1) * 10000;
  return x - Math.floor(x);
};

export const HOURLY: HourlyPoint[] = Array.from({ length: 23 }, (_, i) => ({
  t:    `${String(i).padStart(2, "0")}:00`,
  iDom: i < 6 ? seed(i * 3) * 80 + 20  : seed(i * 3) * 200 + 60,
  iLun: i < 6 ? seed(i * 7) * 50       : seed(i * 7) * 130 + 30,
  ing:  0,
  inv:  0,
  vDom: i > 4 && i < 14 ? Math.floor(seed(i * 11) * 3) : 0,
  vLun: i > 7 && i < 13 ? Math.floor(seed(i * 13) * 2) : 0,
  ven:  0,
}));

export const AUDIO_SETTINGS: AudioSetting[] = [
  { label: "Sonido de venta",         defaultPath: "/sounds/sale-notification.mp3"  },
  { label: "Sonido de reembolso",     defaultPath: "/sounds/refund-notification.mp3"},
  { label: "Sonido de plan gratuito", defaultPath: "/sounds/sale-notification.mp3"  },
  { label: "Sonido de cancelación",   defaultPath: "/sounds/refund-notification.mp3"},
  { label: "Sonido de celebración",   defaultPath: "/sounds/celebration.mp3"        },
];

export const MONTHS_ES   = ["enero","febrero","marzo","abril","mayo","junio","julio","agosto","septiembre","octubre","noviembre","diciembre"];
export const MONTHS_LONG = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"];
export const DAYS_SHORT  = ["lu","ma","mi","ju","vi","sá","do"];
export const PERIODS     = ["Día","Semanal","Últimos 7 días","Mensual","Últimos 30 días"] as const;

export const MRR = 201.61;
export const ARR = MRR * 12;
