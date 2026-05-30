# Email-Only Team Access — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reemplazar el login con contraseña por un flujo donde el miembro ingresa solo su correo, se verifica contra `access_requests`, y entra automáticamente usando una cuenta portal compartida invisible.

**Architecture:** Se agrega una política RLS de anon-SELECT en `access_requests` (solo emails aprobados), se guarda el email real en `localStorage` bajo `aivi_team_session`, y `useAuth` expone `teamEmail` para controlar visibilidad de admin. El flujo de aprobación en AdminPanel se simplifica a un UPDATE directo (sin Edge Function).

**Tech Stack:** Supabase Postgres (RLS migration), Supabase Auth (signInWithPassword con cuenta portal), React + TypeScript, Vite env vars (`VITE_PORTAL_EMAIL`, `VITE_PORTAL_PASSWORD`, `VITE_ADMIN_EMAIL`)

---

## Mapa de Archivos

| Acción | Archivo | Responsabilidad |
|--------|---------|-----------------|
| Crear | `supabase/migrations/20260530000001_anon_access_check.sql` | Política RLS anon-SELECT en access_requests |
| Modificar | `.env.local` | Agregar VITE_PORTAL_EMAIL, VITE_PORTAL_PASSWORD, VITE_ADMIN_EMAIL |
| Modificar | `src/hooks/useAuth.ts` | Exponer teamEmail desde localStorage, limpiar en signOut |
| Modificar | `src/views/LoginView.tsx` | Email-only login: query anon → signIn portal → guardar localStorage |
| Modificar | `src/App.tsx` | Usar teamEmail para pasar isAdmin a vistas |
| Modificar | `src/components/layout/Sidebar.tsx` | Mostrar "Ajustes" solo cuando isAdmin=true |
| Modificar | `src/views/DashboardView.tsx` | Recibir y pasar isAdmin a Sidebar |
| Modificar | `src/views/TransactionsView.tsx` | Recibir y pasar isAdmin a Sidebar |
| Modificar | `src/components/admin/AdminPanel.tsx` | Aprobar = UPDATE directo, sin invoke invite-user |

---

## Task 1: Migración — Política anon-SELECT en access_requests

**Files:**
- Create: `supabase/migrations/20260530000001_anon_access_check.sql`

- [ ] **Step 1: Crear el archivo de migración**

```sql
-- Permite a visitantes anónimos verificar si su email está aprobado.
-- Solo expone filas con status='approved'; pending/rejected quedan ocultos.
create policy "anon_check_approved_email"
  on public.access_requests
  for select
  to anon
  using (status = 'approved');

-- Otorgar privilegio SELECT al rol anon (la tabla solo otorgaba insert a anon)
grant select on public.access_requests to anon;
```

- [ ] **Step 2: Aplicar la migración en Supabase**

Abre el SQL Editor en el Supabase Dashboard y ejecuta el contenido del archivo.

Verifica con:
```sql
select polname, polroles::text, polqual
from pg_policies
where tablename = 'access_requests';
```

Debes ver `anon_check_approved_email` en la lista.

- [ ] **Step 3: Probar la política desde el cliente (anon)**

En el SQL Editor, ejecuta como usuario anon (usa la anon key en el cliente) o simplemente verifica que el SELECT siguiente devuelve solo emails aprobados:
```sql
-- Como anon, solo deben aparecer filas con status='approved'
select email, status from public.access_requests;
```

- [ ] **Step 4: Commit**

```bash
git add supabase/migrations/20260530000001_anon_access_check.sql
git commit -m "feat: política anon-SELECT en access_requests para verificar email aprobado"
```

---

## Task 2: Variables de Entorno

**Files:**
- Modify: `.env.local`

- [ ] **Step 1: Agregar las 3 variables al archivo .env.local**

Abre `.env.local` y agrega al final:

