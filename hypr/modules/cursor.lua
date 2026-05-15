-- Add custom cursor
local env       = hl.env
local exec      = hl.exec_cmd
local defaults  = require("modules.defaults")


-- Set up the cursor via environment variables
env("HYPRCURSOR_THEME", defaults.cursorTheme)
env("HYPRCURSOR_SIZE",  defaults.cursorSize)

hl.on("hyprland.start", function()
    exec("hyprctl setcursor "..defaults.cursorTheme.." "..defaults.cursorSize)
end)
