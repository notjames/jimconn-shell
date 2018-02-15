" Plug (vim-plug) - plugin manager
" https://github.com/junegunn/vim-plug
" Basically: after adding a plug, just remember to run 'PlugInstall'
" This is best with neovim!
" https://neovim.io/
" http://nerditya.com/code/guide-to-neovim/
" Other helpful links:
" http://learnvimscriptthehardway.stevelosh.com/
" http://andrewradev.com/2011/08/06/making-vim-pretty-with-custom-colors/
" =====================================
call plug#begin('~/.vim/plugged')
" -------------------------------------

" various color schemes (neovim default is 'dark'; I like 'slate' with dark background)
" http://vimcolors.com/
Plug 'freeo/vim-kalisi'
Plug 'w0ng/vim-hybrid'
Plug 'bitterjug/vim-colors-bitterjug'
Plug 'jonathanfilip/vim-lucius'
Plug 'crusoexia/vim-monokai'
Plug 'jacoborus/tender.vim'
Plug 'pbrisbin/vim-colors-off'
Plug 'muellan/am-colors'
Plug 'blueshirts/darcula'

" NERD Tree - tree explorer
" https://github.com/scrooloose/nerdtree
" http://usevim.com/2012/07/18/nerdtree/
" (loaded on first invocation of the command)
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" nerdtree-git-plugin - show git status in NERD Tree
" https://github.com/Xuyuanp/nerdtree-git-plugin
Plug 'Xuyuanp/nerdtree-git-plugin'

" vim-airline
" Enhanced statusline
" https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline'
" https://github.com/vim-airline/vim-airline-themes
Plug 'vim-airline/vim-airline-themes'

" Save/restore session support
" https://github.com/tpope/vim-obsession
" tmux users also see: https://github.com/tmux-plugins/tmux-resurrect/blob/master/docs/restoring_vim_and_neovim_sessions.md
Plug 'tpope/vim-obsession'

" Excellent git wrapper
" https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-fugitive'

" Enforce editor settings
" https://github.com/editorconfig/editorconfig-vim
Plug 'editorconfig/editorconfig-vim'

" Make vim a first class Go development environment
" https://github.com/fatih/vim-go
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

" vim-misc
" https://github.com/xolox/vim-misc
Plug 'xolox/vim-misc'

" vim-easytags
" https://github.com/xolox/vim-easytags
Plug 'xolox/vim-easytags'

" Tagbar
" https://github.com/majutsushi/tagbar
Plug 'majutsushi/tagbar'

" https://github.com/nsf/gocode
Plug 'nsf/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }

" deoplete (for gocode completion support)
" https://github.com/Shougo/deoplete.nvim
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" deoplete-go (for gocode completion support)
" https://github.com/zchee/deoplete-go
Plug 'zchee/deoplete-go', { 'do': 'make'}

" Markdown support
" https://github.com/plasticboy/vim-markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" Nice interaction with tmux
" https://github.com/benmills/vimux
Plug 'benmills/vimux'

" Fuzzy file, buffer, mru, tag, etc finder
" ctrlp.vim
" https://github.com/ctrlpvim/ctrlp.vim
Plug 'ctrlpvim/ctrlp.vim'

" A better grep (source code aware)
" You must install ack on your machine for the plugin to work
" sudo apt-get install ack-grep, brew install ack, etc.
Plug 'mileszs/ack.vim'

" OMG - insanely awesome fuzzy search and blazing fast grep
" https://github.com/junegunn/fzf (parent project)
" https://github.com/junegunn/fzf.vim (more extensive wrapper)
" https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2#.rkhrm332m
" To update: :PlugUpdate fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" indentline
" https://github.com/Yggdroot/indentLine
Plug 'Yggdroot/indentLine'

" -------------------------------------
" Add plugins to &runtimepath
call plug#end()
" =====================================

" Auto start NERD tree when opening a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | wincmd p | endif

" Auto start NERD tree if no files are specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | exe 'NERDTree' | endif

" Let quit work as expected if after entering :q the only window left open is NERD Tree itself
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" =====================================
" Initial settings
" =====================================

" Relax file compatibility restriction with original vi
" (not necessary to set with neovim, but useful for vim)
set nocompatible

" Disable beep / flash
set vb t_vb=

