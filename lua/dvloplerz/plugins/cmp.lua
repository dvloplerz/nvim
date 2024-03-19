return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        {
            'L3MON4D3/LuaSnip',
            build = (function()
                -- code
                if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                    return
                end
                return 'make install_jsregexp'
            end)(),
        },
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'rafamadriz/friendly-snippets',
        'nvim-tree/nvim-web-devicons',
        {
            "saecki/crates.nvim",
            event = { "BufRead Cargo.toml" },
            opts = {
                src = {
                    cmp = { enabled = true },
                },
            },
            config = function()
                vim.api.nvim_create_autocmd("BufRead", {
                    group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
                    pattern = "Cargo.toml",
                    callback = function()
                        require("cmp").setup.buffer({ sources = { { name = "crates" } } })
                    end,
                })
            end
        },
    },
    config = function()
        -- code
        local cmp = require "cmp"
        local luasnip = require "luasnip"
        require("luasnip.loaders.from_vscode").lazy_load()
        luasnip.config.setup {}

        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            completion = {
                autocomplete = { 'InsertEnter', 'TextChanged' },
                completeopt = 'menu,menuone,noinsert',
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-y>'] = cmp.mapping.confirm { select = true },
                ['<C-Space>'] = cmp.mapping.complete { select = true },
                ['<C-l>'] = cmp.mapping(function()
                    -- code
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    end
                end, { 'i', 's' }),

                ['<C-h>'] = cmp.mapping(function()
                    -- code
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { 'i', 's' }),
            },
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip', option = { use_show_condition = false } },
                { name = 'path' },
            }),
            formatting = {
                fields = { 'abbr', 'kind', 'menu' },
                format = function(entry, item)
                    -- code
                    local source_name = entry.source.name
                    local max_width = #item.abbr or false

                    local label = ''

                    if source_name == 'nvim_lsp' then
                        label = '[LSP]'
                    elseif source_name == "nvim_lua" then
                        label = "[LUA]"
                    elseif source_name == "luasnip" then
                        label = "[LSN]"
                    else
                        label = string.format('[%s]', source_name)
                    end

                    if vim.tbl_contains({ 'path' }, source_name) then
                        local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
                        if icon then
                            item.kind = icon
                            item.kind_hl_group = hl_group
                            return item
                        end
                    end

                    if item.menu ~= nil then
                        item.menu = string.format("%s %s", label, item.menu)
                    else
                        item.menu = label
                    end

                    if max_width and #item.abbr > max_width then
                        local last = item.kind == 'Snippet' and '~' or ''
                        item.abbr = string.format('%s %s', string.sub(item.abbr, 1, max_width), last)
                    end

                    return item
                end,
            },
            experimental = {
                ghost_text = true
            },
        }
    end,
}
