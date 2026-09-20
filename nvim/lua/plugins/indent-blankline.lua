-- v3. The old config pinned 2.20.7, whose API (`require("indent_blankline")`)
-- no longer exists upstream.
return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  main = "ibl",
  opts = { indent = { char = "│" }, scope = { enabled = false } },
}
