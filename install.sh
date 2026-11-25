#!/usr/bin/env bash
# Instala set-wall, wall-autopause y wall-picker en ~/.local/bin y el tema de rofi.
# Los archivos existentes se respaldan con sufijo .bak-<fecha>.
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$HOME/.local/bin"; ROFI="${XDG_CONFIG_HOME:-$HOME/.config}/rofi"
STAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p "$BIN" "$ROFI"

put() { # put <src> <dest>
    if [ -e "$2" ] && ! cmp -s "$1" "$2"; then cp -a "$2" "$2.bak-$STAMP"; echo "  respaldo: $2.bak-$STAMP"; fi
    install -m "${3:-644}" "$1" "$2"; echo "  instalado: $2"
}
for s in set-wall wall-autopause wall-picker; do put "$REPO/scripts/$s" "$BIN/$s" 755; done
put "$REPO/rofi/wallpicker.rasi" "$ROFI/wallpicker.rasi"

missing=()
for c in linux-wallpaperengine awww awww-daemon mpvpaper jq ffmpeg magick socat rofi hyprctl notify-send; do
    command -v "$c" >/dev/null || missing+=("$c")
done
[ ${#missing[@]} -eq 0 ] || echo "Faltan dependencias: ${missing[*]}"
echo "Listo. Agrega a tu hyprland.lua lo de hypr/autostart.lua."
