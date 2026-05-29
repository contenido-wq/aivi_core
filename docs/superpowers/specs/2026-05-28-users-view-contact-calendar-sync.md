# Spec: UsersView — Contacto, Calendario y Fix de Sync

**Fecha:** 2026-05-28  
**Estado:** Aprobado

---

## Contexto

El panel de Trazabilidad de Usuarios (`src/views/UsersView.tsx`) necesita tres mejoras:

1. **Contacto accionable**: mostrar email, WhatsApp y país del comprador como acciones con un clic, extrayendo el teléfono del `raw_payload` de Hotmart.
2. **Calendario de pagos**: visualización de actividad de pagos por mes en el perfil del usuario.
3. **Fix de datos**: corregir `recalcDailyMetrics` en el webhook para convertir revenue a USD, y añadir botón de sync manual en el dashboard.

**Diagnóstico previo:** La DB tenía 7 días sin datos (última tx: 21 May). Se corrió `hotmart-sync` manualmente y se confirmó que el webhook no está procesando ventas en tiempo real. Los `daily_metrics.revenue` están en moneda original (COP/EUR/DOP) sin convertir a USD — causa raíz de que el chart Semana/Mes muestre valores inflados.

---

## Cambio 1 — Sección de Contacto en el perfil

### Qué cambia
Reemplaza la "info row" actual del header de perfil (País, Canal, Primera compra, Programa) por dos secciones distintas:
- **Info row** (texto, no accionable): Primera compra, Programa, Canal
- **Contacto row** (accionable): Email, WhatsApp, País

### Extracción del teléfono
En `getUsersTraceability` (`src/services/dashboard.ts`):
- Recorrer todas las transacciones del usuario buscando en `raw_payload.data.buyer.checkout_phone` o `raw_payload.data.buyer.phone`
- Usar el primer valor no vacío encontrado
- Si no hay teléfono en ningún payload: `phone = null`

### Interfaz actualizada
```typescript
export interface UserProfile {
  // ... campos existentes ...
  phone: string | null;   // nuevo — puede ser null si Hotmart no lo envía
}
```

### UI — Contacto row
Tres botones/chips en fila horizontal dentro del header de perfil:

| Item | Condición de render | Acción al clic |
|---|---|---|
| Email | Siempre | `window.open("mailto:EMAIL")` |
| WhatsApp | Solo si `phone !== null` | `window.open("https://wa.me/NÚMERO")` |
| País | Siempre | Solo display (no link) |

- El número se limpia antes de armar el link: remover `+`, espacios, guiones → `wa.me/573001234567`
- Estilo: chips pequeños con icono + texto, borde sutil, hover con color de acento

---

## Cambio 2 — Calendario de pagos

### Ubicación
Dentro del panel central (`<main>`), entre el Stats Row y el Historial de Pagos.

### Comportamiento
- **Vista**: mes completo en cuadrícula 7 columnas (Lu–Do)
- **Mes inicial**: el mes de `selected.firstPurchaseDate`
- **Navegación**: flechas `‹` / `›`. El límite derecho es el mes actual (no navega al futuro)
- **Marcado de días**: cada día con transacciones muestra un punto de color debajo del número
  - Verde (`C.green`): al menos una tx `status === "active"`
  - Rojo (`C.red`): al menos una tx `status === "refunded"` o `"chargeback"`
  - Amarillo (`C.yellow`): al menos una tx `status === "delayed"` o `"cancelled"`
  - Prioridad si hay conflicto: verde > amarillo > rojo
- **Sin interacción de clic**: el calendario es solo visual (el historial de abajo ya muestra todo el detalle)
- **Leyenda**: fila de 3 dots con etiqueta (Cobro / Reembolso / Retrasado) debajo del grid

### Lógica de datos
No requiere nuevas llamadas a la API. Se construye desde `selected.transactions` (ya disponible en el estado).

```typescript
// Mapa: "2026-05-21" → "active" | "refunded" | "delayed"
const txDateMap = buildTxDateMap(selected.transactions);
```

