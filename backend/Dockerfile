FROM node:20-bookworm

# vars base
ENV TZ=America/Sao_Paulo \
    PUPPETEER_SKIP_DOWNLOAD=true \
    NPM_CONFIG_OPTIONAL=false

# deps do Chromium + ferramentas de build + libvips (p/ sharp)
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium ca-certificates fonts-liberation xdg-utils \
    libasound2 libnss3 libxss1 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 \
    libxrandr2 libgbm1 \
    # >>> add: toolchain e libvips nativa
    python3 make g++ pkg-config \
    libvips42 libvips-dev \
  && rm -rf /var/lib/apt/lists/*

# wrapper pro Chromium (força flags quando roda como root)
RUN printf '#!/usr/bin/env bash\nexec /usr/bin/chromium --no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --user-data-dir=/app/.chrome "$@"\n' \
    > /usr/local/bin/chromium && chmod +x /usr/local/bin/chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/local/bin/chromium

# >>> dica pro sharp: usar libvips do sistema (não baixar binário)
ENV SHARP_IGNORE_GLOBAL_LIBVIPS=0

WORKDIR /app
COPY package*.json ./

# npm mais resiliente a rede (opcional, mas ajuda)
RUN npm config set fetch-retries 5 \
 && npm config set fetch-retry-factor 2 \
 && npm config set fetch-retry-maxtimeout 600000 \
 && npm config set fetch-timeout 600000

# evita opcionais problemáticos (ex.: re2)
RUN npm ci --omit=optional --legacy-peer-deps

COPY . .

# build se existir
RUN if [ "$(npm pkg get scripts.build | tr -d '\"')" != "null" ]; then npm run build; fi

# entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["/entrypoint.sh"]
