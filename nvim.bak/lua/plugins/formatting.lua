return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    event = { "BufWritePre" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>f",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    config = function()
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          go = { "gofmt" },
          -- javascript = { "prettierd", "prettier" },
          -- typescript = { "prettierd", "prettier" },
          -- typescriptreact = { "prettierd", "prettier" },
          -- javascriptreact = { "prettierd", "prettier" },
          -- css = { "prettierd", "prettier" },
          -- html = { "prettierd", "prettier" },
          -- json = { "prettierd", "prettier" },
          -- yaml = { "prettierd", "prettier" },
          -- markdown = { "prettierd", "prettier" },
        },
        format_on_save = {
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        },
      })
    end,
  },
}
