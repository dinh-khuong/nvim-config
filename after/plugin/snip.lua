local ls = require "luasnip";
local types = "luasnip.util.types"
local extra = require "luasnip.extras"
local snip = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local rep = extra.rep

ls.add_snippets("typescriptreact", {
	snip("rafe", {
		t("const "), d(1, function ()
			return sn(1, i(1, vim.fn.expand("%:t:r")))
		end), t({ " = () => {", "" }),
		t("\treturn (<div>"), i(2), t({ "</div>)", "" }),
		t({ "}", "", "" }),
		t("export default "), rep(1), t({ ";", "" })
	})
})

