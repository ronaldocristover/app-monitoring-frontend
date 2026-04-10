# ---- Stage 1: Build ----
FROM node:22-alpine AS builder

WORKDIR /app

# Layer 1: Install dependencies (cached unless package-lock changes)
COPY package-lock.json package.json ./
RUN npm ci

# Layer 2: Copy source and build
COPY . .
RUN npm run build

# ---- Stage 2: Production ----
FROM nginx:1.27-alpine AS production

# Layer 1: Custom nginx config for SPA routing
COPY <<'EOF' /etc/nginx/conf.d/default.conf
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    # SPA fallback — all routes serve index.html
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets aggressively
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff2?)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Disable cache for index.html
    location = /index.html {
        expires -1;
        add_header Cache-Control "no-store, no-cache, must-revalidate";
    }

    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript image/svg+xml;
    gzip_min_length 256;
}
EOF

# Layer 2: Copy built assets from builder
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
