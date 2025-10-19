# A collection of aliases
alias notes="cd ~/notes"
alias shelf="cd ~/shelf"
alias confs="cd ~/.config"
alias proj="cd ~/projects"
alias tri="cd /home/pano/projects/tricritical-ising"
alias tnotes="cd /home/pano/projects/thermo-notes"
alias tasks="xdg-open 'https://github.com/users/PanosEconomou/projects/3'"

alias rebash="source ~/.bashrc"
alias battery="upower -i $(upower -e | grep -i BAT) | grep --color=never -E 'state|to full|to empty|percentage'"
alias clip="wl-copy"
alias bat="battery"
alias printers="xdg-open http://localhost:631/"
alias la="ls -la"
alias code="/usr/bin/code --enable-proposed-api ms-toolsai.jupyter"
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

function manimation() {
	cd ~/projects/manimation;
	source ./bin/activate
}
