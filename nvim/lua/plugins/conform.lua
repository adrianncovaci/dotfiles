return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  opts = {
    -- `lsp_fallback` is the legacy spelling conform maps internally
    default_format_opts = { lsp_format = "fallback" },
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt" },
      -- goimports fixes the import block, gofumpt is the stricter gofmt
      go = { "goimports", "gofumpt" },
      python = { "ruff_organize_imports", "ruff_format" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      -- previously "tomllint" / "json_tool" / "yamllint", none of which are
      -- conform formatters, so these filetypes silently never formatted
      toml = { "taplo" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      sql = { "sql_formatter" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      html = { "prettier" },
      markdown = { "prettier" },
      ["_"] = { "trim_whitespace" },
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
      if ok and stats and stats.size > 512 * 1024 then
        return
      end
      return { timeout_ms = 1000, lsp_format = "fallback" }
    end,
  },
  init = function()
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, { desc = "Disable format-on-save (! = this buffer only)", bang = true })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = "Re-enable format-on-save" })
  end,
}