```
VITE_PORTAL_EMAIL=portal@aivicore.app
VITE_PORTAL_PASSWORD=<la-contraseña-que-pusiste-en-Supabase-al-crear-el-usuario-portal>
VITE_ADMIN_EMAIL=contenido@jheitrujillo.com
```

Reemplaza `<la-contraseña...>` con la contraseña real del usuario `portal@aivicore.app` que creaste en Supabase Dashboard.

- [ ] **Step 2: Verificar que Vite puede leer las variables**

```bash
npm run dev
```

En la consola del navegador ejecuta:
```js
import.meta.env.VITE_PORTAL_EMAIL
```

Debe devolver `"portal@aivicore.app"`. Si devuelve `undefined`, reinicia el servidor de desarrollo.

> `.env.local` nunca se commitea. Está en `.gitignore` por defecto en proyectos Vite.

---

## Task 3: useAuth — Agregar teamEmail

**Files:**
- Modify: `src/hooks/useAuth.ts`

La clave `aivi_team_session` en `localStorage` almacena `{ email: string }` después del login portal. `useAuth` la lee para exponer el email real del miembro al resto de la app. Al cerrar sesión, se limpia.

- [ ] **Step 1: Reemplazar el contenido de `src/hooks/useAuth.ts`**

```typescript
import { useState, useEffect } from "react";
import type { User, Session } from "@supabase/supabase-js";
import { supabase } from "../services/supabase";

const SESSION_KEY = "aivi_team_session";

export function useAuth() {
  const [user, setUser]           = useState<User | null>(null);
  const [session, setSession]     = useState<Session | null>(null);
  const [loading, setLoading]     = useState(true);
  const [teamEmail, setTeamEmail] = useState<string | null>(() => {
    try {
      const raw = localStorage.getItem(SESSION_KEY);
      return raw ? (JSON.parse(raw) as { email: string }).email : null;
    } catch {
      return null;
    }
  });

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      setUser(session?.user ?? null);
      setLoading(false);
    });

    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      (_event, session) => {
        setSession(session);
        setUser(session?.user ?? null);
        setLoading(false);

        // Si la sesión se cierra externamente, limpiar también el teamEmail
        if (!session) {
          localStorage.removeItem(SESSION_KEY);
          setTeamEmail(null);
        }
      }
    );

    return () => subscription.unsubscribe();
  }, []);

  const signIn = (email: string, password: string) =>
    supabase.auth.signInWithPassword({ email, password });

  const signOut = async () => {
    await supabase.auth.signOut();
    localStorage.removeItem(SESSION_KEY);
    setTeamEmail(null);
  };

  return { user, session, loading, teamEmail, signIn, signOut };
}
```

- [ ] **Step 2: Verificar TypeScript sin errores**

```bash
npx tsc --noEmit
```

Esperado: sin errores relacionados con `useAuth`.

- [ ] **Step 3: Commit**

```bash
git add src/hooks/useAuth.ts
git commit -m "feat: useAuth expone teamEmail desde localStorage; signOut limpia sesión portal"
```

---

## Task 4: LoginView — Email-only login

**Files:**
- Modify: `src/views/LoginView.tsx`

El nuevo flujo de login:
1. Usuario ingresa su email y presiona Entrar
2. Se consulta `access_requests` como anon: `eq("email", email).eq("status", "approved")`
3. Si existe → `signInWithPassword` con las credenciales portal desde `.env` → guardar `{ email }` en `localStorage`
4. Si no existe → mostrar error "Este correo no tiene acceso"

El campo de contraseña desaparece. El formulario de "Pedir acceso" no cambia.

- [ ] **Step 1: Reemplazar el contenido de `src/views/LoginView.tsx`**

