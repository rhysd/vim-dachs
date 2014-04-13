if exists("b:current_syntax")
  finish
endif

" Function
syn region dachsFuncBlock matchgroup=dachsFuncDefine start="\<\%(func\|proc\)\>" end="\%(\<\%(proc\|func\)\_s\+\)\@<!\<end\>" contains=ALL
syn match dachsFuncId "\%(\<\%(func\|proc\)\>\s\+\)\@<=\<[_[:alpha:]][_[:alnum:]]*'\=" contained contains=NONE display

" String
syn match   dachsStringEscape "\\[bfnr"\\]" contained display
syn cluster dachsStringSpecial contains=dachsStringEscape
syn region  dachsString matchgroup=dachsStringDelimiter start="\"" end="\"" skip="\\\\\|\\\"" contains=@dachsStringSpecial,@Spell fold

" Numbers
syn match dachsInteger "\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\)u\=\>" display
syn match dachsFloat "\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\)\.\d\+\>" display
syn match dachsFloat "\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\)\%(\.\d\+\)\=\%([eE][-+]\=\d\+\)\>" display

" Boolean
syn match dachsBoolean "\<\%(true\|false\)\>[?!']\@!"

" Operators
syn match dachsOperator "[~!^&|*/%:+-]\|<=\|>=\|==\|<<\|>>\|:=\|=\|\.\.\.\|\.\."
syn match dachsOperator "-=\|/=\|\*=\|&&=\|&=\|&&\|||=\||=\|||\|%=\|+=\|!=\|\^="

" Control
syn match dachsControl "\<\%(return\|next\|break\|as\)\>[?!']\@!"

" Comment
syn match   dachsSharpBang "\%^#!.*" display
syn keyword dachsTodo FIXME NOTE TODO XXX contained
syn match   dachsComment "#[^#]*#\=" contains=dachsSharpBang,dachsTodo,@Spell display

" Type
syn match dachsBuiltinTypes "\<\%(int\|float\|char\|string\)\>[!']\@!" contained contains=NONE display
syn match dachsBuiltinTypes "\%(\%(:\|as\)\s.*\)\@<=\<range\>(\@=" contained contains=NONE display

hi def link dachsInteger            Number
hi def link dachsFloat              Float
hi def link dachsBoolean            Boolean
hi def link dachsOperator           Operator
hi def link dachsSharpBang          PreProc
hi def link dachsComment            Comment
hi def link dachsTodo               Todo
hi def link dachsControl            Statement
hi def link dachsFuncDefine         Define
hi def link dachsFuncId             Function
hi def link dachsStringEscape       Special
hi def link dachsStringDelimiter    Delimiter
hi def link dachsString             String
hi def link dachsBuiltinTypes       Type
hi def link dachsTypeSigns          Type

let b:current_syntax = "dachs"
