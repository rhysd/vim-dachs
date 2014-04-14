" if exists("b:current_syntax")
"   finish
" endif
syntax clear

syn cluster dachsNotTop contains=dachsStringEscape,dachsFuncBlock,dachsConditional,dachsTodo,dachsBuiltinTypes,dachsInitializeVar,dachsInitializeVarName

" Function
syn region dachsFuncBlock matchgroup=dachsFuncDefine start="\<\%(func\|proc\)\>" end="\%(\<\%(proc\|func\)\_s\+\)\@<!\<end\>" contains=ALLBUT,@dachsNotTop fold
syn match dachsFuncId "\%(\<\%(func\|proc\)\>\s\+\)\@<=\<[_[:alpha:]][_[:alnum:]]*'\=" contained contains=NONE display

" String
syn match   dachsStringEscape "\\[bfnr"\\]" contained display
syn cluster dachsStringSpecial contains=dachsStringEscape
syn region  dachsString matchgroup=dachsStringDelimiter start="\"" end="\"" skip="\\\\\|\\\"" contains=@dachsStringSpecial,@Spell

" Numbers
syn match dachsInteger "\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\)u\=\>" display
syn match dachsFloat "\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\)\.\d\+\>" display
syn match dachsFloat "\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\)\%(\.\d\+\)\=\%([eE][-+]\=\d\+\)\>" display

" Boolean
syn match dachsBoolean "\<\%(true\|false\)\>[?!']\@!" display

" Operators
syn match dachsOperator "[~!^&|*/%:+-]\|<=\|>=\|==\|<<\|>>\|:=\|=\|\.\.\.\|\.\." display
syn match dachsOperator "-=\|/=\|\*=\|&&=\|&=\|&&\|||=\||=\|||\|%=\|+=\|!=\|\^=" display

" Control
syn match  dachsControl "\<\%(return\|next\|break\|as\)\>[?!']\@!" contained display
syn region dachsCaseExpression matchgroup=dachsConditional start="\%(\%(^\|;\)\s*\)\@<=\<case[?!']\@!\>" end="\<end\>" contained contains=ALLBUT,@dachsNotTop fold
syn match  dachsConditional "\<\%(then\|else\|when\)\>[?!']\@!" contained containedin=dachsCaseExpression display
syn region dachsIfStatement matchgroup=dachsConditional start="\%(\%(^\|;\)\s*\)\@<=\<\%(if\|unless\)\>"  end="\<end\>" contained contains=ALLBUT,@dachsNotTop fold
syn match  dachsConditional "\<\%(then\|else\|elseif\)\>[?!']\@!" contained containedin=dachsIfStatement
" XXX: Only one-liner if expression is highlighted
syn region dachsIfExpression matchgroup=dachsConditional start="\%(\%(^\|;\)\s*\)\@<!\<\%(if\|unless\)\>" end="$"
syn match  dachsConditional "\<\%(then\|else\)\>[?!']\@!" contained containedin=dachsIfExpression display
syn region dachsOptionalDoLine   matchgroup=dachsRepeat start="\<for\>[?!']\@!" matchgroup=dachsOptionalDo end="\%(\<do\>\)" end="\ze\%(;\|$\)" oneline contained contains=ALLBUT,@dachsNotTop
syn region dachsRepeatExpression start="\%(\%(^\|;\)\s*\)\@<=\<for\>[?!']\@!" matchgroup=dachsRepeat end="\<end\>" contained contains=ALLBUT,@dachsNotTop nextgroup=dachsOptionalDoLine fold
syn match  dachsOptionalDo "\<in\>[?!']\@!" contained containedin=dachsOptionalDoLine display

" Initialize
syn match dachsInitialize "\%(\%(^\|;\)\s*\)\@<=\%(\<var[?!']\@!\s\+\)\=[_[:alnum:], ]\+\s\+:=" contained contains=ALLBUT,@dachsNotTop transparent
syn match dachsInitializeVarName "\<[_[:alpha:]][_[:alnum:]]*\>" contained containedin=dachsInitialize display
syn match dachsInitializeVar "\<var\>" contained containedin=dachsInitialize display

" Comment
syn match   dachsSharpBang "\%^#!.*" display
syn keyword dachsTodo FIXME NOTE TODO XXX contained
syn match   dachsComment "#[^#]*#\=" contains=dachsSharpBang,dachsTodo,@Spell display

" Type
syn match dachsTypeLeader "\%(\%(:\|as\)\s\+\)\@<=.*" contained contains=ALLBUT,@dachsNotTop transparent
syn match dachsBuiltinTypes "\<\%(int\|float\|char\|string\)\>[!']\@!" contained contains=NONE containedin=dachsTypeLeader display
syn match dachsBuiltinTypes "\%(\%(:\|as\)\s.*\)\@<=\<range\>\%(\s*(\)\@=" contained contains=NONE containedin=dachsTypeLeader display

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
hi def link dachsType               Type
hi def link dachsBuiltinTypes       dachsType
hi def link dachsConditional        Conditional
hi def link dachsRepeat             Repeat
hi def link dachsOptionalDo         rubyRepeat
hi def link dachsInitializeVar      Type
hi def link dachsInitializeVarName  Identifier

let b:current_syntax = "dachs"
