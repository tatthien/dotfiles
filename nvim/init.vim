source $HOME/.config/nvim/plug.vim
source $HOME/.config/nvim/color.vim
source $HOME/.config/nvim/maps.vim

" Enable italics (this line must be placed after colorscheme);
highlight Comment cterm=italic

" Highlight line
set cursorline
highlight Cursorline term=bold cterm=bold

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
set noshowmode                  " Don't show the default -- INSERT -- mode because the mode information is displayed in the statusline
set autoindent 
set foldmethod=manual

set ignorecase
set smartcase

set shell=fish

autocmd FileType css setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType html setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType javascript setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType typescript setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType json setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType yaml setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 

autocmd FileType php setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd FileType make setlocal noexpandtab

autocmd BufNewFile,BufRead *.vue set filetype=html setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd BufNewFile,BufRead *.scss setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd BufNewFile,BufRead *.vim setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd BufNewFile,BufRead *.fish setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd BufNewFile,BufRead *.proto setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd BufNewFile,BufRead *.md set filetype=markdown 
autocmd BufNewFile,BufRead *.mdx set filetype=markdown 

" Fix json file without any quotes
" https://stackoverflow.com/questions/40601818/vim-displays-json-file-without-any-quotes
autocmd Filetype json
  \ let g:indentLine_setConceal = 0 |
  \ let g:vim_json_syntax_conceal = 0


" Config: provider
" https://neovim.io/doc/user/provider.html
let g:python3_host_prog = '/usr/local/bin/python3'
let g:python_host_prog = '/usr/bin/python'

" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
  \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl NoneA

" ---------------------
"  PLUGIN CONFIG
" ---------------------
" Config: floatterm
let g:floaterm_position = 'bottom'
let g:floaterm_width = 0.99
let g:floaterm_height = 0.5

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

