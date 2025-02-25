-- disable netrw at the very start of our init.lua, because we use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.scriptencoding = "uft-8"

-- Enable line number and relative line number
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.autoread = true
vim.opt.swapfile = false
vim.opt.modifiable = true
vim.opt.shell = "fish"
vim.opt.inccommand = "split"
vim.opt.backup = false
vim.opt.modifiable = true

-- Indent settings
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Disable line wrapping by default. Use <leader>z to toggle.
vim.opt.wrap = false

-- Enable mouse mode, can be useful for resizing splits, etc.
vim.opt.mouse = "a"

-- Don't show the mode, since it's already shown in the status line
vim.opt.showmode = false

-- Case-insensitive searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Fold settings
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Diagnostic
vim.diagnostic.config({
  -- virtual_text = false, -- do not show the virtual text
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  severity_sort = true,
  signs = true,
  underline = true,
  -- Update diagnostic in insert mode will be annoying when the output is too verbose
  update_in_insert = true,
})

-- see hidden chars and their colors
vim.opt.listchars = {
  tab = "▸ ",
  trail = "•",
  extends = "›",
  precedes = "‹",
  nbsp = "‿",
}
vim.opt.list = true

-- Show which line your cursor is on
vim.opt.cursorline = true
