-- ============================================================
-- BOOTSTRAP lazy.nvim
-- ============================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================
-- LEADERS — must be set before lazy loads plugins
-- ============================================================
vim.g.mapleader      = "\\"
vim.g.maplocalleader = ";"

-- ============================================================
-- SETTINGS
-- ============================================================
local opt = vim.opt

opt.number       = true
opt.shiftwidth   = 4
opt.tabstop      = 4
opt.incsearch    = true
opt.ignorecase   = true
opt.smartcase    = true
opt.showcmd      = true
opt.showmode     = true
opt.showmatch    = true
opt.hlsearch     = true
opt.history      = 1000
opt.wildmenu     = true
opt.wildmode     = { "longest", "list", "full" }
opt.wildignore   = { "*.docx", "*.jpg", "*.png", "*.gif", "*.pdf", "*.pyc", "*.exe", "*.flv", "*.img", "*.xlsx" }
opt.encoding     = "utf-8"
opt.backup       = false
opt.writebackup  = false
opt.updatetime   = 300
opt.signcolumn   = "yes"
opt.termguicolors = true
opt.cursorline   = true
opt.cursorcolumn = true
opt.laststatus   = 2
opt.undofile     = true
opt.undodir      = vim.fn.expand("~/.config/nvim/backup")
opt.undoreload   = 10000
opt.shortmess:append("c")

-- Hide scrollbars and menu 
opt.guioptions:remove({ "T", "L", "r", "m", "b" })

-- ============================================================
-- PLUGINS
-- ============================================================
require("lazy").setup({

	-- Colorscheme 
	{ "rakr/vim-one" },

	-- images
	{
		"3rd/image.nvim",
		build = false,
		opts = {
			processor = "magick_cli",
		}
	},

	-- Icons
	{ "nvim-tree/nvim-web-devicons", opts = {} },

	-- File explorer — NERDTree replacement, Neovim-native
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				filters = {
					custom = {
						"\\.git$", "\\.jpg$", "\\.mp4$", "\\.ogg$", "\\.iso$",
						"\\.pdf$", "\\.pyc$", "\\.odt$", "\\.png$", "\\.gif$", "\\.db$",
					},
				},
			})
		end,
	},

	-- Linting 
	{
		"dense-analysis/ale",
		config = function()
			vim.g.ale_linters = { tex = {} }  -- keep ALE off for tex, vimtex handles it
		end,
	},

	-- LSP completion 
	{ "neoclide/coc.nvim", branch = "release" },

	-- LaTeX editing
	{
		"lervag/vimtex",
		ft = { "tex" },   -- only load for tex files
		config = function()
			vim.g.tex_flavor                      = "latex"
			vim.g.vimtex_view_method              = "zathura_simple"
			vim.g.vimtex_view_zathura_use_xdotool = 0
			vim.g.vimtex_quickfix_mode            = 0
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
		end,
	},

	-- Snippet engine 
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		config = function()
			require("luasnip.loaders.from_lua").lazy_load({
				paths = { vim.fn.stdpath("config") .. "/snippets" }
			})
		end,
	},

	-- Markdown Rendering
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, 
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	}

}, {
	-- lazy.nvim options
	ui = { border = "rounded" },
})


-- ============================================================
-- COLORSCHEME + TRANSPARENCY
-- ============================================================
vim.cmd("colorscheme one")
vim.o.background = "dark"

local transparent = {
	"Normal", "NonText",  "Cursorline",
	"Cursorcolumn", "StatusLine", "StatusLineNC",
	"SignColumn",
}
for _, group in ipairs(transparent) do
	vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
end

-- ============================================================
-- STATUS LINE
-- ============================================================
opt.statusline = " %F %M %Y %R %= ascii: %b  hex: 0x%B  row: %l  col: %c  percent: %p%%"

-- ============================================================
-- KEYMAPS
-- ============================================================
local map = vim.keymap.set

-- Clear search highlight
map("n", "<leader>\\", ":nohlsearch<CR>")

-- Print file to default printer
map("n", "<leader>p", ":%w !lp<CR>", { silent = true })

-- Space → command mode
map("n", "<space>", ":")

-- Keep search results centered
map("n", "n", "nzz")
map("n", "N", "Nzz")

-- Yank to end of line
map("n", "Y", "y$")

-- Run current file with Python
map("n", "<F5>", ":w<CR>:!clear<CR>:!python3 %<CR>")

-- Split navigation
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")

-- Split resize with arrow keys
map("n", "<C-Up>",    "<C-w>+")
map("n", "<C-Down>",  "<C-w>-")
map("n", "<C-Left>",  "<C-w>>")
map("n", "<C-Right>", "<C-w><")

-- File explorer toggle
map("n", "<F3>", ":NvimTreeToggle<CR>")

-- VimTeX cleanup (noremap=false is required for <Plug> mappings)
map("n", "<localleader>lc", "<cmd>VimtexStop<CR><Plug>(vimtex-clean-full)", { noremap = false })
map("n", "<localleader>lC", "<cmd>VimtexStop<CR><Plug>(vimtex-clean)",      { noremap = false })

-- ============================================================
-- COC KEYMAPS
-- ============================================================
local function check_backspace()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

-- Tab: coc completion → real tab fallback
map("i", "<Tab>", function()
	if vim.fn["coc#pum#visible"]() == 1 then
		return vim.fn["coc#pum#next"](1)
	elseif check_backspace() then
		return "<Tab>"
	else
		return vim.fn["coc#refresh"]()
	end
end, { silent = true, expr = true })

map("i", "<S-Tab>", function()
	if vim.fn["coc#pum#visible"]() == 1 then
		return vim.fn["coc#pum#prev"](1)
	else
		return "<C-h>"
	end
end, { silent = true, expr = true })

-- CR: confirm coc selection or normal newline
map("i", "<CR>", function()
	if vim.fn["coc#pum#visible"]() == 1 then
		return vim.fn["coc#pum#confirm"]()
	else
		return "<C-g>u<CR><C-r>=coc#on_enter()<CR>"
	end
end, { silent = true, expr = true })

-- Trigger completion manually
map("i", "<C-Space>", "coc#refresh()", { silent = true, expr = true })

-- ============================================================
-- AUTOCOMMANDS
-- ============================================================
local augroup  = vim.api.nvim_create_augroup
local autocmd  = vim.api.nvim_create_autocmd

-- HTML: 2-space indent
autocmd("FileType", {
	pattern  = "html",
	callback = function()
		vim.opt_local.tabstop   = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.expandtab = true
	end,
})

-- Vim files: fold by marker
augroup("filetype_vim", { clear = true })
autocmd("FileType", {
	group    = "filetype_vim",
	pattern  = "vim",
	callback = function() vim.opt_local.foldmethod = "marker" end,
})

-- Cursorline/column only in active window
augroup("cursor_off", { clear = true })
autocmd("WinLeave", {
	group    = "cursor_off",
	callback = function()
		vim.opt_local.cursorline   = false
		vim.opt_local.cursorcolumn = false
	end,
})
autocmd("WinEnter", {
	group    = "cursor_off",
	callback = function()
		vim.opt_local.cursorline   = true
		vim.opt_local.cursorcolumn = true
	end,
})

-- ============================================================
-- CURSOR SHAPE (Kitty + Wayland)
-- ============================================================
opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
