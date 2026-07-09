import { supabase } from "./supabase";

export interface EventAdmin {
  id:    string;
  email: string;
}

export interface EligibleTeamMember {
  id:    string;
  email: string;
}

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
    .select("id, email, allowed_sections")
    .eq("status", "approved")
    .order("email", { ascending: true });
  if (error) throw error;
  return ((data as { id: string; email: string; allowed_sections: string[] }[]) ?? [])
    .filter(r => (r.allowed_sections ?? []).includes("eventos"))
    .map(r => ({ id: r.id, email: r.email }));
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

export async function addEventAdmin(code: string, email: string): Promise<void> {
  const row = await getApprovedRowByEmail(email);
  if (!row) throw new Error("Ese correo no tiene una cuenta de equipo aprobada.");
  const next = Array.from(new Set([...(row.allowed_events ?? []), code]));
  const { error } = await supabase.from("access_requests").update({ allowed_events: next }).eq("id", row.id);
  if (error) throw error;
}

export async function removeEventAdmin(code: string, email: string): Promise<void> {
  const row = await getApprovedRowByEmail(email);
  if (!row) return;
  const next = (row.allowed_events ?? []).filter(c => c !== code);
  const { error } = await supabase.from("access_requests").update({ allowed_events: next }).eq("id", row.id);
  if (error) throw error;
}
