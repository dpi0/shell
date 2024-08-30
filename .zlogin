if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    export HYPRLAND_LOG_WLR=1

    exec Hyprland > .hyprland.log.txt 2> .hyprland.err.txt
fi
