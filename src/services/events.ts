import Papa from "papaparse";
import { supabase } from "./supabase";

export interface EventUserRow {
  enrollment_code:              string;
  variacion:                    string | null;
  external_user_id:             string | null;
  nombre:                       string | null;
  email:                        string;
  usuario_activo:               boolean;
  verificado:                   boolean;
  registrado_el:                string | null;
  plan:                         string | null;
  estado_plan:                  string | null;
  ciclo_inicio:                 string | null;
  ciclo_fin:                    string | null;
  tokens_plan_consumidos_ciclo: number;
  tokens_plan_consumidos_total: number;
  adn_creator_exitosas:         number; adn_creator_ultima:         string | null;
  adn_view_exitosas:            number; adn_view_ultima:            string | null;
  analista_exitosas:            number; analista_ultima:            string | null;
  calendar_exitosas:            number; calendar_ultima:            string | null;
  carousel_generator_exitosas:  number; carousel_generator_ultima:  string | null;
  carousel_pro_exitosas:        number; carousel_pro_ultima:        string | null;
  chat_response_exitosas:       number; chat_response_ultima:       string | null;
  espia_ai_exitosas:            number; espia_ai_ultima:            string | null;
  referente_search_exitosas:    number; referente_search_ultima:    string | null;
  sales_simulator_exitosas:     number; sales_simulator_ultima:     string | null;
  script_generator_exitosas:    number; script_generator_ultima:    string | null;
  transcriptor_exitosas:        number; transcriptor_ultima:        string | null;
  viral_ideas_exitosas:         number; viral_ideas_ultima:         string | null;
}

export interface EventSummary {
  code:       string;
  label:      string;
  total:      number;
  activos:    number;
  verificados: number;
}

export interface ModuleUsageRow {
  key:            string;
  label:          string;
  usersWithUsage: number;
  pct:            number;
  totalUses:      number;
}

export type UserStatus = "no_activado" | "sin_tokens" | "con_tokens";

export interface StatusBreakdownRow {
  status: UserStatus;
  label:  string;
  count:  number;
  pct:    number;
}

export function userStatus(u: EventUserRow): UserStatus {
  if (!u.usuario_activo) return "no_activado";
  return u.tokens_plan_consumidos_total > 0 ? "con_tokens" : "sin_tokens";
}

export const STATUS_LABELS: Record<UserStatus, string> = {
  no_activado: "No activado",
  sin_tokens:  "Por empezar",
  con_tokens:  "Generó contenido con IA",
};

export const MODULES: { key: string; label: string }[] = [
  { key: "adn_creator",         label: "ADN Creator"      },
  { key: "adn_view",            label: "ADN View"         },
  { key: "analista",            label: "Analista"         },
  { key: "calendar",            label: "Calendario"       },
  { key: "carousel_generator",  label: "Carrusel Generator" },
  { key: "carousel_pro",        label: "Carrusel Pro"     },
  { key: "chat_response",       label: "Chat"             },
  { key: "espia_ai",            label: "Espía AI"         },
  { key: "referente_search",    label: "Referentes"       },
  { key: "sales_simulator",     label: "Simulador de Ventas" },
  { key: "script_generator",    label: "Generador de Guiones" },
  { key: "transcriptor",        label: "Transcriptor"     },
  { key: "viral_ideas",         label: "Ideas Virales"    },
];

function toBool(v: unknown): boolean {
  return String(v ?? "").trim().toUpperCase() === "TRUE";
}

function toIntOrZero(v: unknown): number {
  const n = parseInt(String(v ?? "").trim(), 10);
  return isNaN(n) ? 0 : n;
}

function toTextOrNull(v: unknown): string | null {
  const s = String(v ?? "").trim();
  return s === "" ? null : s;
}

