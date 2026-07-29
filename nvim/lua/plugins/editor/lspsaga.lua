return {
  "nvimdev/lspsaga.nvim",
  config = function()
    require("lspsaga").setup({})
  end,
  keys = {
    { "gp", "<cmd>Lspsaga peek_definition<CR>", desc = "Lspsaga: Peek Definition" },
  },
}
