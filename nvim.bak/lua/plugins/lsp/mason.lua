return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
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
          "ts_ls",
          "css_variables",
          "cssmodules_ls",
          "biome",
          "html",
          "cssls",
          "lua_ls",
          -- "gopls",
          "prismals",
          "tflint",
          "terraformls",
          "tailwindcss",
          "yamlls",
          "jsonls",
          "intelephense",
        },
      })
    end,
  },
}
