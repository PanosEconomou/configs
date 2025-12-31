#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Please provide an image name."
    exit 1
fi

# Image path
IMAGE_PATH="$(realpath $1)"

# Config file path
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"
LOCK_FILE="$HOME/.config/hypr/hyprlock.conf"
SDDM_THEME="/usr/share/sddm/themes/sddm-astronaut-theme/Backgrounds"

# Clear the config file and write new configuration
sed -i "s/\(path[[:space:]]*=[[:space:]]*\).*/\1$(printf '%s' "$IMAGE_PATH" | sed 's/[&/\]/\\&/g')/" $CONFIG_FILE

# Set the image as the wallpaper (optional if the config file is used directly)
hyprctl hyprpaper wallpaper ", $IMAGE_PATH, cover"

# Set up Hyprlock to have the same background
sed -i "0,/path/s/.*path.*/\t$(printf '%s' "path=$IMAGE_PATH" | sed 's/[&/\]/\\&/g')/"  $LOCK_FILE

# Set up SDDM to have the same background
sudo cp $IMAGE_PATH "$SDDM_THEME/1.png"

echo "Wallpaper set to $1 and configuration updated in hyprpaper.conf, sddm, and hyprlock.conf"
