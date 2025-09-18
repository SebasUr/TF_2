# Backend Dockerfile
FROM node:20-alpine AS base
WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

COPY . .

ENV NODE_ENV=production \
    PORT=5001

EXPOSE 5001

CMD ["node", "server.js"]
