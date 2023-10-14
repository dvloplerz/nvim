return {
    {
        "nvim-telescope/telescope.nvim",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- opts = {
        --     defaults = {
        --         border = {},
        --     },
        -- },
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
                                    actions.move_selection_next, type = "action",
                                    opts = { nowait = true, silent = false }
                                },
                                ["<C-p>"] = {
                                    actions.move_selection_previous, type = "action",
                                    opts = { nowait = true, silent = false }
                                },
                                ["<C-c>"] = {
                                    actions.close, type = "action",
                                    opts = { nowait = true, silent = false }
                                },
                            },
                            n = {
                                ["<C-c>"] = {
                                    actions.close, type = "action",
                                    opts = { nowait = true, silent = false }
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
                    --root_dir
                else
                    --vim.notify("LSP ROOT: " .. vim.lsp.get_clients()[1]["config"]['root_dir'], vim.log.levels.INFO)
                    builtin.find_files { cwd = vim.lsp.get_clients()[1]["config"]['root_dir'] }
                end
                -- root_dir
            end, { noremap = true, silent = false })
            nmap('<leader>bl', builtin.buffers, { noremap = false, silent = false })
            nmap('<leader>H', builtin.help_tags, { noremap = false, silent = false })
            nmap('<leader>?', builtin.oldfiles, { noremap = false, silent = false })
            nmap('<leader>qf', builtin.quickfix, { noremap = false, silent = false })
            nmap('<leader>[d', builtin.diagnostics, { noremap = true, silent = false })
            --nmap('<C-\>', builtin.diagnostics, { noremap = true, silent = false })
        end,
    },

    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = "make",
        config = function()
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
            require('telescope').load_extension('fzf')
        end
    },

    { 'nvim-telescope/telescope-fzf-native.nvim' },
}
