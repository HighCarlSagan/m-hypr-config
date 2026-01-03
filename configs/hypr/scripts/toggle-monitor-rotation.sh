#!/bin/bash

# BenQ HDMI monitor rotation toggle
MONITOR="HDMI-A-1"

# Get current transform
CURRENT=$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$MONITOR\") | .transform")

if [ "$CURRENT" == "0" ]; then
    # Rotate to vertical (90 degrees clockwise)
    hyprctl keyword monitor $MONITOR,1920x1080@60,2560x0,1,transform,1
    notify-send "显示器旋转" "BenQ已切换至竖屏模式"
else
    # Rotate back to horizontal
    hyprctl keyword monitor $MONITOR,1920x1080@60,2560x0,1,transform,0
    notify-send "显示器旋转" "BenQ已切换至横屏模式"
fi
