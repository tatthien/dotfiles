return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    version = false,
    opts_extend = { "ensure_installed" },
    opts = {
      highlight = {
        enable = true,
        -- Disable slow treesitter highlight for large files
        -- https://github.com/fatih/dotfiles/blob/main/init.lua#L130C11-L137C15
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = { enable = true },
      ensure_installed = {
        "astro",
        "cmake",
        "cpp",
        "css",
        "fish",
        "gitignore",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "graphql",
        "http",
        "java",
        "php",
        "rust",
        "scss",
        "sql",
        "svelte",
        "typescript",
        "javascript",
        "tsx",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "vim",
        "yaml",
        "html",
        "xml",
        "python",
        "dockerfile",
      },
      auto_install = true,
      -- https://github.com/fatih/dotfiles/blob/main/init.lua#L145
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["iB"] = "@block.inner",
            ["aB"] = "@block.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]]"] = "@function.outer",
          },
          goto_next_end = {
            ["]["] = "@function.outer",
          },
          goto_previous_start = {
            ["[["] = "@function.outer",
          },
          goto_previous_end = {
            ["[]"] = "@function.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>sn"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>sp"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts)
      -- require("nvim-treesitter.configs").setup(opts)

      -- MDX
      vim.filetype.add({
        extension = {
          mdx = "mdx",
        },
      })
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },
}
