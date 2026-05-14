-- KEYBINDS -------------------------------------------------------------
local map = vim.keymap.set

-- I asked claude to generate a tutorial for how to write these 
--
-- map(mode, lhs, rhs, opts)
--
-- mode: which vim mode(s) this applies to
--   "n" = normal
--   "i" = insert
--   "v" = visual
--   "x" = visual block
--   "t" = terminal
--   "c" = command
--   { "n", "v" } = multiple modes at once
--
-- lhs: the key(s) you press
-- rhs: what it does — a string command or a Lua function
--
-- opts: table of options, most common ones:
--   desc    = "description"  -- shows up in :map and which-key
--   silent  = true           -- don't echo the command to the statusline
--   noremap = true           -- don't allow recursive remapping (default true in vim.keymap.set)
--   buffer  = bufnr          -- only apply to a specific buffer (used in LSP)

-- General
map("n", "<space>", ":", { desc = "Command mode" })
map("n", "Y", "y$", { desc = "Yank until end of line" })
map("n", "<leader>\\", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting", silent = true })
map("n", "<leader>p", "<cmd>%w !lp<CR>", { desc = "Print File" })

-- Search
map("n", "n", "nzz", { desc = "Go to next result and center" })
map("n", "N", "Nzz", { desc = "Go to previous result and center" })

-- Clipboard
map({ "n", "v" }, "<localleader><localleader>", '"+y', { desc = "Yank to Clipboard" })
map({ "n", "v" }, "<localleader>y", '"+y', { desc = "Yank to Clipboard" })
map({ "n", "v" }, "<localleader>Y", '"+Y', { desc = "Yank remaining line to Clipboard" })
map({ "n", "v" }, "<localleader>yy", '"+yy', { desc = "Yank line to Clipboard" })
map({ "n", "v" }, "<localleader>p", '"+p', { desc = "Paste from clipboard after" })
map({ "n", "v" }, "<localleader>P", '"+P', { desc = "Paste from clipboard before" })
map({ "n", "v" }, "<localleader>d", '"+d', { desc = "Delete to clipboard" })
map({ "n", "v" }, "<localleader>dd", '"+d', { desc = "Delete line to clipboard" })
map({ "n", "v" }, "<localleader>D", '"+D', { desc = "Delete remaining line to clipboard" })

-- Split Navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Split Resizing 
map("n", "<C-Up>", "<C-w>+", { desc = "Increase split height" })
map("n", "<C-Down>", "<C-w>-", { desc = "Decrease split height" })
map("n", "<C-Left>", "<C-w>>", { desc = "Increase split width" })
map("n", "<C-Right>", "<C-w><", { desc = "Decrease split width" })

-- File Explorer
map("n", "<F3>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File Explorer", silent = true })

-- Smart File Runner
-- This script runs your files for you tehee
local runners = {
    python      = "python3",
    julia       = "julia",
    javascript  = "node",
    bash        = "bash",
    sh          = "bash",
}

map("n", "<F5>", function()
    local filetype  = vim.bo.filetype
    local runner    = runners[filetype]

    if runner then 
        vim.cmd("w")
        vim.cmd("!"..runner.." %")
    else
        vim.notify("No runner configured for filetype: "..filetype, vim.log.levels.WARN)
    end
end,
{ desc = "Run current file" })
