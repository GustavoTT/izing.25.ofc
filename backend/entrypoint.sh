#!/usr/bin/env bash
set -euo pipefail

# Apaga locks que impedem relançar o Chromium
find /app/.wwebjs_auth -maxdepth 3 -type f -name 'Singleton*' -print -delete 2>/dev/null || true
# Alguns Chromium criam stores que o Node não consegue apagar; remove forçado
find /app/.wwebjs_auth -type d -path '*/Default/GCM Store*' -print -exec rm -rf {} + 2>/dev/null || true

mkdir -p /app/.wwebjs_auth /app/.chrome
chown -R root:root /app/.wwebjs_auth /app/.chrome || true

exec npm run start
