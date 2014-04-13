autocmd BufNewFile,BufRead *.dcs if &filetype !=# 'dachs' | setlocal filetype=dachs | endif
