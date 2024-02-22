local opt = vim.opt
local g = vim.g

g.netrw_bufsettings = "noma nomod nobl nowrap nu ro rnu"
g.netrw_banner = 0
g.netrw_winsize = 25
g.netrw_browse_split = 0

-- : scrolling
opt.smoothscroll = true
opt.scrollback = 10
opt.scrolloff = 10
opt.sidescrolloff = 8

-- : Indenting
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true
opt.cindent = true
opt.expandtab = true

-- : status
opt.laststatus = 3
opt.showmode = false
opt.showcmd = true
opt.cmdheight = 0

-- : personalize
opt.background = "dark"
opt.cursorcolumn = false
opt.cursorline = true
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
opt.colorcolumn = { "120" or "80" }
opt.belloff = "all"
opt.guicursor = { a = "Block" }
opt.icon = true
opt.list = false
opt.number = true
opt.numberwidth = 3
opt.relativenumber = true
opt.scroll = 10
opt.shiftround = true



-- : backspace can shift lines
opt.backspace = "indent,eol,start"

-- : backup 'n more..
opt.backup = false
opt.wrap = false
-- opt.formatoptions = opt.formatoptions - "a" - "t" + "c" + "q" - "o" + "r" + "n" + "j" - "2"
opt.formatoptions = "jcroqlnt"
opt.clipboard = "unnamedplus"

-- : Editor
opt.fillchars = { eob = " ", lastline = " " }
opt.foldenable = false
opt.isfname = { "@-@" }
opt.completeopt = "menuone,noinsert"
opt.pumblend = 10
opt.pumheight = 10
opt.redrawtime = 50
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shortmess = "aIoOc"
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.splitkeep = "screen"

-- : Searching
opt.smartcase = true
opt.hlsearch = false
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.incsearch = true
opt.showmatch = false

opt.termguicolors = true
opt.timeoutlen = 200
opt.title = true

opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
opt.undofile = true
opt.updatetime = 50

-- : Wild Options
opt.wildmode = "longest:full,full"
opt.wildoptions = "pum"
opt.wildignore = "__pycache__"
opt.wildignore:append("*.o", "*~", "*.pyc", "*pycache*")
opt.wildignore:append("Cargo.lock", "Cargo.Bazel.lock")

opt.hidden = true
opt.equalalways = false

opt.textwidth = 80
opt.winminwidth = 5
opt.whichwrap:append("<>[]hl")

vim.g.markdown_recommended_style = 0
