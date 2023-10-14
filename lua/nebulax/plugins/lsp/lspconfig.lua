return {
    {
        "neovim/nvim-lspconfig", -- Required
        lazy = true,
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            {
                "folke/neoconf.nvim",
                event = { "LspAttach", "BufReadPre", "BufNewFile" },
                ft = "lua",
                lazy = true,
            },
            {
                "folke/neodev.nvim",
                lazy = true,
                opts = {},
            },
        },
        opts = {
            diagnostics = {
                underline = false,
                update_in_insert = true,
                virtual_text = {
                    spacing = 4,
                    source = true,
                    prefix = "●",
                },
                severity_sort = true,
            },
            inlay_hints = {
                enabled = true,
            },
            capabilities = {},
            autoformat = true,
            format_notify = true,
        },
        config = function()
            local lspconfig = require "lspconfig"
            local utils = require("nebulax.utils")
            local on_attach = utils.on_attach
            local handlings = utils.handlers
            local cmp_capabilities = require "cmp_nvim_lsp".default_capabilities()
            local capabilities = utils.capabilities

            -- vim.diagnostic.enable(0)
            vim.diagnostic.config({
                underline = false,
                virtual_text = true,
                update_in_insert = true,
                float = {
                    --source = true,
                    source = false,
                    focusable = false,
                    style = "minimal",
                    -- border = utils.borders.top_border,
                    border = "none",
                },
            })

            -- ⚡ ⊗ 🯀  󰙎 󰓧 
            --local sign = { Error = " ⊗", Warn = " ", Hint = "", Info = "󰙎" }
            local sign = { Error = "", Warn = "", Hint = "", Info = "󰙎" }
            for type, icon in pairs(sign) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            require("mason").setup({})
            local mlsp = require("mason-lspconfig").get_installed_servers()
            for _, sv in ipairs(mlsp) do
                lspconfig[sv].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    single_file_support = true,
                    settings = {}
                })
                -- Notify(sv .. " is setting up!", 'i')
            end

            require("mason-lspconfig").setup_handlers({
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        -- handlers = handlings,
                        single_file_support = true,
                        on_attach = on_attach,
                        capabilities = capabilities,
                    }
                end,
                ['neocmake'] = function()
                    lspconfig.neocmake.setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                        filetypes = { "make" },
                    })
                end,
                ['html'] = function()
                    lspconfig.html.setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
                ['gopls'] = function()
                    lspconfig.gopls.setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                        cmd = { "gopls" },
                        filetypes = { "go", "gomod", "gowork", "gotmpl" },
                        -- root_dir = vim.lsp.get_clients({ name = "gopls" })[1]['config']['root_dir']
                        settings = {
                            gopls = {
                                completeUnimported = true,
                                usePlaceholders = true,
                                analyses = {
                                    unusedparams = true,
                                },
                            },
                        },
                    })
                end,
                ['pylsp'] = function()
                    lspconfig.pylsp.setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                        cmd = { "pylsp" },
                        settings = {
                            pylsp = {
                                plugins = {
                                    pycodestyle = {
                                        ignore = { 'W391' },
                                        maxLineLength = 100

                                    },
                                },
                            },
                        },
                    })
                end,
                ['rust_analyzer'] = function()
                    local rt = require("rust-tools")
                    rt.setup({
                        tools = {
                            inlay_hints = {
                                auto = false,
                            },
                            hover_actions = {
                                border = nil,
                            },
                        },
                        server = {
                            cmd = { "rustup", "run", "nightly", "rust-analyzer" },
                            on_attach = function(client, bufnr)
                                require "nebulax.utils".on_attach(client, bufnr)
                                vim.keymap.set(
                                    "n",
                                    "K",
                                    function()
                                        require("rust-tools").hover_actions.hover_actions()
                                        -- Notify("Hover Action [RUST]", "w")
                                    end,
                                    { buffer = bufnr }
                                )
                                vim.keymap.set(
                                    "n",
                                    "<leader>ca",
                                    function()
                                        require("rust-tools").code_action_group.code_action_group()
                                        -- Notify("Code Action [RUST]", "w")
                                    end,
                                    { buffer = bufnr }
                                )
                            end,
                            capabilities = capabilities,
                            single_file_support = true,
                            settings = {
                                ["rust-analyzer"] = {
                                    imports = {
                                        granularity = {
                                            group = "crate",
                                            --group = "preserve",
                                        },
                                        prefix = "crate",
                                    },
                                    diagnostics = {
                                        enable = true,
                                        experimental = {
                                            enable = true,
                                        },
                                        previewRustcOutput = true,
                                    },
                                    completion = {
                                        autoimport = { enable = true },
                                        autoself = { enable = true },
                                        callable = {
                                            snippets = "fill_arguments",
                                        },
                                        fullFunctionSignatures = { enable = false },
                                        limit = 30,
                                    },
                                    check = {
                                        invocationLocation = "workspace",
                                        invocationStrategy = "per_workspace",
                                        command = "clippy",
                                        overrideCommand = "--message-format=json-diagnostic-rendered-ansi",
                                    },
                                    cargo = {
                                        allFeatures = nil,
                                        --allFeatures = true,
                                        buildScripts = {
                                            enable = true,
                                            overrideCommand = true,
                                            useRustcWrapper = true,
                                            invocationLocation = "workspace",
                                            invocationStrategy = "per_workspace",
                                        },
                                    },
                                    inlayHints = {
                                        bindingModeHints = { enable = false },
                                        chainingHints = { enable = true },
                                        closingBraceHints = {
                                            enable = true,
                                            minLines = 0,
                                        },
                                        closureCaptureHints = { enable = false },
                                        closureReturnTypeHints = { enable = "never" },
                                        closureStyle = "impl_fn",
                                        discriminantHints = { enable = "never" },
                                        expressionAdjustmentHints = {
                                            enable = "never",
                                        },
                                        lifetimeElisionHints = {
                                            enable = "never",
                                            useParameterNames = false,
                                        },
                                        parameterHints = { enable = true },
                                        reborrowHints = { enable = "never" },
                                        renderColons = true,
                                        typeHints = {
                                            enable = true,
                                            hideClosureInitialization = false,
                                            hideNamedConstructor = false,
                                        },
                                    },
                                    hover = {
                                        actions = {
                                            references = {
                                                enable = true,
                                            },
                                            run = {
                                                enable = true,
                                            },
                                        },
                                    },
                                    lens = {
                                        enable = true,
                                        debug = {
                                            enable = true,
                                        },
                                        forceCustomCommands = true,
                                        implementations = {
                                            enable = true,
                                        },
                                        location = "above_name",
                                        references = {
                                            adt = {
                                                enable = false,
                                            },
                                            enumVariant = {
                                                enable = true,
                                            },
                                            method = {
                                                enable = true,
                                            },
                                            trait = {
                                                enable = false,
                                            },
                                        },
                                        run = {
                                            enable = true,
                                        },
                                    },
                                    typing = {
                                        autoClosingAngleBrackets = { enable = true },
                                        continueCommentsOnNewline = false,
                                    },
                                    workspace = {
                                        symbol = {
                                            search = {
                                                kind = "only_types",
                                                scope = "all_symbols",
                                                limit = 128,
                                            },
                                        },
                                    },
                                    restartServerOnConfigChange = true,
                                    procMacro = {
                                        enable = true,
                                        attributes = {
                                            enable = true,
                                        },
                                    },
                                    rustfmt = {
                                        rangeFormatting = {
                                            enable = false,
                                        },
                                    },
                                    semanticHighlighting = {
                                        doc = {
                                            comment = {
                                                inject = {
                                                    enable = true,
                                                },
                                            },
                                        },
                                        nonStandardTokens = true,
                                        operator = {
                                            enable = true,
                                            specialization = {
                                                enable = true,
                                            },
                                        },
                                        punctuation = {
                                            enable = true,
                                            separate = {
                                                macro = {
                                                    bang = false,
                                                },
                                            },
                                            specialization = {
                                                enable = true,
                                            },
                                        },
                                        strings = {
                                            enable = false,
                                        },
                                    },
                                    signatureInfo = {
                                        detail = "full",
                                        documentation = {
                                            enable = true,
                                        },
                                    },
                                },
                            },
                        },
                    })
                end,
                ['tailwindcss'] = function()
                    lspconfig.tailwindcss.setup {
                        autostart = false,
                    }
                end,
                ['cssls'] = function()
                    lspconfig.cssls.setup({
                        cmd = { "/home/dvlp/.bun/bin/vscode-css-language-server", "--stdio" },
                        filetypes = { 'css', 'scss', 'less' },
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
                ["lua_ls"] = function()
                    local neodev = require("neodev")
                    neodev.setup({})

                    lspconfig.lua_ls.setup({
                        filetypes = { "lua" },
                        single_file_support = true,
                        on_attach = on_attach,
                        capabilities = capabilities,

                        settings = {
                            Lua = {
                                completion = {
                                    callSnippet = "Replace",
                                },
                                diagnostics = {
                                    globals = { "vim" },
                                },
                                hint = {
                                    enable = true,
                                },
                                runtime = {
                                    version = "LuaJIT",
                                },
                                semantic = {
                                    enable = true,
                                    keyword = true,
                                },
                                workspace = {
                                    library = { vim.env.VIMRUNTIME },
                                    checkThirdParty = false,
                                }
                            },
                        },
                    })
                end
            })
        end,
    }
}
