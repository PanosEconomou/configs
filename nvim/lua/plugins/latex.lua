-- Latex Support
return {
    {
        "lervag/vimtex",
        ft     = { "tex" },
        config = function()
            vim.g.tex_flavor                         = "latex"
            vim.g.vimtex_view_method                 = "zathura"
            vim.g.vimtex_quickfix_mode               = 0
            vim.g.vimtex_lint_chktex_ignore_warnings = "-n1 -n3 -n8 -n25 -n36"
            vim.g.vimtex_compiler_latexmk = {
                options = {
                    "-shell-escape",
                    "-verbose",
                    "-file-line-error",
                    "-synctex=1",
                    "-interaction=nonstopmode",
                },
            }

            -- VimTeX keymaps
            local map = vim.keymap.set
            map("n", "<localleader>lc",
                "<cmd>VimtexStop<CR><Plug>(vimtex-clean-full)",
                { noremap = false, desc = "VimTeX clean full" })
            map("n", "<localleader>lC",
                "<cmd>VimtexStop<CR><Plug>(vimtex-clean)",
                { noremap = false, desc = "VimTeX clean" })
        end,
    },
}
