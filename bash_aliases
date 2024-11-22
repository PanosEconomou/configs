# A collection of aliases
alias notes="cd ~/notes"
alias shelf="cd ~/shelf"
alias qmnotes="cd ~/qmnotes"
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
