-- `undofile` is on in options.lua; this makes the history browsable.
return {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
  keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" } },
}
