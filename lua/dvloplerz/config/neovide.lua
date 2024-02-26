if vim.g.neovide then
    vim.opt.linespace = 0
    vim.g.neovide_scale_factor = 1.0
    vim.g.neovide_padding_top = 0
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 0
    vim.g.neovide_transparency = 0.9
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
    vim.g.neovide_scroll_animation_length = 0
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
    vim.g.neovide_cursor_trail_size = 0
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_animate_in_insert_mode = true
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_cursor_unfocused_outline_width = 0.05
    vim.g.neovide_cursor_vfx_mode = "none"
    vim.g.neovide_cursor_vfx_opacity = 0
    vim.g.neovide_cursor_vfx_particle_lifetime = 0
    vim.g.neovide_cursor_vfx_particle_density = 0
    vim.g.neovide_cursor_vfx_particle_speed = 0
else
    return
end
