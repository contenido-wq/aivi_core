export interface Plan {
  name:   string;
  mens:   number;
  anual:  number;
  pagos:  number;
  cancel: number;
}

export interface HourlyPoint {
  t:    string;
  iDom: number;
  iLun: number;
  ing:  number;
  inv:  number;
  vDom: number;
  vLun: number;
  ven:  number;
}

export interface AudioSetting {
  label:       string;
  defaultPath: string;
}

export type ChartMode = "ingresos" | "ventas";
export type Period    = "Día" | "Semanal" | "Últimos 7 días" | "Mensual" | "Últimos 30 días";
export type AppView   = "dashboard" | "admin" | "usuarios";

export type ProductFilter = "todos" | "AIVI" | "MV3";
