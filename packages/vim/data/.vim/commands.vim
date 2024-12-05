""""""""""""""""
""" COMMANDS """
""""""""""""""""
" Help pages quick access
command! -bar -nargs=* -complete=help H vertical help <args>
command! -bar -nargs=* -complete=help Ho help <args> | only
command! -bar -nargs=* -complete=help Ht tab help <args>
command! Hi vertical help index
command! Hoi help index | only
command! Hti tab help index
command! Hcl helpclose
command! Hq helpclose

" Tab management
command! -bar -nargs=* -complete=file T tabedit <args>
command! -bang -nargs=? Tcl tabclose<bang> <args>
command! -bang -nargs=? To tabonly<bang> <args>
command! -nargs=? Tm tabmove <args>
command! Tf tabfirst
command! Tl tablast

" Close all buffers except the current one. (1. close all buffers; 2. edit the last
" opened buffer; 3. close the unnamed buffer created after step 1)
command! Bdo %bd | e# | bd#

" Write file and reedit to refresh syntax highlighting
command! W w | e

