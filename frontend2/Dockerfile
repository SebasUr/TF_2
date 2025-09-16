# Frontend (Vite React TypeScript) Dockerfile
# 1. Build stage
FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci && npm cache clean --force

COPY . .

ARG VITE_API_BASE_URL
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}

RUN npm run build

# 2. Production server stage using a lightweight static server
FROM nginx:1.27-alpine AS prod

# Copy build output
COPY --from=build /app/dist /usr/share/nginx/html

# Provide a default nginx.conf enabling gzip and try_files for SPA routing
RUN rm /etc/nginx/conf.d/default.conf

COPY <<'EOF' /etc/nginx/conf.d/app.conf
server {
  listen 80;
  server_name _;

  gzip on;
  gzip_types text/plain application/xml text/css text/js text/javascript application/javascript application/json image/svg+xml;
  gzip_min_length 256;

  root /usr/share/nginx/html;
  index index.html;

  # SPA fallback
  location / {
    try_files $uri $uri/ /index.html;
  }

  # Static assets cache
  location ~* \.(js|css|png|jpg|jpeg|gif|svg|ico)$ {
    add_header Cache-Control "public, max-age=31536000, immutable";
    try_files $uri =404;
  }

  # Pass through API (optional if frontend calls absolute API URL)
  location /api/ {
    proxy_pass http://backend:5001/; # service name in docker-compose
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }
}
EOF

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
