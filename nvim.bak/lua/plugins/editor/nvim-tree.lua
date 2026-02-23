return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          adaptive_size = true,
          side = "left",
        },
        renderer = {
          group_empty = true,
          icons = {
            git_placement = "signcolumn",
            show = {
              folder = true,
              file = true,
            },
          },
        },
        filters = {
          dotfiles = false,
          git_ignored = true,
          custom = {
            "^.git$",
          },
          exclude = {
            ".notes.md",
            ".env",
          },
        },
        update_focused_file = {
          enable = true,
          update_root = false,
          ignore_list = {},
        },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")

          local function opts(desc)
            return {
              desc = "nvim-tree: " .. desc,
              buffer = bufnr,
              noremap = true,
              silent = true,
              nowait = true,
            }
          end

          api.config.mappings.default_on_attach(bufnr)

          vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Up"))
          vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
          vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
          vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
        end,
      })
      -- Key maps
      vim.keymap.set("n", "cc", ":NvimTreeToggle<CR>", { noremap = true })
    end,
  },
}
