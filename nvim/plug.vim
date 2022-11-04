call plug#begin(stdpath('config') . '/plugged')

Plug 'kyazdani42/nvim-tree.lua'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'ryanoasis/vim-devicons'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lualine/lualine.nvim'

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
Plug 'plasticboy/vim-markdown'

" Theme
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

" Indention
Plug 'lukas-reineke/indent-blankline.nvim'

" Editorconfig
Plug 'editorconfig/editorconfig-vim'

" Toggle the visibility of comments
Plug 'segeljakt/vim-stealth'

" Integrate direnv
Plug 'direnv/direnv.vim'

" Vim Wiki
Plug 'vimwiki/vimwiki'

Plug 'norcalli/nvim-colorizer.lua'

call plug#end()

