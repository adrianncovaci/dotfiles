-- The theme engine from NvChad, used standalone via the lua/nvconfig.lua shim.
-- This is what restores the exact look of the old config; the theme name
-- ("oxocarbon") and highlight overrides live in that shim.
return {
  "NvChad/base46",
  lazy = false,
  priority = 1000,
  dependencies = { "nvim-lua/plenary.nvim" },
  build = function()
    require("base46").load_all_highlights()
  end,
  config = function()
    require("base46").load_all_highlights()
  end,
  keys = {
    -- restores the old <leader>th theme toggle (oxocarbon <-> one_light,
    -- set in lua/nvconfig.lua)
    { "<leader>th", function()
        require("base46").toggle_theme()
      end, desc = "Toggle theme" },
  },
}
