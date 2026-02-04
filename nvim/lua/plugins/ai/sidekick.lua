return {
{
  "folke/sidekick.nvim",
  version = "*", -- use the latest release
  cmd = "Sidekick",
  keys = {
    { "<leader>aa", function() require("sidekick.cli").toggle({ name = "opencode" }) end, desc = "Sidekick Toggle CLI" },
    {
      "<leader>af",
      function() require("sidekick.cli").send({ name="opencode", msg = "{file}" }) end,
      desc = "Send File",
    },
    { "<tab>", function()
        -- This logic allows Tab to apply AI suggestions or act as a normal tab
        if require("sidekick").nes_jump_or_apply() then
          return
        end
        return "<tab>"
      end, 
      expr = true, mode = { "i", "n" }, desc = "Apply AI Suggestion" 
    },
  },
  opts = {
    -- Default configuration (can be left empty)
    -- cli = {
    --   mux = { backend = "tmux", enabled = true }, -- Use tmux to keep sessions alive
    -- },
  },
}
}
