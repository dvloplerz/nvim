local M = {
    "folke/zen-mode.nvim",
    lazy = true,
    opts = {},
    config = function()
        local width = vim.api.nvim_win_get_width(0) * (100 - 40) / 100

        vim.keymap.set("n", "<leader>zz", function()
            require("zen-mode").setup {
                window = {
                    backdrop = 0,
                    width = width,
                    options = {
                        signcolumn = "yes",
                        number = true,
                        relativenumber = true,
                        cursorline = true,
                        foldcolumn = "0",
                    },
                },
                plugins = {
                    options = {
                        enabled = true,
                        ruler = true,
                        showcmd = true,
                    },

                    gitsigns = {
                        enabled = true,
                    },

                    alacritty = {
                        enabled = true,
                        font = "14",
                    },
                },
            }
            require("zen-mode").toggle()
            vim.wo.wrap = false
            vim.wo.number = true
            vim.wo.rnu = true
        end)
    end
}

return M
