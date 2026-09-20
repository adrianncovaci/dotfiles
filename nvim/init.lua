-- Entry point. Order matters: leader must be set before lazy.nvim loads any
-- plugin that defines a `<leader>` mapping.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require "config.options"
require "config.lazy"
require "config.keymaps"
require "config.autocmds"
