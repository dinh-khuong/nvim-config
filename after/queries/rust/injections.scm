; extends

((string_content) @string.rust (#set! "priority" 90))
((raw_string_literal) @string.rust (#set! "priority" 90))

(
 macro_invocation
 (scoped_identifier) @shader_ident
	(#eq? @shader_ident "vulkano_shaders::shader")
	(token_tree
		(identifier) @src_ident
		(#eq? @src_ident "src")
		(raw_string_literal
			(string_content) @injection.content
			(#set! injection.language "glsl")
			) 
		)
 ) 



