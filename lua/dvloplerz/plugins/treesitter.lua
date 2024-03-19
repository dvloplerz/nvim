return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
        ensure_installed = { 'lua', 'markdown', 'markdown_inline', 'vim', 'vimdoc', 'rust' },
        sync_install = true,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        modules = {
            textobjects = {
                enable = true,
                lookahead = true,
                lsp_interop = {
                    enable = true,
                    border = 'single',
                },
                move = { enable = true },
            },
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