```tsx
import { useState }  from "react";
import { Mail, ArrowRight, CheckCircle, AlertCircle, Loader2 } from "lucide-react";
import { supabase }  from "../services/supabase";
import { C, FONT }   from "../tokens";

const SESSION_KEY = "aivi_team_session";

type Mode = "login" | "request";

type LoginStep = "idle" | "checking" | "signing-in" | "done";

export function LoginView() {
  const [mode, setMode]       = useState<Mode>("login");
  const [email, setEmail]     = useState("");
  const [loading, setLoading] = useState(false);
  const [loginStep, setLoginStep] = useState<LoginStep>("idle");
  const [error, setError]     = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const reset = (nextMode: Mode) => {
    setMode(nextMode);
    setError(null);
    setSuccess(null);
    setLoginStep("idle");
  };

  // ── LOGIN ──────────────────────────────────────────────
  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    const normalizedEmail = email.trim().toLowerCase();

    // 1. Verificar si el correo está aprobado (como anon)
    setLoginStep("checking");
    const { data: rows, error: selectErr } = await supabase
      .from("access_requests")
      .select("email")
      .eq("email", normalizedEmail)
      .eq("status", "approved")
      .limit(1);

    if (selectErr || !rows || rows.length === 0) {
      setError("Este correo no tiene acceso. Pide acceso al admin.");
      setLoading(false);
      setLoginStep("idle");
      return;
    }

    // 2. Login con cuenta portal
    setLoginStep("signing-in");
    const portalEmail    = import.meta.env.VITE_PORTAL_EMAIL as string;
    const portalPassword = import.meta.env.VITE_PORTAL_PASSWORD as string;

    const { error: authErr } = await supabase.auth.signInWithPassword({
      email:    portalEmail,
      password: portalPassword,
    });

    if (authErr) {
      setError("Error al iniciar sesión. Contacta al administrador.");
      setLoading(false);
      setLoginStep("idle");
      return;
    }

    // 3. Guardar email real del miembro en localStorage
    localStorage.setItem(SESSION_KEY, JSON.stringify({ email: normalizedEmail }));
    setLoginStep("done");
    setLoading(false);
    // App.tsx detecta el cambio de sesión vía onAuthStateChange y renderiza el dashboard
  };

  // ── SOLICITAR ACCESO ───────────────────────────────────
  const handleRequest = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setSuccess(null);

    const { error } = await supabase
      .from("access_requests")
      .insert({ email: email.trim().toLowerCase() });

    setLoading(false);

    if (error) {
      if (error.code === "23505") {
        setSuccess("Ya tienes una solicitud registrada. Te avisaremos cuando sea revisada.");
      } else {
        setError("No pudimos registrar tu solicitud. Inténtalo de nuevo.");
      }
    } else {
      setSuccess("¡Solicitud enviada! Te contactaremos cuando tu acceso sea aprobado.");
      setEmail("");
    }
  };

  const stepLabel: Record<LoginStep, string> = {
    idle:        "Entrar",
    checking:    "Verificando acceso...",
    "signing-in":"Entrando...",
    done:        "¡Listo!",
  };

  const inputStyle: React.CSSProperties = {
    width: "100%",
    background: "rgba(255,255,255,0.06)",
    border: `1px solid ${C.border}`,
    borderRadius: 10,
    padding: "12px 14px 12px 42px",
    fontSize: 15,
    color: C.white,
    outline: "none",
    fontFamily: FONT,
    boxSizing: "border-box",
    transition: "border-color 0.2s",
  };

  return (
    <div style={{
      minHeight: "100vh",
      background: C.bg,
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
      fontFamily: FONT,
      padding: "0 16px",
    }}>
      <div style={{
        width: "100%",
        maxWidth: 400,
        background: C.card,
        borderRadius: 20,
        border: `1px solid ${C.border}`,
        padding: "40px 32px",
        boxShadow: "0 24px 80px rgba(0,0,0,0.5)",
      }}>
        {/* Logo */}
        <div style={{ textAlign: "center", marginBottom: 32 }}>
          <div style={{
            display: "inline-flex",
            alignItems: "center",
            justifyContent: "center",
            width: 52,
            height: 52,
            borderRadius: 14,
            background: C.gradBtn,
            marginBottom: 14,
          }}>
            <img src="/logo.png" alt="Logo" style={{ width: 32, height: 32, objectFit: "contain" }} />
          </div>
          <h1 style={{ margin: 0, fontSize: 22, fontWeight: 800, color: C.white }}>AIVI Core</h1>
          <p style={{ margin: "4px 0 0", fontSize: 13, color: C.mutedLight }}>
            {mode === "login" ? "Ingresa tu correo para acceder" : "Solicita acceso a la plataforma"}
          </p>
        </div>

        {/* Tabs */}
        <div style={{
          display: "flex",
          background: "rgba(255,255,255,0.04)",
          borderRadius: 10,
          padding: 3,
          marginBottom: 28,
          gap: 3,
        }}>
          {(["login", "request"] as const).map((m) => (
            <button
              key={m}
              onClick={() => reset(m)}
              style={{
                flex: 1,
                padding: "8px 0",
                borderRadius: 8,
                border: "none",
                cursor: "pointer",
                fontSize: 13,
                fontWeight: 600,
                fontFamily: FONT,
                background: mode === m ? C.orange : "transparent",
                color: mode === m ? "#fff" : C.mutedMid,
                transition: "all 0.2s",
              }}
            >
              {m === "login" ? "Iniciar sesión" : "Pedir acceso"}
            </button>
          ))}
        </div>

        {/* ── FORM LOGIN ── */}
        {mode === "login" && (
          <form onSubmit={handleLogin} style={{ display: "flex", flexDirection: "column", gap: 14 }}>
            <div style={{ position: "relative" }}>
              <Mail size={15} style={{ position: "absolute", left: 14, top: "50%", transform: "translateY(-50%)", color: C.mutedMid }} />
              <input
                type="email"
                required
                placeholder="tu@correo.com"
                value={email}
                onChange={e => setEmail(e.target.value)}
                style={inputStyle}
              />
            </div>

            {error && (
              <div style={{
                display: "flex", alignItems: "flex-start", gap: 8,
                padding: "10px 12px", borderRadius: 8,
                background: "rgba(255,65,59,0.1)", border: "1px solid rgba(255,65,59,0.25)",
              }}>
                <AlertCircle size={14} style={{ color: C.red, flexShrink: 0, marginTop: 1 }} />
                <span style={{ fontSize: 12, color: "#FF8A87" }}>{error}</span>
              </div>
            )}

            <button
              type="submit"
              disabled={loading}
              style={{
                padding: "13px 0",
                borderRadius: 10,
                border: "none",
                cursor: loading ? "not-allowed" : "pointer",
                background: loading ? "rgba(255,107,44,0.4)" : C.gradBtn,
                color: "#fff",
                fontSize: 14,
                fontWeight: 700,
                fontFamily: FONT,
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                gap: 8,
                marginTop: 4,
                transition: "opacity 0.2s",
              }}
            >
              {loading
                ? <><Loader2 size={15} style={{ animation: "spin 1s linear infinite" }} /> {stepLabel[loginStep]}</>
                : <><ArrowRight size={15} /> {stepLabel["idle"]}</>
              }
            </button>
          </form>
        )}

        {/* ── FORM SOLICITAR ACCESO ── */}
        {mode === "request" && (
          <form onSubmit={handleRequest} style={{ display: "flex", flexDirection: "column", gap: 14 }}>
            <div style={{ position: "relative" }}>
              <Mail size={15} style={{ position: "absolute", left: 14, top: "50%", transform: "translateY(-50%)", color: C.mutedMid }} />
              <input
                type="email"
                required
                placeholder="tu@correo.com"
                value={email}
                onChange={e => setEmail(e.target.value)}
                style={inputStyle}
              />
            </div>

            <p style={{ margin: 0, fontSize: 12, color: C.mutedMid, lineHeight: 1.6 }}>
              Ingresa tu correo y el administrador revisará tu solicitud. Una vez aprobada, podrás entrar solo con tu correo.
            </p>

            {error && (
              <div style={{
                display: "flex", alignItems: "flex-start", gap: 8,
                padding: "10px 12px", borderRadius: 8,
                background: "rgba(255,65,59,0.1)", border: "1px solid rgba(255,65,59,0.25)",
              }}>
                <AlertCircle size={14} style={{ color: C.red, flexShrink: 0, marginTop: 1 }} />
                <span style={{ fontSize: 12, color: "#FF8A87" }}>{error}</span>
              </div>
            )}

            {success && (
              <div style={{
                display: "flex", alignItems: "flex-start", gap: 8,
                padding: "10px 12px", borderRadius: 8,
                background: "rgba(34,197,94,0.1)", border: "1px solid rgba(34,197,94,0.25)",
              }}>
                <CheckCircle size={14} style={{ color: C.green, flexShrink: 0, marginTop: 1 }} />
                <span style={{ fontSize: 12, color: "#86EFAC" }}>{success}</span>
              </div>
            )}

            {!success && (
              <button
                type="submit"
                disabled={loading}
                style={{
                  padding: "13px 0",
                  borderRadius: 10,
                  border: "none",
                  cursor: loading ? "not-allowed" : "pointer",
                  background: loading ? "rgba(255,107,44,0.4)" : C.gradBtn,
                  color: "#fff",
                  fontSize: 14,
                  fontWeight: 700,
                  fontFamily: FONT,
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  gap: 8,
                  marginTop: 4,
                  transition: "opacity 0.2s",
                }}
              >
                {loading
                  ? <><Loader2 size={15} style={{ animation: "spin 1s linear infinite" }} /> Enviando...</>
                  : <><Mail size={15} /> Solicitar acceso</>
                }
              </button>
            )}

            {success && (
              <button
                type="button"
                onClick={() => reset("login")}
                style={{
                  padding: "13px 0",
                  borderRadius: 10,
                  border: `1px solid ${C.border}`,
                  cursor: "pointer",
                  background: "transparent",
                  color: C.mutedLight,
                  fontSize: 13,
                  fontWeight: 600,
                  fontFamily: FONT,
                }}
              >
                Ir a iniciar sesión
              </button>
            )}
          </form>
        )}
      </div>

      <style>{`
        @keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
      `}</style>
    </div>
  );
}
```

