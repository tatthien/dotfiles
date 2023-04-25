local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { 'lukas-reineke/indent-blankline.nvim' },
  { 'nvim-treesitter/nvim-treesitter' },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  { 'glepnir/lspsaga.nvim' },
  { 'neovim/nvim-lspconfig' },
  { 'nvim-tree/nvim-web-devicons' },
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
  { 
    'bluz71/vim-nightfly-colors', 
    name = 'nightfly', 
    lazy = false, 
    priority = 1000 ,
    config = function()
      vim.cmd([[colorscheme nightfly]])
    end,
  },
  { 'williamboman/nvim-lsp-installer' },
  { 'windwp/nvim-autopairs' },
  { 'windwp/nvim-ts-autotag' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'onsails/lspkind-nvim' },
  { 'folke/lsp-colors.nvim' },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim' },
  { 'onsails/lspkind-nvim' },
  { 'L3MON4D3/LuaSnip' },
  { 'jose-elias-alvarez/null-ls.nvim' },
  { 'nvim-lualine/lualine.nvim' },
  { 'norcalli/nvim-colorizer.lua' },
  { 'lewis6991/gitsigns.nvim' },
  { 'vim-scripts/sessionman.vim' }
})
