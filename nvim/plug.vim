call plug#begin(stdpath('config') . '/plugged')

" Plug 'preservim/nerdtree'
Plug 'voldikss/vim-floaterm'

Plug 'nvim-lualine/lualine.nvim'
" Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'

Plug 'ryanoasis/vim-devicons'

Plug 'fatih/vim-go'
Plug 'lewis6991/gitsigns.nvim'

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

" Theme
" Plug 'kvrohit/rasmus.nvim'
" Plug 'joshdick/onedark.vim'
" Plug 'flrnprz/plastic.vim'
" Plug 'rakr/vim-one'
" Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'projekt0n/github-nvim-theme'

" Indention
Plug 'lukas-reineke/indent-blankline.nvim'

" Editorconfig
Plug 'editorconfig/editorconfig-vim'

call plug#end()

