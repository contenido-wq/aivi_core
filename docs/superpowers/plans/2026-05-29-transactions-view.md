# Transactions View — Vista Completa de Transacciones

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Crear una vista dedicada de Transacciones con 6 categorías (Compras Aprobadas, Solicitudes de Reembolso, Reembolsos Hechos, Cancelaciones, Atrasados, Tarjeta Rechazada), mostrando toda la información relevante del comprador: nombre, email, teléfono/WhatsApp, país, plan, monto, ID, origen de venta y fuente de tráfico.

**Architecture:** Se extiende la tabla `transactions` con nuevos campos capturados desde Hotmart (teléfono, país, fuente, origen). Se actualiza el webhook y la función de sync para guardar esos datos. Se crea `TransactionsView.tsx` como nueva página completa con 6 tabs y tabla exportable a CSV.

**Tech Stack:** Supabase Postgres (migración SQL), Deno Edge Functions (hotmart-webhook, hotmart-sync), React + TypeScript (TransactionsView), tokens de diseño existentes (C, FONT de `src/tokens.ts`)

---

## Mapa de Archivos

| Acción | Archivo |
|--------|---------|
| Crear | `supabase/migrations/20260529000001_transactions_extend.sql` |
| Modificar | `supabase/functions/hotmart-webhook/index.ts` |
| Modificar | `supabase/functions/hotmart-sync/index.ts` |
| Modificar | `src/services/dashboard.ts` |
| Modificar | `src/types.ts` |
| Crear | `src/views/TransactionsView.tsx` |
| Modificar | `src/App.tsx` |
| Modificar | `src/components/layout/Sidebar.tsx` |
| Modificar | `src/views/DashboardView.tsx` |

---

## Mapeo de Categorías → Eventos Hotmart

| Categoría UI | Eventos Hotmart | Status en DB |
|---|---|---|
| Compras Aprobadas | PURCHASE_COMPLETE, PURCHASE_APPROVED | active |
| Solicitudes de Reembolso | PURCHASE_REFUND_REQUEST | refund_request |
| Reembolsos Hechos | PURCHASE_REFUNDED | refunded |
| Cancelaciones | PURCHASE_CANCELED, SUBSCRIPTION_CANCELLATION | cancelled |
| Atrasados | PURCHASE_DELAYED | delayed |
| Tarjeta Rechazada | CHARGEBACK, PURCHASE_CHARGEBACK | chargeback |

## Campos Nuevos a Capturar desde Hotmart

| Campo DB | Webhook payload | Sync API |
|---|---|---|
| `buyer_phone` | `payload.data.buyer.checkout_phone` | `sale.buyer.checkout_phone` |
| `buyer_country` | `payload.data.buyer.address.country` | `sale.buyer.address.country` |
| `offer_code` | `payload.data.purchase.offer.code` | `sale.purchase.offer.code` |
| `sale_origin` | `payload.data.purchase.origin` | `sale.purchase.origin` |
| `traffic_source` | `payload.data.trackingParameters.source_sck` | `sale.tracking.src` |

---

## Task 1: Migración — Extender tabla `transactions`

**Files:**
- Create: `supabase/migrations/20260529000001_transactions_extend.sql`

- [ ] **Step 1: Escribir la migración**

```sql
-- Agrega campos de contacto, origen y tráfico a transactions
alter table public.transactions
  add column if not exists buyer_phone    text,
  add column if not exists buyer_country  text,
  add column if not exists offer_code     text,
  add column if not exists sale_origin    text,
  add column if not exists traffic_source text;

-- Índices para búsqueda frecuente
create index if not exists transactions_buyer_email_idx   on public.transactions(buyer_email);
create index if not exists transactions_buyer_country_idx on public.transactions(buyer_country);
create index if not exists transactions_event_type_idx    on public.transactions(event_type);
create index if not exists transactions_status_idx        on public.transactions(status);
create index if not exists transactions_created_at_idx    on public.transactions(created_at desc);
```

- [ ] **Step 2: Aplicar la migración localmente**

```bash
supabase db push
```

Esperado: "Applying migration 20260529000001_transactions_extend.sql" sin errores.

> Si no tienes Supabase CLI local, aplica el SQL directamente en el SQL Editor de Supabase Dashboard.

- [ ] **Step 3: Verificar que las columnas existen**

En el SQL Editor de Supabase o via CLI:
```sql
select column_name, data_type
from information_schema.columns
where table_name = 'transactions'
order by ordinal_position;
```

Deben aparecer: `buyer_phone`, `buyer_country`, `offer_code`, `sale_origin`, `traffic_source`.

- [ ] **Step 4: Commit**

```bash
git add supabase/migrations/20260529000001_transactions_extend.sql
git commit -m "feat: migración agrega campos buyer_phone, country, offer_code, origin, traffic_source a transactions"
```

---

## Task 2: Actualizar hotmart-webhook — Capturar nuevos campos

