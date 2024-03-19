local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "dvloplerz.plugins" },
    },
    defaults = {
        lazy = false,
        version = false,
    },
    install = {
        missing = true,
        colorscheme = { "rose-pine" },
    },
    checker = {
        enabled = false,
        notify = false,
    },
    change_detection = {
        enabled = false,
    },
    performance = {
        cache = { enabled = true },
        reset_packpath = true,
        rtp = {
            reset = true,
            disabled_plugins = {
                "tutor",
                "tohtml",
                "tarPlugin",
                "gzip",

            },
        }
    }
})
