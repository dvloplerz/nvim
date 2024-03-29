local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local dvloplerz = augroup("dvloplerzGroup", { clear = true })
local yankGroup = augroup("HighlightYank", { clear = true })

P = function(v)
    print(vim.inspect(v))
    return v
end

RELOAD = function(...)
    local ok, plenary_reload = pcall(require, "plenary.reload")
    if ok then
        reloader = plenary_reload.reload_module
    end

    return reloader(...)
end

NOTI = function(msg)
    return vim.api.nvim_notify(msg, vim.log.levels.WARN, {})
end

R = function(name)
    RELOAD(name)
    return require(name)
end

--[ :Redir lua=P(vim.lsp.get_clients()) ]--
vim.api.nvim_create_user_command("Redir", function(ctx)
    local lines = vim.split(vim.api.nvim_exec(ctx.args, true), "\n", {
        plain = true,
    })
    vim.cmd("new")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.opt_local.modified = false
end, { nargs = "+", complete = "command" })

autocmd("TermOpen", {
    callback = function()
        local cur_win = vim.api.nvim_get_current_win()
        local win_width = vim.api.nvim_win_get_width(cur_win)
        local win_size = math.floor(math.abs(win_width / 2))

        vim.wo[cur_win].number = false
        vim.wo[cur_win].relativenumber = false
        vim.keymap.set("t", "<C-c><C-c>", [[<C-\><C-n><cr>]])
        vim.keymap.set("t", "<C-w><C-w>", [[<C-\><C-n><cr><C-w>w<cr>]])
        if win_width < 70 then
            return
        else
            vim.api.nvim_win_set_width(0, win_size)
        end
        vim.cmd.startinsert()
    end,
})

autocmd("BufWritePre", {
    pattern = "*.lua",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 50 })
    end,
    group = yankGroup,
    pattern = "*",
})

autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    group = dvloplerz,
    buffer = 0,
    callback = function()
        vim.lsp.codelens.refresh({ bufnr = 0 })
    end,
})

autocmd("BufWritePre", {
    group = dvloplerz,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})
