import { useState }       from "react";
import type { AppView }   from "./types";
import { DashboardView }  from "./views/DashboardView";
import { AdminPanel }     from "./components/admin/AdminPanel";
import { LoginView }      from "./views/LoginView";
import { UsersView }        from "./views/UsersView";
import { TransactionsView } from "./views/TransactionsView";
import { useAuth }        from "./hooks/useAuth";
import { C, FONT }        from "./tokens";

export default function App() {
  const { user, loading, signOut, teamEmail } = useAuth();
  const isAdmin = teamEmail === import.meta.env.VITE_ADMIN_EMAIL;
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
            width: 36, height: 36, borderRadius: "50%",
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
  if (!user) return <LoginView />;

  // Vista Admin
  if (view === "admin") return <AdminPanel onBack={() => setView("dashboard")} />;

  // Vista Usuarios (trazabilidad)
  if (view === "usuarios") return <UsersView onBack={() => setView("dashboard")} />;

  // Vista Transacciones
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

  // Dashboard principal — pasamos onUsers para que el sidebar lo active
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
}
