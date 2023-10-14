local M = {
    {
        "elkowar/yuck.vim",
        ft = { "yuck" },
        event = { "BufRead *.yuck" },
    },
    {
        "gpanders/nvim-parinfer",
        ft = { "yuck" },
        event = { "BufRead *.yuck" },
    }
}



return M
