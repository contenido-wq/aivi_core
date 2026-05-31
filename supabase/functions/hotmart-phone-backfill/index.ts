// @ts-nocheck
import { serve }        from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const HOTMART_AUTH_URL = "https://api-sec-vlc.hotmart.com/security/oauth/token";
const HOTMART_API_URL  = "https://developers.hotmart.com/payments/api/v1";

async function getAccessToken(): Promise<string> {
  const clientId     = Deno.env.get("HOTMART_CLIENT_ID")!;
  const clientSecret = Deno.env.get("HOTMART_CLIENT_SECRET")!;
  const basic        = Deno.env.get("HOTMART_BASIC")!;

  const res = await fetch(
    `${HOTMART_AUTH_URL}?grant_type=client_credentials&client_id=${clientId}&client_secret=${clientSecret}`,
    { method: "POST", headers: { Authorization: basic, "Content-Type": "application/json" } },
  );
  const data = await res.json();
  if (!data.access_token) throw new Error(`Auth failed: ${JSON.stringify(data)}`);
  return data.access_token;
}

/**
 * Modo "inspect": devuelve el raw JSON de un subscriber_code para
 * mapear exactamente qué campos tiene el endpoint individual.
 */
async function inspectEndpoints(token: string, code: string): Promise<any> {
  const endpoints = [
    // Reto 15D con product_id
    `/sales/users?max_results=2&product_id=4857530`,
    // Todos los productos sin filtro
    `/sales/users?max_results=2`,
    // Con product_id del Clon
    `/sales/users?max_results=2&product_id=4337977`,
  ];

  const results: any = {};
  for (const path of endpoints) {
    const url = `${HOTMART_API_URL}${path}`;
    try {
      const res  = await fetch(url, {
        headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" },
      });
      const text = await res.text();
      let body: any;
      try { body = JSON.parse(text); } catch { body = text.slice(0, 400); }
      // Truncar arrays a 1 elemento para legibilidad
      if (body?.items?.length > 1) body.items = body.items.slice(0, 1);
      results[path] = { status: res.status, body };
    } catch (e) {
      results[path] = { error: String(e) };
    }
    await new Promise(r => setTimeout(r, 250));
  }
  return results;
}

/**
 * Modo "list": pagina /sales/users y extrae phone/cellphone del rol BUYER.
 * Este endpoint sí devuelve datos de contacto completos del comprador.
 */
async function fetchPhonesByList(token: string, productId?: string): Promise<Map<string, string>> {
  const phoneMap = new Map<string, string>();
  let pageToken: string | null = null;
  let page = 1;

  while (true) {
    let url = `${HOTMART_API_URL}/sales/users?max_results=500`;
    if (productId) url += `&product_id=${productId}`;
    if (pageToken) url += `&page_token=${pageToken}`;

    const res = await fetch(url, {
      headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" },
    });
    if (!res.ok) {
      console.error(`Error ${res.status}:`, (await res.text()).slice(0, 200));
      break;
    }

    const data  = await res.json();
    const items = data.items ?? [];

    for (const item of items) {
      const buyer = (item.users ?? []).find((u: any) => u.role === "BUYER")?.user;
      if (!buyer) continue;

      const email = (buyer.email ?? "").toLowerCase().trim();
      // Hotmart devuelve phone y cellphone — priorizar el que tenga valor
      const phone = [buyer.cellphone, buyer.phone]
        .map((p: any) => String(p ?? "").trim())
        .find(p => p.length > 4) ?? "";

      if (email && phone) phoneMap.set(email, phone);
    }

    console.log(`Página ${page}: ${items.length} sales/users | phones: ${phoneMap.size}`);
    if (!data.page_info?.next_page_token || items.length === 0) break;
    pageToken = data.page_info.next_page_token;
    page++;
    await new Promise(r => setTimeout(r, 200));
  }

  return phoneMap;
}

/**
 * Modo "codes": consulta subscriber_codes individuales en lotes (offset/limit).
 * Llamar varias veces con offset creciente: 0, 150, 300…
 */