- [ ] **Step 2: Verificar TypeScript sin errores**

```bash
npx tsc --noEmit
```

Esperado: sin errores en `LoginView.tsx`.

- [ ] **Step 3: Commit**

```bash
git add src/views/LoginView.tsx
git commit -m "feat: login email-only — verifica access_requests como anon y entra con cuenta portal"
```

---

## Task 5: App + Sidebar + Vistas — isAdmin

**Files:**
- Modify: `src/App.tsx`
- Modify: `src/components/layout/Sidebar.tsx`
- Modify: `src/views/DashboardView.tsx`
- Modify: `src/views/TransactionsView.tsx`

El botón "Ajustes" del sidebar debe ser invisible para miembros del equipo que no sean admin. Se agrega `isAdmin: boolean` como prop que fluye desde `App.tsx` → vistas → `Sidebar`.

- [ ] **Step 1: Modificar `src/App.tsx` — usar teamEmail y computar isAdmin**

Reemplazar:
```typescript
const { user, loading, signOut } = useAuth();
```
Con:
```typescript
const { user, loading, signOut, teamEmail } = useAuth();
const isAdmin = teamEmail === import.meta.env.VITE_ADMIN_EMAIL;
```

Reemplazar la llamada a `DashboardView`:
```tsx
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
Con:
```tsx
return (
  <DashboardView
    onSettings={() => setView("admin")}
    onSignOut={signOut}
    onUsers={() => setView("usuarios")}
    onTransactions={() => setView("transacciones")}
    activeView={view}
    isAdmin={isAdmin}
  />
);
```

Reemplazar la llamada a `TransactionsView`:
```tsx
if (view === "transacciones") return (
  <TransactionsView
    onSettings={() => setView("admin")}
    onSignOut={signOut}
    onDashboard={() => setView("dashboard")}
    onUsers={() => setView("usuarios")}
    activeView={view}
  />
);
```
Con:
```tsx
if (view === "transacciones") return (
  <TransactionsView
    onSettings={() => setView("admin")}
    onSignOut={signOut}
    onDashboard={() => setView("dashboard")}
    onUsers={() => setView("usuarios")}
    activeView={view}
    isAdmin={isAdmin}
  />
);
```

- [ ] **Step 2: Modificar `src/components/layout/Sidebar.tsx` — agregar isAdmin prop**

En la interfaz `SidebarProps`, agregar:
```typescript
isAdmin?: boolean;
```

En la destructuración del componente `Sidebar(...)`, agregar `isAdmin = false` al final de los parámetros.

Reemplazar el bloque del botón "Ajustes" (líneas ~215-225):
```tsx
<button onClick={() => { onSettings(); if (isMobile) onClose?.(); }} style={{
  flex: 1, padding: "8px", borderRadius: 8,
  background: "transparent",
  border: `1px solid ${C.border}`,
  color: C.mutedLight, fontSize: 11, fontWeight: 600,
  display: "flex", alignItems: "center", justifyContent: "center", gap: 6,
  transition: "all .15s",
  cursor: "pointer",
}}>
  <Settings size={13} /> Ajustes
