return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { ".git/" },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          live_grep = {
            additional_args = function()
              return { "--hidden", "--ignore-case" }
            end,
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("live_grep_args")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "ff", builtin.find_files, { desc = "Search files" })
      vim.keymap.set("n", ";g", builtin.git_files, { desc = "Search git files" })
      vim.keymap.set(
        "n",
        ";r",
        ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
        { desc = "Search by grep" }
      )
      vim.keymap.set("n", ";e", builtin.diagnostics, { desc = "Telescope: Search diagnostics" })
      vim.keymap.set("n", ";;", builtin.resume, { desc = "Telescope: Resume last search" })
      vim.keymap.set("n", ";t", builtin.help_tags, { desc = "Telescope: Search help tags" })
      vim.keymap.set("n", ";k", builtin.keymaps, { desc = "Telescope: Search keymaps" })
    end,
  },
}
