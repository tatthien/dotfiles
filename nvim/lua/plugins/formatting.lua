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
          javascript = { "prettierd" },
          typescript = { "prettierd" },
          typescriptreact = { "prettierd" },
          javascriptreact = { "prettierd" },
          css = { "prettierd" },
          html = { "prettierd" },
          json = { "prettierd" },
          yaml = { "prettierd" },
          markdown = { "prettierd" },
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
