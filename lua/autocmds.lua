-- local autocmd_group = vim.api.nvim_create_augroup("LuaFmt", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
-- 	pattern = { "*.lua" },
-- 	desc = "Auto-formatting Lua files after saving.",
-- 	callback = function()
-- 		vim.cmd(":silent !stylua %")
-- 	end,
-- 	group = autocmd_group,
-- })


local autocmd_group = vim.api.nvim_create_augroup("BgTrans", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "Normal", { bg = 10 })
    end
})

vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('DisableNewLineAutoCommentString', {}),
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }
        require("luasnip.loaders.from_vscode").lazy_load()
    end,
})
