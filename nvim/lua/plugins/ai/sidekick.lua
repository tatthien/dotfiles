return {
  {
    "folke/sidekick.nvim",
    version = "*",
    cmd = "Sidekick",
    keys = {
      { "<leader>aa", function() require("sidekick.cli").toggle() end, desc = "Sidekick Toggle CLI" },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      -- {
      --   "<tab>",
      --   function()
      --     if require("sidekick").nes_jump_or_apply() then
      --       return
      --     end
      --     return "<tab>"
      --   end,
      --   expr = true,
      --   mode = { "i", "n" },
      --   desc = "Apply AI Suggestion",
      -- },
    },
    opts = {
      cli = {
        -- Set global defaults
        width = 40, -- 20 is very narrow, 40-50 is usually better for code
        view = { side = "right" },
        mux = { backend = "tmux", enabled = true },
        
        -- Explicitly configure your custom 'opencode' CLI
        configs = {
          opencode = {
            cmd = "opencode", -- Ensure this matches your terminal command
            width = 45,       -- You can override width just for this tool
          },
        },
      },
    },
  },
}
