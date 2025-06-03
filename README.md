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
