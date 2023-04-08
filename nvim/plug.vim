call plug#begin(stdpath('config') . '/plugged')

" Lsp + autocomplete + treesitter
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'windwp/nvim-autopairs'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'tami5/lspsaga.nvim'
Plug 'hrsh7th/nvim-cmp/'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'onsails/lspkind-nvim'
Plug 'folke/lsp-colors.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'onsails/lspkind-nvim'
Plug 'L3MON4D3/LuaSnip'
Plug 'jose-elias-alvarez/null-ls.nvim'

" Theme
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'bluz71/vim-nightfly-colors', { 'as': 'nightfly' }

" Misc
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'segeljakt/vim-stealth'
Plug 'direnv/direnv.vim'
Plug 'vimwiki/vimwiki'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'vim-scripts/sessionman.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
" Plug 'ryanoasis/vim-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lualine/lualine.nvim'

" Languages
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'plasticboy/vim-markdown'


call plug#end()

