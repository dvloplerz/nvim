return {
    {
        'VonHeikemen/lsp-zero.nvim',
        lazy = true,
        event = { "BufEnter", "InsertEnter" },
        branch = 'v3.x',
        dependencies = {
            {
                'williamboman/mason.nvim',
                lazy = false,
                config = true,
                dependencies = {
                    { 'williamboman/mason-lspconfig.nvim', lazy = true }
                }
            },
            {
                'neovim/nvim-lspconfig',
                lazy = true,
                cmd = { "LspInfo", "LspInstall", "LspStart" },
                event = { "BufReadPre", "BufNewFile" },
                dependencies = {
                    {
                        "hrsh7th/nvim-cmp",
                        lazy = true,
                        event = { "BufReadPre", "BufEnter" },
                        opts = function(_, opts)
                            require("luasnip.loaders.from_vscode").lazy_load()
                            local luasnip = require("luasnip")

                            opts.snippet = {
                                expand = function(args)
                                    luasnip.lsp_expand(args.body)
                                end
                            }

                            opts.sources = opts.sources or {}
                            table.insert(opts.sources, { name = "nvim_lsp" })
                            table.insert(opts.sources,
                                { name = "luasnip", option = { show_autosnippets = true } })
                            table.insert(opts.sources, { { name = "path", keyword_length = 2 } })
                            table.insert(opts.sources, { { name = "buffer", keyword_length = 2 } })
                            table.insert(opts.sources, { { name = "crates" } })
                        end,
                        dependencies = {
                            {
                                "L3MON4D3/LuaSnip",
                                lazy = true,
                                build = (function()
                                    return "make install_jsregexp"
                                end)(),
                            },
                            "saadparwaiz1/cmp_luasnip",
                            "hrsh7th/cmp-nvim-lsp",
                            "hrsh7th/cmp-path",
                            "hrsh7th/cmp-buffer",

                            'hrsh7th/cmp-nvim-lua',
                            "rafamadriz/friendly-snippets",
                        },
                    },
                },
            },
        },
    },
    { "mfussenegger/nvim-dap" },
    { "nvim-lua/plenary.nvim", lazy = true },
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        config = function()
            require("nvim-web-devicons").setup({})
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = true,
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            {
                "nvim-treesitter/nvim-treesitter-context",
                lazy = true,
                config = function()
                    require("treesitter-context").setup({
                        enable = true,
                        max_lines = 3,
                    })
                    vim.keymap.set("n", "[c", function()
                        require("treesitter-context").go_to_context(vim.v.count1)
                    end, { silent = true })
                end,
                opts = {
                    mode = "cursor",
                    max_lines = 3,
                },
            },
        },
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            highlight = { enable = true },
            indent = { enable = true },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = "make",
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
                config = function()
                    require('telescope').load_extension('fzf')
                    require('telescope').setup {
                        extensions = {
                            fzf = {
                                fuzzy = true,                   -- false will only do exact matching
                                override_generic_sorter = true, -- override the generic sorter
                                override_file_sorter = true,    -- override the file sorter
                                case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                            }
                        }
                    }
                end
            },
        },
        config = function()
            local actions = require('telescope.actions')
            require('telescope').setup({
                defaults = {
                    file_ignore_patterns = { "target/" },
                    layout_strategy = 'vertical',
                    layout_config = {
                        prompt_position = 'top',
                        width = 90,
                        height = 90,
                    },
                    border = {},
                },
                pickers = {
                    find_files = {
                        layout_config = {
                            prompt_position = 'bottom',
                            width = 70,
                            height = 10,
                        },
                        previewer = false,
                        initial_mode = "normal",
                        mappings = {
                            i = {
                                ["<C-n>"] = {
                                    actions.move_selection_next,
                                    type = "action",
                                    opts = { nowait = true, silent = true }
                                },
                                ["<C-p>"] = {
                                    actions.move_selection_previous,
                                    type = "action",
                                    opts = { nowait = true, silent = true }
                                },
                                ["<C-c>"] = {
                                    actions.close,
                                    type = "action",
                                    opts = { nowait = true, silent = true }
                                },
                            },
                            n = {
                                ["<C-c>"] = {
                                    actions.close,
                                    type = "action",
                                    opts = { nowait = true, silent = true }
                                },
                            },
                        },
                    },
                },
            })
            local nmap = function(lhs, rhs, opts)
                vim.keymap.set('n', lhs, rhs, opts)
            end

            local builtin = require('telescope.builtin')
            nmap('<leader>pf', function()
                if vim.lsp.get_clients({ bufnr = 0 })[1] == nil then
                    builtin.find_files { cwd = require("telescope.utils").buffer_dir() }
                    return
                else
                    builtin.find_files { cwd = vim.lsp.get_clients()[1]["config"]['root_dir'] }
                end
            end, { noremap = true, silent = false })
            nmap('<leader>bl', builtin.buffers, { noremap = false, silent = true })
            nmap('<leader>H', builtin.help_tags, { noremap = false, silent = true })
            nmap('<leader>?', builtin.oldfiles, { noremap = false, silent = true })
            nmap('<leader>qf', builtin.quickfix, { noremap = false, silent = true })
            nmap('<leader>[d', builtin.diagnostics, { noremap = true, silent = true })
        end,
    },
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        dependencies = {
            { "neovim/nvim-lspconfig" },
        },
        config = function()
            local navic = require("nvim-navic")
            navic.setup({
                highlight = true,
            })
        end,
    },
    {
        "rust-lang/rust.vim",
        lazy = true,
        config = function()
            vim.g.rustfmt_autosave = 1
        end
    },
    {
        "mrcjkb/rustaceanvim",
        lazy = true,
        version = "^4", -- Recommended
        ft = { "rust" },
        dependencies = {
            {
                "saecki/crates.nvim",
                tag = "stable",
                event = { "BufRead Cargo.toml" },
                dependencies = { "nvim-lua/plenary.nvim" },
                config = function()
                    require("crates").setup()
                end,
                opts = {
                    src = {
                        cmp = { enabled = true },
                    },
                },
            },
        },
    },
    {
        "folke/neodev.nvim",
        event = { "BufEnter *.lua" },
        ft = { "lua" },
        lazy = false,
    },
    {

        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        opts = {
            styles = {
                bold = true,
                italic = true,
                transparency = true,
            },
            before_highlight = function(group, highlight, palette)
                if highlight.undercurls then
                    highlight.undercurls = false
                end
            end,
        },
        config = function()
            -- require("rose-pine").setup({
            --variant = "main",
            --dark_variant = "main",
            --disable_background = true,
            --dim_inactive_windows = true,
            --extend_background_behind_border = true,

            -- styles = {
            --     bold = true,
            --     italic = true,
            --     transparency = true,
            -- },

            --groups = {
            --	background = "#141217",
            --	background_nc = "#141217",
            --	-- background = "none"
            --},
            --highlight_groups = {
            --	--[ rose-pine Telescope ]--
            --	TelescopeBorder = { fg = "highlight_high", bg = "none" },
            --	TelescopeNormal = { bg = "none" },
            --	TelescopePromptNormal = { bg = "base" },
            --	TelescopeResultsNormal = { fg = "subtle", bg = "none" },
            --	TelescopeSelection = { fg = "text", bg = "base" },
            --	TelescopeSelectionCaret = { fg = "rose", bg = "rose" },

            --	NormalFloat = { bg = "#141217", blend = 0 },
            --	CursorlineNr = { fg = "love" },
            --	-- TermCursor = { bg = "#dde5ed", blend = 100 },

            --	-- Pmenu = { bg = "nc", fg = 'none', blend = 0 },
            --},

            -- before_highlight = function(group, highlight, palette)
            --     if highlight.undercurls then
            --         highlight.undercurls = false
            --     end
            -- end,
            -- })
            vim.cmd.colorscheme("rose-pine")
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        event = "ColorScheme",
        dependencies = {
            {
                "nvim-tree/nvim-web-devicons",
                lazy = true,
                opts = true,
            },
        },
        config = function()
            -- Eviline config for lualine
            -- Author: shadmansaleh
            -- Credit: glepnir
            local lualine = require("lualine")

            -- Color table for highlights
            -- stylua: ignore
            local colors = {
                bg       = '#202328',
                fg       = '#bbc2cf',
                yellow   = '#ECBE7B',
                cyan     = '#008080',
                darkblue = '#081633',
                green    = '#98be65',
                orange   = '#FF8800',
                violet   = '#a9a1e1',
                magenta  = '#c678dd',
                blue     = '#51afef',
                red      = '#ec5f67',
            }

            local conditions = {
                buffer_not_empty = function()
                    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
                end,
                hide_in_width = function()
                    return vim.fn.winwidth(0) > 80
                end,
                check_git_workspace = function()
                    local filepath = vim.fn.expand("%:p:h")
                    local gitdir = vim.fn.finddir(".git", filepath .. ";")
                    return gitdir and #gitdir > 0 and #gitdir < #filepath
                end,
            }

            -- Config
            local config = {
                options = {
                    -- Disable sections and component separators
                    component_separators = "",
                    section_separators = "",
                    theme = {
                        -- We are going to use lualine_c an lualine_x as left and
                        -- right section. Both are highlighted by c theme .  So we
                        -- are just setting default looks o statusline
                        normal = { c = { fg = colors.fg, bg = colors.bg } },
                        inactive = { c = { fg = colors.fg, bg = colors.bg } },
                    },
                },
                sections = {
                    -- these are to remove the defaults
                    lualine_a = {},
                    lualine_b = {},
                    lualine_y = {},
                    lualine_z = {},
                    -- These will be filled later
                    lualine_c = {},
                    lualine_x = {},
                },
                inactive_sections = {
                    -- these are to remove the defaults
                    lualine_a = {},
                    lualine_b = {},
                    lualine_y = {},
                    lualine_z = {},
                    lualine_c = {},
                    lualine_x = {},
                },
            }

            -- Inserts a component in lualine_c at left section
            local function ins_left(component)
                table.insert(config.sections.lualine_c, component)
            end

            -- Inserts a component in lualine_x at right section
            local function ins_right(component)
                table.insert(config.sections.lualine_x, component)
            end

            ins_left({
                function()
                    return "▊"
                end,
                color = { fg = colors.blue },      -- Sets highlighting of component
                padding = { left = 0, right = 1 }, -- We don't need space before this
            })

            ins_left({
                -- mode component
                function()
                    return "󰣇" .. " " .. string.upper(vim.fn.mode())
                end,
                color = function()
                    -- auto change color according to neovims mode
                    local mode_color = {
                        n = colors.red,
                        i = colors.green,
                        v = colors.blue,
                        [""] = colors.blue,
                        V = colors.blue,
                        c = colors.magenta,
                        no = colors.red,
                        s = colors.orange,
                        S = colors.orange,
                        [""] = colors.orange,
                        ic = colors.yellow,
                        R = colors.violet,
                        Rv = colors.violet,
                        cv = colors.red,
                        ce = colors.red,
                        r = colors.cyan,
                        rm = colors.cyan,
                        ["r?"] = colors.cyan,
                        ["!"] = colors.red,
                        t = colors.red,
                    }
                    return { fg = mode_color[vim.fn.mode()] }
                end,
                padding = { right = 1 },
            })

            ins_left({
                -- filesize component
                "filesize",
                cond = conditions.buffer_not_empty,
            })

            ins_left({
                "filename",
                cond = conditions.buffer_not_empty,
                color = { fg = colors.magenta, gui = "bold" },
            })

            ins_left({ "location" })

            ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

            ins_left({
                "diagnostics",
                sources = { "nvim_diagnostic" },
                symbols = { error = " ", warn = " ", info = " " },
                diagnostics_color = {
                    color_error = { fg = colors.red },
                    color_warn = { fg = colors.yellow },
                    color_info = { fg = colors.cyan },
                },
            })

            -- Insert mid section. You can make any number of sections in neovim :)
            -- for lualine it's any number greater then 2
            ins_left({
                function()
                    return "%="
                end,
            })

            ins_left({
                -- Lsp server name .
                function()
                    local msg = "No Active Lsp"
                    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
                    local clients = vim.lsp.get_clients({ bufnr = 0 })
                    if next(clients) == nil then
                        return msg
                    end
                    for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                            return client.name
                        end
                    end
                    return msg
                end,
                icon = " LSP:",
                color = { fg = "#ffffff", gui = "bold" },
            })

            -- Add components to right sections

            ins_right({
                -- filesize component
                "filetype",
                cond = conditions.buffer_not_empty,
            })

            ins_right({
                "o:encoding",       -- option component same as &encoding in viml
                fmt = string.upper, -- I'm not sure why it's upper case either ;)
                cond = conditions.hide_in_width,
                color = { fg = colors.green, gui = "bold" },
            })

            ins_right({
                "fileformat",
                fmt = string.upper,
                icons_enabled = true, -- I think icons are cool but Eviline doesn't have them. sigh
                color = { fg = colors.green, gui = "bold" },
            })

            ins_right({
                "branch",
                icon = "",
                color = { fg = colors.violet, gui = "bold" },
            })

            ins_right({
                "diff",
                -- Is it me or the symbol for modified us really weird
                symbols = { added = " ", modified = "󰝤 ", removed = " " },
                diff_color = {
                    added = { fg = colors.green },
                    modified = { fg = colors.orange },
                    removed = { fg = colors.red },
                },
                cond = conditions.hide_in_width,
            })

            ins_right({
                function()
                    return "▊"
                end,
                color = { fg = colors.blue },
                padding = { left = 1 },
            })

            -- Now don't forget to initialize lualine
            lualine.setup(config)
        end,
    },
    { "MunifTanjim/nui.nvim", lazy = true },
    {
        "tpope/vim-commentary",
        lazy = true,

        event = { "BufReadPre", "BufEnter" },
        config = function()
            vim.keymap.set({ "n", "x", "i" }, "<A-/>", function()
                vim.cmd(":Commentary")
            end, { silent = true, noremap = true })
        end,
    },
    {
        "j-hui/fidget.nvim",
        lazy = true,
        tag = "legacy",
        event = "LspAttach",
        opts = {
            window = {
                blend = 0,
            },
            text = {
                spinner = "arc",
            },
        },
    },
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
        opts = {
            input = {
                enabled = true,
                default_prompt = "▹ ",
                border = "single",
                win_options = {
                    winhighlight = "NormalFloat:DiagnosticError",
                },
            },
            select = {
                enabled = true,
                get_config = function(opts)
                    if opts.kind == "codeaction" then
                        return {
                            backend = "nui",
                            nui = {
                                relative = 'cursor',
                                max_width = 40,
                            },
                        }
                    end
                end
            },
        },
    },
}
