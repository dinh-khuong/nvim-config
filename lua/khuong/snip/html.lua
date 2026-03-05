local ls = require 'luasnip'
local types = require 'luasnip.util.types'
local extras = require 'luasnip.extras'
local snip = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local rep = extras.rep
local fmt = require('luasnip.extras.fmt').fmt

ls.add_snippets('html', {
    snip(
        'init',
        fmt(
            [[
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{}</title>
</head>
<body>
    <!-- All visible content goes here -->
    <h1>This is a Heading</h1>
    <p>This is a paragraph.</p>
</body>
</html>
  ]],
            { i(1) }
        )
    ),
})
