return {
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-jest",
    },
    opts = {
      adapters = {
        ["neotest-jest"] = {
          -- jestCommand, jestConfigFile, cwd, etc. auto-resolve if omitted;
          -- e.g. jestCommand = "npm test --",
        },
      },
    },
  },
}
