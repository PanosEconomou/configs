-- A set of default programs for keybinds etc.
-- Not to be confused with default mimeapps these could be different

local default = {}

default.mod             = "SUPER"
default.terminal        = "kitty"
default.fileManager     = "kitty -e nnn"
default.menu            = "pkill -USR1 wofi || wofi --show drun"
default.browser         = "qutebrowser"
default.altBrowser      = "firefox"
default.lock            = "hyprlock"
default.chat            = default.browser.." https://web.whatsapp.com/"
default.todo            = default.browser.." https://github.com/users/PanosEconomou/projects/3"
default.bar             = "pkill waybar || waybar"
default.printscreen     = 'grim -g "$(slurp -w 0)"'
default.latexclip       = "~/.config/hypr/scripts/latexclip.sh"
default.sunset          = require("scripts.sunset")
default.cursorTheme     = "Bibata-Modern-Ice"
default.cursorSize      = "24"

return default
