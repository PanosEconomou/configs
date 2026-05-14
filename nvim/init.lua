-- THIS IS THE MASTER CONFIG FILE! ----------------------------
-- Load the options from the other directories ----------------

-- Editor Options
vim.g.mapleader         = "\\"
vim.g.maplocalleader    = ";"

require("config.options")

-- Key Remappings
require("config.keymaps")

-- Cute shortcuts and whatnot
require("config.autocmds")

-- Plugins
require("config.lazy")
