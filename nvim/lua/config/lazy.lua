-- Lazy vim setup -------------------------------------------------------------
-- This is the plugin manager

-- Bootstrap Lazyvim
local lazypath = vim.fn.stdpath("data").."/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then 
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Load Plugins
-- The "plugins" searches in lua/plugins for all the files automatically 
require("lazy").setup("plugins", {
    ui      = { border = "rounded" },
    checker = {
        enabled = true,     -- Check for plugins updates
        nodify  = false,    -- But don't tell me all the time
    }, 
})