async function fetchPhonesByCodes(
  token: string,
  supabase: any,
  offset: number,
  limit: number,
  phoneField: string,
): Promise<{ phoneMap: Map<string, string>; rawSample: any }> {
  const phoneMap = new Map<string, string>();

  const { data: subs } = await supabase
    .from("subscriptions")
    .select("buyer_email, subscriber_code")
    .range(offset, offset + limit - 1);

  let rawSample: any = null;

  for (const { buyer_email, subscriber_code } of (subs ?? [])) {
    try {
      const res = await fetch(`${HOTMART_API_URL}/subscriptions/${subscriber_code}`, {
        headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" },
      });
      if (!res.ok) continue;
      const data = await res.json();

      // Guardar muestra del primer response para inspección
      if (!rawSample) rawSample = data;

      // Intentar todos los campos posibles donde Hotmart podría poner el teléfono
      const phone =
        data.subscriber?.phone         ??
        data.subscriber?.checkout_phone ??
        data.buyer?.phone              ??
        data.buyer?.checkout_phone     ??
        data[phoneField]               ??
        "";

      if (phone) phoneMap.set(buyer_email.toLowerCase().trim(), String(phone).trim());
    } catch { /* ignorar errores individuales */ }

    await new Promise(r => setTimeout(r, 120));
  }

  return { phoneMap, rawSample };
}

/** Escribe el mapa email→phone en transactions usando la función SQL update_buyer_phone */
async function applyPhones(
  supabase: any,
  phoneMap: Map<string, string>,
): Promise<{ updated: number; no_match: number }> {
  let updated  = 0;
  let no_match = 0;

  for (const [email, phone] of phoneMap) {
    const { data, error } = await supabase.rpc("update_buyer_phone", {
      p_email: email,
      p_phone: phone,
    });

    const rows = error ? 0 : (Number(data) || 0);
    if (rows > 0) updated += rows;
    else no_match++;
  }

  return { updated, no_match };
}

serve(async (req) => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const url        = new URL(req.url);
  const dryRun     = url.searchParams.get("dry_run") === "true";
  const mode       = url.searchParams.get("mode") ?? "list";
  const offset     = parseInt(url.searchParams.get("offset") ?? "0", 10);
  const limit      = parseInt(url.searchParams.get("limit")  ?? "150", 10);
  const phoneField = url.searchParams.get("phone_field") ?? "";
  const inspectCode = url.searchParams.get("inspect");

  console.log(`Backfill mode=${mode} dry_run=${dryRun} offset=${offset} limit=${limit}`);

  try {
    const token = await getAccessToken();
    console.log("✅ Token OK");

    // Modo inspect: prueba varios endpoints para un subscriber_code
    if (inspectCode) {
      const raw = await inspectEndpoints(token, inspectCode);
      return new Response(JSON.stringify({ ok: true, raw }, null, 2), {
        headers: { "Content-Type": "application/json" },
      });
    }

    let phoneMap: Map<string, string>;
    let rawSample: any = null;

    const productId = url.searchParams.get("product_id") ?? undefined;

    if (mode === "codes") {
      const result = await fetchPhonesByCodes(token, supabase, offset, limit, phoneField);
      phoneMap  = result.phoneMap;
      rawSample = result.rawSample;
    } else {
      phoneMap = await fetchPhonesByList(token, productId);
    }

    console.log(`Teléfonos encontrados: ${phoneMap.size}`);

    if (dryRun) {
      return new Response(JSON.stringify({
        ok:           true,
        dry_run:      true,
        mode,
        offset,
        limit,
        phones_found: phoneMap.size,
        sample:       [...phoneMap.entries()].slice(0, 8).map(([e, p]) => ({ email: e, phone: p })),
        raw_sample:   rawSample,
      }, null, 2), { headers: { "Content-Type": "application/json" } });
    }

    const { updated, no_match } = await applyPhones(supabase, phoneMap);

    return new Response(JSON.stringify({
      ok: true,
      mode,
      phones_found: phoneMap.size,
      txs_updated:  updated,
      no_match,
    }), { headers: { "Content-Type": "application/json" } });

  } catch (e) {
    console.error("Backfill failed:", e);
    return new Response(JSON.stringify({ ok: false, error: String(e) }), { status: 500 });
  }
});
