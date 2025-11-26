FROM node:24-bookworm AS build
ENV TZ=America/Sao_Paulo \
    NODE_OPTIONS=--openssl-legacy-provider

WORKDIR /app
RUN npm i -g @quasar/cli

# cache
COPY frontend/package*.json ./frontend/
WORKDIR /app/frontend
RUN npm ci --legacy-peer-deps
COPY frontend/ .

# (opcional) silenciar aviso do browserslist
RUN npx update-browserslist-db@latest --update-db || true

# build (mantém a flag mesmo se o ENV não propagar)
RUN NODE_OPTIONS=--openssl-legacy-provider quasar build -m pwa

FROM nginx:stable
ENV TZ=America/Sao_Paulo
COPY --from=build /app/frontend/dist/pwa /usr/share/nginx/html
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
