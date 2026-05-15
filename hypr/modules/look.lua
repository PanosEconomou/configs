-- Customize the look and feel
local config = hl.config

config({
    general = {
        gaps_in             = 3,
        gaps_out            = 6,
        border_size         = 0,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(59595955)",
        },

        -- Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border    = false,

        -- See https://wiki.hyprland.org/Configuring/Tearing/ 
        allow_tearing       = false,
        layout              = "dwindle",
    },

    decoration = {
        -- Rounding
        rounding            = 10,
        rounding_power      = 2,

        -- Transparency
        active_opacity      = 1.0,
        inactive_opacity    = 0.95,
        dim_inactive        = true,
        dim_strength        = 0.01,

        -- Blur
        blur  = {
            enabled         = true,
            size            = 15,
            passes          = 3,
            vibrancy        = 0.1696,
        },

        -- Glow
        glow = {
            enabled         = false,
            range           = 5,
            render_power    = 3,
            color           = "rgba(3dd8ffaa)",
        }
    },
})
