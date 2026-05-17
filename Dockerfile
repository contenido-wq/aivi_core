# ============================================================
# Stage 1: Build
# ============================================================
FROM node:24-slim AS builder

WORKDIR /app

# Copiar manifests primero para cache de dependencias
COPY package.json package-lock.json ./
RUN npm ci

# Copiar código fuente
COPY . .

# Compilar TypeScript + Build de Vite
RUN npm run build

# ============================================================
# Stage 2: Nginx para servir SPA
# ============================================================
FROM nginx:stable-alpine AS production

# Copiar nginx.conf estático como configuración principal
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Eliminar directorio de templates de nginx para que el script built-in
# 20-envsubst-on-templates.sh no procese templates y destruya variables
# nativas de nginx ($uri, $host, $http_upgrade, etc.)
RUN rm -rf /etc/nginx/templates

# Copiar template de nginx a una ruta custom que solo nuestro script maneja
COPY nginx.conf.template /etc/nginx/proxy-template/default.conf.template

# Copiar build estático desde la etapa de build
COPY --from=builder /app/dist /usr/share/nginx/html

# Copiar script de entrypoint y asegurar formato LF (compatibilidad Windows)
COPY docker-entrypoint.sh /docker-entrypoint.d/40-configure-backend.sh
RUN sed -i 's/\r$//' /docker-entrypoint.d/40-configure-backend.sh \
    && chmod +x /docker-entrypoint.d/40-configure-backend.sh

EXPOSE 80

HEALTHCHECK NONE

CMD ["nginx", "-g", "daemon off;"]