**Files:**
- Modify: `supabase/functions/hotmart-webhook/index.ts`

El webhook actual captura: `hotmart_id`, `event_type`, `buyer_name`, `buyer_email`, `plan_name`, `amount`, `currency`, `status`, `raw_payload`.

Necesitamos agregar extracción de los nuevos campos y manejar el evento `PURCHASE_REFUND_REQUEST`.

- [ ] **Step 1: Agregar PURCHASE_REFUND_REQUEST a los arrays de eventos y deriveStatus**

En `supabase/functions/hotmart-webhook/index.ts`, localizar (líneas ~24-35):

```typescript
const SALE_EVENTS       = ["PURCHASE_COMPLETE", "PURCHASE_APPROVED"];
const REFUND_EVENTS     = ["PURCHASE_REFUNDED"];
const CANCEL_EVENTS     = ["PURCHASE_CANCELED", "SUBSCRIPTION_CANCELLATION"];
const DELAYED_EVENTS    = ["PURCHASE_DELAYED"];
const TRIAL_EVENTS      = ["PURCHASE_PROTEST"];
const CHARGEBACK_EVENTS = ["CHARGEBACK", "PURCHASE_CHARGEBACK"];
```

Reemplazar con:

```typescript
const SALE_EVENTS           = ["PURCHASE_COMPLETE", "PURCHASE_APPROVED"];
const REFUND_REQUEST_EVENTS = ["PURCHASE_REFUND_REQUEST"];
const REFUND_EVENTS         = ["PURCHASE_REFUNDED"];
const CANCEL_EVENTS         = ["PURCHASE_CANCELED", "SUBSCRIPTION_CANCELLATION"];
const DELAYED_EVENTS        = ["PURCHASE_DELAYED"];
const TRIAL_EVENTS          = ["PURCHASE_PROTEST"];
const CHARGEBACK_EVENTS     = ["CHARGEBACK", "PURCHASE_CHARGEBACK"];
```

- [ ] **Step 2: Actualizar deriveStatus para incluir refund_request**

Localizar la función `deriveStatus` (líneas ~146-154):

```typescript
function deriveStatus(event: string): string {
  if (SALE_EVENTS.includes(event))       return "active";
  if (REFUND_EVENTS.includes(event))     return "refunded";
  if (CANCEL_EVENTS.includes(event))     return "cancelled";
  if (DELAYED_EVENTS.includes(event))    return "delayed";
  if (TRIAL_EVENTS.includes(event))      return "trial";
  if (CHARGEBACK_EVENTS.includes(event)) return "chargeback";
  return "unknown";
}
```

Reemplazar con:

```typescript
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
```

- [ ] **Step 3: Extraer los nuevos campos del payload y guardarlos**

Localizar el bloque de extracción de variables (líneas ~85-93):

```typescript
const hotmart_id      = purchase.transaction as string;
const plan_name       = product?.name         ?? "Desconocido";
const buyer_email     = buyer?.email           ?? "";
const buyer_name      = buyer?.name            ?? "";
const subscriber_code = sub?.subscriber?.code  ?? hotmart_id;
const amount          = Number(purchase.price?.value ?? 0);
const currency        = (purchase.price?.currency_value ?? "USD") as string;
const today           = toColombiaDate(new Date());
```

Reemplazar con:

```typescript
const hotmart_id      = purchase.transaction as string;
const plan_name       = product?.name                                  ?? "Desconocido";
const buyer_email     = buyer?.email                                    ?? "";
const buyer_name      = buyer?.name                                     ?? "";
const buyer_phone     = buyer?.checkout_phone                           ?? buyer?.phone ?? "";
const buyer_country   = buyer?.address?.country                         ?? "";
const offer_code      = purchase?.offer?.code                           ?? "";
const sale_origin     = purchase?.origin                                ?? "";
const traffic_source  = payload.data?.trackingParameters?.source_sck   ?? payload.data?.trackingParameters?.src ?? "";
const subscriber_code = sub?.subscriber?.code                           ?? hotmart_id;
const amount          = Number(purchase.price?.value ?? 0);
const currency        = (purchase.price?.currency_value ?? "USD") as string;
const today           = toColombiaDate(new Date());
```

- [ ] **Step 4: Incluir los nuevos campos en el upsert de transactions**

Localizar el upsert de transactions (líneas ~114-125):

```typescript
await supabase.from("transactions").upsert({
  hotmart_id,
  event_type:  event,
  buyer_name,
  buyer_email,
  plan_name,
  amount,
  currency,
  status:      deriveStatus(event),
  raw_payload: payload,
  created_at:  new Date().toISOString(),
}, { onConflict: "hotmart_id" });
```

Reemplazar con:

```typescript
await supabase.from("transactions").upsert({
  hotmart_id,
  event_type:     event,
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
  status:         deriveStatus(event),
  raw_payload:    payload,
  created_at:     new Date().toISOString(),
}, { onConflict: "hotmart_id" });
```

- [ ] **Step 5: Deploy de la función actualizada**

