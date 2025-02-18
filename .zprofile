# Only execute on tty1 and if not already in a Wayland session
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    clear
    #exec Hyprland > /dev/null 
    exec Hyprland > .hyprland.log.txt 2> .hyprland.err.txt
fi
