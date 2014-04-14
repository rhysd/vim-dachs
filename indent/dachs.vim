if exists('b:did_indent')
  finish
endif

setlocal autoindent
setlocal indentexpr=GetDachsIndent()
setlocal indentkeys=!^F,o,O


let b:undo_indent = 'setlocal '.join([
\   'autoindent<',
\   'indentexpr<',
\   'indentkeys<',
\ ])


function! GetDachsIndent()
  return -1
endfunction

let b:did_indent = 1
