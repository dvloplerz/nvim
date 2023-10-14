local M = {
    {
        "rust-lang/rust.vim",
        lazy = true,
        ft = "rs",
        init = function()
            vim.g.rustfmt_autosave = 1
        end,
    },

    {

        "simrat39/rust-tools.nvim",
        lazy = true,
        event = "BufEnter *.rs",
        ft = "rs",
        dependencies = {
            { "mfussenegger/nvim-dap" },
        },
    }
}

return M
