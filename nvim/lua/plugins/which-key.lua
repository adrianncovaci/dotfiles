return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "<leader>wK", "<cmd>WhichKey<cr>", desc = "Which-key all keymaps" },
    { "<leader>wk", function()
        vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
      end, desc = "Which-key query lookup" },
    -- the old <leader>ch opened NvChad's cheatsheet, which is gone; which-key
    -- is the closest equivalent
    { "<leader>ch", "<cmd>WhichKey<cr>", desc = "Mapping cheatsheet" },
  },
}
