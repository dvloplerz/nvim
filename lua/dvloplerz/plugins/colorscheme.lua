return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
        variant = 'main',
        dark_variant = "main",
        disable_background = false,
        dim_inactive_windows = false,
        extend_background_behind_border = false,
        groups = {
            background = "#0c0b0e",
            background_nc = "#0c0b0e",
        },
        styles = {
            bold = true,
            italic = true,
            transparency = true,
        },
        highlight_groups = {
            --[ rose-pine Telescope ]--
            TelescopeBorder = { fg = "highlight_high", bg = "none" },
            TelescopeNormal = { bg = "none" },
            TelescopePrompt = { bg = "none" },
            TelescopePromptNormal = { bg = "none" },
            TelescopePromptBorder = { bg = "none" },
            TelescopeResultsNormal = { fg = "subtle", bg = "none" },
            TelescopeSelection = { fg = "text", bg = "none" },
            TelescopeSelectionCaret = { fg = "rose", bg = "rose" },

            --[ Custom ]--
            Directory = { fg = "love" },
            CursorLineNr = { fg = "love" },
            MsgArea = { fg = "gold" },
            FloatBorder = { fg = "pine" },
            QuickFixLine = { fg = "rose" },
            Visual = { bg = "pine", blend = 20 },
        },
        before_highlight = function(group, highlight, palette)
            if highlight.undercurls then
                highlight.undercurls = false
            end
        end,
    },
    config = function(things, opts)
        require("rose-pine").setup(opts)
        vim.cmd.colorscheme("rose-pine")
    end,
}