```bash
supabase functions deploy hotmart-webhook
```

Esperado: "Deploying hotmart-webhook ... Done"

- [ ] **Step 6: Commit**

```bash
git add supabase/functions/hotmart-webhook/index.ts
git commit -m "feat: webhook captura buyer_phone, country, offer_code, sale_origin, traffic_source y maneja PURCHASE_REFUND_REQUEST"
```

---

## Task 3: Actualizar hotmart-sync — Capturar nuevos campos

**Files:**
- Modify: `supabase/functions/hotmart-sync/index.ts`

- [ ] **Step 1: Agregar extracción de nuevos campos del objeto sale**

Localizar el bloque de extracción dentro del `for (const sale of sales)` (líneas ~96-114):

```typescript
const hotmart_id      = purchase.transaction ?? String(sale.id ?? Math.random());
const event_type      = purchase.status      ?? "COMPLETE";
const buyer_name      = buyer.name           ?? "";
const buyer_email     = buyer.email          ?? "";
const offer_code      = purchase.offer?.code ?? "";
const plan_name       = OFFER_NAMES[offer_code] ?? product.name ?? "AIVI";
const amount          = Number(purchase.price?.value ?? 0);
const currency        = purchase.price?.currency_code ?? "USD";
const subscriber_code = subscription?.subscriber?.code ?? hotmart_id;
const order_date      = purchase.order_date
  ? new Date(purchase.order_date).toISOString()
  : new Date().toISOString();
const date_key        = toColombiaDate(new Date(order_date));
const status          = deriveStatus(event_type);
```

Reemplazar con:

```typescript
const hotmart_id      = purchase.transaction ?? String(sale.id ?? Math.random());
const event_type      = purchase.status      ?? "COMPLETE";
const buyer_name      = buyer.name           ?? "";
const buyer_email     = buyer.email          ?? "";
const buyer_phone     = buyer.checkout_phone ?? buyer.phone ?? "";
const buyer_country   = buyer.address?.country ?? "";
const offer_code      = purchase.offer?.code ?? "";
const plan_name       = OFFER_NAMES[offer_code] ?? product.name ?? "AIVI";
const sale_origin     = purchase.origin      ?? "";
const traffic_source  = sale.tracking?.src ?? sale.tracking?.source_sck ?? "";
const amount          = Number(purchase.price?.value ?? 0);
const currency        = purchase.price?.currency_code ?? "USD";
const subscriber_code = subscription?.subscriber?.code ?? hotmart_id;
const order_date      = purchase.order_date
  ? new Date(purchase.order_date).toISOString()
  : new Date().toISOString();
const date_key        = toColombiaDate(new Date(order_date));
const status          = deriveStatus(event_type);
```

- [ ] **Step 2: Incluir los nuevos campos en el upsert de transactions del sync**

Localizar el upsert dentro del for-loop (líneas ~127-138):

```typescript
await supabase.from("transactions").upsert({
  hotmart_id,
  event_type,
  buyer_name,
  buyer_email,
  plan_name,
  amount,
  currency,
  status,
  raw_payload: sale,
  created_at: order_date,
}, { onConflict: "hotmart_id" });
```

Reemplazar con:

```typescript
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
  created_at:  order_date,
}, { onConflict: "hotmart_id" });
```

- [ ] **Step 3: Deploy de la función actualizada**

```bash
supabase functions deploy hotmart-sync
```

Esperado: "Deploying hotmart-sync ... Done"

- [ ] **Step 4: Commit**

```bash
git add supabase/functions/hotmart-sync/index.ts
git commit -m "feat: sync captura buyer_phone, country, offer_code, sale_origin, traffic_source"
```

---

## Task 4: Actualizar dashboard.ts — Interfaz Transaction y nueva función

**Files:**
- Modify: `src/services/dashboard.ts`

- [ ] **Step 1: Extender la interfaz Transaction con los nuevos campos**

Localizar la interfaz `Transaction` (líneas ~26-36):

```typescript
export interface Transaction {
  id:         string;
  eventType:  string;
  buyerName:  string;
  buyerEmail: string;
  planName:   string;
  amount:     number;
  currency:   string;
  amountUsd:  number;
  createdAt:  string;
}
```

Reemplazar con:

```typescript
export interface Transaction {
  id:            string;
  eventType:     string;
  buyerName:     string;
  buyerEmail:    string;
  buyerPhone:    string;
  buyerCountry:  string;
  offerCode:     string;
  saleOrigin:    string;
  trafficSource: string;
  planName:      string;
  amount:        number;
  currency:      string;
  amountUsd:     number;
  createdAt:     string;
  hotmartId:     string;
}
```

- [ ] **Step 2: Actualizar mapTransaction para incluir los nuevos campos**

Localizar `mapTransaction` (líneas ~270-282):

