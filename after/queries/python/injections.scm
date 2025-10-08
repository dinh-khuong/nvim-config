; extends

(call function: (attribute
        object: (identifier) @object
        attribute: (identifier) @func)
	  (#match? @object "conn*")
	  (#match? @func "execute")
      arguments: (argument_list
        (string (string_content) @injection.content)
		(#set! injection.language "sql")
		))

