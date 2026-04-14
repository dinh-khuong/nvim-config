; extends

(template_string
	(string_fragment) @injection.content 
	(#match? @injection.content "<[a-zA-Z0-9]+.*>")
	(#set! injection.language "html")
)

