-- Binds for hyprland
local bind          = hl.bind
local exec          = hl.dsp.exec_cmd
local focus         = hl.dsp.focus
local moveWindow    = hl.dsp.window.move
local define_submap = hl.define_submap
local submap        = hl.dsp.submap
local resize        = hl.dsp.window.resize

-- Some bind info is here: https://wiki.hypr.land/Configuring/Basics/Binds/
-- Load the commands that execute the default programs
local default = require("modules.defaults")

-- Set up the main modifier key
local mod   = default.mod

-- Keyboard Binds
bind(mod.." + RETURN",      exec(default.terminal))
bind(mod.." + B",           exec(default.browser))
bind(mod.." + SHIFT + B",   exec(default.altBrowser))
bind(mod.." + Q",           hl.dsp.window.close())
bind(mod.." + SHIFT + Q",   hl.dsp.window.kill())
bind(mod.." + SHIFT + R",   exec("hyprctl reload"))
bind(mod.." + Z",           exec(default.bar))
bind(mod.." + SHIFT + S",   exec(default.printscreen))
bind(mod.." + A",           exec(default.lock))
bind(mod.." + E",           exec(default.fileManager))
bind(mod.." + C",           exec(default.chat))
bind(mod.." + X",           exec(default.latexclip))
bind(mod.." + V",           hl.dsp.window.float({ action = "toggle" }))
bind(mod.." + SPACE",       exec(default.menu))
bind(mod.." + P",           hl.dsp.window.pseudo())
bind(mod.." + T",           exec(default.todo))
bind(mod.." + S",           default.sunset.toggle)

-- Media Buttons
local media = {
    { key = "XF86AudioNext",        cmd = "playerctl next" },
    { key = "XF86AudioPause",       cmd = "playerctl play-pause" },
    { key = "XF86AudioPlay",        cmd = "playerctl play-pause" },
    { key = "XF86AudioPrev",        cmd = "playerctl previous" },
}

for _, m in ipairs(media) do
    bind(m.key, exec(m.cmd), { locked = true })
end

-- Volume and brightness
local repeating = {
    { key = "XF86AudioRaiseVolume",  cmd = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+" },
    { key = "XF86AudioLowerVolume",  cmd = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" },
    { key = "XF86AudioMute",         cmd = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" },
    { key = "XF86AudioMicMute",      cmd = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" },
    { key = "XF86MonBrightnessUp",   cmd = "brightnessctl s 5%+" },
    { key = "XF86MonBrightnessDown", cmd = "brightnessctl s 5%-" },
}

for _, r in ipairs(repeating) do
    bind(r.key, exec(r.cmd), { locked = true, repeating = true })
end

-- Movement
local directions = {
    {key = "left",  vim = "H", dir = "l", x = -20, y =   0 },
    {key = "right", vim = "L", dir = "r", x =  20, y =   0 },
    {key = "up",    vim = "K", dir = "u", x =   0, y = -20 },
    {key = "down",  vim = "J", dir = "d", x =   0, y =  20 },
}

-- Move focus
for _, d in ipairs(directions) do
    bind(mod.." + "..d.key, focus({ direction = d.dir }))
    bind(mod.." + "..d.vim, focus({ direction = d.dir }))
end

-- Move windows around 
for _, d in ipairs(directions) do
    bind(mod.." + SHIFT + "..d.key, moveWindow({ direction = d.dir }))
    bind(mod.." + SHIFT + "..d.vim, moveWindow({ direction = d.dir }))
end

-- Move around workspaces
for i = 1, 10 do
    local key = tostring(i % 10)
    bind(mod.." + "..key,                   focus({ workspace = i }))
    bind(mod.." + SHIFT + "..key,           moveWindow({ workspace = i }))
    bind(mod.." + CONTROL + SHIFT + "..key, moveWindow({ workspace = i, follow = false}))
end

-- Resize mode 
-- Switch to a submap called `resize`.
bind(mod.." + R", submap("resize"))

-- Start a submap called "resize".
define_submap("resize", function()
    -- Resize using vim or regular arrows
    for _, d in ipairs(directions) do
        hl.bind(d.key, hl.dsp.window.resize({ x = d.x, y = d.y, relative = true }), { repeating = true })
        hl.bind(d.vim, hl.dsp.window.resize({ x = d.x, y = d.y, relative = true }), { repeating = true })
    end

    -- Use `reset` to go back to the global submap
    bind("escape",      submap("reset"))
    bind("return",      submap("reset"))
    bind("catchall",    submap("reset"))
end)

-- Keybinds further down will be global again...

-- Scroll through workspaces with mainMod + scroll
bind(mod .. " + mouse_down", focus({ workspace = "e+1" }))
bind(mod .. " + mouse_up",   focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
bind(mod .. " + mouse:272",         hl.dsp.window.drag(),   { mouse = true })
bind(mod .. " + SHIFT + mouse:272", resize(), { mouse = true })
bind(mod .. " + mouse:273",         resize(), { mouse = true })
