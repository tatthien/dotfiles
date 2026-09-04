return {
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   lazy = true,
  --   opts = {
  --     contrast = "hard",
  --   },
  --   config = function(_, opts)
  --     require("gruvbox").setup(opts)
  --   end,
  -- },
  {
    "projekt0n/github-nvim-theme",
    lazy = true,
    config = function()
      require("github-theme").setup({
        options = {
          styles = {
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
          },
        },
      })
    end,
  },
}
