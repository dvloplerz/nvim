local lsp_zero = require("lsp-zero")
local luasnip = require("luasnip")
local navic = require("nvim-navic")
local cmp = require("cmp")
require("luasnip.loaders.from_vscode").lazy_load()

require("neodev").setup {
    library = {
        enabled = true,
        runtime = true,
        types = true,
        plugins = true
    },
    setup_jsonls = true,
    lspconfig = true,
    pathStrict = true,
}

require("mason").setup {}

vim.g.lsp_zero_extend_lspconfig = 1
vim.g.lsp_zero_extend_cmp = 1
vim.g.lsp_zero_ui_signcolumn = 1
vim.g.lsp_zero_api_warnings = 1
vim.g.lsp_zero_ui_float_border = 'single'

vim.b.lsp_zero_enable_autoformat = 1

lsp_zero.extend_lspconfig()
lsp_zero.extend_cmp()

luasnip.setup({
    update_events = "TextChanged,TextChangedI",
})

require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "jsonls", "taplo", "zls" },
    automatic_installation = {
        exclude = { "rust_analyzer" }
    },
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
            require("lspconfig").lua_ls.setup({})
        end,
    }
})

lsp_zero.on_attach(function(client, bufnr)
    require("luasnip.loaders.from_vscode").lazy_load()
    lsp_zero.default_keymaps({ buffer = bufnr })
    lsp_zero.highlight_symbol(client, bufnr)

    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end

    vim.keymap.set({ "n" }, "<leader>f", vim.lsp.buf.format, { silent = true })
    vim.keymap.set({ "n" }, "<leader>rn", vim.lsp.buf.rename, { silent = true })
    vim.keymap.set({ "n" }, "K", vim.lsp.buf.hover, { silent = true })
    vim.keymap.set({ "n" }, "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Docs", silent = true })
    vim.keymap.set({ "n" }, "<leader>ca", function()
            vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
        end,
        { silent = true, desc = "[C]ode[A]ction" })

    vim.keymap.set({ "i", "s" }, "<C-k>", function()
        if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        end
    end, { silent = false })
    vim.keymap.set({ "i", "s" }, "<C-j>", function()
        if luasnip.jumpable(-1) then
            luasnip.jump(-1)
        end
    end, { silent = false })
    vim.keymap.set("i", "<C-l>", function()
        if luasnip.choice_active() then
            luasnip.change_choice(1)
        end
    end)

    vim.api.nvim_set_option_value("formatexpr", "v:lua.vim.lsp.formatexpr()", { buf = bufnr })
    vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
    vim.api.nvim_set_option_value("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = bufnr })

    if client.supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(0, true)
    end

    if client.supports_method("textDocument/formatting") then
        lsp_zero.buffer_autoformat()
    end

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
end)

vim.g.rustaceanvim = {
    server = {
        capabilities = lsp_zero.get_capabilities()
    },
}

lsp_zero.format_on_save {
    format_opts = {
        async = true,
    }
}

lsp_zero.set_sign_icons {
    error = "✘",
    warn = "▲",
    hint = "⚑",
    info = "!»",
}

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
        vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    preselect = cmp.PreselectMode.None,
    completion = {
        autocomplete = { "TextChanged", "TextChangedI" },
        completeopt = "menu,menuone,noinsert,noselect"
    },
    formatting = lsp_zero.cmp_format(),
    mapping = cmp.mapping.preset.insert {
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.mapping.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["C-p"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["C-y"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.mapping.confirm({ select = true })
            end
            fallback()
        end),
        ["<C-l>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                return cmp.complete_common_string()
            end
            fallback()
        end, { "i", "c" }),
        ["<C-.>"] = cmp.mapping.complete({ select = true, behavior = cmp_select }),
        ["<C-Space>"] = cmp.mapping.complete {},
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-'>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            end
            fallback()
        end, { "i", "x" }),
    },
})
