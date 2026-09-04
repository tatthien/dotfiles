return {
  {
    -- kept for manual use (`:Lazy load gruvbox.nvim` then `:colorscheme gruvbox`);
    -- vitesse (nvim/colors/vitesse-{dark,light}.lua) is the active theme, see config/lazy.lua
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    config = function(_, opts)
      require("gruvbox").setup(opts)
    end,
  },
}
