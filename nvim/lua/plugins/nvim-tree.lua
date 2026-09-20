return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>ls", "<cmd>NvimTreeToggle<cr>", desc = "Toggle nvimtree" },
    { "<leader>e", "<cmd>NvimTreeFocus<cr>", desc = "Focus nvimtree" },
  },
  opts = {
    filters = { dotfiles = false },
    disable_netrw = true,
    hijack_cursor = true,
    sync_root_with_cwd = true,
    update_focused_file = { enable = true, update_root = false },
    view = { width = 40, side = "left", preserve_window_proportions = true },
    git = { enable = true, ignore = false },
    filesystem_watchers = { enable = true },
    renderer = {
      root_folder_label = false,
      highlight_git = true,
      indent_markers = { enable = true },
      icons = { show = { file = true, folder = true, folder_arrow = true, git = true } },
    },
  },
}
