#!/bin/bash

# PipeWire volume control with 100% hard cap
# Using wpctl (WirePlumber control)

case $1 in
    up)
        # Increase volume but cap at 1.0 (100%)
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
        ;;
    down)
        # Decrease volume
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        ;;
    mute)
        # Toggle mute
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
esac

# Get current volume percentage
current_vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')

# Show notification
#notify-send "Volume: ${current_vol}%"
