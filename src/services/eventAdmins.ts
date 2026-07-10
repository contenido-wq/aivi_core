import { supabase } from "./supabase";

export interface TeamMemberEmail {
  id:    string;
  email: string;
}

export type EventAdmin = TeamMemberEmail;
export type EligibleTeamMember = TeamMemberEmail;

export async function listEventAdmins(code: string): Promise<EventAdmin[]> {
  const { data, error } = await supabase
    .from("access_requests")
    .select("id, email")
    .eq("status", "approved")
    .contains("allowed_events", [code])
    .order("email", { ascending: true });
  if (error) throw error;
  return (data as EventAdmin[]) ?? [];
}

export async function listEligibleTeamMembers(): Promise<EligibleTeamMember[]> {
  const { data, error } = await supabase
    .from("access_requests")
    .select("id, email")
    .eq("status", "approved")
    .contains("allowed_sections", ["eventos"])
    .order("email", { ascending: true });
  if (error) throw error;
  return (data as EligibleTeamMember[]) ?? [];
}

async function getApprovedRowByEmail(email: string): Promise<{ id: string; allowed_events: string[] } | null> {
  const { data, error } = await supabase
    .from("access_requests")
    .select("id, allowed_events")
    .eq("email", email)
    .eq("status", "approved")
    .limit(1)
    .maybeSingle();
  if (error) throw error;
  return data as { id: string; allowed_events: string[] } | null;
}

/**
 * Usa funciones de Postgres (add_event_admin/remove_event_admin) que hacen un
 * único UPDATE atómico con array_append/array_remove — evita la condición de
 * carrera de leer-y-luego-escribir el array completo desde el cliente.
 */
export async function addEventAdmin(code: string, email: string): Promise<void> {
  const row = await getApprovedRowByEmail(email);
  if (!row) throw new Error("Ese correo no tiene una cuenta de equipo aprobada.");
  const { error } = await supabase.rpc("add_event_admin", { _email: email, _code: code });
  if (error) throw error;
}

export async function removeEventAdmin(code: string, email: string): Promise<void> {
  const { error } = await supabase.rpc("remove_event_admin", { _email: email, _code: code });
  if (error) throw error;
}
