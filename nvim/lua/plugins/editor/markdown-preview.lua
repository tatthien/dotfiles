-- Browser-based markdown preview. LazyVim's lang.markdown extra already ships a
-- spec for this plugin, so this file only layers on what it doesn't set; the two
-- are merged by lazy.nvim. Note it also has to be absent from plugins/disabled.lua,
-- which is where it used to be turned off.
--
-- `build` is deliberately NOT set here: the upstream README suggests
-- "cd app && yarn install", but yarn isn't installed on this machine, and LazyVim's
-- inherited build calls mkdp#util#install() instead — same result, no yarn needed.
return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
}
