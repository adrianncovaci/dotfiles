-- Replaces the NvChad statusline, which came from the EOL NvChad/ui plugin.
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "auto",
      globalstatus = true, -- matches laststatus=3
      section_separators = "",
      component_separators = "",
    },
    sections = {
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "diagnostics", "filetype" },
    },
  },
}
