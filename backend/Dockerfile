FROM node:24-bookworm

ENV TZ=America/Sao_Paulo \
    PUPPETEER_SKIP_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# deps p/ chromium/whatsapp-web.js/puppeteer
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium ca-certificates fonts-liberation xdg-utils \
    libasound2 libnss3 libxss1 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 \
    libxrandr2 libgbm1 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package*.json ./
RUN npm ci --legacy-peer-deps

COPY . .

# roda build se existir
RUN if [ "$(npm pkg get scripts.build | tr -d '\"')" != "null" ]; then npm run build; fi

EXPOSE 9000
CMD ["npm","run","start"]
