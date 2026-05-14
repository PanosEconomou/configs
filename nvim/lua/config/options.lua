-- EDITOR OPTIONS -----------------------------------------------
local opt = vim.opt

-- Line Numbers
opt.number          = true

-- Indentation
opt.shiftwidth      = 4
opt.tabstop         = 4
opt.expandtab       = true 

-- Search
opt.hlsearch        = true	-- Highlight search
opt.incsearch       = true	-- Highlight matchings as I type
opt.ignorecase      = true
opt.smartcase       = true

-- UI
opt.showcmd         = true
opt.cmdheight       = 0
opt.showmode        = false -- Status Line plugin handles it
opt.showmatch       = true	-- Highlight matching parentheses
opt.cursorline      = true
opt.cursorcolumn    = false	-- Do not highlight the column the cursor is in
opt.signcolumn      = "yes"	-- Shows errors or whatnot in a columnd at the side
opt.termguicolors   = true
opt.laststatus      = 2

-- Wild Menu (that tiny menu that pops up under for completions and stuff)
opt.wildmenu        = true
opt.wildmode        = { "longest", "list", "full" }
opt.wildignore      = { "*.docx", "*.jpg", "*.png", "*.gif", "*.pdf", "*.pyc", "*.exe", "*.flv", "*.img", "*.xlsx" }

-- Encoding
opt.encoding        = "utf-8"

-- Backup and Undo
opt.backup          = false
opt.writebackup     = false
opt.undofile        = true	-- Allows for undoing even after closing a file
opt.undodir         = vim.fn.stdpath("state") .. "/undo"
opt.undoreload      = 10000

-- Performance
opt.updatetime      = 300	-- ms
opt.history         = 1000

-- Messages (https://github.com/folke/noice.nvim/wiki/A-Guide-to-Messages#handling-hit-enter-messages)
opt.shortmess:append("c")

-- Folding (fold functions with za, zM, zR)
opt.foldmethod      = "expr"    -- This requires Treesitter plugin 
opt.foldexpr        = "nvim_treesitter#foldexpr()"
opt.foldlevel       = 99        -- Start with everything unfolded
opt.foldenable      = true