```typescript
function mapTransaction(r: any): Transaction {
  return {
    id:         r.id,
    eventType:  r.event_type,
    buyerName:  r.buyer_name  ?? "—",
    buyerEmail: r.buyer_email ?? "—",
    planName:   r.plan_name,
    amount:     Number(r.amount),
    currency:   r.currency ?? "USD",
    amountUsd:  toUSD(Number(r.amount), r.currency),
    createdAt:  r.created_at,
  };
}
```

Reemplazar con:

```typescript
function mapTransaction(r: any): Transaction {
  return {
    id:            r.id,
    hotmartId:     r.hotmart_id     ?? "—",
    eventType:     r.event_type,
    buyerName:     r.buyer_name     ?? "—",
    buyerEmail:    r.buyer_email    ?? "—",
    buyerPhone:    r.buyer_phone    ?? "—",
    buyerCountry:  r.buyer_country  ?? "—",
    offerCode:     r.offer_code     ?? "—",
    saleOrigin:    r.sale_origin    ?? "—",
    trafficSource: r.traffic_source ?? "—",
    planName:      r.plan_name      ?? "—",
    amount:        Number(r.amount),
    currency:      r.currency       ?? "USD",
    amountUsd:     toUSD(Number(r.amount), r.currency),
    createdAt:     r.created_at,
  };
}
```

- [ ] **Step 3: Actualizar los select() en getTransactions y getTransactionsByDateRange para incluir los nuevos campos**

En `getTransactions`, hay dos `.select(...)` calls. Buscar:

```typescript
.select("id, event_type, buyer_name, buyer_email, plan_name, amount, currency, created_at, status")
```

Reemplazar AMBAS ocurrencias con:

```typescript
.select("id, hotmart_id, event_type, buyer_name, buyer_email, buyer_phone, buyer_country, offer_code, sale_origin, traffic_source, plan_name, amount, currency, created_at, status")
```

Hacer lo mismo en `getTransactionsByDateRange` (otra ocurrencia del mismo select).

- [ ] **Step 4: Agregar la función getFullTransactions para la vista de transacciones**

Al final del archivo `src/services/dashboard.ts`, antes de la última función, agregar:

```typescript
export type TxCategory =
  | "compras"
  | "solicitudes_reembolso"
  | "reembolsos"
  | "cancelaciones"
  | "atrasados"
  | "chargeback";

const STATUS_BY_CATEGORY: Record<TxCategory, string[]> = {
  compras:               ["active"],
  solicitudes_reembolso: ["refund_request"],
  reembolsos:            ["refunded"],
  cancelaciones:         ["cancelled"],
  atrasados:             ["delayed"],
  chargeback:            ["chargeback"],
};

export async function getFullTransactions(
  category: TxCategory,
  startDate: Date | null,
  endDate: Date | null,
  search: string = ""
): Promise<Transaction[]> {
  const statuses = STATUS_BY_CATEGORY[category];

  let query = supabase
    .from("transactions")
    .select("id, hotmart_id, event_type, buyer_name, buyer_email, buyer_phone, buyer_country, offer_code, sale_origin, traffic_source, plan_name, amount, currency, created_at, status")
    .in("status", statuses)
    .order("created_at", { ascending: false })
    .limit(500);

  if (startDate) {
    const { start } = localDayRange(startDate);
    query = query.gte("created_at", start);
  }
  if (endDate) {
    const { end } = localDayRange(endDate);
    query = query.lte("created_at", end);
  }

  const { data } = await query;
  const rows = (data ?? []) as any[];

  const lowerSearch = search.toLowerCase().trim();
  const filtered = lowerSearch
    ? rows.filter((r) =>
        (r.buyer_name  ?? "").toLowerCase().includes(lowerSearch) ||
        (r.buyer_email ?? "").toLowerCase().includes(lowerSearch) ||
        (r.buyer_phone ?? "").toLowerCase().includes(lowerSearch)
      )
    : rows;

  return filtered.map(mapTransaction);
}
```

- [ ] **Step 5: Verificar que TypeScript no tiene errores**

```bash
npx tsc --noEmit
```

Esperado: sin errores relacionados con Transaction.

- [ ] **Step 6: Commit**

```bash
git add src/services/dashboard.ts
git commit -m "feat: Transaction interface extiende con phone, country, origin, traffic; agrega getFullTransactions por categoría"
```

---

## Task 5: Crear TransactionsView.tsx

**Files:**
- Create: `src/views/TransactionsView.tsx`

Esta vista muestra las 6 categorías como tabs. Cada tab tiene una tabla con todos los datos del comprador.

- [ ] **Step 1: Crear el archivo con la estructura base y los tabs**

