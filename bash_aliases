# A collection of aliases
alias notes="cd ~/notes"
alias shelf="cd ~/shelf"
alias confs="cd ~/.config"
alias battery="upower -i $(upower -e | grep -i BAT) | grep --color=never -E 'state|to full|to empty|percentage'"
alias bat="battery"
alias printers="xdg-open http://localhost:631/"
# A collection of functions that act as aliases
function t() {
	typora --enable-features=UseOzonePlatform --ozone-platform=wayland "$@" &
	disown
}

function o() {
	xdg-open "$@" &
	disown
}


function open() {
	xdg-open "$@" &
	disown
}

function kbdlight() {
	local btn=${1:-$(if [[ $(brightnessctl -d kbd_backlight get) -eq 0 ]]; then echo 50; else echo 0; fi)}	
	brightnessctl -d kbd_backlight set "$btn"%
}

low() {
  for file in "$@"; do
    # Skip if it's a directory
    [ -f "$file" ] || continue
    # Generate the new filename
    new_name=$(echo "$file" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
    # Rename the file
    mv "$file" "$new_name"
  done
}
