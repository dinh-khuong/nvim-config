; extends

(macro_invocation
 (scoped_identifier) @shader_ident
 (#eq? @shader_ident "vulkano_shaders::shader")
 (token_tree
   (identifier) @src_ident
   (#eq? @src_ident "src")
   (raw_string_literal
     (string_content) (#set! "priority" 90)
     )
   )
 ) 
