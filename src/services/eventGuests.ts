import bcrypt from "bcryptjs";
import { supabase } from "./supabase";

export const GUEST_SESSION_KEY = "aivi_event_guest_session";

export interface GuestSession {
  enrollment_code: string;
  label:           string | null;
}

export interface EventGuest {
  id:              string;
  enrollment_code: string;
  username:        string;
  label:           string | null;
  created_at:      string;
  last_login_at:   string | null;
}

export async function createEventGuest(code: string, username: string, password: string, label?: string): Promise<void> {
  const password_hash = bcrypt.hashSync(password, 10);
  const { error } = await supabase
    .from("event_guests")
    .insert({ enrollment_code: code, username: username.trim(), password_hash, label: label?.trim() || null });
  if (error) throw error;
}

export async function listEventGuests(code: string): Promise<EventGuest[]> {
  const { data, error } = await supabase
    .from("event_guests")
    .select("id, enrollment_code, username, label, created_at, last_login_at")
    .eq("enrollment_code", code)
    .order("created_at", { ascending: false });
  if (error) throw error;
  return (data as EventGuest[]) ?? [];
}

export async function deleteEventGuest(id: string): Promise<void> {
  const { error } = await supabase.from("event_guests").delete().eq("id", id);
  if (error) throw error;
}

export async function loginEventGuest(username: string, password: string): Promise<GuestSession> {
  const { data, error } = await supabase.functions.invoke("event-guest-login", {
    body: { username: username.trim(), password },
  });
  if (error) throw new Error("No se pudo verificar el acceso. Intenta de nuevo.");
  if (!data?.ok) throw new Error(data?.error ?? "Usuario o contraseña incorrectos.");
  return { enrollment_code: data.enrollment_code, label: data.label ?? null };
}
