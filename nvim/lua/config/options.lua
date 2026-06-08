-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = "\\"

-- Format on save (handled by conform.nvim). Toggle per-buffer/global with `<leader>uf`.
vim.g.autoformat = true

vim.opt.list = true
vim.opt.listchars = {
  -- eol = "↓",
  space = "·",
  trail = "●",
  tab = "  →",
  extends = ">",
  precedes = "<",
}

-- Enable tsgo for Typescript LSP
vim.g.lazyvim_ts_lsp = "tsgo"

-- Suppress eslint -32603 "Cannot read config" spam when a project has no eslint config
local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == "string" and msg:find("eslint.*%-32603") then
    return
  end
  orig_notify(msg, level, opts)
end
