source $HOME/.config/nvim/plug.vim

if (has('termguicolors'))
  set termguicolors
endif

colorscheme material
let g:material_terminal_italics = 1
let g:material_theme_style = 'default'
let g:lightline = { 'colorscheme': 'material_vim' }

" Enable italics (this line must be placed after colorscheme)
highlight Comment cterm=italic

" Highlight line
set cursorline
highlight Cursorline term=bold cterm=bold guibg=#37474f

set nocompatible

filetype on
filetype plugin on
filetype plugin indent on

set laststatus=2
set encoding=UTF-8              " Set default encoding to UTF-8
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

set autoindent   

set ignorecase
set smartcase

autocmd FileType css setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType html setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType javascript setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType typescript setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType json setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 

autocmd FileType php setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd FileType make setlocal noexpandtab

autocmd BufNewFile,BufRead  *.vue setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd BufNewFile,BufRead  *.vim setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd BufNewFile,BufRead  *.fish setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd BufNewFile,BufRead  *.proto setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 

" Fix json file without any quotes
" https://stackoverflow.com/questions/40601818/vim-displays-json-file-without-any-quotes
autocmd Filetype json
  \ let g:indentLine_setConceal = 0 |
  \ let g:vim_json_syntax_conceal = 0

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

" Source nvim easily
nnoremap <Leader>sv :source $MYVIMRC<CR>

" Copy & page
noremap <C-c> "*y
noremap <C-v> "*p

" Re-indent entire buffer
noremap <Leader>re gg=G

"Config: vim-plug
nnoremap <leader>p :PlugInstall<CR>
nnoremap <leader>u :PlugUpdate<CR>


" Config: nerdtree
nnoremap cc :NERDTreeToggle<CR>
nnoremap cf :NERDTreeFind<CR>

let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.swp$', '\.git$', '\.vscode$', '\.idea$', '.DS_Store', 'node_modules$']
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeMinimalUI = 1

" Config: fzf
nnoremap ff :Files<CR>
nnoremap gf :GFiles<CR>
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

" Config: vim-go
let g:go_imports_mode='gopls'
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
