#!/bin/bash

# Configuración de rutas (ajustadas a tu sistema)
ASSETS="/home/routel/.local/share/Steam/steamapps/common/wallpaper_engine/assets"
BASE_PATH="/home/routel/.local/share/Steam/steamapps/workshop/content/431960"

# Si no pasas un ID, el script te avisa
if [ -z "$1" ]; then
    echo "Uso: ./set-wp.sh [ID_DEL_WALLPAPER]"
    exit 1
fi

# 1. Matar procesos anteriores para no duplicar consumo
pkill -f linux-wallpaperengine

# 2. Ejecutar el nuevo fondo en segundo plano y silenciar la terminal
linux-wallpaperengine --screen-root DP-0 --profile=balanced --audio-support --assets-dir "$ASSETS" "$BASE_PATH/$1" > /dev/null 2>&1 &

disown
echo "Cambiado al wallpaper: $1"
