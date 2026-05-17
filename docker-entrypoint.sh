#!/bin/sh
set -e

if [ -n "$BACKEND_URL" ]; then
    echo ">> BACKEND_URL detectada: $BACKEND_URL"
    echo ">> Activando proxy reverso en nginx para /api/"
    envsubst '$BACKEND_URL' < /etc/nginx/proxy-template/default.conf.template > /etc/nginx/conf.d/default.conf
    echo ">> nginx configurado con proxy reverso hacia $BACKEND_URL"
else
    echo ">> BACKEND_URL no definida. Usando nginx sin proxy reverso (SPA pura)."
fi
