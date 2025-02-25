return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
    config = function()
      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = {
          "stylua",
          "shfmt",
          "ts_ls",
          "css-lsp",
          "css-variables-language-server",
          "cssmodules_ls",
          "luacheck",
          "biome",
          "html",
          "cssls",
          "lua_ls",
          "gopls",
          "prismals",
          "tflint",
          "terraformls",
          "tailwindcss",
          "yamlls",
          "jsonls",
          "intelephense",
          "hadolint",
        },
      })
    end,
  },
}
