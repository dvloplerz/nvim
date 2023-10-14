local M = {
    "lukas-reineke/indent-blankline.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    main         = "ibl",
    event        = { "BufReadPost", "BufNewFile" },
    opts         = {
        config = {
        },
    },
    config       = function()
        require("ibl").setup({
            indent = {
                char = "▏",
            },
            scope = {
                enabled = true,
                injected_languages = true,
                show_start = false,
                show_end = false,
                highlight = { "Function", "Label" },
                exclude = {},
                include = {
                    node_type = {
                        lua = { "return_statement", "table_constructor" },
                    },
                },
            },
            whitespace = {
                remove_blankline_trail = false,
            },
        })
    end
}

return M;

--{
--"netrw",
--"help",
--"alpha",
--"dashboard",
--"neo-tree",
--"Trouble",
--"lazy",
--"mason",
--"notify",
--"toggleterm",
--"lazyterm",
--}
