if exists('b:did_indent')
  finish
endif

setlocal nosmartindent
setlocal indentexpr=GetDachsIndent(v:lnum)
setlocal indentkeys=!^F,o,O
setlocal indentkeys+==end,=else,=elseif,=when,=ensure,==begin,==end

let s:save_cpo = &cpo
set cpo&vim

let b:undo_indent = 'setlocal '.join([
            \   'smartindent<',
            \   'indentexpr<',
            \   'indentkeys<',
            \ ])

let s:syn_group_skip
            \ = '\<dachs\%(StringEscape\|StringSpecial\|StringDelimiter\|String\|SharpBang\|Comment\)\>'

let s:syn_group_indent
            \ = '^\s*\zs\<\%(func\|proc\|if\|for\|else\|elseif\|case\|when\|unless\|begin\|ensure\)\>'

let s:syn_group_undent
            \ = '^\s*\zs\<\%(end\|else\|elseif\|when\|ensure\|begin\)\>'

function! s:should_skip(lnum, col)
    return synIDattr(synID(a:lnum, a:col, 1), 'name') =~# s:syn_group_skip
endfunction

function! GetDachsIndent(lnum)
    let prev_lnum = prevnonblank(a:lnum)

    let col = match(getline(a:lnum), '\C' . s:syn_group_undent) + 1
    if col > 0 && ! s:should_skip(a:lnum, col)
        return indent(a:lnum) - &shiftwidth
    endif

    let col = match(getline(prev_lnum), '\C' . s:syn_group_indent) + 1
    if col > 0 && ! s:should_skip(prev_lnum, col)
        return indent(a:lnum) + &shiftwidth
    endif

    return indent(a:lnum)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

let b:did_indent = 1
