source $HOME/.config/nvim/plug.vim
source $HOME/.config/nvim/color.vim
source $HOME/.config/nvim/maps.vim

" Enable italics (this line must be placed after colorscheme);
hi Comment cterm=italic
hi Folded ctermfg=12 guifg=#565f89 guibg=#1a1b26
hi StatusLine guifg=#565f89 guibg=#313A47
hi VimwikiHeader1 gui=bold guifg=#f7768e
hi VimwikiHeader2 gui=bold guifg=#7ee787
hi VimwikiHeader3 gui=bold guifg=#A5D6FF
hi VimwikiHeader4 gui=bold guifg=#d2a8ff
hi VimwikiHeader5 gui=bold guifg=#00FFFF
hi VimwikiHeader6 gui=bold guifg=#ffa657
hi VimwikiBold gui=bold guifg=#ffa657
hi VimwikiLink gui=underline guifg=#00ffff
hi Cursorline term=bold cterm=bold

" Highlight line
set cursorline

set nocompatible

filetype on
filetype plugin on
filetype plugin indent on

syntax on

" Common settings
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
set notimeout
set fileformats=unix,dos,mac    " Prefer Unix over Windows over OS 9 formats
set noshowmode                  " Don't show the default -- INSERT -- mode because the mode information is displayed in the statusline
set autoindent 
set ruler
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildignore+=node_modules/*,bower_components/*
set ignorecase
set smartcase

set list
set listchars=tab:···,trail:●,precedes:«,extends:»

" Folding configuration
set foldmethod=indent
set foldtext="fold"
set foldnestmax=10
set nofoldenable        " No folding by default
set fillchars=fold:\ "

" Using fish
set shell=fish

autocmd FileType css setlocal expandtab tabstop=2 softtabstop=2 shiftwidth
autocmd FileType html setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType javascript setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType typescript setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType json setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType yaml setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd FileType php setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd FileType make setlocal noexpandtab

autocmd BufNewFile,BufRead *.vue setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 filetype=html 
autocmd BufNewFile,BufRead *.scss setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd BufNewFile,BufRead *.vim setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd BufNewFile,BufRead *.fish setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd BufNewFile,BufRead *.proto setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 
autocmd BufNewFile,BufRead *.md setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.mdx set filetype=markdown 
autocmd BufWritePost *.go normal! zv

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

" Config: vim-go
let g:go_imports_mode='gopls'
let g:go_imports_autosave=1
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_list_type = "quickfix"
let g:go_highlight_build_constraints = 1
let g:go_highlight_operators = 1
let g:go_fold_enable = []

augroup go
  autocmd!
  autocmd FileType go nmap <silent> <Leader>r <Plug>(go-run)
  autocmd FileType go nmap <silent> <Leader>t <Plug>(go-test)
  autocmd FileType go nmap <silent> <Leader>f <Plug>(go-test-func)
  autocmd FileType go nmap <silent> <Leader>i <Plug>(go-doc)
  autocmd FileType go nmap gg <Plug>(go-alternate-edit)
augroup END

" Config: provider
" https://neovim.io/doc/user/provider.html
let g:python3_host_prog = '/usr/local/bin/python3'
let g:python_host_prog = '/usr/bin/python'

" Config: vimwiki
let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

" Config: vim-markdown
let g:vim_markdown_fenced_languages = ['go=go', 'viml=vim', 'bash=sh', 'javascript', 'js=javascript', 'json=json', 'css']
let g:vim_markdown_conceal = 0
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_extensions_in_markdown = 1
