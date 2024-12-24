
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

vim.g.rustaceanvim = {
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importMergeBehavior = "last",
          importPrefix = "by_self",
        },
        cargo = {
          loadOutDirsFromCheck = true,
          allFeatures = true
        },
        procMacro = {
          enable = true,
        },
        checkOnSave = {
          command = "clippy",
          allFeatures = true,
        },
      },
    },
  }
}
