local palette = require("palette")

return {
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
          style = palette.purple_light,
          duration = 0,
          delay = 100,
        },
        line_num = {
          enable = true,
          style = palette.green_light,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
}
