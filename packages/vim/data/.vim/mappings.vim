" *map-table*
"          Mode  | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang | ~
" Command        +------+-----+-----+-----+-----+-----+------+------+ ~
" [nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
" n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
" [nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
" i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
" c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
" v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
" x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
" s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
" o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
" t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
" l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |

""""""""""""""""""""""""""""
""" INSERT, CMD MAPPINGS """
""""""""""""""""""""""""""""
" Insert and command modes character-wise cursor motion
noremap! <C-h> <Left>
noremap! <C-j> <Down>
noremap! <C-k> <Up>
noremap! <C-l> <Right>

" Insert and command modes word-boundary cursor motion
inoremap <C-f> <S-Right>
inoremap <C-b> <S-Left>
inoremap <C-e> <Esc>ea
cnoremap <C-f> <S-Right><Right>
cnoremap <C-b> <S-Left>
cnoremap <C-e> <S-Right>

" Insert and command modes line-boundary cursor motion
noremap! <C-t> <Home>
noremap! <C-y> <End>

" Insert and command modes word-boundary deletion
inoremap <C-w> <C-g>u<C-w>
inoremap <C-q> <C-o>de
cnoremap <C-q> <C-f>de<C-c>

" Insert and command modes line-boundary deletion
inoremap <C-d> <C-o>d$
cnoremap <C-d> <C-f>d$<C-c>

" Increase and decrease indent in insert mode
inoremap <C-c> <C-t>
inoremap <C-g> <C-d>

" Write the buffer
noremap! <C-s> <Esc><Cmd>w<CR>


"""""""""""""""""""""""""""""""""""""""""
""" NORMAL, VISUAL, TERMINAL MAPPINGS """
"""""""""""""""""""""""""""""""""""""""""
" Convenient navigation between windows
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
tnoremap <C-x> <C-\><C-N>

" Delete all entered characters in the current line
noremap U d^

" Undo all latest changes on one line
noremap <Leader>U U

" Convenient window resizing
" '(' and ')' are normal-only maps, since these keys are useful in visual mode
noremap + <Cmd>resize +1<CR>
noremap _ <Cmd>resize -1<CR>
nnoremap ( <Cmd>vertical resize +1<CR>
nnoremap ) <Cmd>vertical resize -1<CR>

" Quickly scroll down [count] lines. To scroll up [count] lines, use the
" default mapping <C-e>
noremap <C-q> <C-y>

" More accessible 'window commands' prefix
map <C-x> <C-w>
noremap <C-w><C-x> <C-w><C-w>

" Convenient horizontal and vertical splitting
noremap <C-w>i :vsplit<CR><C-w>l
noremap <C-w>u :split<CR><C-w>j

" Split window and jump to declaration of identifier under the cursor
noremap <C-w>D <C-w>i

" Toggle Netrw
noremap <C-n> <Cmd>Lex<CR>

" Buffer navigation
noremap <C-b> <Cmd>ls<CR>
noremap <Leader>n <Cmd>bn<CR>
noremap <Leader>p <Cmd>bp<CR>

" 1. Convenient launching of command-line mode
" 2. Repeat last find character (forward) using <CR> or <C-m>
noremap ; :
noremap <C-m> ;

" Convenient launching of buffer-like window for editing ex-commands
noremap q; q:i

" Repeat the last Ex command
" Same as <C-Space>
noremap <C-@> @:

" Close enough to the behaviour in neovim
noremap Q @q

" Write the buffer
noremap <C-s> <Cmd>w<CR>

" Clear current search highlights
nnoremap <Esc> <Cmd>nohlsearch<CR>

