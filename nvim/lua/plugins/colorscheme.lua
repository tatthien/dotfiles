local palette = require("palette")

local c = {
  error = palette.red_light,
  warning = palette.yellow_light,
  info = palette.green_light,
  hint = palette.aqua_light,
}
local bg = palette.bg
local function blend_colors(color1, color2, alpha)
  local r1, g1, b1 = tonumber(color1:sub(2, 3), 16), tonumber(color1:sub(4, 5), 16), tonumber(color1:sub(6, 7), 16)
  local r2, g2, b2 = tonumber(color2:sub(2, 3), 16), tonumber(color2:sub(4, 5), 16), tonumber(color2:sub(6, 7), 16)
  local r = math.floor(r1 * alpha + r2 * (1 - alpha))
  local g = math.floor(g1 * alpha + g2 * (1 - alpha))
  local b = math.floor(b1 * alpha + b2 * (1 - alpha))
  return string.format("#%02X%02X%02X", r, g, b)
end

return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      -- Default options:
      require("gruvbox").setup({
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = true,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "soft", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        dim_inactive = false,
        transparent_mode = false,
        overrides = {
          DiagnosticVirtualTextError = { bg = blend_colors(c.error, bg, 0.1), fg = c.error },
          DiagnosticVirtualTextWarn = { bg = blend_colors(c.warning, bg, 0.1), fg = c.warning },
          DiagnosticVirtualTextInfo = { bg = blend_colors(c.info, bg, 0.1), fg = c.info },
          DiagnosticVirtualTextHint = { bg = blend_colors(c.hint, bg, 0.1), fg = c.hint },
        },
      })
      vim.o.background = "dark" -- or "light" for light mode
      vim.cmd([[colorscheme gruvbox]])
    end,
  },
}
