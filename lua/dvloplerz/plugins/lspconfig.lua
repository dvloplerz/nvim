return {
    {
        "folke/neodev.nvim",
        priority = 1000,
        ft = { "lua" },
        opts = {}
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            {
                "SmiteshP/nvim-navic",
                opts = {
                    highlight = true,
                },
            },
            { 'j-hui/fidget.nvim', opts = {} },
        },
        config = function()
            -- code
            local function fmt_save()
                vim.lsp.buf.format({ async = true })
            end
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(event)
                    local navic = require("nvim-navic")
                    local luasnip = require("luasnip")
                    local map = function(keys, func, desc)
                        -- code
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end
                    local imap = function(keys, func, desc)
                        -- code
                        vim.keymap.set({ 'i', 's' }, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end
                    local inmap = function(keys, func, desc)
                        -- code
                        vim.keymap.set({ 'i', 'n' }, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    inmap("<C-'>", vim.lsp.buf.code_action, '[C]ode Actions on insert.')
                    map('[d', vim.diagnostic.goto_next, 'Go to next diagnostic')
                    map(']d', vim.diagnostic.goto_prev, 'Go to prev diagnostic')
                    map('<leader>e', vim.diagnostic.open_float, 'Show Diagnostic [E]rror messages')
                    map('<leader>q', vim.diagnostic.setloclist, 'Open Diagnostics list')
                    map('gd', require("telescope.builtin").lsp_definitions, '[G]oto [D]efinition')
                    map('gr', require("telescope.builtin").lsp_references, '[G]oto [R]eferences')
                    map('gI', require("telescope.builtin").lsp_implementations, '[G]oto [I]mplementations')
                    map('<leader>D', require("telescope.builtin").lsp_type_definitions, 'Type [D]efinition')
                    map('<leader>ds', require("telescope.builtin").lsp_document_symbols, '[D]ocument [S]ymbols')
                    map('<leader>ws', require("telescope.builtin").lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('<leader>ca', function()
                            vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
                        end,
                        '[C]ode [A]ction')
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                    map('<leader>f', fmt_save, '[F]ormat code')
                    imap("<C-k>", function() if luasnip.expand_or_jumpable() then luasnip.expand_or_jump() end end,
                        "Expand snippet.")
                    imap("<C-j>", function() if luasnip.jumpable(-1) then luasnip.jump(-1) end end,
                        "LuaSnip jump back.")

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client.server_capabilities.documentSymbolProvider then
                        navic.attach(client, event.buf)
                    end

                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                    if client.supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint.enable(0, true)
                    end

                    vim.diagnostic.config {
                        underline = false,
                        virtual_text = {
                            spacing = 4,
                            source = true,
                            prefix = "●",
                        },
                        signs = true,
                        update_in_insert = true,
                        float = {
                            style = 'minimal',
                            border = 'none',
                            source = 'always',
                            header = '',
                            prefix = ''
                        }
                    }

                    vim.lsp.handlers["textDocument/diagnostic"] = vim.lsp.with(vim.lsp.diagnostic.on_diagnostic, {
                        underline = false,
                        virtual_text = {
                            spacing = 4,
                            source = true,
                            prefix = "●",
                        },
                        signs = true,
                        update_in_insert = true,
                        float = {
                            style = 'minimal',
                            border = 'single',
                            source = 'always',
                            header = '',
                            prefix = ''
                        },
                    })
                end
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require("cmp_nvim_lsp").default_capabilities())

            local servers = {
                rust_analyzer = {},
                taplo = {
                    keys = {
                        {
                            "K",
                            function()
                                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                                    require("crates").show_popup()
                                else
                                    vim.lsp.buf.hover()
                                end
                            end,
                            desc = "Show Crate Document",
                        },
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = {
                                version = 'LuaJIT',
                                fileEncoding = "utf8",
                                pathStrict = true,
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    '${3rd}/luv/library',
                                    unpack(vim.api.nvim_get_runtime_file('', true)),
                                    vim.fn.expand('$VIMRUNTIME/lua'),
                                    vim.fn.stdpath('config') .. '/lua',
                                },
                                ignoreDir = {
                                    "*undo*",
                                },
                            },
                            completion = {
                                enable = true,
                                callSnippet = "Replace",
                                displayContext = 1,
                            },
                            diagnostics = {
                                globals = { "vim" },
                            },
                        },
                    }
                }
            }

            require("mason").setup {}

            require("mason-lspconfig").setup {
                handlers = {
                    function(server_name)
                        -- code
                        require("neodev").setup {}
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                    ["rust_analyzer"] = function()
                        return true
                    end
                },
            }
        end,
    }
}
