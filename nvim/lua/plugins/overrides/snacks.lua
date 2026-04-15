return {
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
░█▀█░█▀█░░░░░█▄█░▀█▀░█▀█░█░█
░█▀█░█░█░▄▄▄░█░█░░█░░█░█░█▀█
░▀░▀░▀░▀░░░░░▀░▀░▀▀▀░▀░▀░▀░▀
 ]],
        },
      },
      explorer = {
        enabled = false,
      },
    },
    keys = {
      { "<leader>e", false },
      { "<leader>ff", false },
      {
        "cc",
        function()
          Snacks.explorer()
        end,
        desc = "File Explorer",
      },
      {
        "ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
    },
  },
}
