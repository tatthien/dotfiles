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
    "vue",
    "hcl",
  },
  autotag = {
    enable = true,
  },
  auto_install = true,
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
