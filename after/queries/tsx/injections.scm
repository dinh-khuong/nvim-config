; extends

(call_expression
	(member_expression
		(identifier) @styled)
	(template_string
		(string_fragment) @css)
		(#eq? @styled "styled")) 

((string_fragment) @css
 (#match? @css "[a-zA-Z]+: [a-zA-Z0-9]+;"))