export function parseEventCSV(file: File): Promise<EventUserRow[]> {
  return new Promise((resolve, reject) => {
    Papa.parse<Record<string, string>>(file, {
      header: true,
      skipEmptyLines: true,
      complete: (result) => {
        const rows: EventUserRow[] = result.data
          .filter(r => toTextOrNull(r.email) && toTextOrNull(r.enrollment_code))
          .map(r => ({
            enrollment_code:              r.enrollment_code.trim(),
            variacion:                    toTextOrNull(r.variacion),
            external_user_id:             toTextOrNull(r.user_id),
            nombre:                       toTextOrNull(r.nombre),
            email:                        r.email.trim().toLowerCase(),
            usuario_activo:               toBool(r.usuario_activo),
            verificado:                   toBool(r.verificado),
            registrado_el:                toTextOrNull(r.registrado_el),
            plan:                         toTextOrNull(r.plan),
            estado_plan:                  toTextOrNull(r.estado_plan),
            ciclo_inicio:                 toTextOrNull(r.ciclo_inicio),
            ciclo_fin:                    toTextOrNull(r.ciclo_fin),
            tokens_plan_consumidos_ciclo: toIntOrZero(r.tokens_plan_consumidos_ciclo),
            tokens_plan_consumidos_total: toIntOrZero(r.tokens_plan_consumidos_total),
            adn_creator_exitosas:         toIntOrZero(r.adn_creator_exitosas),         adn_creator_ultima:         toTextOrNull(r.adn_creator_ultima),
            adn_view_exitosas:            toIntOrZero(r.adn_view_exitosas),            adn_view_ultima:            toTextOrNull(r.adn_view_ultima),
            analista_exitosas:            toIntOrZero(r.analista_exitosas),            analista_ultima:            toTextOrNull(r.analista_ultima),
            calendar_exitosas:            toIntOrZero(r.calendar_exitosas),            calendar_ultima:            toTextOrNull(r.calendar_ultima),
            carousel_generator_exitosas:  toIntOrZero(r.carousel_generator_exitosas),  carousel_generator_ultima:  toTextOrNull(r.carousel_generator_ultima),
            carousel_pro_exitosas:        toIntOrZero(r.carousel_pro_exitosas),        carousel_pro_ultima:        toTextOrNull(r.carousel_pro_ultima),
            chat_response_exitosas:       toIntOrZero(r.chat_response_exitosas),       chat_response_ultima:       toTextOrNull(r.chat_response_ultima),
            espia_ai_exitosas:            toIntOrZero(r.espia_ai_exitosas),            espia_ai_ultima:            toTextOrNull(r.espia_ai_ultima),
            referente_search_exitosas:    toIntOrZero(r.referente_search_exitosas),    referente_search_ultima:    toTextOrNull(r.referente_search_ultima),
            sales_simulator_exitosas:     toIntOrZero(r.sales_simulator_exitosas),     sales_simulator_ultima:     toTextOrNull(r.sales_simulator_ultima),
            script_generator_exitosas:    toIntOrZero(r.script_generator_exitosas),    script_generator_ultima:    toTextOrNull(r.script_generator_ultima),
            transcriptor_exitosas:        toIntOrZero(r.transcriptor_exitosas),        transcriptor_ultima:        toTextOrNull(r.transcriptor_ultima),
            viral_ideas_exitosas:         toIntOrZero(r.viral_ideas_exitosas),         viral_ideas_ultima:         toTextOrNull(r.viral_ideas_ultima),
          }));
        resolve(rows);
      },
      error: (err) => reject(err),
    });
  });
}

export async function uploadEventUsers(rows: EventUserRow[]): Promise<{ count: number }> {
  const CHUNK = 500;
  for (let i = 0; i < rows.length; i += CHUNK) {
    const chunk = rows.slice(i, i + CHUNK);
    const { error } = await supabase
      .from("event_users")
      .upsert(chunk, { onConflict: "enrollment_code,email" });
    if (error) throw error;
  }
  return { count: rows.length };
}

async function fetchAllEventUsers(): Promise<EventUserRow[]> {
  const { data, error } = await supabase
    .from("event_users")
    .select("*")
    .limit(50000);
  if (error) throw error;
  return (data as EventUserRow[]) ?? [];
}

export async function getEventsSummary(): Promise<EventSummary[]> {
  const rows = await fetchAllEventUsers();

  const byCode: Record<string, EventUserRow[]> = {};
  for (const r of rows) {
    if (!byCode[r.enrollment_code]) byCode[r.enrollment_code] = [];
    byCode[r.enrollment_code].push(r);
  }

  return Object.entries(byCode)
    .map(([code, users]) => {
      const labelCounts: Record<string, number> = {};
      for (const u of users) {
        const l = u.variacion ?? code;
        labelCounts[l] = (labelCounts[l] ?? 0) + 1;
      }
      const label = Object.entries(labelCounts).sort((a, b) => b[1] - a[1])[0]?.[0] ?? code;

      return {
        code,
        label,
        total:       users.length,
        activos:     users.filter(u => u.usuario_activo).length,
        verificados: users.filter(u => u.verificado).length,
      };
    })
    .sort((a, b) => b.total - a.total);
}

export async function getEventDetail(code: string): Promise<{
  users: EventUserRow[];
  moduleUsage: ModuleUsageRow[];
  statusBreakdown: StatusBreakdownRow[];
}> {
  const rows = await fetchAllEventUsers();
  const users = rows.filter(u => u.enrollment_code === code);

  const moduleUsage: ModuleUsageRow[] = MODULES.map(m => {
    const exitosasKey = `${m.key}_exitosas` as keyof EventUserRow;
    const usersWithUsage = users.filter(u => (u[exitosasKey] as number) > 0).length;
    const totalUses = users.reduce((s, u) => s + (u[exitosasKey] as number), 0);
    return {
      key:   m.key,
      label: m.label,
      usersWithUsage,
      pct:   users.length > 0 ? Math.round((usersWithUsage / users.length) * 100) : 0,
      totalUses,
    };
  }).sort((a, b) => b.usersWithUsage - a.usersWithUsage);

  const order: UserStatus[] = ["no_activado", "sin_tokens", "con_tokens"];
  const statusBreakdown: StatusBreakdownRow[] = order.map(status => {
    const count = users.filter(u => userStatus(u) === status).length;
    return {
      status,
      label: STATUS_LABELS[status],
      count,
      pct: users.length > 0 ? Math.round((count / users.length) * 100) : 0,
    };
  });

  return { users, moduleUsage, statusBreakdown };
}
