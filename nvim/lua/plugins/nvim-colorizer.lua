-- NvChad/nvim-colorizer.lua now 301-redirects here; catgoose is the maintained
-- home of that fork.
return {
  "catgoose/nvim-colorizer.lua",
  event = { "BufReadPost", "BufNewFile" },
  opts = { user_default_options = { names = false } },
}
