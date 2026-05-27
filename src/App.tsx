import { useState }       from "react";
import type { AppView }   from "./types";
import { DashboardView }  from "./views/DashboardView";
import { AdminPanel }     from "./components/admin/AdminPanel";
import { LoginView }      from "./views/LoginView";
import { useAuth }        from "./hooks/useAuth";
import { C, FONT }        from "./tokens";

export default function App() {
  const { user, loading, signOut } = useAuth();
  const [view, setView] = useState<AppView>("dashboard");

  // Pantalla de carga mientras se verifica la sesión
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
            width: 36,
            height: 36,
            borderRadius: "50%",
            border: `3px solid ${C.border}`,
            borderTopColor: C.orange,
            animation: "spin 0.8s linear infinite",
            margin: "0 auto 12px",
          }} />
          <div style={{ fontSize: 13, color: C.mutedMid }}>Verificando sesión...</div>
        </div>
        <style>{`@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`}</style>
      </div>
    );
  }

  // Sin sesión → pantalla de login / solicitud de acceso
  if (!user) {
    return <LoginView />;
  }

  // Con sesión → dashboard o panel admin
  return view === "admin"
    ? <AdminPanel onBack={() => setView("dashboard")} />
    : <DashboardView onSettings={() => setView("admin")} onSignOut={signOut} />;
}
