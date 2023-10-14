return {
    { "nvim-lua/plenary.nvim",       lazy = true },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    { "MunifTanjim/nui.nvim",        lazy = true },
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        dependencies = {
            "neovim/nvim-lspconfig"
        },
        config = function()
            local navic = require("nvim-navic")
            navic.setup({
                highlight = true,

            })
        end,
    },
    {
        "folke/lazy.nvim",
        version = false,
        lazy = true,
    },
    {
        name = "tabby",
        dir = os.getenv("XDG_CONFIG_HOME") .. "nvim/tabby/clients/vim",
        enabled = true,
        config = function()
            vim.g.tabby_server_url = "http://127.0.0.1:8080"
        end
    }
}
