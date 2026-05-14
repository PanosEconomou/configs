-- Setting up the colorscheme

return {
    "folke/tokyonight.nvim",
    lazy        = false,        -- Load at startup
    priority    = 1000,         -- And before everything else 
    opts        = {
        style       = "night",  -- night, storm, day, moon
        transparent = true,
        styles      = {
            sidebars    = "transparent",
            floats      = "transparent",
        },
        on_highlights = function(hl, c)
            hl.StatusLine   = { bg = "NONE", fg = c.fg }
            hl.StatusLineNC = { bg = "NONE", fg = c.comment }
            hl.CursorLine   = { bg = "NONE" }
        end
    },
    config      = function(_, opts)
        require("tokyonight").setup(opts)
        vim.cmd("colorscheme tokyonight")
    end,
}
