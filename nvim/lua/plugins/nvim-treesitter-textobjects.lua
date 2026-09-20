-- `main` branch, matching nvim-treesitter. Mappings are explicit function
-- calls now rather than a keymaps table.
--
-- The gap that matters most for Rust: select, move and swap by function,
-- class, parameter and block instead of by line.
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-treesitter-textobjects").setup {
      select = { lookahead = true },
      move = { set_jumps = true },
    }

    local select = require "nvim-treesitter-textobjects.select"
    local move = require "nvim-treesitter-textobjects.move"
    local swap = require "nvim-treesitter-textobjects.swap"
    local map = vim.keymap.set

    local objects = {
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
      ["aa"] = "@parameter.outer",
      ["ia"] = "@parameter.inner",
      ["ab"] = "@block.outer",
      ["ib"] = "@block.inner",
    }
    for lhs, query in pairs(objects) do
      map({ "x", "o" }, lhs, function()
        select.select_textobject(query, "textobjects")
      end, { desc = "Select " .. query })
    end

    -- [c/]c stay on gitsigns hunks, so classes use [C/]C
    map({ "n", "x", "o" }, "]f", function()
      move.goto_next_start("@function.outer", "textobjects")
    end, { desc = "Next function start" })
    map({ "n", "x", "o" }, "[f", function()
      move.goto_previous_start("@function.outer", "textobjects")
    end, { desc = "Prev function start" })
    map({ "n", "x", "o" }, "]C", function()
      move.goto_next_start("@class.outer", "textobjects")
    end, { desc = "Next class start" })
    map({ "n", "x", "o" }, "[C", function()
      move.goto_previous_start("@class.outer", "textobjects")
    end, { desc = "Prev class start" })

    map("n", "<leader>sa", function()
      swap.swap_next "@parameter.inner"
    end, { desc = "Swap parameter next" })
    map("n", "<leader>sA", function()
      swap.swap_previous "@parameter.inner"
    end, { desc = "Swap parameter prev" })
  end,
}
