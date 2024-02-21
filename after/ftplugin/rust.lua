local opts = { silent = true, buffer = vim.api.nvim_get_current_buf(), noremap = true, remap = true, desc = "" }

vim.keymap.set({ "n", "i" }, "<C-i>", function()
    vim.cmd.RustLsp("codeAction")
end, vim.tbl_deep_extend("force", opts, { desc = "RustLsp code action." }))

vim.keymap.set("n", "<leader>cr", function()
    vim.cmd.RustLsp("runnables")
end, vim.tbl_deep_extend("force", opts, { desc = "Show runnables commands." }))

vim.keymap.set("n", "<leader>dbg", function()
    require("dap").continue()
    vim.cmd.RustLsp("debuggables")
end, vim.tbl_deep_extend("force", opts, { desc = "RustLsp Debuggables." }))

vim.keymap.set("n", "<leader>mep", function()
    vim.cmd.RustLsp("expandMacro")
end, vim.tbl_deep_extend("force", opts, { desc = "RustLsp ExpandMacro." }))

vim.keymap.set("n", "K", "<Nop>")
vim.keymap.set("n", "K", function()
    vim.cmd.RustLsp({ "hover", "actions" })
end, vim.tbl_deep_extend("force", opts, { desc = "Hover Action from rustaceanvim." }))

vim.keymap.set("n", "<C-S-?>", function()
    vim.cmd.RustLsp("explainError")
end, vim.tbl_deep_extend("force", opts, { desc = "RustLsp ExpandErrors." }))

vim.keymap.set("n", "<leader>Ce", function()
    vim.cmd.RustLsp("openCargo")
end, vim.tbl_deep_extend("force", opts, { desc = "Open Cargo.toml" }))

vim.keymap.set("i", "<C-'>", function()
    require("cmp").mapping.complete({
        sources = { name = "luasnip" }
    })
end, vim.tbl_deep_extend("force", opts, { remap = true, desc = "Completion from luasnip" }))
