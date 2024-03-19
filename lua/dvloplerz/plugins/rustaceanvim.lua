return {
    "mrcjkb/rustaceanvim",
    lazy = false,
    version = "^4", -- Recommended
    ft = { 'rust' },
    dependencies = {
        {
            "rust-lang/rust.vim",
            ft = { 'rust' },
            config = function()
                vim.g.rustfmt_autosave = 1
            end,
        },
    },
    opts = {
        tools = {
            on_initialized = function()
                -- code
                local RustLs = vim.api.nvim_create_augroup("RustLsp", { clear = true })
                vim.api.nvim_create_autocmd("CursorHold", {
                    pattern = "*.rs",
                    callback = vim.lsp.buf.document_highlight,
                    group = RustLs
                })
                vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
                    pattern = "*.rs",
                    callback = vim.lsp.buf.clear_references,
                    group = RustLs
                })
                vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                    pattern = "*.rs",
                    callback = vim.lsp.codelens.refresh,
                    group = RustLs
                })
            end
        },
        server = {
            cmd = { "rustup", "run", "nightly", "rust-analyzer" },
            on_attach = function(_, bufnr)
                vim.keymap.set("n", "<leader>ca", function() vim.cmd.RustLsp("codeAction") end,
                    { desc = "Code Action", buffer = bufnr })
                vim.keymap.set("n", "K", function() vim.cmd.RustLsp({ "hover", "actions" }) end,
                    { desc = "Hover Action", buffer = bufnr })
            end,
            default_settings = {
                ["rust-analyzer"] = {
                    cargo = {
                        allFeatures = true,
                        loadOutDirsFromCheck = true,
                        runBuildScripts = true,
                    },
                    checkOnSave = {
                        allFeatures = true,
                        command = "clippy",
                        extraArgs = { "--no-deps" },
                    },
                    procMacro = {
                        enable = true,
                        ignored = {
                            ["async-trait"] = { "async_trait" },
                            ["napi-derive"] = { "napi" },
                            ["async-recursion"] = { "async_recursion" },
                        },
                    },
                    diagnostics = {
                        experimental = {
                            enable = true,
                            procAttrMacros = true
                        },
                    },
                    hover = {
                        actions = {
                            references = {
                                enable = true
                            },
                        },
                    },
                    imports = {
                        granularity = {
                            group = "module",
                        },
                        prefix = "self",
                    },
                    inlayHints = {
                        closingBraceHints = {
                            minLines = 5,
                        },
                    },
                    semanticHighlighting = {
                        punctuation = {
                            separate = {
                                macro = {
                                    bang = true,
                                },
                            },
                        },
                    },
                    typing = {
                        autoClosingAngleBrackets = {
                            enable = true
                        },
                    },
                },
            },
        },
    },
    config = function(_, opts)
        vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, opts or {})
    end,
}
