-- NOTE: williamboman/mason.nvim now 301-redirects to mason-org/mason.nvim.
return {
  "mason-org/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonInstallAll" },
  opts = {
    ensure_installed = {
      -- lua
      "lua-language-server",
      "stylua",
      -- rust: rust-analyzer comes from rustup; codelldb is the debug adapter
      "codelldb",
      -- web
      "css-lsp",
      "html-lsp",
      "typescript-language-server",
      "eslint-lsp",
      "tailwindcss-language-server",
      "deno",
      "prettier",
      -- c/cpp
      "clangd",
      "clang-format",
      -- go
      "gopls",
      "gofumpt",
      "goimports",
      "delve",
      -- python
      "pyright",
      "ruff",
      -- config / data / shell
      "json-lsp",
      "yaml-language-server",
      "taplo",
      "bash-language-server",
      "shfmt",
      "dockerfile-language-server",
      "sqlls",
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)

    -- `:MasonInstallAll` is an NvChad convenience that mason itself lacks
    vim.api.nvim_create_user_command("MasonInstallAll", function()
      vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
    end, { desc = "Install every tool in ensure_installed" })
  end,
}