</button>
```
Con:
```tsx
{isAdmin && (
  <button onClick={() => { onSettings(); if (isMobile) onClose?.(); }} style={{
    flex: 1, padding: "8px", borderRadius: 8,
    background: "transparent",
    border: `1px solid ${C.border}`,
    color: C.mutedLight, fontSize: 11, fontWeight: 600,
    display: "flex", alignItems: "center", justifyContent: "center", gap: 6,
    transition: "all .15s",
    cursor: "pointer",
  }}>
    <Settings size={13} /> Ajustes
  </button>
)}
```

- [ ] **Step 3: Modificar `src/views/DashboardView.tsx` — recibir y pasar isAdmin**

En la interfaz de props de `DashboardView`, agregar:
```typescript
isAdmin?: boolean;
```

En la destructuración de la función, agregar `isAdmin = false`.

Buscar donde se renderiza `<Sidebar` y agregar `isAdmin={isAdmin}` como prop.

- [ ] **Step 4: Modificar `src/views/TransactionsView.tsx` — recibir y pasar isAdmin**

En la interfaz `TransactionsViewProps`, agregar:
```typescript
isAdmin?: boolean;
```

En la destructuración de la función, agregar `isAdmin = false`.

Buscar donde se renderiza `<Sidebar` y agregar `isAdmin={isAdmin}` como prop.

- [ ] **Step 5: Verificar TypeScript sin errores**

```bash
npx tsc --noEmit
```

Esperado: 0 errores.

- [ ] **Step 6: Commit**

```bash
git add src/App.tsx src/components/layout/Sidebar.tsx src/views/DashboardView.tsx src/views/TransactionsView.tsx
git commit -m "feat: isAdmin controla visibilidad de Ajustes en sidebar según teamEmail"
```

---

## Task 6: AdminPanel — Aprobar sin Edge Function

**Files:**
- Modify: `src/components/admin/AdminPanel.tsx`

El `handleApprove` actual llama a la Edge Function `invite-user`. Lo reemplazamos con un UPDATE directo en `access_requests`. Más rápido y sin dependencias externas.

- [ ] **Step 1: Reemplazar `handleApprove` en `src/components/admin/AdminPanel.tsx`**

Localizar (líneas ~58-82):
```typescript
const handleApprove = async (req: AccessRequest) => {
  setActionId(req.id);
  setActionMsg(null);
  try {
    const { data: sessionData } = await supabase.auth.getSession();
    const token = sessionData.session?.access_token;

    const res = await supabase.functions.invoke("invite-user", {
      body: { email: req.email, requestId: req.id },
      headers: token ? { Authorization: `Bearer ${token}` } : {},
    });

    if (res.error) {
      setActionMsg({ id: req.id, msg: res.error.message ?? "Error al aprobar", ok: false });
    } else {
      setActionMsg({ id: req.id, msg: "Invitación enviada correctamente.", ok: true });
      await loadRequests();
    }
  } catch (e) {
    setActionMsg({ id: req.id, msg: String(e), ok: false });
  } finally {
    setActionId(null);
  }
};
```

Reemplazar con:
```typescript
const handleApprove = async (req: AccessRequest) => {
  setActionId(req.id);
  setActionMsg(null);

  const { error } = await supabase
    .from("access_requests")
    .update({ status: "approved", reviewed_at: new Date().toISOString() })
    .eq("id", req.id);

  if (error) {
    setActionMsg({ id: req.id, msg: error.message, ok: false });
  } else {
    setActionMsg({ id: req.id, msg: "Acceso aprobado. El miembro ya puede entrar con su correo.", ok: true });
    await loadRequests();
  }

  setActionId(null);
};
```

- [ ] **Step 2: Verificar TypeScript sin errores**

```bash
npx tsc --noEmit
```

Esperado: 0 errores.

- [ ] **Step 3: Commit**

```bash
git add src/components/admin/AdminPanel.tsx
git commit -m "feat: aprobar acceso vía UPDATE directo en access_requests, sin Edge Function invite-user"
```

---

## Task 7: Smoke Test Manual

- [ ] **Step 1: Levantar el servidor de desarrollo**

```bash
npm run dev
```

- [ ] **Step 2: Probar login con email aprobado (tu propio email)**

Abrir `http://localhost:5173`. Debes ver la pantalla de login con solo el campo de email.

