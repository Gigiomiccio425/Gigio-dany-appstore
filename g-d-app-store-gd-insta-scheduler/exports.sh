#!/bin/bash
# exports.sh — compatibilità con tooling Umbrel classico.
# Lo store usa icone via URL (vedi `icon:` in umbrel-app.yml), quindi non c'è
# nulla da generare qui: il file esiste solo per gli script che se lo aspettano.
set -euo pipefail
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "GD Insta Scheduler — nessun export da generare (icona via URL)."
echo "Icona: $APP_DIR/exports/icon.svg (PNG derivabile con rsvg-convert o screenshot)"
