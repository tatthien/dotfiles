call plug#begin(stdpath('config') . '/plugged')

" Files: searching, tree
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'

" Floaterm
Plug 'voldikss/vim-floaterm'

" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Status line
Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'

" Code commenting
Plug 'tpope/vim-commentary'

" Code highlighting
Plug 'posva/vim-vue'
Plug 'pangloss/vim-javascript'
Plug 'cespare/vim-toml'
Plug 'plasticboy/vim-markdown'
Plug 'digitaltoad/vim-pug', {'for': 'vue'}

Plug 'Yggdroot/indentLine'

" Theme
Plug 'gruvbox-community/gruvbox'

" Git
Plug 'airblade/vim-gitgutter'

Plug 'jiangmiao/auto-pairs'

" Snippet
Plug 'SirVer/ultisnips'

" Go
Plug 'fatih/vim-go'

" Tagbar: a class outline viewer for Vim
Plug 'preservim/tagbar'

call plug#end()

set termguicolors
let g:gruvbox_italic=1
colorscheme gruvbox

" Enable italics (this line must be placed after colorscheme)
highlight Comment cterm=italic

set nocompatible

filetype on
filetype plugin on
filetype plugin indent on

set laststatus=2
set encoding=utf-8              " Set default encoding to UTF-8
set autoread                    " Automatically reread changed files without asking me anything
               
set backspace=indent,eol,start  " Makes backspace key more powerful.
set incsearch                   " Shows the match while typing
set hlsearch                    " Highlight found searches
set number                      " Show line numbers
set relativenumber
set showcmd                     " Show me what I'm typing
set noswapfile                  " Don't use swapfile
set nobackup                    " Don't create annoying backup files
set fileformats=unix,dos,mac    " Prefer Unix over Windows over OS 9 formats

set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set autoindent   
set smartindent

set ignorecase
set smartcase

" Tabsize
autocmd FileType css setlocal tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType json setlocal tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType php setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd FileType make setlocal noexpandtab

" Config: Keys mapping
" Better split switching
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

inoremap ww <Esc>:w<CR>
inoremap jj <Esc>
inoremap jk <Esc>
tnoremap <Esc> <C-\><C-n>

" Enable movement by screen line instead of movement by line for j, k
nnoremap j gj
nnoremap k gk

" Toggle wrap
nnoremap <leader>z :set wrap!<CR>

" vim-plug
nnoremap <leader>p :PlugInstall<CR>
nnoremap <leader>u :PlugUpdate<CR>

" Source nvim easily
nnoremap <Leader>sv :source $MYVIMRC<CR>

" Copy & page
noremap <C-c> "*y
noremap <C-v> "*p

" Config: nerdtree
nnoremap cc :NERDTreeToggle<CR>
nnoremap cf :NERDTreeFind<CR>

let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.swp$', '\.git$', '\.vscode$', '\.idea$']
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeMinimalUI = 1

" Config: fzf
nnoremap <C-f> :Files<CR>
nnoremap <C-p> :GFiles<CR>
nnoremap ; :Buffer<CR>
nnoremap ag :Ag<CR>
nnoremap w :b<space>

" Config: floaterm
nnoremap <silent> ft :FloatermNew<CR>
nnoremap <silent> tt :FloatermToggle<CR>
nnoremap <silent> fn :FloatermNext<CR>

let g:floaterm_position = 'bottom'
let g:floaterm_width = 0.99
let g:floaterm_height = 0.5
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
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
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

" Config: tagbar
nnoremap <C-t> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
