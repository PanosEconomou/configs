#!/bin/bash

LID_STATE=$(cat /proc/acpi/button/lid/LID0/state | awk '{print $2}')

# Replace eDP-1 with your laptop monitor name
MONITOR="eDP-1"

if [ "$LID_STATE" == "closed" ]; then
    hyprctl keyword monitor "$MONITOR, disable"
else
    hyprctl keyword monitor "$MONITOR, highres, 1920x0, 1"
fi

