-- Neovim port of antfu/vscode-theme-vitesse
-- https://github.com/antfu/vscode-theme-vitesse

local M = {}

function M.load(variant)
  variant = variant or "dark"

  vim.o.termguicolors = true

  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.background = variant:match("dark") and "dark" or "light"
  vim.g.colors_name = "vitesse-" .. variant

  local palette = require("vitesse.palettes")[variant:gsub("-", "_")]
  local groups = require("vitesse.highlights").build(palette)

  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  local terminal_colors = {
    palette.black,
    palette.red,
    palette.green,
    palette.yellow,
    palette.blue,
    palette.magenta,
    palette.cyan,
    palette.white,
    palette.bright_black,
    palette.red,
    palette.green,
    palette.yellow,
    palette.blue,
    palette.magenta,
    palette.cyan,
    palette.bright_white,
  }
  for i, color in ipairs(terminal_colors) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end
end

return M
