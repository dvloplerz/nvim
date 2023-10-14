local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
    pattern = "Cargo.toml",
    callback = function()
        require("cmp").setup.buffer({ sources = { { name = "crates" } } })
    end,
})
--  autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
-- vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
--     callback = function()
--         -- Todo!: enable codelens if client supports.
--         if true then
--             return true
--         end
--         vim.lsp.codelens.refresh()
--         vim.lsp.codelens.get(vim.api.nvim_get_current_buf())
--     end
-- })



return {
    {
        "hrsh7th/nvim-cmp", -- Required
        event = "InsertEnter",
        dependencies = {
            {
                'L3MON4D3/LuaSnip',
                build        = "make install_jsregexp",
                dependencies = {
                    {
                        "rafamadriz/friendly-snippets",
                    },
                },
                opts         = {
                    update_events = "TextChanged, TextChangedI",
                    delete_check_events = "TextChanged",
                    enable_autosnippets = true,
                    history = true,
                },
                config       = function(_, opts)
                    -- #09020e
                    -- require("luasnip.util.types")['choiceNode']['active']['virt_text'] = {
                    --     { "choiceNode", "@variable" } }
                    require("luasnip").config.set_config(opts)

                    require("luasnip.loaders.from_vscode").lazy_load()
                    require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }

                    require("luasnip.loaders.from_snipmate").load()
                    require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

                    require("luasnip.loaders.from_lua").load()
                    require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }

                    vim.api.nvim_create_autocmd("InsertLeave", {
                        callback = function()
                            if
                                require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
                                and not require("luasnip").session.jump_active
                            then
                                require("luasnip").unlink_current()
                            end
                        end,
                    })
                end,
            },
            {
                'hrsh7th/cmp-nvim-lsp',
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                'hrsh7th/cmp-cmdline',
                'saadparwaiz1/cmp_luasnip',
                "hrsh7th/cmp-nvim-lsp-signature-help"
            },

        },
        lazy = true,
        config = function()
            -- Set up nvim-cmp.
            local cmp = require 'cmp'
            local luasnip = require "luasnip"
            local types = require "cmp.types"
            --#vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
            local select_behavior = cmp.SelectBehavior.Select

            local ls = require("luasnip")
            local s = ls.snippet
            local i = ls.insert_node
            local t = ls.text_node

            ls.snippets = {
                rust = {
                    s('auu', t '#![allow(unused)]'),
                    s('dbg', t '#[derive(Debug)]'),
                    -- s('deadcode', t '#[allow(dead_code)]'),
                    -- s('allowfreedom', t '#![allow(clippy::disallowed_names, unused_variables, dead_code)]'),
                    -- s('clippypedantic', t '#![warn(clippy::all, clippy::pedantic)]'),
                    s(':turbofish', { t { '::<' }, i(0), t { '>' } }),

                    s('print', {
                        t { 'println!("' }, i(1), t { ' {:?}", ' }, i(0), t { ');' } }),
                    -- t { 'println!("' }, i(1), t { ' {' }, i(0), t { ':?}");' } }),

                    s('for',
                        {
                            t { 'for ' }, i(1), t { ' in ' }, i(2), t { ' {', '' },
                            i(0),
                            t { '}', '' },
                        }),

                    s('struct',
                        {
                            t { '#[derive(Debug)]', '' },
                            t { 'struct ' }, i(1), t { ' {', '' },
                            i(0),
                            t { '}', '' },
                        }),

                    s('pstruct',
                        {
                            t { '#[derive(Debug)]', '' },
                            t { 'pub struct ' }, i(1), t { ' {', '' },
                            i(0),
                            t { '}', '' },
                        }),

                    s('test',
                        {
                            t { '#[test]', '' },
                            t { 'fn ' }, i(1), t { '() {', '' },
                            t { '	assert' }, i(0), t { '', '' },
                            t { '}' },
                        }),

                    s('testcfg',
                        {
                            t { '#[cfg(test)]', '' },
                            t { 'mod ' }, i(1), t { ' {', '' },
                            t { '	#[test]', '' },
                            t { '	fn ' }, i(2), t { '() {', '' },
                            t { '		assert' }, i(0), t { '', '' },
                            t { '	}', '' },
                            t { '}' },
                        }),

                    s('if',
                        {
                            t { 'if ' }, i(1), t { ' {', '' },
                            i(0),
                            t { '}' },
                        }),
                }
            }
            cmp.setup({
                enabled = function()
                    return true
                end,
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                completion = {
                    completeopt = "menu,menuone,preview,noinsert",
                    keyword_length = 1,
                    autocomplete = { 'InsertEnter', 'TextChanged' },
                },
                confirmation = {
                    default_behavior = types.cmp.ConfirmBehavior.Insert,
                },
                formatting = {
                    --fields = { 'abbr', 'kind', 'menu' },
                    --fields = { "menu", "abbr", "kind" },
                    fields = { "kind", "abbr", "menu" },
                    expandable_indicator = true,
                    format = function(entry, item)
                        local menu_icon = {
                            --  󱠁 󱧜 󰢱 󱃎   󰞷 ␠󰠠   󰡱 󱩏
                            --
                            --
                            -- nvim_lsp = "λ",
                            -- luasnip = "⋗",
                            -- buffer = " ",
                            -- path = "",
                            -- path = " ",
                            -- nvim_lua = "Π",
                            -- crates = " ",
                            nvim_lsp = "󰞷 lsp ",
                            nvim_lua = "  nv-lua",
                            luasnip = "󰠠  lsnip",
                            buffer = "  buf",
                            path = " ",
                        }
                        local kind_icons = {
                            Text = " ",
                            Method = "󰆧",
                            Function = "󰡱",
                            Constructor = "",
                            Field = "󰇽",
                            Variable = "󰂡",
                            Class = "󰠱",
                            Interface = "",
                            Module = "",
                            Property = "󰜢",
                            Unit = "",
                            Value = "󰎠",
                            Enum = "",
                            Keyword = "󰌋",
                            Snippet = " ",
                            Color = "󰏘",
                            File = "󰈙",
                            Reference = "",
                            Folder = "󰉋",
                            EnumMember = "",
                            Constant = "󰏿",
                            Struct = "",
                            Event = "",
                            Operator = "󰆕",
                            TypeParameter = "󰅲",
                        }
                        item.kind = string.format("%s ", kind_icons[item.kind])
                        item.menu = menu_icon[entry.source.name]
                        return item
                    end,
                },
                preselect = cmp.PreselectMode.None,
                window = {
                    -- completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                    winhighlight = "NormalFloat:CursorlineNr,FloatBorder:NormalFloat",
                    completion = {
                        border = "single",
                        max_height = 8,
                    },
                    zindex = 3,
                    max_width = math.floor(12 * (vim.o.columns / 100)),
                    max_height = math.floor(20 * (vim.o.lines / 100)),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = select_behavior })
                            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                            -- they way you will only jump inside the snippet region
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete(
                                {
                                    enabled = true,
                                    sources = {
                                        { name = "nvim_lsp", keyword_length = 1 },
                                    },
                                }
                            )
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<C-p>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = select_behavior })
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<A-i>"] = cmp.mapping.complete({
                        config = {
                            enabled = true,
                            sources = {
                                { name = "nvim_lsp", keyword_length = 1 },
                            },
                        },
                    }),
                    -- ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-e>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.abort()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip', keyword_length = 2 }, -- For luasnip users.
                }, {
                    { name = 'nvim_lua' },
                    { name = 'nvim_lsp_signature_help' },
                }, {
                    { name = 'buffer' },
                    { name = 'path' },
                }),
                experimental = {
                    {
                        native_menu = false,
                    },
                    ghost_text = true,
                    ghost_text = {
                        hl_group = "CmpGhostText",
                    },
                },
            })
            cmp.setup.cmdline('/', {
                sources = cmp.config.sources({
                    { name = 'buffer' }
                })
            })
            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            })
        end,
    },
}
