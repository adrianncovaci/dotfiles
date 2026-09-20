-- Kept over copilot.lua: this is the official plugin, still actively
-- maintained, and it preserves the existing <C-j> accept binding.
return {
  "github/copilot.vim",
  event = "InsertEnter",
  init = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = "\t"
  end,
  config = function()
    vim.keymap.set("i", "<C-j>", function()
      return vim.fn["copilot#Accept"] "\t"
    end, { expr = true, replace_keycodes = false, desc = "Copilot accept" })
  end,
}
