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
  
  " RSMS
  " let g:rasmus_bold_keywords = 1
  " let g:rasmus_italic_functions = 1
  " let g:rasmus_bold_functions = 1
  " colorscheme rasmus
  
  " Onedark
  " let g:onedark_terminal_italics = 1
  " colorscheme onedark
  " let g:one_allow_italics = 1 
  " colorscheme one

  " Gruvbox
  " let g:gruvbox_italic = 1
  " let g:gruvbox_italicize_strings = 0
  " let g:gruvbox_contrast_dark = 'medium'
  " colorscheme gruvbox

  " Onedark
  " let g:onedark_terminal_italics = 1
  " colorscheme onedark

  " Ayu mirage
  " let ayucolor="mirage"
  " colorscheme ayu

  " Vitesse
  " colorscheme vitesse
  
  " Tokyonight
  " let g:tokyonight_style = "storm"
  " let g:tokyonight_italic_functions = 1
  " colorscheme tokyonight
  
  " Github
  let g:github_function_style = "italic"
  let g:github_sidebars = ["qf", "vista_kind", "terminal", "packer"]
  let g:github_colors = {
    \ 'hint': 'orange',
    \ 'error': '#ff0000'
  \ }
  colorscheme github_dark
endif

