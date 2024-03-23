require("khuong.setting.option")
require("khuong.setting.keymap")
require("khuong.autocmd")
require("khuong.helper")
require("khuong.snipconfig")

require("khuong.custom.init")

-- (function_declaration
-- 	name: (identifier) @name (#eq? @name "Find_git_root")
-- 	) @id

-- local query = [[
-- 	select * from user;
-- ]]
--
-- local css = [[
-- 	// -- css 
-- 	background-color: black;
-- 	.user {
-- 		color: black;
-- 	}
-- ]]


-- (call_expression
-- 	function: 
-- 	(member_expression
-- 		object: (identifier) @styled
-- 		(#eq? @styled "styled")
-- 		) 
-- 	arguments: template_string (string_fragment) @css
-- 	) @hello
--




-- local get_root = function(bufnr)
-- 	local parser = vim.treesitter.get_parser(bufnr, "lua", {});
-- 	return parser:parse()[1]:root()
-- end
--
-- local css_string = {}
--
-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	callback = function()
-- 		local bufnr = vim.api.nvim_get_current_buf()
-- 		local root = get_root(bufnr)
-- 		local string_contents = vim.treesitter.query.parse("lua", [[
-- 			(string
-- 				content: (string_content) @string_content
-- 				(#match? @string_content "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$")
-- 			)
-- 			]]
-- 		)
-- 		for _, node in string_contents:iter_captures(root, bufnr, 0, -1) do
-- 			local css = vim.treesitter.get_node_text(node, bufnr)
--
-- 			if css[css] == nil then
-- 				css[css] = true
-- 				local group_name = "Hex" .. string.sub(css, 2, -1)
-- 				vim.api.nvim_set_hl(1, group_name, {
-- 					bg = css,
-- 				})
-- 			end
-- 		end
-- 	end
-- })
