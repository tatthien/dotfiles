call plug#begin(stdpath('config') . '/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'voldikss/vim-floaterm'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'

Plug 'tpope/vim-commentary'

Plug 'elzr/vim-json', {'for' : 'json'}
Plug 'posva/vim-vue'
Plug 'pangloss/vim-javascript'
Plug 'cespare/vim-toml'
Plug 'plasticboy/vim-markdown'
Plug 'digitaltoad/vim-pug', {'for': 'vue'}

Plug 'Yggdroot/indentLine'

Plug 'gruvbox-community/gruvbox'

Plug 'airblade/vim-gitgutter'

Plug 'jiangmiao/auto-pairs'

" Snippet
Plug 'SirVer/ultisnips'

" Go
Plug 'fatih/vim-go'

call plug#end()

colorscheme gruvbox

set nocompatible
filetype off
filetype plugin indent on

set laststatus=2
set encoding=utf-8              " Set default encoding to UTF-8
set autoread                    " Automatically reread changed files without asking me anything
set autoindent                  
set backspace=indent,eol,start  " Makes backspace key more powerful.
set incsearch                   " Shows the match while typing
set hlsearch                    " Highlight found searches
set number                   " Show line numbers
set relativenumber
set showcmd                  " Show me what I'm typing
set noswapfile               " Don't use swapfile
set nobackup                 " Don't create annoying backup files
set fileformats=unix,dos,mac " Prefer Unix over Windows over OS 9 formats
set smartcase

" Tabsize
set tabstop=2
set shiftwidth=2
set expandtab

autocmd Filetype php setlocal tabstop=4 shiftwidth=4
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4

" Ensure tabs don't get converted to spaces in Makefiles.
autocmd Filetype make setlocal noexpandtab

" Config: Keys binding
" Better split switching
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

inoremap ww <Esc>:w<CR>
inoremap jj <Esc>
inoremap jk <Esc>
tnoremap <Esc> <C-\><C-n>

" Config: nerdtree
nnoremap cc :NERDTreeToggle<CR>
nnoremap cf :NERDTreeFind<CR>

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeMinimalUI = 1

" Config: fzf
nnoremap <C-f> :Files<CR>
nnoremap ag :Ag<CR>
nnoremap w :b<space>

" Config: floaterm
nnoremap <silent> ft :FloatermNew<CR>
nnoremap <silent> tt :FloatermToggle<CR>
nnoremap <silent> fn :FloatermNext<CR>

let g:floaterm_position = 'bottom'
let g:floaterm_width = 0.99
let g:floaterm_height = 0.4
let g:floaterm_title = '🎏'

" Config: tmuxline
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'win'  : '#I #W',
      \'cwin' : '#I #W',
      \'x'    : '%a',
      \'y'    : '%Y-%m-%d %H:%M',
      \'z'    : ' #h',
      \'options' : {'status-justify' : 'left', 'status-position' : 'top'}}

let g:tmuxline_powerline_separators = 0

" Config: markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_fenced_languages = ['go=go', 'viml=vim', 'bash=sh']
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_extensions_in_markdown = 1

" Config: vim-go
let g:go_imports_mode="gopls"
let g:go_imports_autosave=1

augroup go
  autocmd!

  autocmd FileType go nmap <silent> <Leader>r <Plug>(go-run)
  autocmd FileType go nmap <silent> <Leader>t <Plug>(go-test)
augroup END

" Config: provider
" https://neovim.io/doc/user/provider.html
let g:python3_host_prog = '/usr/local/bin/python3'
let g:python_host_prog = '/usr/bin/python'

" Config: snippet
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'  
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:UltiSnipsListSnippets='<c-l>'
let g:UltiSnipsSnippetDirectories=[$HOME.'/dotfiles/vim-snippets']
