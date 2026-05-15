-- Animation goodness
local config    = hl.config
local curve     = hl.curve
local animation = hl.animation

config({
    animations = {
        enabled     = true,
    }
})

-- Snappy ease-out for instant feel
curve("snap",    { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.0} } })
-- Quick deceleration for closing/fading
curve("snapOut", { type = "bezier", points = { {0.25, 1.0}, {0.5, 1.0} } })
-- Bouncy spring: snappy attack + gentle overshoot
curve("bounce", { type = "spring", mass = 1, stiffness = 100, dampening = 16 })
-- Softer spring for workspace transitions
curve("wsSoft", { type = "spring", mass = 1, stiffness = 90,  dampening = 16 })

-- Open: pops in with a lil bounce (popin = scale from center)
animation({ leaf = "windowsIn",   enabled = true, speed = 4, spring = "bounce", style = "popin 80%" })
-- Close: snaps out fast, no linger
animation({ leaf = "windowsOut",  enabled = true, speed = 2, bezier = "snapOut", style = "popin 80%" })
-- Move/resize: snappy, spring-settled
animation({ leaf = "windowsMove", enabled = true, speed = 3, spring = "bounce" })

-- Workspace switch: smooth slide with soft spring
animation({ leaf = "workspaces",        enabled = true, speed = 4, spring = "wsSoft", style = "slide" })
-- Special workspaces (scratchpad etc): slide down, bouncy
animation({ leaf = "specialWorkspace", enabled = true, speed = 4, spring = "bounce", style = "slidevert" })

-- Fade in/out: quick, not distracting
animation({ leaf = "fade",        enabled = true, speed = 3, bezier = "snap" })
animation({ leaf = "fadeOut",     enabled = true, speed = 2, bezier = "snapOut" })
-- Layers (bars, notifications): slide in from top
animation({ leaf = "layers",      enabled = true, speed = 3, spring = "bounce", style = "slide" })
-- Border: subtle animated glow angle
animation({ leaf = "fadeIn",     enabled = true, speed = 3, bezier = "snap" })
animation({ leaf = "fadeOut",    enabled = true, speed = 2, bezier = "snapOut" })
animation({ leaf = "fadeSwitch", enabled = true, speed = 2, bezier = "snap" })
animation({ leaf = "fadeDim",    enabled = true, speed = 3, bezier = "snap" })

-- Layers (bars, notifications): slide in with bounce
animation({ leaf = "layersIn",  enabled = true, speed = 3, spring = "bounce", style = "slide" })
animation({ leaf = "layersOut", enabled = true, speed = 2, bezier = "snapOut", style = "slide" })
