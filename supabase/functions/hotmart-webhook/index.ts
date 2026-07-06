// @ts-nocheck
import { serve }        from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

/** Devuelve la fecha en Colombia (UTC-5) como "YYYY-MM-DD" */
function toColombiaDate(d: Date): string {
  const local = new Date(d.getTime() - 5 * 60 * 60 * 1000);
  return local.toISOString().split("T")[0];
}

/** Rango UTC que cubre el día completo en Colombia para la fecha dada (YYYY-MM-DD Colombia) */
function colombiaDayRange(date: string): { start: string; end: string } {
  // Colombia medianoche = UTC 05:00 del mismo día
  // Colombia 23:59:59.999 = UTC 04:59:59.999 del día siguiente
  const [y, m, d] = date.split("-").map(Number);
  const nextDay = new Date(Date.UTC(y, m - 1, d + 1));
  const nextDayStr = nextDay.toISOString().split("T")[0];
  return {
    start: `${date}T05:00:00.000Z`,
    end:   `${nextDayStr}T04:59:59.999Z`,
  };
}

// Meta/Utmify concatena campaña|adset|ad|placement en purchase.tracking.external_code
// separados por este token fijo (confirmado contra ~3000 transacciones históricas).
// Cada segmento de campaña/adset/ad termina en "|<id numérico>" que hay que descartar
// para que el nombre coincida exactamente con campaign_investment_data.campaign_name.
const EXTERNAL_CODE_DELIMITER = "hQwK21wXxR";

function extractCampaignFromExternalCode(externalCode: string | undefined | null): string | null {
  if (!externalCode || !externalCode.includes(EXTERNAL_CODE_DELIMITER)) return null;
  const parts = externalCode.split(EXTERNAL_CODE_DELIMITER);
  const raw = (parts[1] ?? "").replace(/\|\d+$/, "").trim();
  return raw || null;
}

const SALE_EVENTS           = ["PURCHASE_COMPLETE", "PURCHASE_APPROVED"];
const REFUND_REQUEST_EVENTS = ["PURCHASE_REFUND_REQUEST"];
const REFUND_EVENTS         = ["PURCHASE_REFUNDED"];
const CANCEL_EVENTS         = ["PURCHASE_CANCELED", "SUBSCRIPTION_CANCELLATION"];
const DELAYED_EVENTS        = ["PURCHASE_DELAYED"];
const TRIAL_EVENTS          = ["PURCHASE_PROTEST"];
const CHARGEBACK_EVENTS     = ["CHARGEBACK", "PURCHASE_CHARGEBACK"];

const RATES: Record<string, number> = {
  USD: 1,     COP: 1/4100,  EUR: 1.08,  DOP: 1/59,
  BRL: 1/5.2, MXN: 1/17,   ARS: 1/1000, CLP: 1/950,
  PEN: 1/3.7, VES: 1/36,
};

