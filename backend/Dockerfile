FROM node:20-bookworm

ENV TZ=America/Sao_Paulo \
    PUPPETEER_SKIP_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/local/bin/chromium \
    NPM_CONFIG_OPTIONAL=false

# Deps Chromium e runtime
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium ca-certificates fonts-liberation xdg-utils \
    libasound2 libnss3 libxss1 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 \
    libxrandr2 libgbm1 \
    # evita download do libvips pelo sharp (usa sistema)
    libvips libvips-dev \
    # ferramentas build caso algum nativo precise (ex.: node-gyp)
    python3 make g++ \
    && rm -rf /var/lib/apt/lists/*

# Wrapper garante flags certas SEMPRE (inclui no-sandbox)
RUN printf '#!/usr/bin/env bash\nexec /usr/bin/chromium --no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage "$@"\n' \
    > /usr/local/bin/chromium && chmod +x /usr/local/bin/chromium

WORKDIR /app
COPY package*.json ./

# Instala em modo clean; sem opcionais quebradiços
RUN npm ci --omit=optional --legacy-peer-deps

COPY . .

# Build se existir
RUN if [ "$(npm pkg get scripts.build | tr -d '\"')" != "null" ]; then npm run build; fi

# Entrypoint cuida de locks do Chromium
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["/entrypoint.sh"]
