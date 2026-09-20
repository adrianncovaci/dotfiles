return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = require "gitsigns"
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- carried over from the old NvChad gitsigns mappings
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal { "]c", bang = true }
        else
          gs.nav_hunk "next"
        end
      end, "Next hunk")

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal { "[c", bang = true }
        else
          gs.nav_hunk "prev"
        end
      end, "Prev hunk")

      map("n", "<leader>rh", gs.reset_hunk, "Reset hunk")
      map("n", "<leader>ph", gs.preview_hunk, "Preview hunk")
      map("n", "<leader>gb", gs.blame_line, "Blame line")
      map("n", "<leader>td", gs.toggle_deleted, "Toggle deleted")
    end,
  },
}
