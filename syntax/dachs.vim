if exists("b:current_syntax")
    finish
endif

syn cluster dachsNotTop contains=dachsCharacterEscape,dachsStringEscape,dachsFuncBlock,dachsConditional,dachsTodo,dachsBuiltinTypes,dachsInitializeVar,dachsInitializeVarName,dachsIfExprElse,dachsDoBlockHeader,dachsDoBlockParams,dachsClassInit,dachsAccess

" Function
syn region dachsFuncBlock matchgroup=dachsFuncDefine start="\<\%(func\|proc\)\>" end="\%(\<\%(proc\|func\)\_s\+\)\@<!\<end\>" contains=ALLBUT,@dachsNotTop fold
syn match dachsFuncId "\%(\<\%(func\|proc\)\>\s\+\)\@<=\<[_[:alpha:]][_[:alnum:]]*'*" contained contains=NONE display

" Character
syn match dachsCharacterEscape "\\[bfnr'\\]" contained display
syn match dachsCharacter "'\%([^\\]\|\\[bfnr'\\]\)'" contained contains=dachsCharacterEscape display

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
if exists('g:dachs_highlight_operators')
    syn match dachsOperator "[~!^&|*/%:<+-]\|=\@<!>\|<=\|>=\|==\|<<\|>>\|:=\|=\|\.\.\.\|\.\." display
    syn match dachsOperator "-=\|/=\|\*=\|&&=\|&=\|&&\|||=\||=\|||\|%=\|+=\|!=\|\^=" display
endif
syn match dachsNew "\<new\>[?!']\@!" contained


" Control
syn match  dachsControl "\<\%(ret\|next\|break\|as\|do\)\>[?!']\@!" contained display
syn region dachsCaseExpression matchgroup=dachsConditional start="\%(\%(^\|;\)\s*\|\<in\>\_s\+\)\@<=\<case[?!']\@!\>" end="\<end\>" contained contains=ALLBUT,@dachsNotTop fold
syn match  dachsConditional "\<\%(then\|else\|when\)\>[?!']\@!" contained containedin=dachsCaseExpression display
syn region dachsIfStatement matchgroup=dachsConditional start="\%(\%(^\|;\)\s*\|\<in\>\_s\+\)\@<=\<\%(if\|unless\)\>"  end="\<end\>" contained contains=ALLBUT,@dachsNotTop fold
syn match  dachsConditional "\<\%(then\|else\|elseif\)\>[?!']\@!" contained containedin=dachsIfStatement display
syn region dachsIfExprThen matchgroup=dachsConditional start="\%(\%(^\|;\)\s*\)\@<!\<\%(if\|unless\)\>[?!']\@!" matchgroup=dachsConditional end="\<then[!?']\@!\>" end="\ze\%(;\|$\)" oneline contained contains=ALLBUT,@dachsNotTop nextgroup=dachsIfExprElse skipwhite
syn region dachsIfExprElse start="\%(\<then\>\_s\+\)\@<=\zs" matchgroup=dachsConditional end="\<else\>" contained containedin=NONE contains=ALLBUT,@dachsNotTop
syn region dachsRepeatStatement matchgroup=dachsRepeat start="\%(\%(^\|;\)\s*\|\<in\>\_s\+\)\@<=\<for\>[?!']\@!" matchgroup=dachsRepeat end="\<end\>" contained contains=ALLBUT,@dachsNotTop fold
syn match dachsRepeatForIn "\%(\%(\%(^\|;\)\s*\|\<in\>\_s\+\)\@<=\<for\>[?!']\@!\%(.\%(\<in\>\)\@!\)*\s\)\@<=\<in\>" contained containedin=dachsRepeatStatement display
syn region dachsDoBlock matchgroup=dachsControl start="\<do\>[?!']\@!" matchgroup=dachsControl end="\<end\>" contained contains=ALLBUT,@dachsNotTop fold
syn region dachsDoBlockParameterList start="\%(\%(\<do\|{\)\s*\)\@<=|" end="|" oneline contains=dachsDoBlockParams display
syn match dachsDoBlockParams "[_[:alpha:]][_[:alnum:]]*" contained containedin=dachsDoBlockHeader contains=ALLBUT,@dachsNotTop display
syn region dachsLetInStatement matchgroup=dachsControl start="\<let\>[?!']\@!" matchgroup=dachsControl end="\<in\>" contained contains=ALLBUT,@dachsNotTop
" syn region dachsLambdaOneLine matchgroup=dachsControl start="->" matchgroup=dachsControl end="\<in\>\|.\%(\<do\>\)\@=" oneline contained contains=ALLBUT,@dachsNotTop fold
syn match dachsLambda "->" display
syn match dachsLambdaIn "\%(->.\+\)\@<=\<in\>" display

