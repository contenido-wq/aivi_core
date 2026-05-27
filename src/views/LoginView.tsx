import { useState }  from "react";
import { Mail, Lock, ArrowRight, CheckCircle, AlertCircle, Loader2 } from "lucide-react";
import { supabase }  from "../services/supabase";
import { C, FONT }   from "../tokens";

type Mode = "login" | "request";

export function LoginView() {
  const [mode, setMode]           = useState<Mode>("login");
  const [email, setEmail]         = useState("");
  const [password, setPassword]   = useState("");
  const [loading, setLoading]     = useState(false);
  const [error, setError]         = useState<string | null>(null);
  const [success, setSuccess]     = useState<string | null>(null);

  const reset = (nextMode: Mode) => {
    setMode(nextMode);
    setError(null);
    setSuccess(null);
    setPassword("");
  };

  // ── LOGIN ──────────────────────────────────────────────
  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    const { error } = await supabase.auth.signInWithPassword({ email, password });
    setLoading(false);
    if (error) {
      if (error.message.includes("Invalid login credentials")) {
        setError("Correo o contraseña incorrectos.");
      } else if (error.message.includes("Email not confirmed")) {
        setError("Debes confirmar tu correo antes de iniciar sesión. Revisa tu bandeja de entrada.");
      } else {
        setError(error.message);
      }
    }
    // Si no hay error, useAuth detecta el cambio y App.tsx renderiza el dashboard
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
        // Unique violation — ya existe una solicitud para ese correo
        setSuccess("Ya tienes una solicitud registrada. Te avisaremos cuando sea revisada.");
      } else {
        setError("No pudimos registrar tu solicitud. Inténtalo de nuevo.");
      }
    } else {
      setSuccess("¡Solicitud enviada! Te contactaremos cuando tu acceso sea aprobado.");
      setEmail("");
    }
  };

  // ── ESTILOS ────────────────────────────────────────────
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
      {/* Card */}
      <div style={{
        width: "100%",
        maxWidth: 400,
        background: C.card,
        borderRadius: 20,
        border: `1px solid ${C.border}`,
        padding: "40px 32px",
        boxShadow: "0 24px 80px rgba(0,0,0,0.5)",
      }}>

        {/* Logo / marca */}
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
            {mode === "login" ? "Inicia sesión en tu cuenta" : "Solicita acceso a la plataforma"}
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
            {/* Email */}
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
            {/* Password */}
            <div style={{ position: "relative" }}>
              <Lock size={15} style={{ position: "absolute", left: 14, top: "50%", transform: "translateY(-50%)", color: C.mutedMid }} />
              <input
                type="password"
                required
                placeholder="Contraseña"
                value={password}
                onChange={e => setPassword(e.target.value)}
                style={inputStyle}
              />
            </div>

            {/* Error */}
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
                background: loading ? "rgba(254,128,63,0.4)" : C.gradBtn,
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
                ? <><Loader2 size={15} style={{ animation: "spin 1s linear infinite" }} /> Entrando...</>
                : <><ArrowRight size={15} /> Entrar</>
              }
            </button>
          </form>
        )}

        {/* ── FORM SOLICITAR ACCESO ── */}
        {mode === "request" && (
          <form onSubmit={handleRequest} style={{ display: "flex", flexDirection: "column", gap: 14 }}>
            {/* Email */}
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
              Ingresa tu correo y el administrador revisará tu solicitud. Recibirás un email de invitación cuando sea aprobada.
            </p>

            {/* Error */}
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

            {/* Éxito */}
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
                  background: loading ? "rgba(254,128,63,0.4)" : C.gradBtn,
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

      {/* Animación spinner */}
      <style>{`
        @keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
      `}</style>
    </div>
  );
}
