-- Some Plugins for setting up the overall UI ---------------------------------------------
return {
    -- Icons
    {
        "echasnovski/mini.icons",
        lazy = true,
        opts = {
            style = "glyph",
        },
    },

    -- File Explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "echasnovski/mini.icons" },
        cmd          = "NvimTreeToggle",
        opts         = {
            filters = {
                custom = {
                    "\\.git$", "\\.jpg$", "\\.mp4$", "\\.ogg$", "\\.iso$",
                    "\\.pdf$", "\\.pyc$", "\\.odt$", "\\.png$", "\\.gif$", "\\.db$",
                },
            },
            renderer = {
                group_empty = true,
            },
            view = {
                width = 30,
            },
        },       
    },


    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "echasnovski/mini.icons" },
        opts         = {
            options     = {
                theme   = (function()
                    local theme = require("lualine.themes.tokyonight")
                    theme.normal.c.bg   = "NONE"
                    theme.insert.c      = { bg = "NONE" }
                    theme.visual.c      = { bg = "NONE" }
                    theme.replace.c     = { bg = "NONE" }
                    theme.command.c     = { bg = "NONE" }
                    return theme
                end)(),
                component_separators = { left = "|", right = "|" },
                section_separators   = { left = "",  right = ""  },
                globalstatus         = true,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location", "searchcount" },
            },
        },
    },

    -- Make the command promt pretty!
    { "MunifTanjim/nui.nvim", lazy = true },
    {
        "folke/noice.nvim",
        event        = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            cmdline = {
                view = "cmdline_popup",
                format = {
                    cmdline   = { icon = ":" },
                    search_down = { icon = "/ " },
                    search_up   = { icon = "? " },
                },
            },
            views = {
                cmdline_popup = {
                    position = {
                        row  = -2,    -- 2 lines from bottom, sits just above statusline
                        col  = "50%", -- centered horizontally
                    },
                    size = {
                        width  = 70,
                        height = "auto",
                    },
                    border = {
                        style   = "rounded",
                        padding = { 0, 1 },
                    },
                },
            },
            messages  = { enabled = true },
            popupmenu = { enabled = true },
            lsp = {
                -- let fidget handle lsp progress
                progress = { enabled = false },
            },
            routes = {
                {
                    filter = { event = "msg_show", kind = "search_count" },
                    opts   = { skip = true },
                },
            },
        },
    },
}
