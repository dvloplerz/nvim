local M = {
    {

        "rose-pine/neovim",
        lazy = false,
        priority = 1000,
        name = "rose-pine",
        config = function()
            require("rose-pine").colorscheme("main")
            require("rose-pine").setup({
                variant = "main",
                dark_variant = "main",
                disable_background = true,
                disable_float_background = false,
                disable_italics = false,
                groups = {
                    background = "#141217",
                },
                highlight_groups = {
                    NormalFloat = { bg = "_experimental_nc", blend = 0 },
                    CursorlineNr = { fg = "love" },
                    TermCursor = { bg = "#dde5ed", blend = 100 },
                    TelescopeBorder = { fg = "none", bg = "none", blend = 0 },
                    TelescopeNormal = { bg = "overlay", blend = 0 },
                    TelescopePromptNormal = { bg = "base" },
                    TelescopeResultsNormal = { fg = "subtle", bg = "base" },
                    TelescopeSelection = { fg = "none", bg = "#0e0817" },
                    TelescopeSelectionCaret = { fg = "none", bg = "none" },
                    Pmenu = { bg = "nc", fg = 'none', blend = 0 },
                }
            })
            -- p.nc = "#0f002e"
            -- local p = require "rose-pine.palette"
            -- p.nc = "#141219"
            -- vim.api.nvim_set_hl(0, "Normal", { bg = p.nc, blend = 100 })
            -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = p.nc, blend = 100 })
            vim.cmd.colorscheme("rose-pine")
            vim.api.nvim_set_hl(0, "@lsp.type.comment", { bg = nil, fg = "#a6e3a1", italic = true })
        end,
    },
}

return M

-- [ chaos_theory ]
--bg-color: #141221; -> 141217
--main-color: #fd77d7;
--caret-color: #dde5ed;
--text-color: #dde5ed;
--error-color: #fd77d7;
--sub-color: #676e8a;
--sub-alt-color: #1e1d2f;
--error-color: #ff5869;
--error-extra-color: #b03c47;
--colorful-error-color: #ff5869;
--colorful-error-extra-color: #b03c47;