function amountToUSD(amount: number, currency: string): number {
  return amount * (RATES[currency] ?? 1);
}

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  let payload: any;
  try {
    payload = await req.json();
  } catch {
    return new Response("Invalid JSON", { status: 400 });
  }

  // Hotmart v2 envía el hottok DENTRO del body
  const hottok =
    payload.hottok ??
    req.headers.get("X-Hotmart-Hottok") ??
    req.headers.get("x-hotmart-hottok") ??
    "";

  const expectedToken = Deno.env.get("HOTMART_HOTTOK") ?? "";

  console.log("Evento:", payload.event);

  if (expectedToken && hottok !== expectedToken) {
    console.error("Token inválido — acceso denegado");
    return new Response("Unauthorized", { status: 401 });
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const event           = payload.event as string;
  const purchase        = payload.data?.purchase;
  const product         = payload.data?.product;
  const buyer           = payload.data?.buyer;
  const sub             = payload.data?.subscription;

  if (!event || !purchase) {
    console.error("Falta event o purchase:", { event, purchase });
    return new Response("Missing event or purchase data", { status: 400 });
  }

  const hotmart_id      = purchase.transaction as string;
  const plan_name       = product?.name         ?? "Desconocido";
  const buyer_email     = buyer?.email           ?? "";
  const buyer_name      = buyer?.name            ?? "";
  // Hotmart no siempre envía subscription.subscriber.code en cobros recurrentes
  // (solo en el pago inicial). Si cae a hotmart_id, cada renovación mensual genera
  // un hotmart_id distinto y el upsert onConflict:"subscriber_code" nunca matchea
  // la fila anterior, duplicando la suscripción cada mes. Usamos email+plan como
  // llave estable para que las renovaciones actualicen la misma fila.
  const subscriber_code    = sub?.subscriber?.code
    ?? (buyer_email ? `EMAIL:${buyer_email.toLowerCase().trim()}::${plan_name}` : hotmart_id);
  const cancellation_type  = sub?.subscriber?.cancellation_type ?? null;
  const amount             = Number(purchase.price?.value ?? 0);
  const currency           = (purchase.price?.currency_value ?? "USD") as string;
  const today              = toColombiaDate(new Date());

  const buyer_phone     = buyer?.checkout_phone                         ?? buyer?.phone ?? "";
  const buyer_country   = buyer?.address?.country                       ?? "";
  const offer_code      = purchase?.offer?.code                         ?? "";
  const tracking        = purchase?.tracking;
  const sale_origin     = tracking?.source_sck ?? tracking?.source ?? "";
  const traffic_source  = extractCampaignFromExternalCode(tracking?.external_code) ?? tracking?.source_sck ?? "";

  // Para cancelaciones, chargebacks y pagos atrasados, evitar duplicados del mismo día
  // (Hotmart reintenta webhooks con distinto hotmart_id para el mismo evento)
  if ([...CANCEL_EVENTS, ...CHARGEBACK_EVENTS, ...DELAYED_EVENTS].includes(event)) {
    const { start: dayStart, end: dayEnd } = colombiaDayRange(today);
    const query = supabase
      .from("transactions")
      .select("id")
      .eq("buyer_email", buyer_email)
      .eq("event_type", event)
      .gte("created_at", dayStart)
      .lte("created_at", dayEnd)
      .limit(1);
    // Para pagos atrasados también filtramos por plan para no bloquear
    // usuarios con dos suscripciones distintas retrasadas el mismo día
    if (DELAYED_EVENTS.includes(event)) {
      query.eq("plan_name", plan_name);
    }
    const { data: existing } = await query;
    if (existing && existing.length > 0) {
      console.log(`⚠️ Duplicado ignorado: ${event} — ${buyer_email} — ${plan_name}`);
      return new Response(JSON.stringify({ ok: true, skipped: true }), {
        headers: { "Content-Type": "application/json" },
      });
    }
  }

  await supabase.from("transactions").upsert({
    hotmart_id,
    event_type:        event,
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
    status:            deriveStatus(event),
    cancellation_type,
    raw_payload:       payload,
    created_at:        new Date().toISOString(),
  }, { onConflict: "hotmart_id" });

  const { error: subError } = await supabase.from("subscriptions").upsert({
    subscriber_code,
    buyer_email,
    buyer_name,
    plan_name,
    status:     deriveStatus(event),
    amount,
    currency,
    updated_at: new Date().toISOString(),
  }, { onConflict: "subscriber_code" });
  if (subError) console.error("Error upsert subscriptions:", subError);

  await recalcDailyMetrics(supabase, today);

  console.log(`✅ Procesado ${event} — ${buyer_email} — plan: ${plan_name}`);
  return new Response(JSON.stringify({ ok: true }), {
    headers: { "Content-Type": "application/json" },
  });
});

function deriveStatus(event: string): string {
  if (SALE_EVENTS.includes(event))           return "active";
  if (REFUND_REQUEST_EVENTS.includes(event)) return "refund_request";
  if (REFUND_EVENTS.includes(event))         return "refunded";
  if (CANCEL_EVENTS.includes(event))         return "cancelled";
  if (DELAYED_EVENTS.includes(event))        return "delayed";
  if (TRIAL_EVENTS.includes(event))          return "trial";
  if (CHARGEBACK_EVENTS.includes(event))     return "chargeback";
  return "unknown";
}

async function recalcDailyMetrics(supabase: any, date: string) {
  const { count: active_total } = await supabase
    .from("subscriptions")
    .select("*", { count: "exact", head: true })
    .eq("status", "active");

  const { start, end } = colombiaDayRange(date);

  const { data: todayTx } = await supabase
    .from("transactions")
    .select("event_type, amount, currency")
    .gte("created_at", start)
    .lte("created_at", end);

  const metrics = { new_users: 0, recurring: 0, trials: 0, refunds: 0, cancellations: 0, revenue: 0 };

  for (const tx of (todayTx ?? [])) {
    if (SALE_EVENTS.includes(tx.event_type))   { metrics.new_users++; metrics.revenue += amountToUSD(Number(tx.amount), tx.currency ?? "USD"); }
    if (REFUND_EVENTS.includes(tx.event_type)) { metrics.refunds++;   metrics.revenue -= amountToUSD(Number(tx.amount), tx.currency ?? "USD"); }
    if (CANCEL_EVENTS.includes(tx.event_type))   metrics.cancellations++;
    if (TRIAL_EVENTS.includes(tx.event_type))    metrics.trials++;
  }

  const { data: invRow } = await supabase
    .from("investment_data")
    .select("investment")
    .eq("date", date);

  const investment = (invRow ?? []).reduce((s: number, r: any) => s + Number(r.investment), 0);

  await supabase.from("daily_metrics").upsert({
    date,
    revenue:       Math.max(0, metrics.revenue),
    investment,
    new_users:     metrics.new_users,
    recurring:     metrics.recurring,
    trials:        metrics.trials,
    refunds:       metrics.refunds,
    cancellations: metrics.cancellations,
    active_total:  active_total ?? 0,
    updated_at:    new Date().toISOString(),
  }, { onConflict: "date" });
}
