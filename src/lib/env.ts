declare global {
  interface Window {
    _env_?: Record<string, string>;
  }
}

export function env(key: string): string {
  return window._env_?.[key] || (import.meta.env[key] as string) || "";
}
