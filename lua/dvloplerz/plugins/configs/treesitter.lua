vim.defer_fn(function()
    require("nvim-treesitter.configs").setup {
        auto_install = true,
        ensure_installed = { "rust", "lua", "toml", "html", "bash", "vim", "markdown", "markdown_inline", "go", "query" },
        ignore_install = {},
        sync_install = true,
        modules = {},
        highlight = { enable = true, },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<c-space>",
                node_incremental = "<c-space>",
                scope_incremental = "<c-s>",
                node_decremental = "<M-space>",
            },
        },
        textobjects = {
            enable = true,
            lookahead = true,
        },
    }
end, 0)
