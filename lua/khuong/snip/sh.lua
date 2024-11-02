local ls = require "luasnip";
local types = require "luasnip.util.types"
local extras = require "luasnip.extras"
local snip = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("sh", {
  snip("for", fmt([[
    for {} in {}; do
      {}
    done
  ]], {
      i(1), i(2), i(3),
    }
  ))
})

ls.add_snippets("sh", {
  snip("fun", fmt([[
  function {}() {{
    {}
  }}
  ]], { i(1), i(2) }))

})

ls.add_snippets("sh", {
  snip("if", fmt([[
  if [ {} ]; then
    {}
  fi
  ]], {
      i(1), i(2),
    }
  ))
})
