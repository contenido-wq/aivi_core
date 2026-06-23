# Analytics Command Center — Spec

**Fecha:** 2026-06-22  
**Ruta:** `/analytics`  
**Archivo vista:** `src/views/AnalyticsView.tsx`

---

## Objetivo

Construir un Command Center independiente en `/analytics` que cruce datos de Meta Ads (UTMify), videos (VTurb) y ventas (Hotmart) para permitir tomar decisiones de pauta aceleradas en las revisiones de mañana y noche.

---

## Arquitectura de Datos

### Fuentes

| Fuente | Datos | Tabla Supabase |
|--------|-------|----------------|
| UTMify | Inversión, impresiones, clicks por `utm_campaign` | `investment_data` (existente) |
| Hotmart | Ventas, ingresos, `utm_campaign` del comprador | `transactions` (existente) |
| VTurb | Plays, views, retención, button_clicks por video | `vturb_analytics` (nueva), `vturb_retention` (nueva) |

### Nuevas tablas Supabase

**`vturb_analytics`**
```sql
id            uuid primary key
video_id      text not null
video_name    text
date          date not null
plays         integer default 0
views         integer default 0
play_rate     numeric(5,2)
avg_watch_time integer  -- segundos
button_clicks integer default 0
created_at    timestamptz default now()
unique(video_id, date)
```

**`vturb_retention`**
```sql
id          uuid primary key
video_id    text not null
date        date not null
second      integer not null   -- segundo del video
percentage  numeric(5,2)       -- % de audiencia retenida en ese segundo
created_at  timestamptz default now()
unique(video_id, date, second)
```

### Nueva tabla: `campaign_investment_data`

La tabla `investment_data` existente almacena gasto **agregado por día** (sin desglose por campaña). Para el CAC por combinación se necesita gasto a nivel de campaña. Se crea una nueva tabla y se actualiza `utmify-sync` para poblarla:

```sql
id            uuid primary key
campaign_id   text not null
campaign_name text
date          date not null
platform      text default 'facebook'
investment    numeric(10,2) default 0
impressions   integer default 0
clicks        integer default 0
created_at    timestamptz default now()
unique(campaign_id, date, platform)
```

La edge function `utmify-sync` se actualiza para llamar también al endpoint de campaña de la API de Meta (vía UTMify MCP) y poblar esta tabla en cada sync horario.

### Métrica calculada: CAC

```
CAC = campaign_investment_data.investment (por campaign_id WHERE fecha IN período)
      ÷ COUNT(transactions WHERE utm_campaign = campaign_name AND fecha IN período)
```

El campo de enlace es `utm_campaign` en `transactions` vs `campaign_name` en `campaign_investment_data`.

### Métrica calculada: ROAS

```
ROAS = SUM(transactions.price WHERE utm_campaign = X)
       ÷ investment_data.investment (por utm_campaign)
```

### Score de Replicación (0–100)

Fórmula compuesta ponderada:
```
score = (ROAS_norm × 0.35) + (retención_50%_norm × 0.25) + (play_rate_norm × 0.20) + (conv_rate_norm × 0.20)
```
Donde cada componente está normalizado al máximo del período (0–1) y multiplicado por 100.

---

## Nueva Edge Function: `vturb-sync`

**Archivo:** `supabase/functions/vturb-sync/index.ts`

- Autenticación: Bearer token con `VTURB_API_KEY`
- Endpoints a consumir:
  - `GET /plays` — plays y views por video y fecha
  - `GET /retention` — curva de retención por video y fecha
- Corre cada hora via cron (igual que `utmify-sync`)
- Soporta backfill con `?from=YYYY-MM-DD&to=YYYY-MM-DD`
- Escribe en `vturb_analytics` y `vturb_retention` con `upsert` (on conflict update)
- Variable de entorno requerida: `VTURB_API_KEY`

---

## Layout del Command Center

### Bloque 1 — Selector de Período (header fijo)

Botones rápidos: **Noche** (22:00–08:00) · **Día** (08:00–22:00) · **Hoy** · **Ayer** · **7 días** + selector de rango custom.

Comparación automática: cada métrica muestra delta `+X%` / `-X%` vs el mismo período anterior, en verde/rojo.

---

### Bloque 2 — Resumen Ejecutivo (KPI Row)

8 métricas del período con delta vs período anterior:

