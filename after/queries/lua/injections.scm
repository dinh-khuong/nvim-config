; extends

((string_content) @sql
	(#match? @sql ".*-- sql.*")
 )

((string_content) @css
	(#match? @css ".*-- css.*")
 )

(variable_declaration
	(assignment_statement
		(variable_list (identifier) @type)
		(expression_list (string (string_content) @css))
		(#eq? @type "css")
	)
 )

(variable_declaration
	(assignment_statement
		(variable_list (identifier) @type)
		(expression_list (string (string_content) @sql))
		(#eq? @type "query")
	)
 )

