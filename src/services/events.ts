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
  /** No viene en el CSV — se cruza con transactions.buyer_phone después de cargar */
  phone?:                       string | null;
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

/** Mismo criterio que getUsersTraceability en dashboard.ts: columna buyer_phone primero, luego raw_payload. */
function extractPhone(tx: { buyer_phone?: string | null; raw_payload?: unknown }): string | null {
  if (tx.buyer_phone && String(tx.buyer_phone).trim() !== "") return String(tx.buyer_phone).trim();
  try {
    const rp = typeof tx.raw_payload === "string" ? JSON.parse(tx.raw_payload) : (tx.raw_payload as any);
    const p = rp?.data?.buyer?.checkout_phone ?? rp?.data?.buyer?.phone ?? rp?.buyer?.checkout_phone ?? rp?.buyer?.phone ?? null;
    if (p && String(p).trim() !== "") return String(p).trim();
  } catch { /* ignore */ }
  return null;
}

/** Cruza emails de un evento con transactions para traer el teléfono, cuando exista. */
export async function getPhonesByEmail(emails: string[]): Promise<Record<string, string>> {
  if (emails.length === 0) return {};
  const { data, error } = await supabase
    .from("transactions")
    .select("buyer_email, buyer_phone, raw_payload")
    .in("buyer_email", emails);
  if (error || !data) return {};

  const map: Record<string, string> = {};
  for (const tx of data as { buyer_email: string; buyer_phone: string | null; raw_payload: unknown }[]) {
    if (map[tx.buyer_email]) continue;
    const phone = extractPhone(tx);
    if (phone) map[tx.buyer_email] = phone;
  }
  return map;
}

export async function updateEventUserField(
  code: string,
  email: string,
  fields: { nombre?: string; phone?: string }
): Promise<void> {
  const patch: Record<string, string> = {};
  if (fields.nombre !== undefined) patch.nombre = fields.nombre.trim();
  if (fields.phone  !== undefined) patch.phone  = fields.phone.trim();
  if (Object.keys(patch).length === 0) return;

  const { error } = await supabase
    .from("event_users")
    .update(patch)
    .eq("enrollment_code", code)
    .eq("email", email);
  if (error) throw error;
}

export async function setEventDisplayName(code: string, name: string): Promise<void> {
  const { error } = await supabase
    .from("events")
    .upsert({ enrollment_code: code, display_name: name.trim() }, { onConflict: "enrollment_code" });
  if (error) throw error;
}

async function fetchDisplayNames(): Promise<Record<string, string>> {
  const { data, error } = await supabase.from("events").select("enrollment_code, display_name");
  if (error) throw error;
  const map: Record<string, string> = {};
  for (const r of data ?? []) {
    if (r.display_name && r.display_name.trim() !== "") map[r.enrollment_code] = r.display_name;
  }
  return map;
}

export async function getEventsSummary(): Promise<EventSummary[]> {
  const [rows, displayNames] = await Promise.all([fetchAllEventUsers(), fetchDisplayNames()]);

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
      const autoLabel = Object.entries(labelCounts).sort((a, b) => b[1] - a[1])[0]?.[0] ?? code;

      return {
        code,
        label:       displayNames[code] ?? autoLabel,
        total:       users.length,
        activos:     users.filter(u => u.usuario_activo).length,
        verificados: users.filter(u => u.verificado).length,
      };
    })
    .sort((a, b) => b.total - a.total);
}

export function computeModuleUsage(users: EventUserRow[]): ModuleUsageRow[] {
  return MODULES.map(m => {
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
}

export function computeStatusBreakdown(users: EventUserRow[]): StatusBreakdownRow[] {
  const order: UserStatus[] = ["no_activado", "sin_tokens", "con_tokens"];
  return order.map(status => {
    const count = users.filter(u => userStatus(u) === status).length;
    return {
      status,
      label: STATUS_LABELS[status],
      count,
      pct: users.length > 0 ? Math.round((count / users.length) * 100) : 0,
    };
  });
}

export async function getEventDetail(code: string): Promise<{
  users: EventUserRow[];
  moduleUsage: ModuleUsageRow[];
  statusBreakdown: StatusBreakdownRow[];
}> {
  const rows = await fetchAllEventUsers();
  const users = rows.filter(u => u.enrollment_code === code);
  return { users, moduleUsage: computeModuleUsage(users), statusBreakdown: computeStatusBreakdown(users) };
}

/**
 * Igual que getEventDetail, pero para una sesión de invitado (sin sesión de
 * Supabase Auth — RLS le bloquea event_users). Pasa por la Edge Function
 * event-guest-data, que usa service_role y solo devuelve el evento asignado
 * a ese guestId (revocable borrando la fila en event_guests).
 */
export async function getEventDetailAsGuest(guestId: string): Promise<
  | { ok: true; enrollment_code: string; label: string | null; users: EventUserRow[]; moduleUsage: ModuleUsageRow[]; statusBreakdown: StatusBreakdownRow[] }
  | { ok: false; error: string }
> {
  const { data, error } = await supabase.functions.invoke("event-guest-data", { body: { guestId } });
  if (error) return { ok: false, error: "No se pudo cargar el evento." };
  if (!data?.ok) return { ok: false, error: data?.error ?? "Acceso revocado." };
  const users = (data.users as EventUserRow[]) ?? [];
  return {
    ok: true,
    enrollment_code: data.enrollment_code,
    label: data.label ?? null,
    users,
    moduleUsage: computeModuleUsage(users),
    statusBreakdown: computeStatusBreakdown(users),
  };
}
