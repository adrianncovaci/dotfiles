return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {},
  keys = {
    { "<leader>fx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    { "<leader>fX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
    { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
    { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP references (Trouble)" },
    { "<leader>fL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list (Trouble)" },
    { "<leader>fQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list (Trouble)" },
  },
}
