-- Completion for code and text  
return {
    {
        "saghen/blink.cmp",
        version = "1.*",
        dependences = {
            -- snippets
            "rafmadriz/friendly-snippets",
        },
        opts = {
            keymap = {
                preset = "default",
                -- confirm completion
                ["<CR>"]  = { "accept", "fallback" },
                -- navigate completion menu
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                -- scroll docs
                ["<C-d>"] = { "scroll_documentation_down", "fallback" },
                ["<C-u>"] = { "scroll_documentation_up", "fallback" },
                -- dismiss
                ["<C-e>"] = { "hide", "fallback" },
            },
            appearance = {
                use_nvim_cmp_as_default = false,
                nerd_font_variant       = "mono",
            },

            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },

            completion = {
                documentation = {
                    auto_show       = true,
                    auto_show_delay_ms = 200,
                    window = {
                        border = "rounded",
                    },
                },
                menu = {
                    border = "rounded",
                    draw   = {
                        columns = {
                            { "label",     "label_description", gap = 1 },
                            { "kind_icon", "kind" },
                        },
                    },
                },
            },

            -- show signature help while typing function args
            signature = {
                enabled = true,
                window  = { border = "rounded" },
            },
        },
    },
}
