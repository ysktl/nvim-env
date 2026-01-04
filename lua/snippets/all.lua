local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("hello", {
    t("Hello, world!"),
  }),

  s("todo", {
    t("// TODO: "),
    i(1, "write something"),
  }),
}
