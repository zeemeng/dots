" ABOUT FOLDING
" The folding method can be set with the 'foldmethod' option.
"
" There are six methods to select folds:
"	manual		manually define folds [This is the default]
"	indent		more indent means a higher fold level
"	expr		specify an expression to define folds
"	syntax		folds defined by [language syntax files]
"	diff		folds for unchanged text
"	marker		folds defined by markers in the text
"
" Ideally, "precise" folding based on language syntax seems preferable,
" however in practice, not all language syntax files define folds. Even for
" some that do define folds, they might be rudimentary. Therefore, using
" "indent" as the default "foldmethod", and if particular standard language syntax
" files define folds, have "foldmethod" be set to "syntax" either automatically by
" the syn file, or do it explicitly.
"
" Refs:
" https://vim.fandom.com/wiki/Folding
" https://vim.fandom.com/wiki/Check_your_syntax_files_for_configurable_options
" https://neovim.io/doc/user/fold.html
" https://neovim.io/doc/user/syntax.html#%3Asyn-fold
" https://vimhelp.org/syntax.txt.html
" https://github.com/Konfekt/FastFold?tab=readme-ov-file#example-setup

set foldmethod=indent
set foldlevelstart=99

" Display a more useful summary of the folded content. See ref:
" https://www.reddit.com/r/neovim/comments/sofaax/is_there_a_way_to_change_neovims_way_of/
function FoldText()
	let line = getline(v:foldstart)
	let numOfLines = v:foldend - v:foldstart
	let fillCount = winwidth('%') - len(line) - len(numOfLines) - 14
	return line . '  ' . repeat('.', fillCount) . ' (' . numOfLines . ' L)'
endfunction
set foldtext=FoldText()
set fillchars=fold:\  " removes trailing dots. Mind that there is a whitespace after the \!

" FOLDING FROM STANDARD SYN FILES
" Automatic `set foldmethod=syntax` by syn files
let g:baan_fold = 1
let g:baan_fold_block = 1
let g:baan_fold_sql = 1
let g:clojure_fold = 1
let g:fortran_fold = 1
let g:fortran_fold_conditionals = 1
let g:javaScript_fold = 1
let g:perl_fold = 1
let g:perl_fold_blocks = 1
let g:php_folding = 1
let g:r_syntax_folding = 1
let g:rst_fold_enabled = 1
let g:ruby_fold = 1
let g:sh_fold_enabled= 7
let g:tex_fold_enabled = 1
let g:vimsyn_folding = "afhHl"
let g:zsh_fold_enable = 1

" Require explicit `set foldmethod=syntax`
let g:html_syntax_folding = 1
let g:xml_syntax_folding = 1
" For C, you can add these lines in a file in the "after" directory in "runtimepath".
" For Unix this would be: ~/.vim/after/syntax/c.vim. 
"     syn sync fromstart
"     set foldmethod=syntax

" FOLDING NEEDED FROM EXTERNAL SYN FILES (e.g. from vim-polyglot, etc.)
" vim.g.markdown_folding = 1
" vim.g.rust_fold = 1

au FileType * call SetFdmAutocmd()

function! SetFdmAutocmd()
  let ft = &filetype
  if ft =~# 'c\|html\|xml'
    setlocal foldmethod=syntax
    syn sync fromstart
  endif
endfunction

