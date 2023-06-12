require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    side = 'left',
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
        { key = "<C-s>", action = "split" },
        { key = "v", action = "vsplit" },
        { key = "c", action = "" },
        { key = "<C-c>", action = "copy" },
      },
    },
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        folder = false,
        file = false,
      }
    }
  },
  filters = {
    dotfiles = false,
    custom = {
      "^.git$"
    }
  },
  update_focused_file = {
    enable = true,
    update_root = false,
    ignore_list = {},
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
})
