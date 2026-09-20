local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.numberwidth = 2
opt.ruler = false
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.laststatus = 3 -- one global statusline
opt.showmode = false -- lualine already shows it
opt.fillchars = { eob = " " }
opt.colorcolumn = "120"
opt.scrolloff = 8
opt.wrap = false
opt.splitbelow = true
opt.splitright = true
opt.winborder = "rounded"
opt.shortmess:append "sI" -- no intro screen

-- Indent
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Files / undo
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.expand "~/.vim/undodir"

-- Behaviour
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.timeoutlen = 400
opt.updatetime = 250
opt.isfname:append "@-@"
opt.whichwrap:append "<>[]hl"
opt.exrc = true -- trust project-local .nvim.lua

-- base46 (the theme engine) writes its compiled highlight cache here and reads
-- this global at require time, so it must be set before any plugin loads.
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"

-- netrw off; we use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Providers we do not use -- skipping them speeds up startup
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- mason-installed binaries on PATH
vim.env.PATH = vim.fn.stdpath "data" .. "/mason/bin:" .. vim.env.PATH
