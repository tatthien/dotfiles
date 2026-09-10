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
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    opts = {
      flavour = "latte",
      custom_highlights = function(colors)
        return {
          -- lighten listchars (tab/space/trail arrows) and eol/extends/precedes markers
          Whitespace = { fg = colors.surface0 },
          NonText = { fg = colors.surface0 },
        }
      end,
    },
  },
}
