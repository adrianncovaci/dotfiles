-- Minimal shim so NvChad's base46 theme engine runs standalone.
--
-- base46 is the only piece of NvChad worth keeping (it is what made the old
-- config look the way it did), but it hard-requires a module called
-- `nvconfig` for its options. NvChad itself supplies that; this file is a
-- stand-in providing just the fields base46 actually reads.
return {
  base46 = {
    theme = "oxocarbon",
    theme_toggle = { "oxocarbon", "one_light" },
    transparency = false,

    -- carried over from the old custom/highlights.lua
    hl_override = {
      Comment = { italic = true },
      Normal = { bg = { "black", -4 } },
    },
    hl_add = {
      NvimTreeOpenedFolderName = { fg = "green", bold = true },
    },

    integrations = {},
    -- these three theme NvChad's own UI, which this config no longer has
    excluded = { "nvcheatsheet", "statusline", "tbline" },
    changed_themes = {},
  },

  ui = {
    cmp = { style = "default" },
    statusline = { theme = "default" },
    telescope = { style = "borderless" },
  },

  cheatsheet = { theme = "grid" },
}
