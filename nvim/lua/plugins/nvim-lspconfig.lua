-- nvim 0.11+ native LSP. The `require("lspconfig")` framework is deprecated and
-- removed in nvim-lspconfig v3; server definitions ship as `lsp/<name>.lua` on
-- the runtimepath, `vim.lsp.config` layers settings on top, `vim.lsp.enable`
-- starts them. See `:help lspconfig-nvim-0.11`.

-- rust_analyzer is deliberately absent: rustaceanvim owns it (rustaceanvim.lua).
local servers = {
  "lua_ls",
  "html",
  "cssls",
  "ts_ls",
  "clangd",
  "pyright",
  "jsonls",
  "yamlls",
  "bashls",
  "dockerls",
  "gopls",
  "sqlls",
  "tailwindcss",
  "eslint",
  "taplo",
}

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "mason-org/mason.nvim", "saghen/blink.cmp" },
  config = function()
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          hint = { enable = true },
        },
      },
    })

    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--offset-encoding=utf-16",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
      },
    })

    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          analyses = { unusedparams = true, nilness = true, unusedwrite = true },
          staticcheck = true,
          gofumpt = true,
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    })

    vim.lsp.config("pyright", {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoImportCompletions = true,
            diagnosticMode = "workspace",
          },
        },
      },
    })

    vim.lsp.enable(servers)

    -- Buffer-local LSP keymaps. Using LspAttach rather than a per-server
    -- on_attach means rustaceanvim's client gets them too, even though it
    -- never goes through vim.lsp.config.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("cfg_lsp_attach", { clear = true }),
      callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- all carried over from the old NvChad mappings
        map("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
        map("n", "gd", vim.lsp.buf.definition, "LSP definition")
        map("n", "gi", vim.lsp.buf.implementation, "LSP implementation")
        map("n", "K", vim.lsp.buf.hover, "LSP hover")
        map("n", "<leader>D", vim.lsp.buf.type_definition, "LSP type definition")
        map("n", "<leader>ra", vim.lsp.buf.rename, "LSP rename")
        map("n", "<leader>gr", vim.lsp.buf.references, "LSP references")
        map("n", "<leader>lsh", vim.lsp.buf.signature_help, "LSP signature help")
        map({ "n", "v" }, "ga", vim.lsp.buf.code_action, "LSP code action")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
        map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
        map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
        map("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "List workspace folders")

        if client and client:supports_method "textDocument/inlayHint" then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end,
    })

    local severity = vim.diagnostic.severity
    vim.diagnostic.config {
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      virtual_text = false,
      virtual_lines = false,
      signs = {
        text = {
          [severity.ERROR] = "󰅚 ",
          [severity.WARN] = "󰀪 ",
          [severity.INFO] = "󰋽 ",
          [severity.HINT] = "󰌶 ",
        },
      },
      float = { border = "rounded", source = true, header = "", scope = "line" },
    }

    -- Show diagnostics in float with gl
    vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.goto_prev { float = true }
    end, { desc = "Previous diagnostic" })
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.goto_next { float = true }
    end, { desc = "Next diagnostic" })
  end,
}
