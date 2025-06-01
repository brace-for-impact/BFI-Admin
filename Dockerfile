# --- Stage 1: Build with Vite ---
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

ARG MODE=production
ENV NODE_ENV=$MODE

RUN npm run build:$MODE

# --- Stage 2: Serve with Nginx ---
FROM nginx:1.25-alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
