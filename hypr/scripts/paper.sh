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

# Clear the config file and write new configuration
echo "preload = $IMAGE_PATH" > $CONFIG_FILE
echo "wallpaper = ,$IMAGE_PATH" >> $CONFIG_FILE

# Preload the image (optional if the config file is used directly)
hyprctl hyprpaper preload "$IMAGE_PATH"

# Set the image as the wallpaper (optional if the config file is used directly)
hyprctl hyprpaper wallpaper ",$IMAGE_PATH"

# Restart hyprpaper
pkill hyprpaper
hyprpaper & disown

echo "Wallpaper set to $1 and configuration updated in hyprpaper.conf"
