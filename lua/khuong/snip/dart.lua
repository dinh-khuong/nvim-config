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

ls.add_snippets("dart", {
  snip("statefull", fmt([[
  class {} extends StatefulWidget {{
    {}();

    @override
    State<StatefulWidget> createState() => _{}();
  }}

  class _{} extends State<{}> {{
    
  }}
  ]], {
      i(1), rep(1), rep(1), rep(1), rep(1)
    }
  ))
})


ls.add_snippets("dart", {
  snip("stateless", fmt([[
  class {} extends StatelessWidget {{
    {}();

  }}
  ]], {
      i(1), rep(1)
    }
  ))
})