| KPI | Fuente |
|-----|--------|
| Inversión total | UTMify |
| Ingresos atribuidos | Hotmart (filtrado por UTM) |
| ROAS | Calculado |
| CAC promedio | Calculado |
| Ventas totales | Hotmart |
| Plays totales | VTurb |
| Play rate promedio | VTurb |
| Costo por play | UTMify ÷ VTurb |

---

### Bloque 3 — Funnel por Combinación Anuncio + VSL

Una tarjeta por `utm_campaign` activa en el período. Layout de cada tarjeta:

**Funnel visual (barra horizontal con 6 etapas):**
```
Impresiones → Clicks → Plays → 50% Video → CTA Click → Compra
  [número]     [número] [número]  [número]    [número]   [número]
  [%conv]      [CTR]   [play%]   [ret%]      [cta%]    [conv%]
```

**Métricas adicionales por tarjeta:**
- CAC y ROAS de esa combinación
- Hora de mayor conversión del período
- Dispositivo dominante (móvil/desktop) con su tasa de conversión
- País #1 generando ventas
- Score de replicación (badge 0–100, color verde/amarillo/rojo)

---

### Bloque 4 — Comparador de VSLs

**Gráfico de líneas (Recharts):** curvas de retención superpuestas de todos los VSLs activos en el período. Eje X = segundo del video, eje Y = % de audiencia retenida. Cada línea con color distinto y leyenda con nombre del video.

**Marcador automático:** punto rojo en el segundo donde cualquier video pierde más del 20% de audiencia en un solo tramo de 10 segundos (punto crítico de edición).

**Tabla debajo del gráfico:**

| VSL | Plays | Ret. 25% | Ret. 50% | Ret. 75% | CTA Clicks | Conversiones | Conv. Rate |
|-----|-------|----------|----------|----------|------------|--------------|------------|

---

### Bloque 5 — Tabla de Anuncios Rankeada

Ordenada por CAC ascendente (mejor primero). Columna de color de fondo por fila: verde (CAC ≤ objetivo), amarillo (CAC 1–1.5x objetivo), rojo (CAC > 1.5x objetivo).

Columnas: Campaña · Inversión · Clicks · CPM · CPC · Plays · Play Rate · Ventas · CAC · ROAS · VSL asignado · Score

El umbral de CAC objetivo se configura en un campo editable en el header de la tabla.

### Vinculación Campaña ↔ VSL

La asociación entre `utm_campaign` y el `video_id` de VTurb se gestiona mediante una nueva tabla liviana:

```sql
-- campaign_vsl_mapping
campaign_name  text primary key
video_id       text not null
video_name     text
created_at     timestamptz default now()
```

El Command Center incluye un botón **"Configurar mapeos"** que abre un modal con una tabla editable donde el usuario asigna manualmente cada campaña a su VSL. Una vez guardado, todos los bloques que cruzan datos ad+video usan esta tabla. Si una campaña no tiene VSL asignado, los bloques de VTurb muestran "Sin VSL asignado" para esa fila.

---

### Bloque 6 — Análisis Horario

Heatmap 24h × 7 días donde cada celda muestra número de conversiones. Color más intenso = más conversiones. Permite identificar las ventanas horarias óptimas para concentrar presupuesto de pauta.

Implementado con grid CSS + escala de color (Tailwind `bg-orange-*` con opacidad variable).

---

### Bloque 7 — LTV por Fuente de Tráfico

Tabla que cruza `utm_campaign` con el historial completo de `transactions` para calcular:

| Campaña | Clientes | LTV Promedio | Ingresos Totales | CAC | ROI Real |
|---------|----------|--------------|------------------|-----|----------|

**ROI Real** = LTV Promedio ÷ CAC. Revela cuáles fuentes traen clientes más valiosos a largo plazo, independientemente del CAC inicial.

---

### Bloque 8 — Alertas Inteligentes

Panel en la parte superior de la vista (debajo del selector de período). Se genera automáticamente al cargar el período y muestra máximo 5 alertas priorizadas:

- 🔴 **Crítico:** CAC subió >30% vs período anterior, retención cayó bajo 40% en minuto 2
- 🟡 **Atención:** Play rate bajo promedio, ROAS en límite
- 🟢 **Oportunidad:** Combinación con score >80, candidata a escalar

