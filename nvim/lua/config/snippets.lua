local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Allow typescript snippets to be used in typescriptreact (tsx)
ls.filetype_extend("typescriptreact", { "typescript" })

ls.add_snippets("typescript", {
  -- Shared snippets for ts and tsx
  s("cl", {
    t("console.log('>>>', "),
    i(1),
    t(")"),
  }),
})

ls.add_snippets("typescriptreact", {
  -- React specific snippets
  s("uef", {
    t("useEffect(() => {"),
    i(1),
    t("}, [])"),
  }),
})
