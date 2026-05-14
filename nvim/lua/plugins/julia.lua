-- Plugins for Julia
return {
    {
        "JuliaEditorSupport/julia-vim",
        lazy = false,
        init = function()
            vim.g.latex_to_unicode_auto = 1  -- auto convert \alpha → α etc.
        end,
    },
}
