-- Latex Support
return {
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})  -- activates S, ys, ds, cs globally
        end,
    },
    {
        "lervag/vimtex",
        ft              = { "tex" },
        config          = function()
            vim.g.tex_flavor                         = "latex"
            vim.g.vimtex_view_method                 = "zathura"
            vim.g.vimtex_quickfix_mode               = 0
            vim.g.vimtex_lint_chktex_ignore_warnings = "-n1 -n3 -n8 -n25 -n36"
            vim.g.vimtex_compiler_latexmk = {
                options     = {
                    "-shell-escape",
                    "-verbose",
                    "-file-line-error",
                    "-synctex=1",
                    "-interaction=nonstopmode",
                },
            }

            -- Create command to export the output file
            vim.api.nvim_create_user_command('VimtexExportPdf', function()
                local fname = vim.fn.expand('%:t:r')         -- current file name without extension
                local build_pdf = '.build/' .. fname .. '.pdf'
                local dest = vim.fn.expand('%:p:h') .. '/' .. fname .. '.pdf'

                if vim.fn.filereadable(build_pdf) == 1 then
                    vim.fn.system('cp ' .. vim.fn.shellescape(build_pdf) .. ' ' .. vim.fn.shellescape(dest))
                    vim.notify('Exported: ' .. fname .. '.pdf', vim.log.levels.INFO)
                else
                    vim.notify('PDF not found in .build/: ' .. build_pdf, vim.log.levels.ERROR)
                end
            end, {})

            -- VimTeX keymaps
            local map = vim.keymap.set
            map("n", "<localleader>lc","<cmd>VimtexStop<CR><Plug>(vimtex-clean-full)",  { noremap = false, desc = "VimTeX clean full" })
            map("n", "<localleader>lC","<cmd>VimtexStop<CR><Plug>(vimtex-clean)",       { noremap = false, desc = "VimTeX clean" })
            map("n", "<localleader>lp","<cmd>VimtexExportPdf<CR>",                      { noremap = false, desc = "VimTex export pdf" })

            -- Surround highlighted lines with new environemnt using nvim-surround
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "tex",
                callback = function()
                    require("nvim-surround").buffer_setup({
                        surrounds = {
                            ["e"] = {
                                add = function()
                                    local env = require("nvim-surround.config").get_input("Environment: ")
                                    if env then
                                        return {
                                            { "\\begin{" .. env .. "}" },
                                            { "\\end{" .. env .. "}" },
                                        }
                                    end
                                end,
                            },
                        },
                    })
                end,
            })
        end,
    },
}
