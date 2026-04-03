return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      diagnostics = {
        disabled = { "markdown" },
      },
      servers = {
        vtsls = {
          settings = {
            typescript = {
              tsserver = {
                maxTsServerMemory = 8192,
              },
            },
          },
        },
        eslint = {
          settings = {
            workingDirectory = { mode = "auto" },
          },
        },
      },
    },
  },
}
