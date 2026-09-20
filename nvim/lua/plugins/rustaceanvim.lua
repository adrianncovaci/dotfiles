return {
  "mrcjkb/rustaceanvim",
  version = "^5",
  ft = { "rust" },
  dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap", "akinsho/toggleterm.nvim" },
  config = function()
    vim.g.rustaceanvim = {
      tools = {
        executor = "toggleterm",
        test_executor = "background",
        enable_clippy = true,
        -- replaces the old `hover_actions` table, which v5 silently ignores
        float_win_config = { auto_focus = true, border = "rounded" },
      },
      server = {
        -- keymaps arrive via the shared LspAttach autocmd in nvim-lspconfig.lua
        default_settings = {
          ["rust-analyzer"] = {
            -- was `assist.importMergeBehavior` / `assist.importPrefix`,
            -- both removed from rust-analyzer
            imports = {
              granularity = { group = "module" },
              prefix = "self",
            },
            cargo = {
              -- `allFeatures` is gone; it is `features = "all"` now
              features = "all",
              -- replaces `loadOutDirsFromCheck` + `runBuildScripts`
              buildScripts = { enable = true },
            },
            -- `checkOnSave` is a boolean; the command moved under `check`.
            -- Passing a table here silently disabled clippy entirely.
            checkOnSave = true,
            check = {
              command = "clippy",
              extraArgs = { "--no-deps" },
              features = "all",
            },
            procMacro = {
              enable = true,
              ignored = { leptos_macro = { "server" } },
            },
            inlayHints = {
              lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = true },
              closureReturnTypeHints = { enable = "with_block" },
              parameterHints = { enable = true },
              typeHints = { enable = true },
              closingBraceHints = { enable = true, minLines = 20 },
            },
            diagnostics = {
              enable = true,
              experimental = { enable = true },
            },
          },
        },
      },
    }
  end,
  keys = {
    { "<leader>rr", "<cmd>RustLsp runnables<cr>", ft = "rust", desc = "Rust runnables" },
    { "<leader>rd", "<cmd>RustLsp debuggables<cr>", ft = "rust", desc = "Rust debuggables" },
    { "<leader>rt", "<cmd>RustLsp testables<cr>", ft = "rust", desc = "Rust testables" },
    { "<leader>re", "<cmd>RustLsp expandMacro<cr>", ft = "rust", desc = "Rust expand macro" },
    { "<leader>rc", "<cmd>RustLsp openCargo<cr>", ft = "rust", desc = "Open Cargo.toml" },
    { "<leader>rp", "<cmd>RustLsp parentModule<cr>", ft = "rust", desc = "Rust parent module" },
    { "<leader>rD", "<cmd>RustLsp renderDiagnostic<cr>", ft = "rust", desc = "Rust render diagnostic" },
    { "<leader>rE", "<cmd>RustLsp explainError<cr>", ft = "rust", desc = "Rust explain error" },
  },
}
