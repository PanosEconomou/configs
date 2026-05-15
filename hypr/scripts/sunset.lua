-- Trigger sunset if needed 
local sunset    = false
local dispatch  = hl.dispatch
local exec      = hl.dsp.exec_cmd

local function toggle()
    if sunset then
        dispatch(exec("hyprctl hyprsunset temperature 6000"))
    else
        dispatch(exec("hyprctl hyprsunset temperature 4000"))
    end
    sunset = not sunset
end

return { toggle = toggle }
