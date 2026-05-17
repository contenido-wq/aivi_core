import { useState } from "react";
import type { AppView } from "./types";
import { DashboardView } from "./views/DashboardView";
import { AdminPanel }    from "./components/admin/AdminPanel";

export default function App() {
  const [view, setView] = useState<AppView>("dashboard");
  return view === "admin"
    ? <AdminPanel onBack={() => setView("dashboard")} />
    : <DashboardView onSettings={() => setView("admin")} />;
}
