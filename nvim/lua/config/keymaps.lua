-- Every mapping here is carried over from the old NvChad config
-- (core/mappings.lua + custom/mappings.lua), with the same keys.
local map = vim.keymap.set

-- === insert mode: move without leaving home row ===
map("i", "<C-b>", "<ESC>^i", { desc = "Beginning of line" })
map("i", "<C-e>", "<End>", { desc = "End of line" })
map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })

-- === normal mode ===
map("n", "<Esc>", "<cmd>noh<cr>", { desc = "Clear highlights" })

-- custom/mappings.lua overrode <C-h>/<C-l> from window-switching to buffer
-- cycling, so that is what they do here too. <C-j>/<C-k> stay window moves.
map("n", "<C-h>", "<cmd>bprevious<cr>", { desc = "Goto prev buffer" })
map("n", "<C-l>", "<cmd>bnext<cr>", { desc = "Goto next buffer" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })

map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<C-c>", "<cmd>%y+<cr>", { desc = "Copy whole file" })
map("n", "<leader>n", "<cmd>set nu!<cr>", { desc = "Toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<cr>", { desc = "Toggle relative number" })
map("n", "<leader>b", "<cmd>enew<cr>", { desc = "New buffer" })
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Close buffer" })

-- move through wrapped lines naturally
map("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true, desc = "Move down" })
map("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true, desc = "Move up" })
map("n", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true, desc = "Move down" })
map("n", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true, desc = "Move up" })

-- === visual mode ===
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true, desc = "Move down" })
map("v", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true, desc = "Move up" })
map("v", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true, desc = "Dont copy replaced text" })

-- === terminal ===
map("t", "<C-x>", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), { desc = "Escape terminal mode" })

-- === comments ===
-- Comment.nvim is gone: Neovim 0.10+ ships gc/gcc natively. remap=true is
-- required because gcc is itself a mapping.
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" })
map("v", "<leader>/", "gc", { remap = true, desc = "Toggle comment" })

-- === formatting ===
map({ "n", "v" }, "<leader>fm", function()
  require("conform").format { async = true, lsp_format = "fallback" }
end, { desc = "Format buffer" })

-- === diagnostics ===
-- nvim 0.11 replaced goto_prev/goto_next with vim.diagnostic.jump
local severity = vim.diagnostic.severity
map("n", "<leader>lf", vim.diagnostic.open_float, { desc = "Floating diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic setloclist" })
map("n", "<leader>g[", function()
  vim.diagnostic.jump { count = -1, float = false }
end, { desc = "Goto prev diagnostic" })
map("n", "<leader>g]", function()
  vim.diagnostic.jump { count = 1, float = false }
end, { desc = "Goto next diagnostic" })
map("n", "[d", function()
  vim.diagnostic.jump { count = -1, float = false }
end, { desc = "Prev diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump { count = 1, float = false }
end, { desc = "Next diagnostic" })
map("n", "[e", function()
  vim.diagnostic.jump { count = -1, severity = severity.ERROR, float = false }
end, { desc = "Prev error" })
map("n", "]e", function()
  vim.diagnostic.jump { count = 1, severity = severity.ERROR, float = false }
end, { desc = "Next error" })

map("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end, { desc = "Toggle inlay hints" })
