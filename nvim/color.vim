if (has('termguicolors'))
  syntax enable
  set termguicolors
  set winblend=0
  set wildoptions=pum
  set pumblend=5
  set background=dark
 
  " Use NeoSolarized
  " let g:neosolarized_termtrans=1
  " runtime ./colors/NeoSolarized.vim
  " colorscheme NeoSolarized
  
  let g:rasmus_bold_keywords = 1
  let g:rasmus_italic_functions = 1
  let g:rasmus_bold_functions = 1
  colorscheme rasmus
endif

" let g:gruvbox_italic = 1
" let g:gruvbox_italicize_strings = 0
" let g:gruvbox_contrast_dark = 'medium'
" colorscheme gruvbox

" let g:onedark_terminal_italics = 1
" colorscheme onedark

" let ayucolor="mirage"
" colorscheme ayu

" colorscheme vitesse
