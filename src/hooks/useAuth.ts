import { useState, useEffect } from "react";
import type { User, Session } from "@supabase/supabase-js";
import { supabase } from "../services/supabase";
import type { AppView } from "../types";

const SESSION_KEY = "aivi_team_session";

interface StoredSession {
  email:           string;
  allowedSections?: AppView[];
  allowedEvents?:   string[];
}

function readStoredSession(): StoredSession | null {
  try {
    const raw = localStorage.getItem(SESSION_KEY);
    return raw ? (JSON.parse(raw) as StoredSession) : null;
  } catch {
    return null;
  }
}

export function useAuth() {
  const [user, setUser]           = useState<User | null>(null);
  const [session, setSession]     = useState<Session | null>(null);
  const [loading, setLoading]     = useState(true);
  const [teamEmail, setTeamEmail] = useState<string | null>(() => readStoredSession()?.email ?? null);
  const [allowedSections, setAllowedSections] = useState<AppView[]>(() => readStoredSession()?.allowedSections ?? []);
  const [allowedEvents, setAllowedEvents]     = useState<string[]>(() => readStoredSession()?.allowedEvents ?? []);

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
          setAllowedSections([]);
          setAllowedEvents([]);
        } else {
          // Re-leer localStorage cuando se inicia sesión (el login lo escribe antes de este evento)
          const stored = readStoredSession();
          setTeamEmail(stored?.email ?? null);
          setAllowedSections(stored?.allowedSections ?? []);
          setAllowedEvents(stored?.allowedEvents ?? []);
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
    setAllowedSections([]);
    setAllowedEvents([]);
  };

  return { user, session, loading, teamEmail, allowedSections, allowedEvents, signIn, signOut };
}
