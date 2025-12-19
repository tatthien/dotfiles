return {
  {
    "glepnir/lspsaga.nvim",
    config = function()
      local status, saga = pcall(require, "lspsaga")
      if not status then
        return
      end

      saga.setup({
        ui = {
          winblend = 10,
          border = "rounded",
        },
        lightbulb = {
          enable = false,
          sign = false,
        },
      })

      local map = function(key, cmd, desc)
        vim.keymap.set("n", key, cmd, { noremap = true, silent = true, desc = desc })
      end

      map("gj", "<Cmd>Lspsaga diagnostic_jump_next<CR>", "LSP: jump next diagnostic")
      map("gk", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", "LSP: jump prev diagnostic")
      map("gp", "<Cmd>Lspsaga peek_definition<CR>", "LSP: show peek definition")
      map("gr", "<Cmd>Lspsaga rename<CR>", "LSP: renaming")
      map("go", "<Cmd>Lspsaga outline<CR>", "LSP: show outline")
      map("gd", "<Cmd>Lspsaga goto_definition<CR>", "LSP: goto definition")
      map("gl", "<Cmd>Lspsaga show_buf_diagnostics<CR>", "LSP: show diagnostics in the current buffer")
      map("gw", "<Cmd>Lspsaga show_workspace_diagnostics<CR>", "LSP: show diagnostics in the current workspace")
      map("gsf", "<Cmd>Lspsaga finder<CR>", "Lspsaga: show finder")
      map("gi", require("telescope.builtin").lsp_implementations, "LSP: goto implementation")
      map("gf", require("telescope.builtin").lsp_references, "LSP: show references")
      map("gD", require("telescope.builtin").lsp_type_definitions, "LSP: goto type definition")
      map("g?", "<cmd>lua vim.diagnostic.open_float()<CR>", "LSP: show line diagnostics")
      map("K", "<Cmd>Lspsaga hover_doc<CR>", "LSP: hover documentation")

      -- code action
      local codeaction = require("lspsaga.codeaction")
      vim.keymap.set("n", "<leader>ca", function()
        codeaction:code_action()
      end, { silent = true })

      vim.keymap.set("v", "<leader>ca", function()
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-U>", true, false, true))
        codeaction:range_code_action()
      end, { silent = true })
    end,
  },
}
