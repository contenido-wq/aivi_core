// @ts-nocheck
import { serve }        from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

declare const Deno: {
  env:  { get(key: string): string | undefined };
  cron: (name: string, schedule: string, handler: () => Promise<void>) => void;
};

/** Devuelve la fecha en Colombia (UTC-5) como "YYYY-MM-DD" */
function toColombiaDate(d: Date): string {
  const local = new Date(d.getTime() - 5 * 60 * 60 * 1000);
  return local.toISOString().split("T")[0];
}

// Meta/Utmify concatena {prefijo}|campaña|adset|ad|placement en
// purchase.tracking.external_code, separados por este token fijo (confirmado
// contra transacciones reales — ver docs/superpowers/specs/2026-07-06-ad-level-attribution-metrics-design.md).
// Cada segmento de campaña/adset/ad termina en "|<id numérico>" que hay que
// separar del nombre; placement no tiene id.
const EXTERNAL_CODE_DELIMITER = "hQwK21wXxR";

interface TrackingSegments {
  campaignName: string | null;
  campaignId:   string | null;
  adsetName:    string | null;
  adsetId:      string | null;
  adName:       string | null;
  adId:         string | null;
  placement:    string | null;
}

function splitNameAndId(segment: string | undefined): { name: string | null; id: string | null } {
  if (!segment) return { name: null, id: null };
  const match = segment.match(/^(.*)\|(\d+)$/);
  if (match) {
    const name = match[1].trim();
    return { name: name || null, id: match[2] };
  }
  const trimmed = segment.trim();
  return { name: trimmed || null, id: null };
}

function extractTrackingSegments(externalCode: string | undefined | null): TrackingSegments {
  const empty: TrackingSegments = {
    campaignName: null, campaignId: null,
    adsetName: null, adsetId: null,
    adName: null, adId: null,
    placement: null,
  };
  if (!externalCode || !externalCode.includes(EXTERNAL_CODE_DELIMITER)) return empty;
  const parts = externalCode.split(EXTERNAL_CODE_DELIMITER);
  const campaign  = splitNameAndId(parts[1]);
  const adset     = splitNameAndId(parts[2]);
  const ad        = splitNameAndId(parts[3]);
  const placement = (parts[4] ?? "").trim() || null;
  return {
    campaignName: campaign.name, campaignId: campaign.id,
    adsetName:    adset.name,    adsetId:    adset.id,
    adName:       ad.name,       adId:       ad.id,
    placement,
  };
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

/** Ventana de 3 días (con solape) para la corrida automática — captura renovaciones
 *  y reintentos recientes sin re-descargar todo el histórico en cada corrida. */
function lastDaysRange(days: number): { start: string; end: string } {
  const end = Date.now();
  const start = end - days * 24 * 60 * 60 * 1000;
  return { start: String(start), end: String(end) };
}

async function runSync(startDate: string, endDate: string): Promise<Response> {
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  console.log(`Sincronizando ventas del ${startDate} al ${endDate}`);

  try {
    const token = await getAccessToken();
    console.log("✅ Token OK");

    const rawSales = await fetchAllSales(token, startDate, endDate);
    console.log(`Total ventas encontradas: ${rawSales.length}`);

    // Ordenar cronológicamente (más antiguo primero) para que el evento más reciente
    // sea siempre el último en upsertarse y defina el estado final de la suscripción.
    const sales = [...rawSales].sort((a, b) => {
      const dateA = Number(a.purchase?.order_date ?? 0);
      const dateB = Number(b.purchase?.order_date ?? 0);
      return dateA - dateB;
    });

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
        const tracking        = purchase.tracking;
        const sale_origin     = tracking?.source_sck ?? tracking?.source ?? "";
        const segments        = extractTrackingSegments(tracking?.external_code);
        const traffic_source  = segments.campaignName ?? tracking?.source_sck ?? "";
        const plan_name       = OFFER_NAMES[offer_code] ?? product.name ?? "AIVI";
        const amount          = Number(purchase.price?.value ?? 0);
        const currency        = purchase.price?.currency_code ?? "USD";
        // Hotmart no siempre envía subscription.subscriber.code en cobros recurrentes
        // (solo en el pago inicial). Si cae a hotmart_id, cada renovación mensual genera
        // un hotmart_id distinto y el upsert onConflict:"subscriber_code" nunca matchea
        // la fila anterior, duplicando la suscripción cada mes. Usamos email+plan como
        // llave estable para que las renovaciones actualicen la misma fila.
        const subscriber_code = subscription?.subscriber?.code
          ?? (buyer_email ? `EMAIL:${buyer_email.toLowerCase().trim()}::${plan_name}` : hotmart_id);
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

        // La API de historial de Hotmart no devuelve teléfono — omitir buyer_phone
        // del upsert para no sobreescribir el que llegó por webhook
        const txRecord: Record<string, any> = {
          hotmart_id,
          event_type,
          buyer_name,
          buyer_email,
          buyer_country,
          offer_code,
          sale_origin,
          traffic_source,
          ad_id:      segments.adId,
          ad_name:    segments.adName,
          adset_id:   segments.adsetId,
          adset_name: segments.adsetName,
          placement:  segments.placement,
          plan_name,
          amount,
          currency,
          status,
          raw_payload: sale,
          created_at: order_date,
        };
        if (buyer_phone) txRecord.buyer_phone = buyer_phone;

        // Para cancelaciones, no sobreescribir filas existentes:
        // la suscripción terminó pero el dinero ya fue recibido y cuenta como revenue.
        // Refunds/chargebacks sí sobreescriben porque implican devolución de dinero.
        const upsertOpts = status === "cancelled"
          ? { onConflict: "hotmart_id", ignoreDuplicates: true }
          : { onConflict: "hotmart_id" };
        await supabase.from("transactions").upsert(txRecord, upsertOpts);

        const { error: subError } = await supabase.from("subscriptions").upsert({
          subscriber_code,
          buyer_email,
          buyer_name,
          plan_name,
          status,
          amount,
          currency,
          updated_at: order_date,
        }, { onConflict: "subscriber_code" });
        if (subError) console.error("Error upsert subscriptions:", subError);

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
}

// Corrida diaria automática — red de seguridad para renovaciones/eventos que el
// webhook en tiempo real no haya recibido (caídas, reintentos de Hotmart, etc).
if (typeof Deno.cron === "function") {
  Deno.cron("hotmart-sync-daily", "0 6 * * *", async () => {
    const { start, end } = lastDaysRange(3);
    await runSync(start, end);
  });
}

serve(async (req) => {
  const url       = new URL(req.url);
  const startDate = url.searchParams.get("start") ?? "1735689600000";
  const endDate   = url.searchParams.get("end")   ?? String(Date.now());
  return runSync(startDate, endDate);
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