Cada alerta es una línea concisa con el dato específico y el nombre de la campaña/VSL afectado.

---

### Bloque 9 — Inteligencia Accionable (IA Analyst)

Panel con botón **"Analizar período"**. Al presionar, envía el snapshot completo de métricas del período a Claude (Anthropic API existente) y devuelve análisis en 3 secciones:

**¿Qué escalar ahora?**
Identifica las 2-3 combinaciones con mejor performance combinado. Incluye presupuesto sugerido de incremento y ventana horaria recomendada.

**¿Qué corregir hoy?**
Lista los puntos de fuga más costosos: segundo de drop-off, anuncio con CTR bajo, VSL con play rate débil. Una acción específica por problema.

**¿Qué replicar?**
Extrae los patrones del contenido ganador (tipo de hook, duración, estructura del VSL, momento del CTA) y describe exactamente qué aplicar al próximo video/anuncio.

**Prompt al modelo:** incluye todos los datos numéricos del período, instrucciones en español neutro latinoamericano, tono directo y accionable, sin preamble.

**UX:** resultado mostrado como texto estructurado con las 3 secciones claramente separadas. Botón de copiar para llevar el análisis a otra herramienta.

---

## Servicio de Datos

**Archivo nuevo:** `src/services/analytics.ts`

Funciones exportadas:
- `getAnalyticsSummary(from, to)` — KPIs del Bloque 2
- `getFunnelByCampaign(from, to)` — datos del Bloque 3
- `getVSLRetention(from, to)` — datos del Bloque 4
- `getAdsRanking(from, to)` — datos del Bloque 5
- `getHourlyHeatmap(from, to)` — datos del Bloque 6
- `getLTVBySource()` — datos del Bloque 7
- `generateAlerts(summary, funnel, vsl)` — lógica del Bloque 8 (pure function)
- `getAIAnalysis(payload)` — llamada a Anthropic para Bloque 9

---

## Hook de React

**Archivo nuevo:** `src/hooks/useAnalyticsData.ts`

Maneja estado del período seleccionado, loading states por bloque, y refresco manual. No usa Realtime (los datos de VTurb y UTMify son por hora, no por segundo).

---

## Variables de Entorno Nuevas

```env
VTURB_API_KEY=<api_key_de_vturb>
```

Las demás ya existen: `ANTHROPIC_API_KEY`, `UTMIFY_MCP_TOKEN`, `SUPABASE_*`.

---

## Archivos a Crear

| Archivo | Tipo |
|---------|------|
| `supabase/functions/vturb-sync/index.ts` | Edge Function |
| `supabase/migrations/20260622000001_vturb_tables.sql` | Migración DB (vturb_analytics, vturb_retention) |
| `supabase/migrations/20260622000002_campaign_tables.sql` | Migración DB (campaign_investment_data, campaign_vsl_mapping) |
| `src/views/AnalyticsView.tsx` | Vista principal |
| `src/services/analytics.ts` | Servicio de datos |
| `src/hooks/useAnalyticsData.ts` | Hook de estado |
| `src/components/analytics/KPISummary.tsx` | Bloque 2 |
| `src/components/analytics/CampaignFunnelCard.tsx` | Bloque 3 |
| `src/components/analytics/VSLComparator.tsx` | Bloque 4 |
| `src/components/analytics/AdsRankingTable.tsx` | Bloque 5 |
| `src/components/analytics/HourlyHeatmap.tsx` | Bloque 6 |
| `src/components/analytics/LTVTable.tsx` | Bloque 7 |
| `src/components/analytics/AlertsPanel.tsx` | Bloque 8 |
| `src/components/analytics/AIAnalyst.tsx` | Bloque 9 |

## Archivos a Modificar

| Archivo | Cambio |
|---------|--------|
| `src/components/dashboard/Sidebar.tsx` | Agregar enlace a `/analytics` |
| `src/App.tsx` o router | Agregar ruta `/analytics → AnalyticsView` |
| `supabase/config.toml` | Registrar `vturb-sync` como cron |

---

## Consideraciones de Seguridad

- `VTURB_API_KEY` solo en variables de entorno de Supabase, nunca en frontend
- `vturb_analytics` y `vturb_retention`: RLS habilitado, lectura solo con auth
- El prompt al modelo de IA no incluye datos PII de compradores
