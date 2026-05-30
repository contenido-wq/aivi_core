#!/bin/sh
set -e

# Inyectar variables de entorno en window._env_ para que Vite las lea en runtime
cat > /usr/share/nginx/html/env-config.js <<EOF
window._env_ = {
  VITE_SUPABASE_URL: "${VITE_SUPABASE_URL}",
  VITE_SUPABASE_ANON_KEY: "${VITE_SUPABASE_ANON_KEY}",
  VITE_PORTAL_EMAIL: "${VITE_PORTAL_EMAIL}",
  VITE_PORTAL_PASSWORD: "${VITE_PORTAL_PASSWORD}",
  VITE_ADMIN_EMAIL: "${VITE_ADMIN_EMAIL}",
  VITE_ADMIN_PASSWORD: "${VITE_ADMIN_PASSWORD}"
};
EOF
echo ">> env-config.js generado con variables de entorno"

if [ -n "$BACKEND_URL" ]; then
    echo ">> BACKEND_URL detectada: $BACKEND_URL"
    echo ">> Activando proxy reverso en nginx para /api/"
    envsubst '$BACKEND_URL' < /etc/nginx/proxy-template/default.conf.template > /etc/nginx/conf.d/default.conf
    echo ">> nginx configurado con proxy reverso hacia $BACKEND_URL"
else
    echo ">> BACKEND_URL no definida. Usando nginx sin proxy reverso (SPA pura)."
fi
