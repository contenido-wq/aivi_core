import { useState } from "react";
import type { AppView }        from "./types";
import { DashboardView }       from "./views/DashboardView";
import { AnalyticsView }       from "./views/AnalyticsView";
import { LoginView }           from "./views/LoginView";
import { AdminPanel }          from "./components/admin/AdminPanel";
import { UsersView }           from "./views/UsersView";
import { TransactionsView }    from "./views/TransactionsView";
import { EventosView }         from "./views/EventosView";
import { EventGuestView }      from "./views/EventGuestView";
import { useAuth }             from "./hooks/useAuth";
import { ADMIN_EMAIL }         from "./lib/authConfig";
import { GUEST_SESSION_KEY, type GuestSession } from "./services/eventGuests";
import { C, FONT }             from "./tokens";

function readGuestSession(): GuestSession | null {
  try {
    const raw = localStorage.getItem(GUEST_SESSION_KEY);
    return raw ? (JSON.parse(raw) as GuestSession) : null;
  } catch {
    return null;
  }
}

export default function App() {
  const [guestSession, setGuestSession] = useState<GuestSession | null>(() => readGuestSession());

  // Sesión de invitado: completamente aparte del login de equipo — nunca pasa
  // por Supabase Auth ni por allowedSections, solo ve el evento asignado.
  if (guestSession) {
    return (
      <EventGuestView
        guestId={guestSession.guestId}
        enrollmentCode={guestSession.enrollment_code}
        label={guestSession.label}
        onSignOut={() => {
          localStorage.removeItem(GUEST_SESSION_KEY);
          setGuestSession(null);
        }}
      />
    );
  }

  return <TeamApp onGuestLogin={setGuestSession} />;
}

function TeamApp({ onGuestLogin }: { onGuestLogin: (s: GuestSession) => void }) {
  const { user, loading, signOut, teamEmail, allowedSections } = useAuth();
  const [view, setView]                       = useState<AppView>("dashboard");
  const isAdmin = teamEmail === ADMIN_EMAIL;
  const canAccess = (v: AppView) => isAdmin || allowedSections.includes(v);

  // Spinner mientras Supabase restaura la sesión
  if (loading) {
    return (
      <div style={{
        height: "100vh",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        background: C.bg,
        fontFamily: FONT,
      }}>
        <div style={{ textAlign: "center" }}>
          <div style={{
            width: 36, height: 36, borderRadius: "50%",
            border: `3px solid ${C.border}`,
            borderTopColor: C.orange,
            animation: "spin 0.8s linear infinite",
            margin: "0 auto 12px",
          }} />
          <div style={{ fontSize: 13, color: C.mutedMid }}>Cargando...</div>
        </div>
        <style>{`@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`}</style>
      </div>
    );
  }

  // Sin sesión → pantalla de login con verificación de acceso
  if (!user) return <LoginView onGuestLogin={onGuestLogin} />;

  // Vista efectiva: si no hay acceso a la vista actual, caer a la primera sección permitida
  const effectiveView: AppView | null = canAccess(view) ? view : (allowedSections[0] ?? null);

  if (effectiveView === null) {
    return (
      <div style={{
        height: "100vh", display: "flex", flexDirection: "column",
        alignItems: "center", justifyContent: "center", gap: 12,
        background: C.bg, fontFamily: FONT, color: C.mutedLight, textAlign: "center", padding: 24,
      }}>
        <div style={{ fontSize: 14 }}>No tienes acceso a ninguna sección todavía.</div>
        <div style={{ fontSize: 12, color: C.muted }}>Contacta al administrador para que te asigne acceso.</div>
        <button onClick={signOut} style={{
          marginTop: 8, padding: "8px 18px", borderRadius: 8, border: `1px solid ${C.border}`,
          background: "transparent", color: C.mutedLight, fontSize: 12, fontWeight: 600, cursor: "pointer",
        }}>
          Cerrar sesión
        </button>
      </div>
    );
  }

  // Vista Admin
  if (effectiveView === "admin") return <AdminPanel onBack={() => setView("dashboard")} />;

  // Vista Usuarios (trazabilidad)
  if (effectiveView === "usuarios") return (
    <UsersView
      onBack={() => setView("dashboard")}
      onDashboard={() => setView("dashboard")}
      onTransactions={() => setView("transacciones")}
      onAnalytics={() => setView("analytics")}
      onSettings={() => setView("admin")}
      isAdmin={isAdmin}
      allowedSections={allowedSections}
    />
  );

  // Vista Analytics Command Center
  if (effectiveView === "analytics") return (
    <AnalyticsView
      onDashboard={() => setView("dashboard")}
      onUsers={() => setView("usuarios")}
      onTransactions={() => setView("transacciones")}
      onSettings={() => setView("admin")}
      onEventos={() => setView("eventos")}
      onSignOut={signOut}
      activeView={effectiveView}
      isAdmin={isAdmin}
      allowedSections={allowedSections}
    />
  );

  // Vista Transacciones
  if (effectiveView === "transacciones") return (
    <TransactionsView
      onSettings={() => setView("admin")}
      onSignOut={signOut}
      onDashboard={() => setView("dashboard")}
      onUsers={() => setView("usuarios")}
      onAnalytics={() => setView("analytics")}
      onEventos={() => setView("eventos")}
      activeView={effectiveView}
      isAdmin={isAdmin}
      allowedSections={allowedSections}
    />
  );

  // Vista Eventos
  if (effectiveView === "eventos") return (
    <EventosView
      onSettings={() => setView("admin")}
      onSignOut={signOut}
      onDashboard={() => setView("dashboard")}
      onUsers={() => setView("usuarios")}
      onTransactions={() => setView("transacciones")}
      onAnalytics={() => setView("analytics")}
      activeView={effectiveView}
      isAdmin={isAdmin}
      allowedSections={allowedSections}
    />
  );

  return (
    <DashboardView
      onSettings={() => setView("admin")}
      onSignOut={signOut}
      onUsers={() => setView("usuarios")}
      onTransactions={() => setView("transacciones")}
      onAnalytics={() => setView("analytics")}
      onEventos={() => setView("eventos")}
      activeView={effectiveView}
      isAdmin={isAdmin}
      allowedSections={allowedSections}
    />
  );
}
