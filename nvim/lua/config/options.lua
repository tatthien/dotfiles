-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = "\\"

vim.opt.list = true
vim.opt.listchars = {
  -- eol = "↓",
  space = "·",
  trail = "●",
  tab = "  →",
  extends = ">",
  precedes = "<",
}

vim.g.lazyvim_ts_lsp = "tsgo"
