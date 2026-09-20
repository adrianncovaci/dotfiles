-- Project-wide find & replace with a live preview buffer.
return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = { { "<leader>sr", "<cmd>GrugFar<cr>", desc = "Search & replace (project)" } },
  opts = {},
}
