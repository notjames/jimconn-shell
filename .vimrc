" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'fatih/molokai'

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
"Plug '~/my-prototype-plugin'
Plug 'tpope/vim-sensible'

" display the indentation levels with thin vertical lines
Plug 'Yggdroot/indentLine'

" syntastic goodness
Plug 'vim-syntastic/syntastic'

" pathogen
Plug 'tpope/vim-pathogen'

" Go stuff
Plug 'fatih/vim-go'

" Initialize plugin system
call plug#end()
set timeoutlen=1000 ttimeoutlen=10

execute pathogen#infect()
autocmd BufWritePre * :%s/\s\+$//e
autocmd BufWritePre * :set et
autocmd BufWritePre * :retab

" tell vim to allow you to copy between files, remember your cursor
" position and other little nice things like that
set viminfo='100,\"2500,:200,%,n~/.viminfo

"let g:rehash256 = 1
"let g:molokai_original = 1
"let g:go_fmt_options='-tabwidth=2 -tabs=false'
"colorscheme molokai

" Tab navigation like Firefox.
nnoremap <C-p> :tabprevious<CR>
nnoremap <C-n> :tabnext<CR>
nnoremap <C-t> :tabnew<CR>

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height=3
let b:syntastic_sh_shellcheck_args = "--exclude SC2016,SC1090"

" use goimports for formatting
let g:go_fmt_command = "goimports"

" turn highlighting on
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']

let g:indentLine_setColors = 1
let g:indentLine_char = "|"

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

nnoremap <C-e> :Errors<CR>
nnoremap <C-u> :lclose<CR>
nnoremap <C-y> :lnext<CR>
nnoremap <C-w> :lprevious<CR>

"autocmd BufNewFile,BufRead *.go setlocal et ts=4 sw=4
set sts=4 ts=8 sw=2 ai nu ruler si sta sm hls et

"highlight search term=bold,italic ctermfg=black ctermbg=blue
highlight Search term=bold,italic cterm=bold,italic ctermfg=white ctermbg=blue guifg=white guibg=blue
:command! -nargs=1 -range SuperRetab <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g

" $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
" found: https://github.com/neovim/neovim/issues/2475
" pipe      \<Esc>[5 q
" underline \<Esc>[4 q
" block     \<Esc>[3 q
" insert mode:  &t_SI
" replace mode: &t_SR
" common:       &t_EI
"
" insert mode - pipe
let &t_SI .= "\<Esc>[5 q"

" replace mode - block
let &t_SR .= "\<Esc>[3 q"

" common - block
let &t_EI .= "\<Esc>[3 q"

if has('nvim-0.1.5')        " True color in neovim wasn't added until 0.1.5
  set termguicolors
endif

colo koehler
set list lcs=tab:\|\
