-- Language Server Protocols ----------------------------------------------------------
-- It keeps track of recognizing syntax of various languages 

return {
    -- Show server status when buffering or soemthing
    {
        "j-hui/fidget.nvim",
        opts = {
            notification = {
                window = { winblend = 0 },
            },
        },
    },

    -- This is nvims default awesome language server manager
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            -- Mason automatically handles language support
            -- We will use it for everything except freaking julia
            require("mason").setup({
                ui = { border = "rounded" },
            })

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "bashls",
                    "clangd",
                    "html",
                    "cssls",
                    "texlab",
                },
                automatic_installation = true,
            })

            -- Add some nice keybinds 
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local map  = vim.keymap.set
                    local opts = { buffer = args.buf }

                    map("n", "gd",          vim.lsp.buf.definition,     opts)
                    map("n", "gi",          vim.lsp.buf.implementation, opts)
                    map("n", "gr",          vim.lsp.buf.references,     opts)
                    map("n", "K",           vim.lsp.buf.hover,          opts)
                    map("n", "<leader>rn",  vim.lsp.buf.rename,         opts)
                    map("n", "<leader>ca",  vim.lsp.buf.code_action,    opts)
                    map("n", "<leader>f",   vim.lsp.buf.format,         opts)
                    map("n", "<leader>e",   vim.diagnostic.open_float, opts)
                    map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts)
                    map("n", "]d", function() vim.diagnostic.jump({ count =  1 }) end, opts)
                end,
            })

            -- Some diagnostic information
            vim.diagnostic.config({
                virtual_text     = false,   -- no inline text
                signs            = true,    -- keep signcolumn icons
                underline        = true,
                update_in_insert = false,   -- don't update while typing
                float = {
                    border = "rounded",
                    source = true,          -- show which LSP is reporting
                },
            })

            -- Configurations of language servers
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library         = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                    },
                },
            })

            vim.lsp.config("julials", {
                cmd = {
                    "julia",
                    "--startup-file=no",
                    "--history-file=no",
                    "-e", "using LanguageServer; runserver()",
                },
            })


            vim.lsp.enable({
                "lua_ls",
                "pyright",
                "bashls",
                "clangd",
                "html",
                "cssls",
                "texlab",
                "julials",   -- manual, juliaup managed
            })
        end,
    },
}
