return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "jayp0521/mason-null-ls.nvim", -- Ensure dependencies are installed
  },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting -- Setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- Setup linters

    -- Formatters & linters for Mason to install
    require("mason-null-ls").setup({
      ensure_installed = {
        "prettier", -- JavaScript/TypeScript/HTML/CSS/JSON formatter
        "stylua", -- Lua formatter
        "eslint_d", -- JavaScript/TypeScript linter
        "shfmt", -- Shell script formatter
        "checkmake", -- Linter for Makefiles
        "ruff", -- Python linter and formatter
        "gofmt", -- Go formatter (builtin in Go toolchain)
        "golines", -- Go formatter for line wrapping
        -- "taplo", -- TOML formatter
      },
      automatic_installation = true,
    })

    local sources = {
      diagnostics.checkmake,
      -- formatting.taplo,

      -- JavaScript/TypeScript/HTML/CSS/JSON
      formatting.prettier.with({
        extra_args = { "--tab-width", "2", "--use-tabs", "false" },
        filetypes = { "javascript", "typescript", "html", "json", "yaml", "markdown", "css", "scss", "less" },
      }),

      -- Lua
      formatting.stylua.with({
        extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      }),

      -- Shell scripts
      formatting.shfmt.with({
        args = { "-i", "2", "-ci", "-sr" }, -- -i 2 (indent size), -ci (switch cases indent), -sr (simpler redirects)
      }),

      -- Terraform
      formatting.terraform_fmt,

      -- Python
      require("none-ls.formatting.ruff_format").with({
        extra_args = { "--line-length", "88", "--indent-size", "2" },
      }),

      -- Golang
      formatting.gofmt, -- Standard Go formatter
      formatting.golines.with({
        extra_args = { "--max-len=100", "--base-formatter=gofmt" }, -- Format with gofmt + line wrapping
      }),
    }

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    null_ls.setup({
      sources = sources,
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end,
    })
  end,
}
