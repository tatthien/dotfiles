if (has('termguicolors'))
  set termguicolors
  set winblend=0
  set wildoptions=pum
  set pumblend=5
  set background=dark
 
  " Github
  " let g:github_comment_style = "italic"
  " let g:github_sidebars = ["qf", "vista_kind", "terminal", "packer"]
  " let g:github_colors = {
  "   \ 'hint': 'orange',
  "   \ 'error': '#ff0000'
  " \ }
  " colorscheme github_dark_default
endif

lua << EOF
require("tokyonight").setup({
  style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
  light_style = "day", -- The theme is used when the background is set to light
  transparent = false, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
  sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  dim_inactive = false, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
  on_colors = function(colors) end,
  on_highlights = function(highlights, colors) end,
})
EOF

colorscheme tokyonight
