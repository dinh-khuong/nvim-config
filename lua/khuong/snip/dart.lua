local types = require "luasnip.util.types"
local ls = require "luasnip";
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
    {}({{super.key}});

    @override
    State<StatefulWidget> createState() => _{}();
  }}

  class _{} extends State<{}> {{
  }}
  ]], {
    i(1), rep(1), rep(1), rep(1), rep(1)
  })),
  snip("stateless", fmt([[
  class {} extends StatelessWidget {{
    {}({{super.key}});
  }}
  ]], {
    i(1), rep(1)
  })),
  snip("widgetnode", fmt([[
  {}(
    child: {},
  )
  ]], {
    i(1), i(2)
  })),
  snip("row", fmt([[
  Row(
    children: [
      {}
    ],
  )
  ]], {
    i(1)
  })),
  snip("column", fmt([[
  Column(
    children: [
      {}
    ],
  )
  ]], {
    i(1)
  })),
})


-- local function fn(
--   args,     -- text from i(2) in this example i.e. { { "456" } }
--   parent,   -- parent snippet or parent node
--   user_args -- user_args from opts.user_args 
-- )
--    return '[' .. user_args .. args[1][1].. ']'
-- end
-- ls.add_snippets("lua", {
--   snip("test", fmt([[
--   {}
--   ]], {
--     f(function()
--       return ""
--     end, {})
--   })),
--   snip("date", fmt([[
--   Current Date: {}
--   ]],
--     {
--       f(function()
--         return os.date("%Y-%m-%d") -- Returns current date as a string
--       end, {})                     -- Pass an empty table {} as the input nodes since there are no dependencies
--     }
--   )),
--   snip("trig", {
--     i(1), t '<-i(1) ',
--     f(fn,  -- callback (args, parent, user_args) -> string
--       {2}, -- node indice(s) whose text is passed to fn, i.e. i(2)
--       { user_args = { "dinh quang " }} -- opts
--     ),
--     t ' i(2)->', i(2), t '<-i(2) i(0)->', i(0)
--   }),
--   snip("trig2", fmt([[
--   {}<-i(1) {} i(2)->{}<-i(2) i(0)->{}
--   ]], {
--       i(1), f(fn, {2}, {user_args = {"dinh quang "}}), i(2), i(3)
--     })),
-- })


