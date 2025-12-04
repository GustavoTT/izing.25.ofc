FROM node:20-bookworm

# Vars base (sem apontar o executável ainda)
ENV TZ=America/Sao_Paulo \
    PUPPETEER_SKIP_DOWNLOAD=true \
    NPM_CONFIG_OPTIONAL=false

# deps p/ chromium/whatsapp-web.js/puppeteer
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium ca-certificates fonts-liberation xdg-utils \
    libasound2 libnss3 libxss1 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 \
    libxrandr2 libgbm1 && \
    rm -rf /var/lib/apt/lists/*

# Wrapper garante flags obrigatórias quando rodar como root
# (sempre sem sandbox e com /dev/shm otimizado)
RUN printf '#!/usr/bin/env bash\nexec /usr/bin/chromium --no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --user-data-dir=/app/.chrome "$@"\n' \
    > /usr/local/bin/chromium && chmod +x /usr/local/bin/chromium

# Agora sim, aponte o PUPPETEER para o wrapper
ENV PUPPETEER_EXECUTABLE_PATH=/usr/local/bin/chromium

WORKDIR /app
COPY package*.json ./

# evita compilar nativos opcionais incompatíveis (ex.: re2)
RUN npm ci --omit=optional --legacy-peer-deps

COPY . .

# roda build se existir
RUN if [ "$(npm pkg get scripts.build | tr -d '\"')" != "null" ]; then npm run build; fi

# entrypoint permanece como você já usa
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["/entrypoint.sh"]
