return {
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "css", "scss", "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "lua" },
        user_default_options = {
          names = false,
          mode = "virtualtext",
        },
      })
    end,
  },
}
