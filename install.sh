#!/usr/bin/env bash
# Enlaza set-wall, wall-autopause y wall-picker en ~/.local/bin y el tema de rofi en ~/.config/rofi.
# Son enlaces simbólicos al repo: lo que edites queda listo para commit y push.
# Lo que ya exista (y no sea el enlace correcto) se respalda con sufijo .bak-<fecha>.
set -euo pipefail
REPO="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
BIN="$HOME/.local/bin"; ROFI="${XDG_CONFIG_HOME:-$HOME/.config}/rofi"
STAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p "$BIN" "$ROFI"

put() { # put <src> <dest>
    if [ -L "$2" ] && [ "$(readlink -f "$2")" = "$(readlink -f "$1")" ]; then echo "  ok: $2"; return; fi
    if [ -e "$2" ] || [ -L "$2" ]; then mv "$2" "$2.bak-$STAMP"; echo "  respaldo: $2.bak-$STAMP"; fi
    ln -s "$1" "$2"; echo "  enlazado: $2 ⇒ $1"
}
chmod +x "$REPO"/scripts/set-wall "$REPO"/scripts/wall-autopause "$REPO"/scripts/wall-picker
for s in set-wall wall-autopause wall-picker; do put "$REPO/scripts/$s" "$BIN/$s"; done
put "$REPO/rofi/wallpicker.rasi" "$ROFI/wallpicker.rasi"

missing=()
for c in linux-wallpaperengine awww awww-daemon mpvpaper jq ffmpeg magick socat rofi hyprctl notify-send; do
    command -v "$c" >/dev/null || missing+=("$c")
done
[ ${#missing[@]} -eq 0 ] || echo "Faltan dependencias: ${missing[*]}"
echo "Listo. Agrega a tu hyprland.lua lo de hypr/autostart.lua."
