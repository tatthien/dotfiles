call plug#begin(stdpath('config') . '/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'voldikss/vim-floaterm'
Plug 'ryanoasis/vim-devicons'
" Plug 'digitaltoad/vim-pug'
" Plug 'posva/vim-vue'
Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'

" Theme
Plug 'gruvbox-community/gruvbox'
Plug 'joshdick/onedark.vim'

Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'

" Lsp + autocomplete + treesitter
Plug 'neovim/nvim-lspconfig'
Plug 'windwp/nvim-autopairs'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'hrsh7th/nvim-cmp/'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'onsails/lspkind-nvim'
call plug#end()

