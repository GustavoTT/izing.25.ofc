# Build do FRONT (Quasar) com Node 24
FROM node:24-bookworm AS build
ENV TZ=America/Sao_Paulo
WORKDIR /app
RUN npm i -g @quasar/cli

# cache melhor
COPY frontend/package*.json ./frontend/
WORKDIR /app/frontend
RUN npm ci --legacy-peer-deps
COPY frontend/ .
RUN quasar -v && node -v && npm -v
RUN quasar build -m pwa

# Nginx runtime
FROM nginx:stable
ENV TZ=America_Sao_Paulo=America/Sao_Paulo
COPY --from=build /app/frontend/dist/pwa /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
