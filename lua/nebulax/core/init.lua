require "nebulax.core.opts"
require "nebulax.core.remap"

local nvim = vim.api

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local nebulaxGroup = augroup("nebulax", {})
local yankGroup = augroup("HighlightYank", {})

function R(name)
    require "plenary.reload".reload_module(name)
end

--[ :Redir lua=P(vim.lsp.get_clients()) ]--
vim.api.nvim_create_user_command('Redir', function(ctx)
    local lines = vim.split(vim.api.nvim_exec(ctx.args, true), '\n', { plain = true })
    vim.cmd('new')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.opt_local.modified = false
end, { nargs = '+', complete = 'command' })

autocmd("BufWritePre", {
    pattern = "*.lua",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end
})

function P(name)
    print(vim.inspect(name))
end

--vim.notify("buffer root: " .. require("telescope.utils").buffer_dir(), vim.log.levels.INFO)
function Notify(msg, lvl)
    -- code
    local level = {
        t = vim.log.levels.TRACE,
        d = vim.log.levels.DEBUG,
        i = vim.log.levels.INFO,
        w = vim.log.levels.WARN,
        e = vim.log.levels.ERROR,
        o = vim.log.levels.OFF,
    }

    local t_lvl = {
        t = "TRACE",
        d = "DEBUG",
        i = "INFO",
        w = "WARN",
        e = "ERROR",
        o = "OFF",
    }
    if #lvl == nil then
        vim.notify("INFO: " .. " " .. msg, level["i"])
    else
        vim.notify(t_lvl[lvl] .. ":  " .. msg, level[lvl])
    end
end

autocmd('TextYankPost', {
    group = yankGroup,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 50,
        })
    end,
})

autocmd({ 'BufEnter' }, {
    group = nebulaxGroup,
    pattern = '*',
    callback = function()
        vim.lsp.codelens.refresh()
    end,
})

-- autocmd({ 'BufWritePre' }, {
--     group = nebulaxGroup,
--     pattern = '*',
--     command = [[%s/\s\+$//e]],
-- })

vim.diagnostic.config({ virtual_text = true })

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 50

if vim.g.neovide then
    vim.opt.guifont = "Operator-Caska:h12:#e-subpixelantialias:#h-slight"
    vim.opt.linespace = 0
    vim.g.neovide_scale_factor = 1.0
    vim.g.neovide_padding_top = 2
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 0
    vim.g.transparency = 0.8
    vim.g.neovide_transparency = 0.9
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
    vim.g.neovide_scroll_animation_length = 0.1
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_underline_automatic_scaling = false
    vim.g.neovide_theme = 'auto'
    vim.g.neovide_refresh_rate = 60
    vim.g.neovide_refresh_rate_idle = 10
    vim.g.neovide_no_idle = false
    vim.g.neovide_confirm_quit = true
    vim.g.neovide_fullscreen = false
    vim.g.neovide_remember_window_size = true
    vim.g.neovide_profiler = false
    vim.g.neovide_cursor_animation_length = 0.15
    vim.g.neovide_cursor_trail_size = 0.25
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_animate_in_insert_mode = true
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_cursor_unfocused_outline_width = 0.05
    vim.g.neovide_cursor_vfx_mode = "pixiedust"
    vim.g.neovide_cursor_vfx_opacity = 50.0
    vim.g.neovide_cursor_vfx_particle_lifetime = 1
    vim.g.neovide_cursor_vfx_particle_density = 1.0
    vim.g.neovide_cursor_vfx_particle_speed = 2.0
end
