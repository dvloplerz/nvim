local o = vim.o and vim.opt
local g = vim.g

g.netrw_bufsettings = "noma nomod nobl nowrap nu ro rnu"
g.netrw_banner = 0
g.netrw_winsize = 25
g.netrw_browse_split = 0

-- : scrolling
o.smoothscroll = true
o.scrollback = 10
o.scrolloff = 10
o.sidescrolloff = 8

-- : Indenting
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.autoindent = true
o.smartindent = true
o.breakindent = true
o.cindent = true
o.expandtab = true

-- : status
o.laststatus = 3
o.showmode = false
o.showcmd = true
o.cmdheight = 1

-- : personalize
o.background = "dark"
o.cursorcolumn = false
o.cursorline = true
local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(ev, val, pat)
    vim.api.nvim_create_autocmd(ev, {
        group = group,
        patern = pat,
        callback = function()
            vim.opt_local.cursorline = val
        end,
    })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("BufLeave", true)
o.colorcolumn = { "120" or "80" }
o.belloff = "all"
o.guicursor = { a = "Block" }
o.icon = true
o.list = false
o.number = true
o.numberwidth = 3
o.relativenumber = true
o.scroll = 10
o.shiftround = true



-- : backspace can shift lines
o.backspace = "indent,eol,start"

-- : backup 'n more..
o.backup = false
o.wrap = false
-- opt.formatoptions = opt.formatoptions - "a" - "t" + "c" + "q" - "o" + "r" + "n" + "j" - "2"
o.formatoptions = "jcroqlnt"
o.clipboard = "unnamedplus"

-- : Editor
o.fillchars = { eob = " ", lastline = " " }
o.foldenable = false
o.isfname = { "@-@" }
o.completeopt = "menuone,noinsert"
o.pumblend = 10
o.pumheight = 10
o.redrawtime = 50
o.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
o.shortmess = "aIoOc"
o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.swapfile = false
o.splitkeep = "screen"

-- : Searching
o.smartcase = true
o.hlsearch = false
o.ignorecase = true
o.inccommand = "nosplit"
o.incsearch = true
o.showmatch = false

o.termguicolors = true
o.timeoutlen = 200
o.title = true

o.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
o.undofile = true
o.updatetime = 50

-- : Wild Options
o.wildmode = "longest:full,full"
o.wildoptions = "pum"
o.wildignore = "__pycache__"
o.wildignore:append("*.o", "*~", "*.pyc", "*pycache*")
o.wildignore:append("Cargo.lock", "Cargo.Bazel.lock")

o.hidden = true
o.equalalways = false

o.textwidth = 80
o.winminwidth = 5
o.whichwrap:append("<>[]hl")

vim.g.markdown_recommended_style = 0
