# Padots

These are some dotfiles for my local Hyprland installation

## To install

To install make sure you have cloned this repo in ``~/.config`` and once there do

```
cd ~/.config
pacman -S --needed - < pkglist.txt
```

This will install the necessary packages. I think then if you do ``reboot`` things will start working.

## Manual Installation

Let's assuem that you have started in a minimal installation of arch and are running on a TTY. Let's set up Hyprland.

On arch do
```
pacman -S hyprland
```

This will hopefully install Hyprland. It can be launched by
```
Hyprland
``` 

If this repo is cloned in the right place some of the customization should work out of the box. Time to make a setup script.


Fonts: Here are some [Nerd Fonts](https://www.nerdfonts.com/font-downloads)

## Common issues

Here are a couple of things that I needed to figure out about arch multiple times over so it's nice to have a list.

Often electron apps like Vivaldi, Typora, and so on, would randomly crash for no reason citing a vague gpu misconfig. I think this is because the combo electron+Hyprland is sad, and Hyprland doesn't let electron know which drivers to use sometimes for some reason. Setting this global configuration in ``/etc/environment`` actually helped
```
# Enable Wayland for Chromium/Electron
NATIVE_WAYLAND=1
OZONE_PLATFORM=wayland
ELECTRON_OZONE_PLATFORM_HINT=wayland
QT_QPA_PLATFORM=wayland
SDL_VIDEODRIVER=wayland
LIBVA_DRIVER_NAME=i965
```
