call plug#begin(stdpath('config') . '/plugged')

" Files: searching, tree
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'

" Floaterm
Plug 'voldikss/vim-floaterm'

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

" Icons
Plug 'ryanoasis/vim-devicons'

Plug 'digitaltoad/vim-pug'
Plug 'posva/vim-vue'

" Status line
Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'

" Code commenting
Plug 'tpope/vim-commentary'

" Theme
Plug 'gruvbox-community/gruvbox'

" Git
Plug 'airblade/vim-gitgutter'

" Go
Plug 'fatih/vim-go'
call plug#end()

