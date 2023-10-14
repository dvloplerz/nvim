local M = {
    {

        "tpope/vim-commentary",
        lazy = true,
        event = "BufReadPre",
        config = function()
            vim.keymap.set("n", "<leader>gc", function()
                vim.cmd(":Commentary")
            end, { silent = false, noremap = true })
        end
    },
}

return M
