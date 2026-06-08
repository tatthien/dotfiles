return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Filetypes Biome can handle. Biome only runs when the project has a
      -- biome config (see the condition below); otherwise conform falls back
      -- to prettier via `stop_after_first`, so non-Biome projects are unaffected.
      local biome_supported = {
        "css",
        "graphql",
        "javascript",
        "javascriptreact",
        "json",
        "jsonc",
        "typescript",
        "typescriptreact",
        "vue",
      }

      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(biome_supported) do
        local list = opts.formatters_by_ft[ft] or {}
        -- Try Biome first, fall back to whatever was already configured (prettier).
        table.insert(list, 1, "biome-check")
        list.stop_after_first = true
        opts.formatters_by_ft[ft] = list
      end

      -- `biome check --write` applies formatting + lint safe-fixes + import
      -- sorting in one pass, i.e. the full set of rules from biome.json.
      -- Gate it on the presence of a Biome config so projects still on
      -- prettier/eslint keep using prettier.
      opts.formatters = opts.formatters or {}
      opts.formatters["biome-check"] = {
        condition = require("conform.util").root_file({
          "biome.json",
          "biome.jsonc",
          ".biome.json",
          ".biome.jsonc",
        }),
      }

      return opts
    end,
  },
}
