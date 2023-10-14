local M = {
    {
        "williamboman/mason.nvim", -- Optional
        lazy = true,
        events = "LspAttach",
        opts = {
            ensure_installed = {
                "gopls",
                "rust_analyzer",
                "lua_ls",
                "python-lsp-server",
                "taplo",
            }
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
    }, -- Optional
}

return M
