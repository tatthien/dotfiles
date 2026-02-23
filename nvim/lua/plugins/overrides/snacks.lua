return {
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
    ___    _   __      __  ________   ____  __
   /   |  / | / /     /  |/  /  _/ | / / / / /
  / /| | /  |/ /_____/ /|_/ // //  |/ / /_/ / 
 / ___ |/ /|  /_____/ /  / // // /|  / __  /  
/_/  |_/_/ |_/     /_/  /_/___/_/ |_/_/ /_/   
 ]],
        },
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
