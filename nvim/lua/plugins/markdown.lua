-- Markdown Parsing
return {
    -- Rendering
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft           = { "markdown" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "echasnovski/mini.icons",
        },
        opts = {
            render_modes = { "n", "c" },
            heading = {
                sign    = false,   -- no signs in signcolumn for headings
                icons   = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
            },
            code = {
                sign        = false,
                width       = "block",
                border      = "rounded",
            },
            bullet = {
                icons = { "●", "○", "◆", "◇" },
            },
            latex = {
                enabled  = true,
                render_environments = true,  -- render \begin{equation} blocks too
                converter = "latex",         -- use latex + dvisvgm pipeline
            },
        },
    },

    -- Images
    {
        "3rd/image.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "echasnovski/mini.icons",
            "3rd/image.nvim",
        },
        ft    = { "markdown" },
        build = false,
        opts  = {
            processor                   = "magick_cli",
            only_render_image_at_cursor = true,
            hijack_file_patterns        = { "*.png", "*.jpg", "*.gif", "*.webp" },
        },
    },
}
