-- local autocmd_group = vim.api.nvim_create_augroup("LuaFmt", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
-- 	pattern = { "*.lua" },
-- 	desc = "Auto-formatting Lua files after saving.",
-- 	callback = function()
-- 		vim.cmd(":silent !stylua %")
-- 	end,
-- 	group = autocmd_group,
-- })

local autocmd_group = vim.api.nvim_create_augroup("CustomBufSetup", { clear = true })
local buffer_enter = 'BufEnter'
vim.api.nvim_create_autocmd(buffer_enter, {
    group = autocmd_group,
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "Normal", { bg = 10 })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = 10 })
    end,
})

vim.api.nvim_create_autocmd(buffer_enter, {
    group = autocmd_group,
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }
    end,
})