" Set tabs and indents (for go)
set ts=8
set shiftwidth=8
set ai sw=8
" replace tab with spaces
"set expandtab
" allow cursor to move to beginning of tab
" will interfere with soft line wrapping (set nolist)
set list lcs=tab:\ \ 

" highlight matches when searching
" Use C-l to clear (see key map section)
set hlsearch

" Line numbering
" Toggle set to ';n' in key map section
set nonumber

" Disable line wrapping
" Toggle set to ';w' in key map section
set nowrap

" enable line and column display
set ruler

"disable showmode since using vim-airline; otherwise use 'set showmode'
set noshowmode

" file type recognition
filetype on
filetype plugin on
filetype indent on

" syntax highlighting
syntax on

" scroll a bit horizontally when at the end of the line
set sidescroll=6

" Make it easier to work with buffers
" http://vim.wikia.com/wiki/Easier_buffer_switching
set hidden
set confirm
set autowriteall
set wildmenu wildmode=full

" markdown
" https://github.com/plasticboy/vim-markdown
let g:vim_markdown_folding_disabled = 1

" auto switch current working directory to current buffer (not recommended)
"autocmd BufEnter * :cd %:p:h

" open new split panes to right and below (as you probably expect)
set splitright
set splitbelow

" Use Ag (the silver searcher) instack of Ack
let g:ackprg = 'ag --nogroup --nocolor --column'

" =====================================
" Theme color scheme settings
" =====================================
" blue
" darkblue
" default
" delek
" desert
" elflord
" evening
" koehler
" morning
" murphy
" pablo
" peachpuff
" ron
" shine
" slate
" torte
" zellner
" -------------------------------------

function! Light()
    echom "set bg=light"
    set bg=light
    colorscheme off
    set list
endfunction

function! Dark()
    echom "set bg=dark"
    set bg=dark
    colorscheme darcula
    "darcula fix to hide the indents:
    set nolist
endfunction

function! ToggleLightDark()
  if &bg ==# "light"
    call Dark()
  else
    call Light()
  endif
endfunction

" adjustments
"hi Statement ctermfg=1 guifg=#60BB60
"hi Constant ctermfg=4

" for macvim
"
" Disable scrollbar in gui
" set scrolloff=9999
" hide right scrollbar
set guioptions-=r
"
set guifont=Menlo\ Regular:h16

" =====================================
" key map
" Understand mapping modes:
" http://stackoverflow.com/questions/3776117/what-is-the-difference-between-the-remap-noremap-nnoremap-and-vnoremap-mapping#answer-3776182
" http://stackoverflow.com/questions/22849386/difference-between-nnoremap-and-inoremap#answer-22849425
" =====================================

" change the leader key from "\" to ";" ("," is also popular)
let mapleader=";"

" Shortcut to edit THIS configuration file: (e)dit (c)onfiguration
nnoremap <silent> <leader>ec :e <CR>

" Shortcut to source (reload) THIS configuration file after editing it: (s)ource (c)onfiguraiton
nnoremap <silent> <leader>sc :source <CR>

" use ;; for escape
" http://vim.wikia.com/wiki/Avoid_the_escape_key
inoremap ;; <Esc>

" Toggle NERDTree
" Can't get <C-Space> by itself to work, so this works as Ctrl - space - space
" https://github.com/neovim/neovim/issues/3101
" http://stackoverflow.com/questions/7722177/how-do-i-map-ctrl-x-ctrl-o-to-ctrl-space-in-terminal-vim#answer-24550772
"nnoremap <C-Space> :NERDTreeToggle<CR>
"nmap <C-@> <C-Space>
nnoremap <silent> <Space> :NERDTreeToggle<CR>

" toggle tagbar
nnoremap <silent> <leader>tb :TagbarToggle<CR>

" toggle line numbers
nnoremap <silent> <leader>n :set number! number?<CR>

" toggle line wrap
nnoremap <silent> <leader>w :set wrap! wrap?<CR>

" toggle buffer (switch between current and last buffer)
nnoremap <silent> <leader>bb <C-^>

" go to next buffer
nnoremap <silent> <leader>bn :bn<CR>
nnoremap <C-l> :bn<CR>

