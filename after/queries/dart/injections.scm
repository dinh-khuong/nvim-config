; extends

(await_expression 
  (identifier) @object
  (selector
    (unconditional_assignable_selector
      (identifier) @func))
  (#match? @object "db*")
  (#eq? @func "execute")
  (selector
    (argument_part
      (arguments
	(argument
	  (string_literal) @injection.content)
	(#set! injection.language "sql")
	))))


;(call function: (attribute
;        object: (identifier) @object
;        attribute: (identifier) @func)
;	  (#match? @object "conn*")
;	  (#match? @func "execute")
;      arguments: (argument_list
;        (string (string_content) @injection.content)
;		(#set! injection.language "sql")
;		))
;
