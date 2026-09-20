-- Replaces nvim-cmp and its five source plugins. Rust fuzzy matcher, and one
-- spec instead of six.
return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  version = "1.*", -- release tags ship the prebuilt fuzzy-matcher binary
  dependencies = { "rafamadriz/friendly-snippets", "saghen/blink.compat" },
  ---@module 'blink.cmp'
  opts = {
    keymap = {
      preset = "default",
      ["<C-y>"] = { "select_and_accept" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
    appearance = { nerd_font_variant = "mono" },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      -- off so it does not fight Copilot's inline suggestion
      ghost_text = { enabled = false },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      per_filetype = { toml = { "crates", "lsp", "path", "buffer" } },
      providers = {
        crates = { name = "crates", module = "blink.compat.source", score_offset = 100 },
      },
    },
    signature = { enabled = true },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
