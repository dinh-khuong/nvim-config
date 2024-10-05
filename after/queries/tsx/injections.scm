; extends

(call_expression
  (member_expression
    (identifier) @styled)
  (template_string
    (string_fragment) @css)
  (#eq? @styled "styled")) 

((string_fragment) @css
		   (#match? @css "[a-zA-Z]+: [a-zA-Z0-9]+;"))

(variable_declarator
  name: (identifier) @var
  value: (string) @injection.content
  (#match? @var "html|Html|HTML")
  (#set! injection.language "html"))

(variable_declarator
  name: (identifier) @var
  value: (template_string (string_fragment) @injection.content)
  (#match? @var "html|Html|HTML")
  (#set! injection.language "html"))

(variable_declarator
  name: (identifier) @var
  value: (template_string (string_fragment) @injection.content)
  (#match? @var "script|Script|js")
  (#set! injection.language "js"))

