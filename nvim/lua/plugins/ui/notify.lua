-- Better notifications
return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    local notify = require("notify")
    notify.setup({
      background_colour = "#000000", -- Example: Set background color if needed
      -- You can customize stages, render method, timeout, etc. here
      -- See :help notify-options
    })

    -- Set nvim-notify as the default handler for vim.notify()
    vim.notify = notify
  end,
}
