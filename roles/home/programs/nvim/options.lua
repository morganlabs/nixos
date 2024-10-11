local opt = vim.opt
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Disable line wrapping
opt.wrap = false

-- Line numbers
opt.nu = true
opt.rnu = true

-- Tabstop
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- Swapfile
opt.swapfile = false
opt.backup = false

-- Undo
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

opt.hlsearch = true
opt.incsearch = true

-- Colours
opt.termguicolors = true

-- Scrolloff
opt.scrolloff = 10

-- Misc.
opt.signcolumn = "yes"
opt.updatetime = 50
opt.colorcolumn = "80"
