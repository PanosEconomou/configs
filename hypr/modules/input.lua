-- Mouse and Keyboard settings
local config    = hl.config
local gesture   = hl.gesture

config({
    input = {
        kb_layout           = "us",
        kb_variant          = "",
        kb_model            = "",
        kb_rules            = "",
        follow_mouse        = 1,
        sensitivity         = 0,            -- -1.0 - 1.0, 0 means no modification
        touchpad = {
            natural_scroll  = true
        }
    },
})

-- Move workspaces with 3 or 4 fingers 
gesture({
    fingers     = 3,
    direction   = "horizontal",
    action      = "workspace"
})

gesture({
    fingers     = 4,
    direction   = "horizontal",
    action      = "workspace"
})
