return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      -- Stretch code blocks across the full window width instead of stopping
      -- at the longest line.
      code = {
        width = "full",
        -- Padding inside the block, around the code.
        left_pad = 2,
        right_pad = 2,
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      -- Strip the full-width heading background bars (RenderMarkdownH1Bg..H6Bg)
      -- while leaving the heading foreground colors (RenderMarkdownH1..H6) intact.
      local function clear_heading_backgrounds()
        for level = 1, 6 do
          vim.api.nvim_set_hl(0, "RenderMarkdownH" .. level .. "Bg", { bg = "NONE" })
        end
      end

      clear_heading_backgrounds()
      -- Re-apply after any colorscheme load, since render-markdown regenerates
      -- these blended Bg groups on the ColorScheme event.
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = clear_heading_backgrounds,
      })
    end,
  },
}