```tsx
import { useState, useEffect, useCallback } from "react";
import { ArrowLeft, Download, Search, RefreshCw } from "lucide-react";
import { C, FONT } from "../tokens";
import {
  getFullTransactions,
  type Transaction,
  type TxCategory,
} from "../services/dashboard";

const CATEGORIES: { key: TxCategory; label: string; color: string }[] = [
  { key: "compras",               label: "Compras Aprobadas",       color: C.green   },
  { key: "solicitudes_reembolso", label: "Solicitudes de Reembolso",color: C.yellow  },
  { key: "reembolsos",            label: "Reembolsos Hechos",       color: C.orange  },
  { key: "cancelaciones",         label: "Cancelaciones",           color: C.red     },
  { key: "atrasados",             label: "Atrasados",               color: C.purple  },
  { key: "chargeback",            label: "Tarjeta Rechazada",       color: C.pink    },
];

interface TransactionsViewProps {
  onBack: () => void;
}

export function TransactionsView({ onBack }: TransactionsViewProps) {
  const [activeTab, setActiveTab]   = useState<TxCategory>("compras");
  const [rows, setRows]             = useState<Transaction[]>([]);
  const [loading, setLoading]       = useState(false);
  const [search, setSearch]         = useState("");
  const [startDate, setStartDate]   = useState("");
  const [endDate, setEndDate]       = useState("");

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const start = startDate ? new Date(startDate) : null;
      const end   = endDate   ? new Date(endDate)   : null;
      const data  = await getFullTransactions(activeTab, start, end, search);
      setRows(data);
    } finally {
      setLoading(false);
    }
  }, [activeTab, startDate, endDate, search]);

  useEffect(() => { load(); }, [load]);

  function exportCSV() {
    const headers = [
      "Fecha", "Nombre", "Email", "Teléfono", "País",
      "Plan", "Monto", "Divisa", "USD", "Origen Venta",
      "Fuente Tráfico", "Código Oferta", "ID Hotmart",
    ];
    const csvRows = rows.map((r) => [
      new Date(r.createdAt).toLocaleString("es-CO"),
      r.buyerName, r.buyerEmail, r.buyerPhone, r.buyerCountry,
      r.planName,
      r.amount.toFixed(2), r.currency,
      r.amountUsd.toFixed(2),
      r.saleOrigin, r.trafficSource, r.offerCode, r.hotmartId,
    ].map((v) => `"${String(v).replace(/"/g, '""')}"`).join(","));

    const blob = new Blob(
      [headers.join(",") + "\n" + csvRows.join("\n")],
      { type: "text/csv;charset=utf-8;" }
    );
    const url = URL.createObjectURL(blob);
    const a   = document.createElement("a");
    a.href     = url;
    a.download = `transacciones_${activeTab}_${new Date().toISOString().split("T")[0]}.csv`;
    a.click();
    URL.revokeObjectURL(url);
  }

  const activeCategory = CATEGORIES.find((c) => c.key === activeTab)!;

  return (
    <div style={{
      minHeight: "100vh",
      background: C.bg,
      fontFamily: FONT,
      color: C.white,
    }}>
      {/* Header */}
      <div style={{
        padding: "16px 24px",
        borderBottom: `1px solid ${C.border}`,
        display: "flex",
        alignItems: "center",
        gap: 16,
        background: C.sidebar,
        position: "sticky",
        top: 0,
        zIndex: 10,
      }}>
        <button
          onClick={onBack}
          style={{
            background: "none", border: "none", cursor: "pointer",
            color: C.mutedMid, display: "flex", alignItems: "center", gap: 6,
            fontSize: 13, padding: "4px 8px", borderRadius: 6,
          }}
        >
          <ArrowLeft size={16} /> Volver
        </button>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 18, fontWeight: 800, letterSpacing: "-0.03em" }}>
            AIVI — Transacciones
          </div>
          <div style={{ fontSize: 11, color: C.mutedMid }}>
            {rows.length} registros · {activeCategory.label}
          </div>
        </div>
        <button
          onClick={exportCSV}
          disabled={rows.length === 0}
          style={{
            display: "flex", alignItems: "center", gap: 6,
            padding: "7px 14px", borderRadius: 8, fontSize: 12, fontWeight: 700,
            background: rows.length > 0 ? C.orange : C.card,
            border: "none", cursor: rows.length > 0 ? "pointer" : "not-allowed",
            color: rows.length > 0 ? "#fff" : C.muted,
          }}
        >
          <Download size={14} /> Exportar CSV
        </button>
      </div>

      {/* Tabs */}
      <div style={{
        display: "flex",
        gap: 4,
        padding: "12px 24px",
        borderBottom: `1px solid ${C.border}`,
        overflowX: "auto",
        background: C.bgSecondary,
      }}>
        {CATEGORIES.map((cat) => (
          <button
            key={cat.key}
            onClick={() => setActiveTab(cat.key)}
            style={{
              padding: "6px 14px",
              borderRadius: 20,
              fontSize: 12,
              fontWeight: 700,
              border: `1px solid ${activeTab === cat.key ? cat.color : C.border}`,
              background: activeTab === cat.key ? `${cat.color}20` : "transparent",
              color: activeTab === cat.key ? cat.color : C.mutedMid,
              cursor: "pointer",
              whiteSpace: "nowrap",
              transition: "all 0.15s",
            }}
          >
            AIVI {cat.label.toUpperCase()}
          </button>
        ))}
      </div>

      {/* Filters */}
      <div style={{
        padding: "12px 24px",
        display: "flex",
        gap: 10,
        flexWrap: "wrap",
        alignItems: "center",
        borderBottom: `1px solid ${C.border}`,
      }}>
        <div style={{ position: "relative", flex: "1 1 220px" }}>
          <Search size={14} style={{
            position: "absolute", left: 10, top: "50%",
            transform: "translateY(-50%)", color: C.muted,
          }} />
          <input
            type="text"
            placeholder="Buscar por nombre, email o teléfono..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={{
              width: "100%", paddingLeft: 32, paddingRight: 12,
              height: 36, borderRadius: 8,
              background: C.card, border: `1px solid ${C.border}`,
              color: C.white, fontSize: 12,
              boxSizing: "border-box",
            }}
          />
        </div>
        <input
          type="date"
          value={startDate}
          onChange={(e) => setStartDate(e.target.value)}
          style={dateInputStyle()}
        />
        <span style={{ color: C.muted, fontSize: 12 }}>→</span>
        <input
          type="date"
          value={endDate}
          onChange={(e) => setEndDate(e.target.value)}
          style={dateInputStyle()}
        />
        <button
          onClick={() => { setStartDate(""); setEndDate(""); setSearch(""); }}
          style={{
            padding: "6px 12px", borderRadius: 8, fontSize: 11,
            background: "none", border: `1px solid ${C.border}`,
            color: C.muted, cursor: "pointer",
          }}
        >
          Limpiar
        </button>
        <button
          onClick={load}
          style={{
            display: "flex", alignItems: "center", gap: 4,
            padding: "6px 12px", borderRadius: 8, fontSize: 11,
            background: "none", border: `1px solid ${C.border}`,
            color: C.mutedLight, cursor: "pointer",
          }}
        >
          <RefreshCw size={12} /> Actualizar
        </button>
      </div>

      {/* Table */}
      <div style={{ overflowX: "auto", padding: "0 0 40px" }}>
        {loading ? (
          <div style={{ padding: 48, textAlign: "center", color: C.mutedMid, fontSize: 13 }}>
            Cargando...
          </div>
        ) : rows.length === 0 ? (
          <div style={{ padding: 64, textAlign: "center" }}>
            <div style={{ fontSize: 32, marginBottom: 12 }}>📭</div>
            <div style={{ color: C.mutedMid, fontSize: 13 }}>
              No hay registros en esta categoría
            </div>
          </div>
        ) : (
          <table style={{
            width: "100%", borderCollapse: "collapse",
            fontSize: 12, minWidth: 1100,
          }}>
            <thead>
              <tr style={{ borderBottom: `1px solid ${C.border}` }}>
                {[
                  "Fecha/Hora", "Nombre", "Email", "Teléfono",
                  "País", "Plan", "Monto", "USD",
                  "Origen Venta", "Fuente Tráfico", "ID Hotmart",
                ].map((h) => (
                  <th key={h} style={{
                    padding: "10px 14px", textAlign: "left",
                    color: C.muted, fontWeight: 700, fontSize: 10,
                    letterSpacing: "0.08em", textTransform: "uppercase",
                    whiteSpace: "nowrap", background: C.panel,
                    position: "sticky", top: 0,
                  }}>
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {rows.map((row, i) => (
                <tr
                  key={row.id}
                  style={{
                    borderBottom: `1px solid ${C.border}`,
                    background: i % 2 === 0 ? "transparent" : C.bgSecondary,
                  }}
                >
                  <td style={td()}>{fmtDate(row.createdAt)}</td>
                  <td style={{ ...td(), fontWeight: 600, color: C.white }}>{row.buyerName}</td>
                  <td style={{ ...td(), color: C.mutedLight }}>{row.buyerEmail}</td>
                  <td style={td()}>
                    {row.buyerPhone !== "—" ? (
                      <a
                        href={`https://wa.me/${row.buyerPhone.replace(/\D/g, "")}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        style={{ color: C.green, textDecoration: "none" }}
                      >
                        {row.buyerPhone}
                      </a>
                    ) : "—"}
                  </td>
                  <td style={td()}>{row.buyerCountry}</td>
                  <td style={{ ...td(), maxWidth: 160, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                    {row.planName}
                  </td>
                  <td style={td()}>
                    {row.amount.toFixed(2)} <span style={{ color: C.muted }}>{row.currency}</span>
                  </td>
                  <td style={{ ...td(), color: C.green, fontWeight: 700 }}>
                    ${row.amountUsd.toFixed(2)}
                  </td>
                  <td style={{ ...td(), color: C.mutedLight }}>{row.saleOrigin}</td>
                  <td style={{ ...td(), color: C.teal }}>{row.trafficSource}</td>
                  <td style={{ ...td(), color: C.muted, fontSize: 10, fontFamily: "monospace" }}>
                    {row.hotmartId.slice(0, 16)}…
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}

function td(): React.CSSProperties {
  return { padding: "10px 14px", color: C.mutedLight, whiteSpace: "nowrap" };
}

function dateInputStyle(): React.CSSProperties {
  return {
    height: 36, padding: "0 10px", borderRadius: 8,
    background: C.card, border: `1px solid ${C.border}`,
    color: C.white, fontSize: 12,
  };
}

function fmtDate(iso: string): string {
  const d = new Date(iso);
  return d.toLocaleString("es-CO", {
    day: "2-digit", month: "2-digit", year: "2-digit",
    hour: "2-digit", minute: "2-digit",
  });
}
```

- [ ] **Step 2: Verificar que el archivo compila sin errores**

```bash
npx tsc --noEmit
```

Esperado: sin errores en `src/views/TransactionsView.tsx`.

- [ ] **Step 3: Commit**

```bash
git add src/views/TransactionsView.tsx
git commit -m "feat: TransactionsView con 6 categorías, búsqueda, filtro de fechas y exportación CSV"
```

---

## Task 6: Cablear la navegación

**Files:**
- Modify: `src/types.ts`
- Modify: `src/App.tsx`
- Modify: `src/components/layout/Sidebar.tsx`
- Modify: `src/views/DashboardView.tsx`

- [ ] **Step 1: Agregar "transacciones" al tipo AppView en types.ts**

Localizar en `src/types.ts`:

```typescript
export type AppView   = "dashboard" | "admin" | "usuarios";
```

Reemplazar con:

```typescript
export type AppView   = "dashboard" | "admin" | "usuarios" | "transacciones";
```

- [ ] **Step 2: Agregar la ruta de transacciones en App.tsx**

Localizar en `src/App.tsx`:

```typescript
import { UsersView }      from "./views/UsersView";
```

Reemplazar con:

```typescript
import { UsersView }          from "./views/UsersView";
import { TransactionsView }   from "./views/TransactionsView";
```

Luego, localizar:

```typescript
// Vista Usuarios (trazabilidad)
if (view === "usuarios") return <UsersView onBack={() => setView("dashboard")} />;
```

Reemplazar con:

```typescript
// Vista Usuarios (trazabilidad)
if (view === "usuarios") return <UsersView onBack={() => setView("dashboard")} />;

// Vista Transacciones
if (view === "transacciones") return <TransactionsView onBack={() => setView("dashboard")} />;
```

- [ ] **Step 3: Activar el nav item de Transacciones en Sidebar.tsx**

Localizar en `src/components/layout/Sidebar.tsx`:

```typescript
interface SidebarProps {
  filter:     ProductFilter;
  onFilter:   (f: ProductFilter) => void;
  onSettings: () => void;
  onSignOut?: () => void;
  onUsers?:   () => void;
  activeView?: string;
  ...
}
```

Reemplazar con:

```typescript
interface SidebarProps {
  filter:            ProductFilter;
  onFilter:          (f: ProductFilter) => void;
  onSettings:        () => void;
  onSignOut?:        () => void;
  onUsers?:          () => void;
  onTransactions?:   () => void;
  activeView?:       string;
  ...
}
```

Luego localizar:

```typescript
const NAV_ITEMS = [
  { icon: LayoutDashboard, label: "Dashboard",     view: "dashboard" },
  { icon: Users,           label: "Usuarios",      view: "usuarios"  },
  { icon: BarChart2,       label: "Analytics",     view: null        },
  { icon: CreditCard,      label: "Transacciones", view: null        },
  { icon: RefreshCw,       label: "Suscripciones", view: null        },
];
```

Reemplazar con:

```typescript
const NAV_ITEMS = [
  { icon: LayoutDashboard, label: "Dashboard",     view: "dashboard"     },
  { icon: Users,           label: "Usuarios",      view: "usuarios"      },
  { icon: CreditCard,      label: "Transacciones", view: "transacciones" },
  { icon: BarChart2,       label: "Analytics",     view: null            },
  { icon: RefreshCw,       label: "Suscripciones", view: null            },
];
```

Luego encontrar donde se hace el click en cada nav item del Sidebar y asegurarse de que se llame la prop correcta. Buscar donde se llama `onUsers?.()` en el componente Sidebar y agregar el handler para transacciones. Localizar el onClick de los nav items (busca `item.view === "usuarios"`) y reemplazar la lógica de dispatch:

```typescript
// Dentro del onClick del nav item:
if (item.view === "usuarios") { onUsers?.(); onClose?.(); }
```

Reemplazar con:

```typescript
if (item.view === "usuarios")       { onUsers?.();        onClose?.(); }
if (item.view === "transacciones")  { onTransactions?.(); onClose?.(); }
```

Agregar `onTransactions` a la destructuring del componente:

```typescript
export function Sidebar({ filter, onFilter, onSettings, onSignOut, onUsers, onTransactions, activeView, mrr, arr, daily, open, onClose, isMobile }: SidebarProps) {
```

- [ ] **Step 4: Pasar onTransactions desde DashboardView.tsx**

En `src/views/DashboardView.tsx`, localizar la interfaz DashboardViewProps:

```typescript
interface DashboardViewProps {
  onSettings: () => void;
  onSignOut?:  () => void;
  onUsers?:    () => void;
  activeView?: string;
}
```

Reemplazar con:

```typescript
interface DashboardViewProps {
  onSettings:       () => void;
  onSignOut?:       () => void;
  onUsers?:         () => void;
  onTransactions?:  () => void;
  activeView?:      string;
}
```

Luego localizar la destructuring del componente:

```typescript
export function DashboardView({ onSettings, onSignOut, onUsers, activeView = "dashboard" }: DashboardViewProps) {
```

Reemplazar con:

```typescript
export function DashboardView({ onSettings, onSignOut, onUsers, onTransactions, activeView = "dashboard" }: DashboardViewProps) {
```

Luego localizar donde se pasan props al Sidebar (busca `<Sidebar`) y agregar `onTransactions`:

```typescript
<Sidebar
  ...
  onUsers={onUsers}
  ...
/>
```

Agregar `onTransactions={onTransactions}` al componente Sidebar.

- [ ] **Step 5: Pasar onTransactions desde App.tsx al DashboardView**

En `src/App.tsx`, localizar:

```typescript
return (
  <DashboardView
    onSettings={() => setView("admin")}
    onSignOut={signOut}
    onUsers={() => setView("usuarios")}
    activeView={view}
  />
);
```

Reemplazar con:

```typescript
return (
  <DashboardView
    onSettings={() => setView("admin")}
    onSignOut={signOut}
    onUsers={() => setView("usuarios")}
    onTransactions={() => setView("transacciones")}
    activeView={view}
  />
);
```

- [ ] **Step 6: Verificar que el proyecto compila sin errores**

```bash
npx tsc --noEmit
```

Esperado: 0 errores.

- [ ] **Step 7: Commit**

```bash
git add src/types.ts src/App.tsx src/components/layout/Sidebar.tsx src/views/DashboardView.tsx
git commit -m "feat: cableado navegación transacciones — Sidebar activo, App.tsx ruteado, DashboardView prop"
```

---

## Task 7: Smoke test manual

- [ ] **Step 1: Levantar el servidor de desarrollo**

```bash
npm run dev
```

Esperado: servidor en `http://localhost:5173` (o el puerto configurado).

- [ ] **Step 2: Verificar los 6 tabs**

1. Ir a la app → click en "Transacciones" en el sidebar
2. Verificar que aparecen los 6 tabs: AIVI COMPRAS APROBADAS, AIVI SOLICITUDES DE REEMBOLSO, etc.
3. Click en cada tab → la tabla debe cargarse sin errores de consola

- [ ] **Step 3: Verificar búsqueda y filtros de fecha**

1. En el tab "Compras Aprobadas", escribir un email en el buscador → tabla filtra en tiempo real
2. Seleccionar rango de fechas → tabla recarga mostrando solo ese rango
3. Click "Limpiar" → filtros se resetean

- [ ] **Step 4: Verificar exportación CSV**

1. Con datos en pantalla, click "Exportar CSV"
2. Abrir el archivo descargado → debe tener todas las columnas: Fecha, Nombre, Email, Teléfono, País, Plan, Monto, Divisa, USD, Origen Venta, Fuente Tráfico, ID Hotmart

- [ ] **Step 5: Verificar link de WhatsApp**

1. Si existe una transacción con teléfono capturado, el número debe ser un link verde que abre `wa.me/<numero>`

- [ ] **Step 6: Commit final si todo funciona**

```bash
git add -A
git commit -m "feat: vista completa de transacciones con 6 categorías, búsqueda, filtros y exportación CSV"
```

---

## Notas de Implementación

**Datos históricos:** Los campos `buyer_phone`, `buyer_country`, `offer_code`, `sale_origin`, `traffic_source` quedarán como `—` en transacciones importadas antes de esta feature. Para backfill, ejecutar hotmart-sync con rango histórico después del deploy.

**Teléfono/WhatsApp:** En Latinoamérica el número de checkout suele ser WhatsApp. El link `wa.me/<numero>` funciona globalmente. El campo `buyer_phone` viene del campo `checkout_phone` de Hotmart, que es el número que el comprador ingresa en el checkout.

**Fuente de Tráfico:** `source_sck` es el parámetro de tracking de Hotmart (equivalente a UTM source). Si no hay tracking, el campo muestra `—`. Para campañas de Meta/Google se configuran los parámetros UTM en los links de Hotmart.

**PURCHASE_REFUND_REQUEST:** Este evento Hotmart se dispara cuando el comprador solicita reembolso pero aún no fue procesado. `PURCHASE_REFUNDED` se dispara cuando el reembolso ya fue ejecutado.
