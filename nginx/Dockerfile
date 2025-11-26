FROM node:24-bookworm AS build
WORKDIR /app
RUN npm i -g @quasar/cli

# cache
COPY frontend/package*.json ./frontend/
WORKDIR /app/frontend
RUN npm ci --legacy-peer-deps

# código do front
COPY frontend/ .
RUN quasar -v && node -v && npm -v
RUN quasar build -m pwa

FROM nginx:stable
# artefato do build
COPY --from=build /app/frontend/dist/pwa /usr/share/nginx/html
# caminho ajustado (agora o contexto é a raiz)
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80