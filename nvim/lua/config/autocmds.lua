-- Autocmds ---------------------------------------------------------------------
-- These are commands that are executed when you read or write a file 
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Filetype specific Indentations
local indent = augroup("filetype_indent", { clear = true })

autocmd("FileType", {
    group       = indent,
    pattern     = { "html", "css", "javascript", "json", "yaml", "tex" },
    callback    = function()
        vim.opt_local.tabstop       = 2
        vim.opt_local.shiftwidth    = 2
        vim.opt_local.softtabstop   = 2
        vim.opt_local.expandtab     = true
    end
})

autocmd("FileType", {
    group       = indent,
    pattern     = { "python", "c", "cpp", "julia" },
    callback    = function()
        vim.opt_local.tabstop       = 4
        vim.opt_local.shiftwidth    = 4
        vim.opt_local.softtabstop   = 4
        vim.opt_local.expandtab     = true
    end
})

-- Hide the cursor if you're not in this window
local cursor_off = augroup("cursor_off", { clear = true })

autocmd("WinLeave", {
    group       = cursor_off,
    callback    = function()
        vim.opt_local.cursorline = false
    end,
})

autocmd("WinEnter", {
    group       = cursor_off,
    callback    = function()
        vim.opt_local.cursorline = true 
    end,
})


-- Highlight when you yank some text
local yank_highlight = augroup("yank_highlight", { clear = true })

autocmd("TextYankPost", {
    group       = yank_highlight,
    callback    = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
})

