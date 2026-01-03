#!/bin/bash

# Script to move active window between monitors intelligently
# Usage: ./move-to-monitor.sh [primary|secondary|toggle]

MODE=${1:-toggle}

# Get current workspace
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

case $MODE in
    "secondary")
        # Move from primary (1-9) to secondary (11-19)
        if [ $CURRENT_WS -le 9 ]; then
            TARGET_WS=$((CURRENT_WS + 10))
            hyprctl dispatch movetoworkspace $TARGET_WS
            notify-send "窗口移动" "移至副屏工作区 $((CURRENT_WS))"
        fi
        ;;
    "primary")
        # Move from secondary (11-19) to primary (1-9)
        if [ $CURRENT_WS -ge 11 ] && [ $CURRENT_WS -le 19 ]; then
            TARGET_WS=$((CURRENT_WS - 10))
            hyprctl dispatch movetoworkspace $TARGET_WS
            notify-send "窗口移动" "移至主屏工作区 $TARGET_WS"
        fi
        ;;
    "toggle")
        # Automatically toggle between monitors
        if [ $CURRENT_WS -le 9 ]; then
            # Currently on primary, move to secondary
            TARGET_WS=$((CURRENT_WS + 10))
            hyprctl dispatch movetoworkspace $TARGET_WS
            notify-send "Window Moved" "Moved to BenQ workspace $((CURRENT_WS))"
        elif [ $CURRENT_WS -ge 11 ] && [ $CURRENT_WS -le 19 ]; then
            # Currently on secondary, move to primary
            TARGET_WS=$((CURRENT_WS - 10))
            hyprctl dispatch movetoworkspace $TARGET_WS
            notify-send "Window Moved" "Moved to Samsung workspace $TARGET_WS"
        fi
        ;;
esac
