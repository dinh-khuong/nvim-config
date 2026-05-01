; extends

(call function: (attribute
		  object: (identifier) @object
		  attribute: (identifier) @func)
      (#match? @object "*curr*")
      (#match? @func "^execute")
      arguments: (argument_list
		   (string (string_content) @injection.content)
		   (#set! injection.language "sql")
		   ))

(call
  function: (attribute
	      object: (identifier) @object
	      attribute: (identifier) @execute)
  (#match? @object "curr*")
  (#match? @execute "^execute")
  arguments: (argument_list
	       (string (string_content) @injection.content
		       (#set! injection.language "sql")
		       (#set! injection.combined)
		       )))




