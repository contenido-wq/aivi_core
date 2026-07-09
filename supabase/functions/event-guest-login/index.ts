import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import bcrypt from "npm:bcryptjs@2.4.3";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

function respond(body: Record<string, unknown>, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { username, password } = await req.json();

    if (!username || !password) {
      return respond({ ok: false, error: "Usuario y contraseña son requeridos" }, 400);
    }

    // Cliente admin con service_role — el invitado nunca consulta esta tabla
    // directamente, ni ve el hash de la contraseña.
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    const { data: guest, error } = await supabaseAdmin
      .from("event_guests")
      .select("id, enrollment_code, username, password_hash, label")
      .eq("username", String(username).trim())
      .maybeSingle();

    // Mismo mensaje genérico tanto si el usuario no existe como si la
    // contraseña no coincide — no revelar cuál de los dos falló.
    if (error || !guest) {
      return respond({ ok: false, error: "Usuario o contraseña incorrectos" });
    }

    const valid = bcrypt.compareSync(String(password), guest.password_hash);
    if (!valid) {
      return respond({ ok: false, error: "Usuario o contraseña incorrectos" });
    }

    await supabaseAdmin
      .from("event_guests")
      .update({ last_login_at: new Date().toISOString() })
      .eq("id", guest.id);

    return respond({ ok: true, enrollment_code: guest.enrollment_code, label: guest.label, guestId: guest.id });
  } catch (_e) {
    return respond({ ok: false, error: "Error interno" }, 500);
  }
});
