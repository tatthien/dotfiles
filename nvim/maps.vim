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
nnoremap <Leader>z :set wrap!<CR>

" Source nvim easily
nnoremap <Leader>sv :source $MYVIMRC<CR>

" Copy & page
noremap <C-c> "*y
noremap <C-v> "*p

" Re-indent entire buffer
noremap <Leader>re gg=G

" Easily switch between tabs
nnoremap H gT
nnoremap L gt

" Quickly open buffers
nnoremap w :b<space>

" ---------------
" Plugin mapping
" ---------------

" vim-plug
nnoremap <leader>p :PlugInstall<CR>
nnoremap <leader>u :PlugUpdate<CR>

" nvim-tree.vim
nnoremap cc :NvimTreeToggle<CR>
nnoremap cf :NvimTreeFindFile<CR>

" floaterm
nnoremap <silent> ft :FloatermNew<CR>
nnoremap <silent> tt :FloatermToggle<CR>
nnoremap <silent> fn :FloatermNext<CR>


