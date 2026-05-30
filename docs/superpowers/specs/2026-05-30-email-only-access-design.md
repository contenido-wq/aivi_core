# Email-Only Team Access — Design Spec

**Date:** 2026-05-30  
**Status:** Approved

---

## Problema

El flujo actual de acceso para el equipo requiere que el miembro:
1. Solicite acceso (funciona)
2. El admin lo apruebe vía `invite-user` Edge Function, que crea un usuario en Supabase Auth
3. El miembro reciba un email de invitación, haga clic, y configure una contraseña

Jhei quiere eliminar los pasos 2 y 3 del lado del miembro: **solo ingresar el correo y ver el dashboard**.

---

## Flujo objetivo

### Solicitud (sin cambios)
1. Miembro del equipo va a la URL → pestaña "Pedir acceso"
2. Ingresa su correo → guardado en `access_requests` con `status = 'pending'`

### Aprobación (simplificada)
1. Admin (Jhei) abre AdminPanel → ve las solicitudes pendientes
2. Hace clic en "Aprobar" → actualiza `access_requests.status = 'approved'`
3. **Ya no llama a `invite-user` Edge Function** — no se crea usuario en Supabase Auth

### Login (nuevo)
1. Miembro va a la URL → ingresa su correo → presiona Entrar
2. App verifica correo contra `access_requests` donde `status = 'approved'`
3. Si aprobado → login automático con cuenta portal (invisible) → dashboard inmediato
4. Si no aprobado → mensaje: "Este correo no tiene acceso. Pide acceso al admin."

---

## Arquitectura

### Cuenta portal
- Una cuenta Supabase Auth técnica creada manualmente una sola vez
- Email/password guardados en variables de entorno, nunca visibles al usuario
- Todos los miembros del equipo comparten esta sesión técnica
- La sesión es válida → RLS de Supabase funciona normalmente

### Variables de entorno nuevas
```
VITE_PORTAL_EMAIL=portal@aivicore.app
VITE_PORTAL_PASSWORD=<random-string-64-chars>
VITE_ADMIN_EMAIL=contenido@jheitrujillo.com
```

### RLS — nueva política
`access_requests` actualmente solo permite SELECT a usuarios autenticados. Se agrega política para que `anon` pueda verificar si un email específico está aprobado:

```sql
CREATE POLICY "anon_check_approved_email"
  ON access_requests
  FOR SELECT
  TO anon
  USING (status = 'approved');
```

Esto expone solo emails aprobados a consultas anónimas. Los pendientes y rechazados quedan ocultos.

### Persistencia de identidad
- Después del login portal, se guarda `{ email: inputEmail }` en `localStorage` bajo la clave `aivi_team_session`
- `useAuth` lo lee para saber quién está "usando" la sesión portal
- Al cerrar sesión: `supabase.auth.signOut()` + borrar `aivi_team_session` de localStorage

---

## Componentes que cambian

### `LoginView.tsx`
- Modo `"login"`: eliminar campo de contraseña
- Nueva lógica: query anon a `access_requests` → si aprobado → `signInWithPassword` con credenciales portal → guardar email en localStorage
- Mensajes de estado: "Verificando acceso…" → "Entrando…" → dashboard
- Error si email no está aprobado

### `useAuth.ts`
- Mantiene `supabase.auth.onAuthStateChange` (detecta la sesión portal)
- Agrega lectura de `localStorage.aivi_team_session` para exponer el email real del miembro
- Expone `teamEmail: string | null` junto al `user` existente

### `App.tsx`
- Botón de ajustes/admin: visible solo si `teamEmail === import.meta.env.VITE_ADMIN_EMAIL` (contenido@jheitrujillo.com)

### `AdminPanel.tsx`
- Botón "Aprobar": cambia de llamar `invite-user` Edge Function a solo hacer UPDATE directo en `access_requests`
- Más simple, más rápido, sin dependencia de Edge Function

### Migración nueva
- `20260530000001_anon_access_check.sql`: política anon SELECT en `access_requests`

---

## Lo que NO cambia
- Tabla `access_requests` (sin modificar estructura)
- Edge Function `invite-user` (se deja de usar pero no se elimina)
- Flujo "Pedir acceso" en `LoginView` (funciona igual)
- Todas las queries del dashboard (siguen usando sesión autenticada)
- RLS de `transactions`, `subscriptions`, etc.

---

## Pasos manuales (Jhei hace una vez)
1. Crear usuario portal en Supabase Dashboard → Authentication → Users → Create user con `portal@aivicore.app` y contraseña larga aleatoria
2. Insertar el propio email de Jhei en `access_requests` como aprobado (su cuenta actual es Supabase Auth directo, no pasó por el flujo de solicitud):
   ```sql
   INSERT INTO access_requests (email, status, reviewed_at)
   VALUES ('contenido@jheitrujillo.com', 'approved', now())
   ON CONFLICT (email) DO UPDATE SET status = 'approved';
   ```
3. Agregar las 3 variables al `.env.local`
4. Correr migración en Supabase

---

## Consideraciones de seguridad
- Cualquier persona que conozca un correo aprobado puede acceder → aceptable para equipo interno pequeño
- La cuenta portal no tiene permisos especiales — usa la misma RLS que cualquier usuario autenticado
- El admin puede revocar acceso cambiando `status = 'rejected'` en cualquier momento
- El email del portal no se expone en el frontend (solo en `.env`)
