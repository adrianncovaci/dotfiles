-- Lua LSP that understands the Neovim config you are editing right now:
-- completion and docs for `vim.*` and for installed plugin modules.
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