" go to previous buffer
nnoremap <silent> <leader>bp :bp<CR>
" https://github.com/neovim/neovim/issues/2048
nnoremap <C-h> :bp<CR>

" close buffer
nnoremap <silent> <leader>bd :bd<CR>

" kill buffer
nnoremap <silent> <leader>bk :bd!<CR>

" list buffers
nnoremap <silent> <leader>bl :ls<CR>
" list and select buffer
nnoremap <silent> <leader>bg :ls<CR>:buffer<Space>

" horizontal split with new buffer
nnoremap <silent> <leader>bh :new<CR>

" vertical split with new buffer
nnoremap <silent> <leader>bv :vnew<CR>

" redraw screan and clear search highlighted items
"http://stackoverflow.com/questions/657447/vim-clear-last-search-highlighting#answer-25569434
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

" vimux
" https://raw.githubusercontent.com/benmills/vimux/master/doc/vimux.txt
nnoremap <leader>vc :VimuxPromptCommand<CR>
nnoremap <leader>vl :VimuxRunLastCommand<CR>
nnoremap <leader>vq :VimuxCloseRunner<CR>
nnoremap <leader>vx: VimuxInterruptRunner<CR>

" improved keyboard navigation
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" improved keyboard support for navigation (especially terminal)
" https://neovim.io/doc/user/nvim_terminal_emulator.html
tnoremap <Esc> <C-\><C-n>
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
nnoremap <silent> <leader>tt :terminal<CR>
nnoremap <silent> <leader>tv :vnew<CR>:terminal<CR>
nnoremap <silent> <leader>th :new<CR>:terminal<CR>
tnoremap <C-x> <C-\><C-n><C-w>q

" ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = ''

" toggle colors to optimize based on light or dark background
nnoremap <leader>c :call ToggleLightDark()<CR>

" =====================================
" Go
" https://github.com/fatih/vim-go
" =====================================
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" go-def is automatically by default to plain "gd" (no leader required)
au FileType go nnoremap <Leader>gd <Plug>(go-def)
au FileType go nmap <Leader>gp <Plug>(go-def-pop)

au FileType go nnoremap <Leader>gv <Plug>(go-doc-vertical)
" or open in a browser...
au FileType go nnoremap <Leader>gb <Plug>(go-doc-browser)

au FileType go nnoremap <Leader>s <Plug>(go-implements)
au FileType go nnoremap <Leader>i <Plug>(go-info)
au FileType go nnoremap <Leader>gl <Plug>(go-metalinter)
au FileType go nnoremap <Leader>gc <Plug>(go-callers)

" =====================================
" vim-airline status
" configure: https://github.com/vim-airline/vim-airline#user-content-extensible-pipeline
" =====================================
let g:airline_theme='monochrome'
" show buffers (if only one tab)
"let g:airline#extensions#tabline#enabled = 1

let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
TagbarClose
NERDTreeClose
        set foldcolumn=10

    else
set foldcolumn=0
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2 
        set showcmd
NERDTree
" NERDTree takes focus, so move focus back to the right
" (note: "l" is lowercase L (mapped to moving right)
wincmd l
TagbarOpen

    endif
endfunction

nnoremap <silent> <leader>h :call ToggleHiddenAll()<CR>

" =====================================
" Custom find
" =====================================
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" =====================================
" Custom styling
" =====================================

" http://stackoverflow.com/questions/9001337/vim-split-bar-styling
set fillchars+=vert:\ 

" http://vim.wikia.com/wiki/Highlight_current_line
" http://stackoverflow.com/questions/8750792/vim-highlight-the-whole-current-line
" http://vimdoc.sourceforge.net/htmldoc/autocmd.html#autocmd-events
autocmd BufEnter * setlocal cursorline
autocmd WinEnter * setlocal cursorline
autocmd BufLeave * setlocal nocursorline
autocmd WinLeave * setlocal nocursorline

" tagbar autopen
"autocmd VimEnter * nested :call tagbar#autoopen(1)
"autocmd FileType * nested :call tagbar#autoopen(0)
"autocmd BufEnter * nested :call tagbar#autoopen(0)

" =====================================
" auto completion
" =====================================
set completeopt+=noinsert
set completeopt+=noselect
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#go#use_cache = 1


" =====================================
" Init
" =====================================
silent call Dark()
autocmd VimEnter * wincmd p
