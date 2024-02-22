vim.g.mapleader = " "
vim.g.localmapleader = vim.g.mapleader

require("dvloplerz")

vim.defer_fn(function()
    require("dvloplerz.plugins.configs.lsp")
    require("dvloplerz.plugins.configs.treesitter")
end, 0)
