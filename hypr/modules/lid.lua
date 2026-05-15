-- Handle what happens to the display when the lid is closed
local internal = "eDP-1"
local kbd      = "dell::kbd_backlight"

-- Check for external monitors 
local function has_external_monitors()
    local monitors = hl.get_monitors()
    for _, m in ipairs(monitors) do
        if m.name ~= internal then
            return true
        end
    end
    return false
end

-- Turns off internal monitor 
local function disable_internal()
    hl.dispatch(hl.dsp.dpms({ action = "disable", monitor = internal }))
    hl.exec_cmd("brightnessctl -d " .. kbd .. " s 0%")
end

-- Turns on internal monitor 
local function enable_internal()
    hl.dispatch(hl.dsp.dpms({ action = "enable", monitor = internal }))
    hl.exec_cmd("brightnessctl -d " .. kbd .. " s 60%")
end

-- Lid closed
hl.bind("switch:on:Lid Switch", function()
    disable_internal()
    if not has_external_monitors() then
        hl.exec_cmd("loginctl lock-session")
    end
end)

-- Lid opened
hl.bind("switch:off:Lid Switch", function()
    enable_internal()
end)
