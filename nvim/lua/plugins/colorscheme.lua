return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = true,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "soft", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        dim_inactive = true,
        transparent_mode = false,
        -- overrides = {
        --   DiagnosticVirtualTextError = { bg = blend_colors(c.error, bg, 0.1), fg = c.error },
        --   DiagnosticVirtualTextWarn = { bg = blend_colors(c.warning, bg, 0.1), fg = c.warning },
        --   DiagnosticVirtualTextInfo = { bg = blend_colors(c.info, bg, 0.1), fg = c.info },
        --   DiagnosticVirtualTextHint = { bg = blend_colors(c.hint, bg, 0.1), fg = c.hint },
        -- },
      })
      vim.o.background = "dark" -- or "light" for light mode
      vim.cmd([[colorscheme gruvbox]])
    end,
  },
}
