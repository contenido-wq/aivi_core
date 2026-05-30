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

        if (!session) {
          localStorage.removeItem(SESSION_KEY);
          setTeamEmail(null);
        } else {
          // Re-leer localStorage cuando se inicia sesión (el login lo escribe antes de este evento)
          try {
            const raw = localStorage.getItem(SESSION_KEY);
            setTeamEmail(raw ? (JSON.parse(raw) as { email: string }).email : null);
          } catch {
            setTeamEmail(null);
          }
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
