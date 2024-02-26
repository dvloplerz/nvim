local M = {}
local vimls = vim.lsp
local api = vim.api

---Get current buffer `id` and check if `LSP` is attached.
---@param bufnr     integer|nil  Buffer `id` or `nil`. If `nil` will use current buffer.
---@return table|nil   #Current client info table or `nil` if can't get info or no client is attached.
M.get_server = function(bufnr)
    -- code
    if bufnr == nil then
        bufnr = api.nvim_get_current_buf()
    end

    local client = vimls.get_clients { bufnr = bufnr }

    if type(client) == "table" and client ~= nil then
        return client[1]
    end
    return {}
end

---Get LSP client settings.
---@param client table Client table.
---@return table|nil    #client settings table. `nil` if Err.
M.get_server_settings = function(client)
    -- code
    if type(client) == "table" then
        return client.config.settings
    else
        return nil
    end
end

return M
