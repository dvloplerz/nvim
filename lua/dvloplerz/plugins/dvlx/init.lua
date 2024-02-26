local utils = require("utils")

P("Registering LspServerSettings")
vim.api.nvim_create_user_command("LspGetSettings", function()
    -- code
    local server = utils.get_server()
    if type(server) == "table" then
        P(utils.get_server_settings(server))
    else
        return nil
    end
end, { bang = false })

return {}
