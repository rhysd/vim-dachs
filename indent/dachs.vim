if exists('b:did_indent')
    finish
endif

setlocal nosmartindent
setlocal indentexpr=GetDachsIndent(v:lnum)
setlocal indentkeys=!^F,o,O,e,=end,=else,=elseif,=in,0=when,0=ensure,0=begin

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
            \ = '\%(^\s*\%(\<in\s\+\)\=\zs\<\%(func\|proc\|if\|for\|else\|elseif\|case\|when\|unless\|let\|begin\|ensure\)\>\|\<do\>\%(\s*|[^|]\+|\)\=\_$\)'

let s:syn_group_undent
            \ = '^\s*\zs\<\%(end\|else\|elseif\|when\|ensure\|begin\)\>'

function! s:should_skip(lnum, col)
    return col <= 0 || synIDattr(synID(a:lnum, a:col, 1), 'name') =~# s:syn_group_skip
endfunction

let s:prev = -1
function! GetDachsIndent(lnum)
    let prev_lnum = prevnonblank(a:lnum)
    let prev_line = getline(prev_lnum)
    let current_line = getline('.')

    if current_line =~# '^\s*$'
        let s:prev = -1

        let col = match(prev_line, '\C' . s:syn_group_indent) + 1
        if !s:should_skip(prev_lnum, col)
            return indent(prev_lnum) + &l:shiftwidth
        endif

        let col = match(prev_line, '\C' . s:syn_group_undent) + 1
        if !s:should_skip(a:lnum, col)
            return indent(prev_lnum)
        endif
    end

    let col = match(current_line, '\C' . '\<in\>\s*$') + 1
    if !s:should_skip(a:lnum, col)
        let oneline_idx = match(current_line, '->\|\<let\>')
        if s:prev == v:lnum ||
          \ (oneline_idx > 0 && oneline_idx < col-1)
            return -1
        endif
        let s:prev = v:lnum
        return indent(a:lnum) - &l:shiftwidth
    endif

    let col = match(current_line, '\C' . s:syn_group_undent) + 1
    if !s:should_skip(a:lnum, col)
        if s:prev == v:lnum
            return -1
        endif
        let s:prev = v:lnum
        return indent(a:lnum) - &l:shiftwidth
    endif

    return -1
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

let b:did_indent = 1
