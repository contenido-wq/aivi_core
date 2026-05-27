# Spec: Trazabilidad de Usuarios — Admin Panel
**Fecha:** 2026-05-27  
**Estado:** Aprobado por usuario

---

## Resumen

Nuevo módulo de trazabilidad de clientes dentro del Admin Panel de AIVI. Permite al admin ver el perfil completo de cada comprador: historial de pagos, canal de adquisición, datos de contacto, perfil emprendedor, uso de la plataforma, LTV calculado y notas manuales.

---

## Diseño Visual Aprobado

Layout de 3 columnas (referencia: `.superpowers/brainstorm/.../user-traceability-design.html`):

- **Izquierda (300px):** Lista filtrable de usuarios con estado, LTV y país
- **Centro (flex):** Ficha completa del usuario seleccionado
- **Derecha (380px):** Panel de métricas, LTV hero, score de retención, acciones rápidas

Estética: dark mode, futurista, naranja AIVI (#FF6B35), Syne + JetBrains Mono + DM Sans.

---

## Datos a Mostrar por Usuario

| Campo | Fuente | Acción requerida |
|-------|--------|-----------------|
| Nombre | `transactions.buyer_name` / `subscriptions.buyer_name` | Ya existe |
| Email | `transactions.buyer_email` | Ya existe |
| Teléfono/WhatsApp | `hotmart-webhook` → `payload.data.buyer.phone` | Capturar en webhook |
| País / Ciudad | `hotmart-webhook` → `payload.data.buyer.address` | Capturar en webhook |
| Canal (plataforma) | `hotmart-webhook` → UTM o campo de tracking de Hotmart | Capturar/inferir en webhook |
| Fecha primera compra | `MIN(transactions.created_at)` por email | Calcular en query |
| Plan actual | `subscriptions.plan_name` | Ya existe |
| Status (activo/cancelado) | `subscriptions.status` | Ya existe |
| Historial de pagos | `transactions` por email | Ya existe |
| Renovaciones | `COUNT(transactions)` por email | Calcular en query |
| LTV | `plan_amount × meses_activos` | Calcular (ver fórmula) |
| Próxima renovación | `subscriptions.updated_at + 30 días` | Calcular |
| Días activo | `NOW() - first_purchase_at` | Calcular |
| A qué se dedica | `user_profiles.industry_description` | Tabla nueva + onboarding |
| Industria | `user_profiles.industry` | Tabla nueva + onboarding |
| Objetivo principal | `user_profiles.main_objective` | Tabla nueva + onboarding |
| Etapa ADN | `user_adn.stage` (ya existe en DB) | Leer tabla existente |
| Uso de herramientas | Nueva tabla `usage_events` — requiere agregar tracking a cada módulo | Tabla nueva + hooks en componentes |
| Notas del admin | `user_profiles.admin_notes` (JSONB array) | Tabla nueva |
| Score retención | Calculado: 0-100 basado en uso + renovaciones + días | Lógica frontend |
| Tags | `user_profiles.tags` (array) | Tabla nueva |

---

## Nueva Tabla: `user_profiles`

```sql
CREATE TABLE user_profiles (
  id                  uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  email               text UNIQUE NOT NULL,
  buyer_phone         text,
  country             text,
  city                text,
  platform_channel    text,         -- 'meta' | 'google' | 'tiktok' | 'organic'
  industry_description text,        -- "Coach de negocios digitales"
  industry            text,         -- "Educación / Coaching"
  main_objective      text,
  tags                text[],
  admin_notes         jsonb DEFAULT '[]'::jsonb,
  -- admin_notes structure: [{ text, created_at, author }]
  created_at          timestamptz DEFAULT now(),
  updated_at          timestamptz DEFAULT now()
);

-- RLS: solo service role puede leer/escribir (admin only)
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
```

---

## Cambios al Webhook `hotmart-webhook`

Extraer y guardar en `user_profiles` (upsert por email):
- `payload.data.buyer.phone` → `buyer_phone`
- `payload.data.buyer.address.country` → `country`
- `payload.data.buyer.address.city` → `city`
- UTM source de `payload.data.purchase.tracking_parameters` o campo equivalente → `platform_channel` (normalizar a 'meta' | 'google' | 'tiktok' | 'organic')

---

## Cálculo de LTV

```
meses_activos = DATEDIFF(months, first_purchase_at, COALESCE(cancelled_at, NOW()))
ltv = plan_amount × meses_activos
```

Donde `first_purchase_at` = MIN(created_at) de transactions activas por email.

---

## Score de Retención (frontend)

Heurística simple (0–100):
- +40 pts si status = 'active'
- +20 pts si renovaciones >= 3
- +20 pts si usó la app en los últimos 7 días
- +20 pts si tiene teléfono registrado
- −30 pts si próxima renovación < 15 días y uso bajo

---

## Componente Frontend

**Archivo nuevo:** `src/components/admin/UsersPanel.tsx`

Sub-componentes:
- `UserList.tsx` — lista filtrable izquierda
- `UserProfileCard.tsx` — ficha central (header + stats + perfil + timeline + uso + notas)
- `UserMetricsPanel.tsx` — panel derecho (LTV hero + mini-stats + risk + acciones)

El componente se integra como nueva sección dentro del `AdminPanel.tsx` existente (nueva opción en la navegación interna del panel).

---

## Onboarding — Campos Nuevos

Al crear cuenta o en primera sesión, mostrar 2 preguntas opcionales:
1. "¿A qué te dedicas?" → `industry_description`
2. "¿Cuál es tu meta principal con AIVI?" → `main_objective`

Guardar en `user_profiles` vía Supabase client. El admin puede editar estos campos desde el panel.

---

## Acciones Rápidas del Admin

| Acción | Comportamiento |
|--------|---------------|
| Enviar WhatsApp | Abre `https://wa.me/{phone}` en nueva pestaña |
| Enviar Email | Abre `mailto:{email}` |
| Ofrecer descuento | Modal para generar cupón (fase 2) |
| Marcar cancelado | Actualiza `subscriptions.status = 'cancelled'` |

---

## Nueva Tabla: `usage_events`

```sql
CREATE TABLE usage_events (
  id         uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id    uuid REFERENCES auth.users(id),
  email      text NOT NULL,
  tool       text NOT NULL,  -- 'guiones' | 'carruseles' | 'analyzer' | 'adn' | 'simulador' | 'referentes' | 'transcriptor'
  created_at timestamptz DEFAULT now()
);
CREATE INDEX ON usage_events (email, created_at DESC);
```

Cada módulo de la app llama `trackUsage(tool)` al iniciar uso. Los datos se agregan en la UI del panel como barras de uso por herramienta.

---

## Fuera de Alcance (fase 2)

- Timeline de eventos granular por usuario (cada acción dentro de un módulo)
- Generación de cupones de descuento
- Exportación CSV de usuarios
- Segmentación avanzada / filtros múltiples
- Envío de emails masivos

---

## Criterios de Éxito

1. El admin puede buscar cualquier usuario por email o nombre en < 1 segundo
2. La ficha muestra LTV calculado correctamente para usuarios con múltiples transacciones
3. El webhook captura teléfono y país en compras nuevas
4. El admin puede agregar y guardar notas en la ficha del usuario
5. El botón de WhatsApp abre la conversación directamente
