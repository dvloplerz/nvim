local opt = vim.opt
local g = vim.g

g.netrw_bufsettings = "number"

g.scrolloff = 8
g.guifont = "Iosevka_NF"

opt.scrollback = 10
opt.scrolloff = 10

--opt.clipboard = 'unnamed'

opt.autoindent = true

opt.background = "dark"
opt.backspace = "indent,eol,start"
opt.backup = false
opt.breakindent = true

opt.clipboard = 'unnamedplus'
opt.completeopt = { 'menu', 'menuone', 'preview', 'noinsert', 'noselect' }
opt.cursorcolumn = false
opt.cursorline = true
opt.colorcolumn = "80"

opt.expandtab = true

opt.fillchars = { eob = " ", lastline = " " }
opt.foldenable = false
-- opt.formatoptions = 'tqj'

opt.guicursor = { a = "Block" }

opt.hlsearch = false

opt.icon = true
opt.inccommand = 'nosplit'
opt.incsearch = true
opt.isfname = { '@-@' }

opt.list = false

opt.number = true
-- opt.numberwidth = 1

opt.pumblend = 10
opt.pumheight = 10

opt.redrawtime = 50
opt.relativenumber = true

opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.scroll = 10
opt.scrollback = 10
opt.scrolloff = 10
opt.shiftwidth = 4
opt.shiftround = true
opt.shortmess = "aI"
opt.showmatch = false
opt.showmode = false
opt.sidescrolloff = 30
opt.signcolumn = 'yes'
opt.smartindent = true
opt.softtabstop = 4
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false

opt.tabstop = 4
opt.termguicolors = true
opt.timeoutlen = 400

opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
opt.undofile = true
opt.updatetime = 50

opt.wildignore = { "Cargo.lock" }
opt.wildmode = "longest:full,full"
opt.wrap = false
opt.textwidth = 80
opt.winminwidth = 5
opt.whichwrap:append "<>[]hl"

vim.g.markdown_recommended_style = 0
