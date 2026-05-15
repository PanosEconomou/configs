-- Monitor and display config
local monitor = hl.monitor

-- Set up primary display
monitor({
    output      = "eDP-1",
    mode        = "preferred",
    position    = "0x0",
    scale       = 1,
})

monitor({
    output      = "DP-1",
    mode        = "highres",
    position    = "0x-1080",
    scale       = 1,
})


monitor({
    output      = "",
    mode        = "highres",
    position    = "auto",
    scale       = 1,
})
