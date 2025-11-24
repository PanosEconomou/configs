" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on
syntax on

" Add linenumbers
set number

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx



" PLUGINS ---------------------------------------------------------------- {{{

call plug#begin('~/.vim/plugged')

	Plug 'dense-analysis/ale'
	Plug 'preservim/nerdtree'
	Plug 'rakr/vim-one'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'lervag/vimtex'

call plug#end()

" Set up vimtex plugin
let g:text_flavor = 'latex'
let g:vimtex_view_method = 'zathura_simple'
let g:vimtex_view_zathura_use_xdotool = 0
let g:vimtex_quickfix_mode = 0
let maplocalleader = ";"

" This will cleanup all the files used to live compile latex
noremap <localleader>lc :VimtexStop<cr> <plug>(vimtex-clean-full)<cr>

" In insert mode: if the completion menu is visible, <Tab> → <C-y>, else do normal <Tab>
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"

set shortmess+=c
inoremap <silent><expr> <Esc> coc#pum#visible()   ? coc#pum#cancel() : coc#snippet#jumpable() ? coc#snippet#cancel() : "\<Esc>"

" }}}


" MAPPINGS --------------------------------------------------------------- {{{


" Set the backslash as the leader key.
let mapleader = "\\"

" Press \\ to turn off search highlighting
nnoremap <leader>\ :nohlsearch<CR>

" Press \p to print the current file to the default printer from a Linux operating system.
" View available printers:   lpstat -v
" Set default printer:       lpoptions -d <printer_name>
" <silent> means do not display output.
nnoremap <silent> <leader>p :%w !lp<CR>

" Type jj to exit insert mode quickly.
inoremap jj <Esc>

" Press the space bar to type the : character in command mode.
nnoremap <space> :

" Center the cursor vertically when moving to the next word during a search.
nnoremap n nzz
nnoremap N Nzz

" Yank from cursor to the end of line.
nnoremap Y y$

" Map the F5 key to run a Python script inside Vim.
" I map F5 to a chain of commands here.
" :w saves the file.
" <CR> (carriage return) is like pressing the enter key.
" !clear runs the external clear screen command.
" !python3 % executes the current file with Python.
nnoremap <f5> :w <CR>:!clear <CR>:!python3 % <CR>

" You can split the window in Vim by typing :split or :vsplit.
" Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w>>
noremap <c-right> <c-w><

" NERDTree specific mappings.
" Map the F3 key to toggle NERDTree open and close.
nnoremap <F3> :NERDTreeToggle<cr>

" Have nerdtree ignore certain files and directories.
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']

" }}}


" STATUS LINE ------------------------------------------------------------ {{{

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%

" Show the status on the second to last line.
set laststatus=2

" }}}


" VIMSCRIPT -------------------------------------------------------------- {{{


" Enable the marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" If the current file type is HTML, set indentation to 2 spaces.
autocmd Filetype html setlocal tabstop=2 shiftwidth=2 expandtab

" If Vim version is equal to or greater than 7.3 enable undofile.
" This allows you to undo changes to a file even after saving it.
if version >= 703
    set undodir=~/.vim/backup
    set undofile
    set undoreload=10000
endif

" You can split a window into sections by typing `:split` or `:vsplit`.
" Display cursorline and cursorcolumn ONLY in active window.
augroup cursor_off
    autocmd!
    autocmd WinLeave * set nocursorline nocursorcolumn
    autocmd WinEnter * set cursorline cursorcolumn
augroup END

" }}}

" Set the colorscheme, but remove the background config
colorscheme one
set background=dark
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE


" Display more of the file by default.
" Hide the toolbar.
" set guioptions-=T

" Hide the the left-side scroll bar.
set guioptions-=L

" Hide the the right-side scroll bar.
set guioptions-=r

" Hide the the menu bar.
set guioptions-=m

" Hide the the bottom scroll bar.
set guioptions-=b

" Support terminal Colors
set termguicolors

highlight StatusLine ctermbg=NONE guibg=NONE
highlight StatusLineNC ctermbg=NONE guibg=NONE

" Map the F4 key to toggle the menu, toolbar, and scroll bar.
" <Bar> is the pipe character.
" <CR> is the enter key.
nnoremap <F4> :if &guioptions=~#'mTr'<Bar>
	\set guioptions-=mTr<Bar>
	\else<Bar>
	\set guioptions+=mTr<Bar>
	\endif<CR>


" Cursor
if &term =~ 'kitty'
    let &t_SI = "\e[5 q"  " Set to bar cursor in insert mode
    let &t_EI = "\e[2 q"  " Reset to block cursor in normal mode
endif
