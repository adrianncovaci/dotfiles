-- `main` branch, not `master`.
--
-- master supports Neovim 0.10+ and breaks on 0.12: its query_predicates call
-- node methods that 0.12's treesitter no longer provides, which surfaces as
-- "Parser could not be created for buffer N" and as nil-method errors from any
-- plugin that parses (render-markdown, etc). main requires 0.12.0+.
--
-- The API is entirely different: no `nvim-treesitter.configs`, no `opts`
-- table. Parsers are installed imperatively and highlighting is Neovim's own
-- `vim.treesitter.start()`.

local ensure_installed = {
  "vim", "vimdoc", "lua", "luadoc", "query", "regex",
  "markdown", "markdown_inline",
  "rust", "toml", "ron",
  "c", "cpp", "go", "gomod", "gosum", "python", "bash", "sql",
  "html", "css", "javascript", "typescript", "tsx",
  "json", "yaml",
  "diff", "git_config", "git_rebase", "gitcommit", "gitignore", "dockerfile",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup {
      install_dir = vim.fn.stdpath "data" .. "/site",
    }

    -- no-op for parsers already present
    require("nvim-treesitter").install(ensure_installed)

    -- Highlighting, folds and indent are Neovim features now; nvim-treesitter
    -- only supplies the parsers and queries.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("cfg_treesitter", { clear = true }),
      callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
          return
        end
        -- only start if the parser is actually installed, so opening a file
        -- for an uninstalled language is silent rather than an error
        if not pcall(vim.treesitter.language.add, lang) then
          return
        end

        pcall(vim.treesitter.start, args.buf)
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- start unfolded; foldexpr above would otherwise collapse the file
    vim.opt.foldlevelstart = 99
  end,
}
