#!/bin/bash

case "$1" in
    lock)
        # Lock all active sessions
        USER_ID=$(id -u carl)
        XDG_RUNTIME_DIR="/run/user/$USER_ID"
        WAYLAND_DISPLAY="wayland-1"
        
        # Lock using proper environment
        sudo -u carl XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" WAYLAND_DISPLAY="$WAYLAND_DISPLAY" hyprlock &
        
        echo "System locked"
        ;;
    logout)
        # Kill Hyprland process
        pkill -x Hyprland
        echo "Logging out"
        ;;
    sleep)
        systemctl suspend
        echo "System sleeping"
        ;;
    shutdown)
        sudo shutdown now
        echo "Shutting down"
        ;;
    reboot)
        sudo reboot
        echo "Rebooting"
        ;;
    *)
        echo "Usage: remote-control.sh {lock|logout|sleep|shutdown|reboot}"
        exit 1
        ;;
esac
