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

ls.add_snippets("typescriptreact", {
	snip("init", fmt([[
	import React from 'react';

	function {}() {{
		return (<>{}</>);
	}}

	export default {};
	]], {
		d(1, function()
			return sn(1, i(1, vim.fn.expand("%:t:r")))
		end),
		i(2),
		rep(1),
	}))
})

ls.add_snippets("typescriptreact", {
	snip("if", fmt([[
	if ({}) {{
		{}
	}}
	]], { i(1), rep(1) }))
})

ls.add_snippets("typescriptreact", {
	snip("else", fmt([[
	else {{
		{}
	}}
	]], {i(1)}))
})


