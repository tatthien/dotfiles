lua << END
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
        { key = "<C-s>", action = "split" },
        { key = "v", action = "vsplit" },
      },
    },
  },
  renderer = {
    group_empty = true,
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
})
END
