-- Some plugins that make the editing experience better for everything
return {
    -- Auto Pair parentheses
    {
        "echasnovski/mini.pairs",
        event = "InsertEnter",   -- only load when you enter insert mode
        opts  = {},
    },

    -- Add comments automatically
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        opts  = {},   -- gcc to comment line, gc{motion} for range
    },


}
