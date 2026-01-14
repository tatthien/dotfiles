return {
  {
    "dmmulroy/tsc.nvim",
    config = function()
      local utils = require("tsc.utils")
      require("tsc").setup({
        flags = {
          noEmit = true,
          -- project = function()
          --   return utils.find_nearest_tsconfig()
          -- end,
          watch = true,
        },
      })
    end,
  },
}
