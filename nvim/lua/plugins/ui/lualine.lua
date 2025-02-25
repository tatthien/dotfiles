return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          disabled_filetypes = { "NvimTree" },
        },
        sections = {
          lualine_c = {
            {
              "filename",
              file_status = true, -- displays file status (readonly status, modified status)
              path = 3, -- 0 = just filename, 1 = relative path, 2 = absolute path
            },
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
        },
      })
    end,
  },
}
