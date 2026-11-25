-- Fragmento para hyprland.lua (config de Hyprland en Lua)

-- Autostart: vuelve a poner el último wallpaper y activa la pausa automática
hl.on("hyprland.start", function()
    hl.exec_cmd("~/.local/bin/set-wall --restore")  -- fondo: awww / mpvpaper / Wallpaper Engine
    hl.exec_cmd("~/.local/bin/wall-autopause")      -- pausa el fondo animado si hay ventanas
end)

-- Selector gráfico (rofi). Alt+Enter = escena con audio reactivo
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("~/.local/bin/wall-picker"))
