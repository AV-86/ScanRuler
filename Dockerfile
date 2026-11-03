# SPDX-License-Identifier: AGPL-3.0-only
FROM node:22-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
ENV NODE_OPTIONS=--max-old-space-size=4096
RUN npm run build

FROM nginx:1.27-alpine

RUN apk add --no-cache openssl \
  && mkdir -p /etc/nginx/certs \
  && openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/localhost.key \
    -out /etc/nginx/certs/localhost.crt \
    -subj "/CN=localhost" \
    -addext "subjectAltName=DNS:localhost,IP:127.0.0.1" \
  && chmod 644 /etc/nginx/certs/localhost.key /etc/nginx/certs/localhost.crt

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 442
