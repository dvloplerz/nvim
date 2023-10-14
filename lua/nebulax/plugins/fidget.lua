local M = {
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
}

return M
