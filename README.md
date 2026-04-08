# 🌌 Wallpaper Engine Wayland Bridge
A bridge to run Wallpaper Engine scenes on Wayland (Hyprland/Sway) with **Audio Reactive** support.

This project uses `linux-wallpaperengine` to render Steam Workshop wallpapers as your background.

## ✨ Features
- **Audio Reactive:** Wallpapers respond to system audio.
- **Wayland Ready:** Configured for modern composers.
- **Steam Integration:** Automatically points to your Steam Workshop library.

## 🛠️ Requirements
1. **Wallpaper Engine** installed on Steam.
2. **linux-wallpaperengine** (Build from source or install via AUR/Copr).
3. **Steam Workshop IDs** of your favorite wallpapers.

## 🚀 Usage
Run the script providing the Wallpaper ID from the Workshop:
```bash
./scripts/set-wp.sh 2110291414
```

## 📝 Script Breakdown
The script performs the following:
- Kills previous instances to save resources.
- Sets the profile to `balanced` for performance.
- Enables `--audio-support` for reactive effects.
- Directs output to the root of your primary monitor (`DP-1`).

## ⚠️ Limitations
This is a partial integration. Not all complex scenes are 100% compatible with the Linux port, but audio reactivity works perfectly for supported scenes.
