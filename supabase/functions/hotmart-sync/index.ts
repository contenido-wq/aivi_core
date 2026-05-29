// @ts-nocheck
import { serve }        from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

/** Devuelve la fecha en Colombia (UTC-5) como "YYYY-MM-DD" */
function toColombiaDate(d: Date): string {
  const local = new Date(d.getTime() - 5 * 60 * 60 * 1000);
  return local.toISOString().split("T")[0];
}

const HOTMART_AUTH_URL = "https://api-sec-vlc.hotmart.com/security/oauth/token";
const HOTMART_API_URL  = "https://developers.hotmart.com/payments/api/v1";

async function getAccessToken(): Promise<string> {
  const clientId     = Deno.env.get("HOTMART_CLIENT_ID")!;
  const clientSecret = Deno.env.get("HOTMART_CLIENT_SECRET")!;
  const basic        = Deno.env.get("HOTMART_BASIC")!;

  const res = await fetch(
    `${HOTMART_AUTH_URL}?grant_type=client_credentials&client_id=${clientId}&client_secret=${clientSecret}`,
    { method: "POST", headers: { "Authorization": basic, "Content-Type": "application/json" } }
  );
  const data = await res.json();
  if (!data.access_token) throw new Error(`Auth failed: ${JSON.stringify(data)}`);
  return data.access_token;
}

async function fetchAllSales(token: string, startDate: string, endDate: string) {
  const sales: any[] = [];
  let pageToken: string | null = null;
  let page = 1;

  while (true) {
    let url = `${HOTMART_API_URL}/sales/history?start_date=${startDate}&end_date=${endDate}&max_results=100`;
    if (pageToken) url += `&page_token=${pageToken}`;

    console.log(`Fetching página ${page}...`);

    const res = await fetch(url, {
      headers: { "Authorization": `Bearer ${token}`, "Content-Type": "application/json" },
    });

    if (!res.ok) {
      console.error("API error:", res.status, await res.text());
      break;
    }

    const data = await res.json();
    const items = data.items ?? [];
    sales.push(...items);

    console.log(`Página ${page}: ${items.length} registros — total acumulado: ${sales.length}`);

    if (!data.page_info?.next_page_token || items.length === 0) break;
    pageToken = data.page_info.next_page_token;
    page++;

    // Pequeña pausa para no saturar la API
    await new Promise(r => setTimeout(r, 200));
  }

  return sales;
}

// Mapeo de offer.code de Hotmart → nombre legible del plan
// Agregar nuevos códigos aquí cuando se creen nuevas ofertas en Hotmart
const OFFER_NAMES: Record<string, string> = {
  "z48o3uz9": "AIVI — Creator Lite Semestral",
};

serve(async (req) => {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const url       = new URL(req.url);
  const startDate = url.searchParams.get("start") ?? "1735689600000";
  const endDate   = url.searchParams.get("end")   ?? String(Date.now());

  console.log(`Sincronizando ventas del ${startDate} al ${endDate}`);

  try {
    const token = await getAccessToken();
    console.log("✅ Token OK");

    const sales = await fetchAllSales(token, startDate, endDate);
    console.log(`Total ventas encontradas: ${sales.length}`);

    let inserted = 0;
    let errors   = 0;
    const dailyMap: Record<string, any> = {};

    for (const sale of sales) {
      try {
        const purchase        = sale.purchase ?? {};
        const buyer           = sale.buyer    ?? {};
        const product         = sale.product  ?? {};
        const subscription    = sale.subscription ?? {};

        const hotmart_id      = purchase.transaction ?? String(sale.id ?? Math.random());
        const event_type      = purchase.status      ?? "COMPLETE";
        const buyer_name      = buyer.name           ?? "";
        const buyer_email     = buyer.email          ?? "";
        const buyer_phone     = buyer.checkout_phone ?? buyer.phone ?? "";
        const buyer_country   = buyer.address?.country ?? "";
        const offer_code      = purchase.offer?.code ?? "";
        const sale_origin     = purchase.origin ?? "";
        const traffic_source  = sale.tracking?.src ?? sale.tracking?.source_sck ?? "";
        const plan_name       = OFFER_NAMES[offer_code] ?? product.name ?? "AIVI";
        const amount          = Number(purchase.price?.value ?? 0);
        const currency        = purchase.price?.currency_code ?? "USD";
        const subscriber_code = subscription?.subscriber?.code ?? hotmart_id;
        const order_date      = purchase.order_date
          ? new Date(purchase.order_date).toISOString()
          : new Date().toISOString();
        const date_key        = toColombiaDate(new Date(order_date));
        const status          = deriveStatus(event_type);

        // Acumular por día
        if (!dailyMap[date_key]) {
          dailyMap[date_key] = { revenue: 0, new_users: 0, refunds: 0, cancellations: 0, trials: 0 };
        }
        const d = dailyMap[date_key];
        const e = event_type.toUpperCase();
        if (["COMPLETE","APPROVED"].includes(e))      { d.new_users++; d.revenue += amount; }
        if (e.includes("REFUND"))                      { d.refunds++;   d.revenue -= amount; }
        if (e.includes("CANCEL"))                        d.cancellations++;
        if (e.includes("PROTEST") || e === "TRIAL")      d.trials++;

        await supabase.from("transactions").upsert({
          hotmart_id,
          event_type,
          buyer_name,
          buyer_email,
          buyer_phone,
          buyer_country,
          offer_code,
          sale_origin,
          traffic_source,
          plan_name,
          amount,
          currency,
          status,
          raw_payload: sale,
          created_at: order_date,
        }, { onConflict: "hotmart_id" });

        await supabase.from("subscriptions").upsert({
          subscriber_code,
          buyer_email,
          buyer_name,
          plan_name,
          status,
          amount,
          currency,
          updated_at: new Date().toISOString(),
        }, { onConflict: "subscriber_code" });

        inserted++;
      } catch (e) {
        console.error("Error en venta:", e);
        errors++;
      }
    }

    // Obtener total de activos
    const { count: active_total } = await supabase
      .from("subscriptions")
      .select("*", { count: "exact", head: true })
      .eq("status", "active");

    // Guardar daily_metrics por cada día
    for (const [date, m] of Object.entries(dailyMap)) {
      await supabase.from("daily_metrics").upsert({
        date,
        revenue:       Math.max(0, m.revenue),
        investment:    0,
        new_users:     m.new_users,
        recurring:     0,
        trials:        m.trials,
        refunds:       m.refunds,
        cancellations: m.cancellations,
        active_total:  active_total ?? 0,
        updated_at:    new Date().toISOString(),
      }, { onConflict: "date" });
    }

    console.log(`✅ Sync completo — ${inserted} insertados, ${errors} errores`);
    return new Response(JSON.stringify({
      ok: true,
      total:    sales.length,
      inserted,
      errors,
      dias:     Object.keys(dailyMap).length,
    }), { headers: { "Content-Type": "application/json" } });

  } catch (e) {
    console.error("Sync failed:", e);
    return new Response(JSON.stringify({ ok: false, error: String(e) }), { status: 500 });
  }
});

function deriveStatus(event: string): string {
  const e = event.toUpperCase();
  if (["COMPLETE","APPROVED"].includes(e))               return "active";
  if (e.includes("REFUND"))                              return "refunded";
  if (e.includes("CANCEL"))                              return "cancelled";
  if (e.includes("DELAY"))                               return "delayed";
  if (e.includes("PROTEST") || e === "TRIAL")            return "trial";
  return "active";
}
