-- rustaceanvim ships its own neotest adapter, so `neotest-rust` (barely
-- maintained) is not needed.
--
-- neotest's README still suggests FixCursorHold.nvim, but that plugin has not
-- been touched since 2023 and its own README says it is obsolete; `updatetime`
-- is already 250ms in options.lua, which is what it existed to provide.
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<leader>tr", function() require("neotest").run.run() end, desc = "Test nearest" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand "%") end, desc = "Test file" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
    { "<leader>to", function() require("neotest").output.open { enter = true } end, desc = "Test output" },
    { "<leader>tw", function() require("neotest").watch.toggle() end, desc = "Test watch" },
  },
  config = function()
    require("neotest").setup {
      adapters = { require "rustaceanvim.neotest" },
    }
  end,
}
