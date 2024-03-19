local autocmd_group = vim.api.nvim_create_augroup("CustomBufSetup", { clear = true })
local buffer_enter = 'BufEnter'

vim.api.nvim_create_autocmd(buffer_enter, {
    group = autocmd_group,
    pattern = "*",
    callback = function()
        local enable = false
        if enable then
            vim.api.nvim_set_hl(0, "Normal", { bg = 15 })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = 0 })
        else
            return
        end
    end,
})

vim.api.nvim_create_autocmd(buffer_enter, {
    group = autocmd_group,
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }
    end,
})

local function setup_codelens_refresh(client, bufnr)
    -- code
    local ok, codelens_supported = pcall(function()
        return client.supports_method("textDocuments/codeLens")
    end)

    if not ok or not codelens_supported then
        return
    end
    local group = "lsp_codelens_refresh"
    local cl_events = { "BufEnter", "InsertLeave" }
    local is_ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
        group = group,
        buffer = bufnr,
        event = cl_events,
    })
    if is_ok and #cl_autocmds > 0 then
        return
    end
    vim.api.nvim_create_augroup(group, { clear = true })
    vim.api.nvim_create_autocmd(cl_events, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh(),
    })
end

vim.diagnostic.config({
    on_init_callback = function(_)
        -- code
        setup_codelens_refresh(_)
    end,
})
