FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci && npm cache clean --force

COPY . .

ARG VITE_API_BASE_URL
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}

RUN npm run build

FROM nginx:1.27-alpine AS prod

COPY --from=build /app/dist /usr/share/nginx/html

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
}
EOF

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