Ingresa `contenido@jheitrujillo.com` → presiona Entrar.

Esperado: el status cambia "Verificando acceso..." → "Entrando..." → redirige al dashboard.

En DevTools → Application → Local Storage: debe existir la clave `aivi_team_session` con valor `{"email":"contenido@jheitrujillo.com"}`.

- [ ] **Step 3: Verificar que el botón "Ajustes" es visible para el admin**

Dentro del dashboard, el sidebar debe mostrar el botón "Ajustes".

- [ ] **Step 4: Cerrar sesión y probar con email NO aprobado**

Cierra sesión. En Local Storage, `aivi_team_session` debe haber desaparecido.

Intenta ingresar con un email inventado, por ejemplo `intruso@ejemplo.com`.

Esperado: mensaje de error "Este correo no tiene acceso. Pide acceso al admin."

- [ ] **Step 5: Probar flujo de solicitud de acceso**

Cambia a la pestaña "Pedir acceso", ingresa `nuevo@miembro.com`, presiona Solicitar.

Esperado: mensaje de éxito "¡Solicitud enviada!...".

- [ ] **Step 6: Probar aprobación desde AdminPanel**

Como admin (`contenido@jheitrujillo.com`), ve a Ajustes → verás la solicitud de `nuevo@miembro.com` como pendiente.

Haz clic en "Aprobar".

Esperado: el mensaje cambia a "Acceso aprobado. El miembro ya puede entrar con su correo." y la solicitud pasa a la sección de aprobados.

- [ ] **Step 7: Verificar que un miembro no-admin no ve Ajustes**

Si tienes un segundo email aprobado de prueba, inicia sesión con él.

Esperado: el sidebar NO muestra el botón "Ajustes".