" Initialize
syn match dachsInitialize "\%(\%(^\|;\)\s*\|\<in\>\_s\+\)\@<=\%(\<var[?!']\@!\s\+\)\=[_[:alnum:], ]\+\s\+:=" contained contains=ALLBUT,@dachsNotTop transparent
syn match dachsInitializeVarName "[_[:alpha:]][_[:alnum:]]*" contained containedin=dachsInitialize,dachsTypeLeader display

" Comment
syn match   dachsSharpBang "\%^#!.*" display
syn keyword dachsTodo FIXME NOTE TODO XXX contained
syn match   dachsComment "#[^#]*#\=" contains=dachsSharpBang,dachsTodo,@Spell display

" Type
syn match dachsTypeLeader "\%(\%(:\|as\)\s\+\)\@<=.*" contained contains=ALLBUT,@dachsNotTop transparent
syn match dachsBuiltinTypes "\<\%(int\|float\|char\|string\|uint\|bool\|symbol\)\>[!']\@!" contained contains=NONE containedin=dachsTypeLeader display
syn match dachsBuiltinTypes "\%(\%(:\|as\)\s.*\)\@<=\<range\>\%(\s*(\)\@=" contained contains=NONE containedin=dachsTypeLeader display
syn match dachsVar "\<var\>[?!']\@!"

" Ctor
syn region dachsClassInit matchgroup=dachsFuncDefine start="\<init\>" end="\<end\>" contains=ALLBUT,@dachsNotTop fold

" Class
syn match dachsClassName "\%(\<class\_s\+\)\@<=\<[_[:alpha:]][_[:alnum:]]*" contained containedin=dachsClassBlock display
syn region dachsClassBlock matchgroup=dachsClassDefine start="\<class\>" matchgroup=dachsClassDefine end="\%(\<class\_s\+\)\@<!\<end\>" contains=TOP contains=dachsAccess fold
syn match dachsAccess "[+-]" contained containedin=dachsClassBlock display
syn match dachsInstanceVar "@[_[:alpha:]][_[:alnum:]]*"

let g:dachs_highlight_minlines = get(g:, 'dachs_highlight_minlines', 500)
exec "syn sync minlines=" . g:dachs_highlight_minlines

hi def link dachsInteger            Number
hi def link dachsFloat              Float
hi def link dachsBoolean            Boolean
hi def link dachsOperator           Operator
hi def link dachsSharpBang          PreProc
hi def link dachsComment            Comment
hi def link dachsTodo               Todo
hi def link dachsDoBlockParams      Identifier
hi def link dachsControl            Statement
hi def link dachsFuncDefine         Define
hi def link dachsFuncId             Function
hi def link dachsVar                Type
hi def link dachsCharacterEscape    Special
hi def link dachsCharacter          Character
hi def link dachsStringEscape       Special
hi def link dachsStringDelimiter    Delimiter
hi def link dachsString             String
hi def link dachsType               Type
hi def link dachsBuiltinTypes       dachsType
hi def link dachsConditional        Conditional
hi def link dachsRepeat             Repeat
hi def link dachsRepeatForIn        Repeat
hi def link dachsInitializeVarName  Identifier
hi def link dachsNew                Operator
hi def link dachsLambda             Statement
hi def link dachsLambdaIn           Statement
hi def link dachsClassDefine        Define
hi def link dachsClassName          Type
hi def link dachsAccess             Statement
hi def link dachsInstanceVar        Identifier

let b:current_syntax = "dachs"
