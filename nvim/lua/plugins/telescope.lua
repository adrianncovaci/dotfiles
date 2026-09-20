return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable "make" == 1 },
  },
  -- every one of these is carried over from the old NvChad mappings
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>", desc = "Find all" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help page" },
    { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Find oldfiles" },
    { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in buffer" },
    { "<leader>cm", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
    { "<leader>gt", "<cmd>Telescope git_status<cr>", desc = "Git status" },
    -- old <leader>ma was NvChad's bookmarks picker; marks is the native equivalent
    { "<leader>ma", "<cmd>Telescope marks<cr>", desc = "Marks" },
  },
  opts = {
    defaults = {
      vimgrep_arguments = {
        "rg", "-L", "--color=never", "--no-heading",
        "--with-filename", "--line-number", "--column", "--smart-case",
      },
      prompt_prefix = "   ",
      selection_caret = "  ",
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = { prompt_position = "top", preview_width = 0.55 },
        width = 0.87,
        height = 0.8,
      },
      file_ignore_patterns = { "node_modules", "%.git/", "target/" },
      path_display = { "truncate" },
      mappings = { i = { ["<C-j>"] = "move_selection_next", ["<C-k>"] = "move_selection_previous" } },
    },
  },
  config = function(_, opts)
    local telescope = require "telescope"
    telescope.setup(opts)
    pcall(telescope.load_extension, "fzf")
  end,
}
