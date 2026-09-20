-- Shim letting crates.nvim (an nvim-cmp source) feed blink.cmp.
return { "saghen/blink.compat", version = "2.*", lazy = true, opts = {} }
