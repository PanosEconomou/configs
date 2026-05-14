-- This is a very commonly used plugin that takes code and builds a syntax tree for easy parsing
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build   = ":TSUpdate",                        -- update parsers when plugin updates
        config  = function()
            require("nvim-treesitter.config").setup({
                -- Prarses 
                ensure_installed = {
                    -- Programming Languates
                    "c", "cpp", "python", "julia", "javascript", "typescript",

                    -- Scripting
                    "bash", "lua",

                    -- Data
                    "json", "yaml", "toml",

                    -- Web
                    "html", "css",

                    -- Docs
                    "markdown", "markdown_inline", "latex",

                    -- Nvim
                    "vim", "vimdoc",
                },

                highlight = {
                    enable  = true,
                    additional_vim_regex_highlighting = { "latex" },
                    -- latex needs both treesitter and vim regex
                    -- because vimtex relies on the vim regex highlighting
                },
                
                indent = {
                    enable = true,
                },

                incremental_selection = {
                    enable  = true,
                    keymaps = {
                        init_selection      = "<CR>",   -- start selection
                        node_incremental    = "<CR>",   -- expand to next node
                        node_decremental    = "<BS>",   -- shrink selection
                        scope_incremental   = "<TAB>",  -- expand to scope
                    },
                },
            })
        end
    },
}
