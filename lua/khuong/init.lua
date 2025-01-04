require("khuong.setting.option")
require("khuong.setting.keymap")
require("khuong.setting.autocmd")
require("khuong.setting.command")
require("khuong.custom.init")
require("khuong.setting.highlight")

-- print(
--   vim.fn.argv()[1]
-- )

-- local a = vim.treesitter.query.parse("lua", [[
-- 	(function_call)
-- ]]);

-- vim.treesitter.get_parser

-- local b = TSTree:root()
-- vim.print(b)
-- local bufnr = vim.api.nvim_get_current_buf();
-- local tree = vim.;

-- vim.print(vim.treesitter.query.edit("lua"));
-- vim.print(a:iter_matches(, 1, 0, 9))
-- local tree = vim.treesitter.query.get()
-- vim.print(tree)


-- for pattern, match, metadata in a:iter_matches(tree:root(), bufnr, 0, -1, { all = true }) do
-- 	for id, nodes in pairs(match) do
-- 		local name = query.captures[id]
-- 		for _, node in ipairs(nodes) do
-- 			-- `node` was captured by the `name` capture in the match
--
-- 			local node_data = metadata[id] -- Node level metadata
-- 			-- ... use the info here ...
-- 		end
-- 	end
-- end
-- vim.api.nvim_buf_set_extmark();
-- vim.api.nvim_buf_set_keymap
-- local query_sdfsdf = [[
-- 	select * from user;
-- ]]

-- (call_expression
-- 	function:
-- 	(member_expression
-- 		object: (identifier) @styled
-- 		(#eq? @styled "styled")
-- 		)
-- 	arguments: template_string (string_fragment) @css
-- 	) @hello
