import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

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
    const { guestId } = await req.json();
    if (!guestId) {
      return respond({ ok: false, error: "guestId es requerido" }, 400);
    }

    // Cliente admin con service_role — el invitado no tiene sesión de
    // Supabase Auth, así que event_users no es legible bajo su propio rol
    // (RLS solo permite `authenticated`). Esta function es el único puente:
    // valida que el guestId siga existiendo (el admin puede revocar
    // borrando la fila) y devuelve solo los datos de SU evento asignado.
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    const { data: guest, error: guestErr } = await supabaseAdmin
      .from("event_guests")
      .select("enrollment_code, label")
      .eq("id", guestId)
      .maybeSingle();

    if (guestErr || !guest) {
      return respond({ ok: false, error: "Acceso revocado o inválido." });
    }

    const { data: users, error: usersErr } = await supabaseAdmin
      .from("event_users")
      .select("*")
      .eq("enrollment_code", guest.enrollment_code)
      .limit(50000);

    if (usersErr) {
      return respond({ ok: false, error: "Error al cargar los datos del evento." }, 500);
    }

    return respond({
      ok: true,
      enrollment_code: guest.enrollment_code,
      label: guest.label,
      users: users ?? [],
    });
  } catch (_e) {
    return respond({ ok: false, error: "Error interno" }, 500);
  }
});
