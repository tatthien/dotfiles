return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "astro",
          "bash",
          "cmake",
          "cpp",
          "css",
          "diff",
          "fish",
          "gitcommit",
          "gitignore",
          "go",
          "gomod",
          "gowork",
          "gosum",
          "graphql",
          "hcl",
          "http",
          "java",
          "jsdoc",
          "jsonc",
          "php",
          "regex",
          "rust",
          "scss",
          "sql",
          "svelte",
          "terraform",
          "toml",
          "typescript",
          "javascript",
          "tsx",
          "json",
          "lua",
          "luadoc",
          "markdown",
          "markdown_inline",
          "vim",
          "vimdoc",
          "yaml",
          "html",
          "xml",
          "python",
          "dockerfile",
        },
        auto_install = true,
      })

      -- MDX filetype
      vim.filetype.add({
        extension = {
          mdx = "mdx",
        },
      })
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    config = function()
      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      -- Textobjects: select
      vim.keymap.set({ "x", "o" }, "aa", function()
        select.select_textobject("@parameter.outer", "textobjects")
      end, { desc = "Select outer parameter" })
      vim.keymap.set({ "x", "o" }, "ia", function()
        select.select_textobject("@parameter.inner", "textobjects")
      end, { desc = "Select inner parameter" })
      vim.keymap.set({ "x", "o" }, "af", function()
        select.select_textobject("@function.outer", "textobjects")
      end, { desc = "Select outer function" })
      vim.keymap.set({ "x", "o" }, "if", function()
        select.select_textobject("@function.inner", "textobjects")
      end, { desc = "Select inner function" })
      vim.keymap.set({ "x", "o" }, "ac", function()
        select.select_textobject("@class.outer", "textobjects")
      end, { desc = "Select outer class" })
      vim.keymap.set({ "x", "o" }, "ic", function()
        select.select_textobject("@class.inner", "textobjects")
      end, { desc = "Select inner class" })
      vim.keymap.set({ "x", "o" }, "aB", function()
        select.select_textobject("@block.outer", "textobjects")
      end, { desc = "Select outer block" })
      vim.keymap.set({ "x", "o" }, "iB", function()
        select.select_textobject("@block.inner", "textobjects")
      end, { desc = "Select inner block" })

      -- Textobjects: move
      vim.keymap.set({ "n", "x", "o" }, "]]", function()
        move.goto_next_start("@function.outer", "textobjects")
      end, { desc = "Next function start" })
      vim.keymap.set({ "n", "x", "o" }, "][", function()
        move.goto_next_end("@function.outer", "textobjects")
      end, { desc = "Next function end" })
      vim.keymap.set({ "n", "x", "o" }, "[[", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end, { desc = "Previous function start" })
      vim.keymap.set({ "n", "x", "o" }, "[]", function()
        move.goto_previous_end("@function.outer", "textobjects")
      end, { desc = "Previous function end" })

      -- Textobjects: swap
      vim.keymap.set("n", "<leader>sn", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "Swap next parameter" })
      vim.keymap.set("n", "<leader>sp", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "Swap previous parameter" })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },
}
