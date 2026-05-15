-- Rules about how to handle certain kinds of windows.
local rule = hl.window_rule

rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Force Mathematica to not tile initially
rule({
    name            = "mathematica-float",
    match           = { title = "WolframNB" },
    float           = true,
    no_blur         = true,
    no_shadow       = true,
})

-- Make vscode transparent
rule({
    match           = { class = "code-oss" },
    opacity         = 0.92,
})

-- Make typora transparent
rule({
    match           = { class = "Typora" },
    opacity         = 0.9,
})

-- Don't allow things to be maximized
rule({
    name            = "suppress-maximize-events",
    match           = { class = ".*" },
    suppress_event  = "maximize",
})
