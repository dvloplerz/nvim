local M = {}

M.borders = {
    none = "none",
    single = "single",
    double = "double",
    rounded = "rounded",
    solid = "solid",
    shadow = "shadow",
    nvb = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
    d_border = { "◤", " ", "◥", " ", "◢", " ", "◣", " " },
    top_border = { " ", "", " ", " ", " ", "", " ", " " },
}

local on_references = vim.lsp.handlers["textDocument/references"]

M.handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = false,
            virtual_text = {
                spacing = 2,
            },
            signs = true,
            update_in_insert = true,
            float = {
                border = M.borders.nvb,
            },
        }
    ),
    ["textDocument/references"] = vim.lsp.with(
        on_references, {
            -- Use location list instead of quickfix list
            loclist = true,
        }
    )

}

M.on_attach = function(client, bufnr)
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({
            group = augroup,
            buffer = bufnr,
        })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
    end

    -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    --     vim.lsp.diagnostic.on_publish_diagnostics, {
    --         underline = false,
    --         virtual_text = {
    --             spacing = 2,
    --         },
    --         signs = true,
    --         update_in_insert = true,
    --         float = {
    --             border = M.borders.nvb,
    --         },
    --     }
    -- )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
            border = "single",
        })
    --print(vim.inspect(vim.lsp.codelens.refresh()))

    if client.supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint(bufnr, true)
    end

    if client.supports_method("textDocument/semanticTokens") then
        client.server_capabilities.semanticTokensProvider = true
    end


    local navic = require("nvim-navic")
    if client.supports_method("textDocument/documentSymbolProvider") then
        if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
        end
    else
        return
    end

    local opts = { buffer = 0, remap = false }
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>da", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next({ float = true }) end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<F4>", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set({ "n", "i" }, "<leader>h", function() vim.lsp.buf.signature_help() end, opts)
    -- vim.keymap.set("n", "<leader>sh", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<leader>cl", function()
        if #vim.lsp.codelens.get(0) > 0 then
            vim.lsp.codelens.run()
        else
            vim.notify('No CodeLens available.', vim.log.levels.INFO)
            vim.lsp.codelens.refresh()
            return
        end
        vim.lsp.codelens.refresh()
    end, opts)
end

local vlp_capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
M.capabilities = vim.tbl_deep_extend("force", vlp_capabilities, cmp_capabilities)
-- vim.print(M.capabilities)
--M.capabilities = require("nvim-cmp").make_client_capabilities()
-- M.capabilities = {
--     textDocument = {
--         callHierarchy = {
--             resolveProvider = true,
--         },
--         completion = {
--             completionItem = {
--                 valueSet = { 1 },
--                 commitCharactersSupport = true,
--                 deprecatedSupport = true,
--                 documentationFormat = { "markdown", "plaintext" },
--                 preselectSupport = true,
--                 snippetSupport = true,
--             },
--             contextSupport = true,
--             dynamicRegistration = true,
--         },
--         diagnostic = {
--             dynamicRegistration = true,
--         },
--         documentHighlight = {
--             dynamicRegistration = true,
--         },
--     },
-- }



-- > vim.lsp.get_clients()[1].server_capabilities
--{
--"documentFormattingProvider",
--"documentSymbolProvider",
--"definitionProvider",
--"codeActionProvider",
--"selectionRangeProvider",
--"diagnosticProvider",
--"foldingRangeProvider",
--"colorProvider",
--"renameProvider",
--"documentHighlightProvider",
--"documentLinkProvider",
--"completionProvider",
--"hoverProvider",
--"textDocumentSync",
--"documentRangeFormattingProvider",
--"referencesProvider"
--}
--{
--"window/showMessageRequest",
--"textDocument/declaration",
--"textDocument/codeLens",
--"textDocument/implementation",
--"workspace/applyEdit",
--"textDocument/hover",
--"workspace/configuration",
--"textDocument/inlayHint",
--"textDocument/documentHighlight",
--"textDocument/completion",
--"textDocument/formatting",
--"client/registerCapability",
--"workspace/semanticTokens/refresh",
--"textDocument/references",
--"client/unregisterCapability",
--"textDocument/signatureHelp",
--"textDocument/rangeFormatting",
--"window/workDoneProgress/create",
--"textDocument/diagnostic",
--"workspace/inlayHint/refresh",
--"textDocument/rename",
--"signature_help",
--"textDocument/documentSymbol",
--"textDocument/publishDiagnostics",
--"hover",
--"callHierarchy/outgoingCalls",
--"callHierarchy/incomingCalls",
--"workspace/executeCommand",
--"$/progress",
--"window/showMessage",
--"workspace/symbol",
--"workspace/workspaceFolders",
--"textDocument/definition",
--"window/showDocument",
--"textDocument/typeDefinition",
--"window/logMessage"
--}
--
--capabilities = {
--	textDocument = {
--		callHierarchy = {
--			resolveProvider = true,
--		},
--		completion = {
--			completionItem = {
--				commitCharactersSupport = true,
--				deprecatedSupport = true,
--				documentationFormat = { "markdown", "plaintext" },
--				preselectSupport = true,
--				snippetSupport = true,
--			},
--			contextSupport = true,
--			dynamicRegistration = true,
--		},
--		diagnostic = {
--			dynamicRegistration = true,
--		},
--		documentHighlight = {
--			dynamicRegistration = true,
--		},
--		semanTokens = {},
--	},
--},

return M
