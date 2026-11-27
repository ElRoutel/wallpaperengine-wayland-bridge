# 🌌 Wallpaper Engine Wayland Bridge

Fondos de pantalla de **Wallpaper Engine** (Steam Workshop), videos e imágenes en **Hyprland / Wayland**, con un solo comando, restauración al iniciar sesión, pausa automática para ahorrar GPU y un selector gráfico con miniaturas.

Usa [`linux-wallpaperengine`](https://github.com/Almamu/linux-wallpaperengine) para las escenas, `mpvpaper` para los videos y `awww` para las imágenes fijas.

## ✨ Qué incluye

| Archivo | Qué hace |
| :--- | :--- |
| `scripts/set-wall` | Pone cualquier fondo: ID del Workshop, video o imagen. Guarda el último para restaurarlo al iniciar. |
| `scripts/wall-autopause` | Pausa el fondo animado cuando el workspace visible tiene ventanas y lo reanuda al quedar vacío (~26-29 W menos en una RTX 2080). |
| `scripts/wall-picker` | Selector gráfico (rofi) con miniaturas de todos tus wallpapers. Tema "Vidrio adaptativo": el color de acento sale del fondo actual. |
| `rofi/wallpicker.rasi` | Tema de rofi del selector (cuadrícula 4×3, vidrio translúcido). |
| `hypr/autostart.lua` | Fragmento para `hyprland.lua`: autostart + atajo `Super+Shift+W`. |
| `scripts/legacy/set-wp.sh` | Script original (v1), conservado como referencia. |

## 🛠️ Requisitos

- **Wallpaper Engine** comprado e instalado en Steam (aporta los assets y el Workshop).
- `linux-wallpaperengine`, `awww` (con `awww-daemon`), `mpvpaper`
- `jq`, `ffmpeg`, `imagemagick` (`magick`), `socat`, `rofi` (>= 2.0, Wayland), `libnotify`
- Hyprland (usa `hyprctl` y su socket de eventos)

Rutas que asumen los scripts (cámbialas al inicio de cada script si usas otras):
- Workshop: `~/.local/share/Steam/steamapps/workshop/content/431960`
- Assets: `~/.local/share/Steam/steamapps/common/wallpaper_engine/assets`
- Imágenes/videos locales para el selector: `~/Pictures/wallpapers` y `~/Pictures/Wallpapers`

## 🚀 Instalación

```bash
git clone https://github.com/ElRoutel/wallpaperengine-wayland-bridge.git
cd wallpaperengine-wayland-bridge
./install.sh
```

Enlaza los scripts en `~/.local/bin` y el tema en `~/.config/rofi` (enlaces simbólicos al repo; respalda lo que ya exista con sufijo `.bak-<fecha>`). Después agrega a tu `hyprland.lua` lo que hay en `hypr/autostart.lua`.

## 🎛️ Uso

```bash
set-wall 1348279970          # escena o video del Workshop por ID
set-wall 1753984965 --audio  # escena reactiva al audio (por defecto va en --silent)
set-wall --fps 60 <ID>       # fps de escenas (por defecto 30) y videos (por defecto los del archivo)
set-wall --props <ID>        # opciones de una escena (colores, sliders...) y las que tienes guardadas
set-wall --prop schemecolor="1 0 0"   # cambia una opción del wallpaper actual; se guarda para ese ID
set-wall --prop bloom=false <ID>      # lo mismo para otro wallpaper (lo aplica)
set-wall --prop schemecolor=          # quita una opción guardada
set-wall --reset-props [ID]  # borra todas las opciones guardadas
set-wall ~/Videos/fondo.mp4  # video local (mpvpaper)
set-wall ~/Pictures/foto.jpg # imagen fija (awww)
set-wall --list              # lista ID, tipo y título de todo el Workshop
set-wall --restore           # vuelve a aplicar el último (para el autostart)
set-wall --stop              # detiene la animación (queda la imagen fija)
set-wall --subscribed        # IDs a los que sigues suscrito en Steam
set-wall --prune             # borra del disco los wallpapers a los que te desuscribiste (pide confirmación; -y para no preguntar)

wall-picker                  # selector gráfico (o Super+Shift+W)
wall-autopause --status      # ¿debería estar pausado ahora?
```

En el selector: **Enter** aplica, **Alt+Enter** aplica con audio reactivo, **Alt+1/2/3** aplica a 15/30/60 fps, **Esc** cierra. El wallpaper actual aparece marcado.

## ⚙️ Cómo funciona

1. **`set-wall` siempre deja una imagen fija con `awww` debajo** del fondo animado: un fotograma del video, la captura que hace Wallpaper Engine a los 60 s, o mientras tanto la preview del Workshop. Así otras herramientas que leen el fondo con `awww query` (lockscreens, shells con efecto vidrio) siempre tienen imagen, y si el fondo animado se cae no queda negro.
2. **El estado** se guarda en `~/.config/set-wall/current` (`objetivo<TAB>audio<TAB>fps`, fps `0` = por defecto) y las opciones de cada escena en `~/.config/set-wall/props/<ID>` (una línea `nombre=valor`, se pasan a `--set-property`). Limitar los fps de un video usa `vf=fps=N` con `hwdec=auto-copy`. `set-wall --restore` lo lee al iniciar sesión y espera a que Hyprland tenga monitores.
3. **Escenas** → `linux-wallpaperengine`; **videos del Workshop o locales** → `mpvpaper` (mucho más ligero). Los wallpapers tipo **web** no funcionan en `linux-wallpaperengine` y se rechazan.
4. **`wall-autopause`** escucha los eventos de Hyprland (`.socket2.sock`). Pausa mpv por IPC y Wallpaper Engine con `SIGSTOP`/`SIGCONT`.
5. **`wall-picker`** solo muestra los wallpapers a los que sigues suscrito (los que tienen `subscribedby` en `steamapps/workshop/appworkshop_431960.acf`), porque Steam no siempre borra la carpeta al desuscribirte; `WALLPICKER_ALL=1 wall-picker` muestra todos. Lee los `project.json` del Workshop, genera miniaturas 16:9 en `~/.cache/set-wall/thumbs` (en paralelo, solo la primera vez) y llama a `set-wall`.

## ⚠️ Limitaciones

- No todas las escenas complejas son 100% compatibles con el port de Linux.
- Los wallpapers web no están soportados.
- Pensado para un monitor; con varios usa el que tiene el foco.
