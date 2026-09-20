-- Kept rather than swapped: rustaceanvim drives it directly as its runnable
-- executor (`tools.executor = "toggleterm"` in rustaceanvim.lua).
return {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "TermExec" },
  keys = {
    [[<c-\>]],
    -- old <leader>pt was NvChad's "pick hidden term"
    { "<leader>pt", "<cmd>TermSelect<cr>", desc = "Pick terminal" },
  },
  opts = { open_mapping = [[<c-\>]], direction = "float" },
}
