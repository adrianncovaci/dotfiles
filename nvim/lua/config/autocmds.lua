local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name)
  return vim.api.nvim_create_augroup("cfg_" .. name, { clear = true })
end

-- Brief highlight on yank, so it is obvious what got copied
autocmd("TextYankPost", {
  group = augroup "highlight_yank",
  callback = function()
    vim.hl.on_yank { higroup = "IncSearch", timeout = 120 }
  end,
})

-- Reopen a file where you left it
autocmd("BufReadPost", {
  group = augroup "restore_cursor",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lines = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lines and vim.bo[args.buf].filetype ~= "gitcommit" then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Do not list quickfix buffers in the bufferlist
autocmd("FileType", {
  group = augroup "qf_unlisted",
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- q closes throwaway windows
autocmd("FileType", {
  group = augroup "close_with_q",
  pattern = { "help", "qf", "man", "lspinfo", "checkhealth", "startuptime", "neotest-output", "neotest-summary" },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, silent = true })
  end,
})

-- Strip trailing whitespace is handled by conform; here we just warn on big files
autocmd("BufReadPre", {
  group = augroup "bigfile",
  callback = function(args)
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > 1024 * 1024 then
      vim.b[args.buf].disable_autoformat = true
      vim.bo[args.buf].swapfile = false
      vim.cmd "syntax clear"
    end
  end,
})
