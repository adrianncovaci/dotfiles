local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "ts_ls", "clangd", "pyright", "jsonls", "yamlls", "bashls", "dockerls", "gopls", "sqlls", "tailwindcss", "eslint" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

local cmp_nvim_lsp = require "cmp_nvim_lsp"

lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = cmp_nvim_lsp.default_capabilities(),
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
    "--suggest-missing-includes",
    "--cross-file-rename",
  },
}
-- 
--
-- lspconfig.pyright.setup { blabla}

-- lspconfig.rust_analyzer.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   settings = {
--     ["rust-analyzer"] = {
--       assist = {
--         importMergeBehavior = "last",
--         importPrefix = "by_self",
--       },
--       cargo = {
--         loadOutDirsFromCheck = true,
--         allFeatures = true
--       },
--       procMacro = {
--         enable = true,
--       },
--       checkOnSave = {
--         command = "clippy",
--         allFeatures = true,
--       },
--     },
--   },
-- }
