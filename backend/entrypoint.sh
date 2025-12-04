#!/usr/bin/env bash
set -euo pipefail

mkdir -p /app/.wwebjs_auth /app/.chrome
# limpa locks antigos do Chromium (evita "ProcessSingleton/SingletonLock")
find /app/.wwebjs_auth -maxdepth 2 -type f -name "SingletonLock" -delete || true
rm -f /app/.wwebjs_auth/**/SingletonCookie 2>/dev/null || true

# nodemon vs node: respeita teu package.json (start usa nodemon)
exec npm start