La función `buildTxDateMap` recorre las transacciones y convierte cada `createdAt` a fecha Colombia (UTC-5) usando la misma función `localDateStr` ya existente en `dashboard.ts` (equivalente a restar 5 horas antes de extraer YYYY-MM-DD). Asigna el color de mayor prioridad por día.

---

## Cambio 3 — Fix de datos y sync

### 3a — `recalcDailyMetrics` en USD (`supabase/functions/hotmart-webhook/index.ts`)

**Problema**: `metrics.revenue += Number(tx.amount)` acumula en moneda original. Un cobro de 9,302 COP se guarda como `9302` en lugar de `~2.33` USD.

**Fix**: Importar tasas de cambio hardcodeadas (aproximadas, suficientes para métricas diarias) o usar la tabla `transactions` para recalcular en USD usando las tasas ya guardadas.

Enfoque elegido: recalcular el revenue de `daily_metrics` desde las transacciones usando un mapa de tasas fijo en el Edge Function (USD=1, COP≈4100, EUR≈1.08, DOP≈0.017, BRL≈0.19). Este mapa se puede actualizar manualmente cuando las tasas cambien significativamente.

```typescript
const RATES: Record<string, number> = {
  USD: 1, COP: 1/4100, EUR: 1.08, DOP: 1/59, BRL: 1/5.2,
  MXN: 1/17, ARS: 1/1000, CLP: 1/950, PEN: 1/3.7,
};
function toUSD(amount: number, currency: string): number {
  return amount * (RATES[currency] ?? 1);
}
```

### 3b — Botón "Sincronizar hoy" en el TopNav del dashboard

**Ubicación**: `src/components/dashboard/TopNav.tsx` — botón pequeño con icono `RefreshCw` junto al reloj.

**Acción**: llama a `https://[SUPABASE_URL]/functions/v1/hotmart-sync` con `start` y `end` del día de hoy (Colombia). Muestra spinner mientras corre, luego dispara `refresh()` del hook para recargar la data.

**Prop nueva en TopNav**: `onSync?: () => Promise<void>`

**Implementación del sync en frontend** (`src/services/dashboard.ts`):
```typescript
export async function syncToday(): Promise<{ inserted: number }> {
  const now = Date.now();
  const start = now - 24 * 60 * 60 * 1000; // últimas 24h
  const url = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/hotmart-sync?start=${start}&end=${now}`;
  const res = await fetch(url, {
    headers: { Authorization: `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}` }
  });
  return res.json();
}
```

---

## Archivos a modificar

| Archivo | Cambio |
|---|---|
| `src/services/dashboard.ts` | Añadir `phone` a `UserProfile`, extraer teléfono en `getUsersTraceability`, añadir `syncToday()` |
| `src/views/UsersView.tsx` | Contacto row + calendario de pagos |
| `src/components/dashboard/TopNav.tsx` | Botón sync + prop `onSync` |
| `src/views/DashboardView.tsx` | Pasar `onSync` a TopNav |
| `supabase/functions/hotmart-webhook/index.ts` | Fix `recalcDailyMetrics` con conversión a USD |

## Notas de implementación

- Los `daily_metrics` históricos con revenue en COP/EUR no se backfillean. Se corregirán automáticamente la próxima vez que el webhook procese un evento de ese día. Para corregir retroactivamente se puede correr `hotmart-sync` nuevamente.
- El botón "Sincronizar" sincroniza las últimas 24h, no solo el día de hoy Colombia — esto cubre el caso de ventas en la madrugada Colombia que cayeron en el día UTC anterior.

## Archivos que NO cambian
- `src/types.ts`
- `src/hooks/useDashboardData.ts`
- `supabase/functions/hotmart-sync/index.ts`
- Tablas de Supabase (sin migraciones)

---

## Criterios de éxito

- [ ] El panel de perfil muestra email como link mailto y WhatsApp como link wa.me
- [ ] Si no hay teléfono en el payload, el botón de WhatsApp no aparece
- [ ] El calendario muestra los meses del historial del usuario con dots de color correctos
- [ ] El chart "Semana/Mes" muestra valores en USD, no en moneda original
- [ ] El botón "Sincronizar" en el dashboard importa las últimas 24h y refresca la vista
