return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Biome wiring lives in the `lang.typescript.biome` extra (see lazy.lua):
      -- it registers `biome-check` with `require_cwd = true` so it only runs in
      -- projects that have a biome.json, and otherwise falls back to prettier.
      return opts
    end,
  },
}
