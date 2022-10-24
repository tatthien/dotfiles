if !exists('g:loaded_nvim_treesitter')
  echo "Not loaded treesitter"
  finish
endif

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = true
  },
  indent = {
    enable = true,
    disable = {},
  },
  ensure_installed = {
    "toml",
    "fish",
    "php",
    "json",
    "yaml",
    "html",
    "css",
    "scss",
    "javascript",
    "typescript",
    "go",
    "vue"
  },
  autotag = {
    enable = true,
  }
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
EOF
