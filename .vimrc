""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Copyright (c) 2009-2012 Seth Wright (seth@crosse.org)
"
" Permission to use, copy, modify, and distribute this software for any
" purpose with or without fee is hereby granted, provided that the above
" copyright notice and this permission notice appear in all copies.
"
" THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
" WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
" MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
" ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
" WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
" ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
" IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Things to note:
" * If you 'export EDITOR=vim' in your shell startup scripts and want to
"   be able to edit crontabs ('crontab -e'), you'll want to add the
"   following line to your .profile:
"
"   alias crontab="VIM_CRONTAB=true crontab"
"
"   This will disable some backup features that crontab (at least on Mac
"   OS X) does not like.  See http://goo.gl/LP6X0 for more information.

" * The following keys and their functions are defined below.  This
"   doesn't include everything; mostly just the 'convenience' keys.  If I
"   remapped a key just to change how it works slightly (like PageUp), but
"   it still works mostly the same way as before, I am not including it
"   here.
"
"   F2 - toggle spell check
"   F4 - toggle search highlighting
"   F5 - toggle list mode; i.e., 'Show Codes'
"   F6 - execute 'make' in the current directory
"   F9 - toggle nearest fold open and closed
"   F10 - toggle the fold column
"   Ctrl-Space - toggle nearest fold open and closed
"   Ctrl-Enter - same as 'O'; i.e., insert a line above the current line
"   Ctrl-J - mapped to 'tabnext'
"   Ctrl-K - mapped to 'tabprevious'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" This file isn't compatible with vi.
set nocompatible

" don't have files trying to override this .vimrc:
set nomodeline

" Clear any existing autocommands
autocmd!

" Set some variables we'll use a few times
" Note that these are just my preferences; substitute
" whatever works for you if you don't like them.
"
" The colorscheme to use for GVIM
let gui_scheme = "solarized"
" The colorscheme to use for vim
let console_scheme = "default"
" The font to use in GVIM for Windows
let ms_font = "Consolas:h11"
let ms_print_font = "Consolas:h8"
" The font to use in MacVim
let mac_font = "Consolas:h14,Inconsolata:h14"
let mac_print_font="Consolas:h8"
" The font to use in GVIM on Unix
let unix_font = "Monospace"
" GVIM default window size
if has('gui_running')
    set lines=60
    set columns=140
endif

if has("win32") || has("win16") || has("win95") || has("win64")
    " Windows-specific settings
    behave mswin
    source $VIMRUNTIME/mswin.vim

    exec "set printfont=".ms_print_font

    if has("gui_running")
        " The font to use for GVIM / Windows
        exec "set guifont=".ms_font
    endif
elseif has('mac') || has('macvim')
    " MacVim-specific settings
    exec "set printfont=".mac_print_font

    if has("gui_running")
        " The font to use for MacVim
        exec "set guifont=".mac_font
    endif
else
    exec "set printfont=".unix_font

    " Unix-specific settings
    if has('gui_running')
        " Set the font to use for GVIM
        exec "set guifont=".unix_font
    endif
endif

" GVIM options for all platforms
if has('gui_running')
    " Turn off the toolbar
    set guioptions-=T
    " Set a color scheme
    exec "colorscheme ".gui_scheme
    set background=light
else
    exec "colorscheme ".console_scheme
endif

" Turn syntax highlighting on, if vim supports it
if has('syntax') && (&t_Co > 2 || has('gui_running'))
    syntax on

    " This sets up a 'gutter' line at 76 characters.
    if exists('+colorcolumn')
        set colorcolumn=76
        highlight ColorColumn ctermbg=gray guibg=gray
    endif

    if has('extra_search')
        " Turn on search highlighting
        set hlsearch
        " Map F4 to toggle search highlighting:
        map <silent> <F4> :set hlsearch!<CR>:set hlsearch?<CR>
        imap <silent> <F4> <C-O>:set hlsearch!<CR><C-O>:set hlsearch?<CR>
    endif
endif

" Disable some things that tick off crontab on at least Mac OSX.  See
" http://goo.gl/LP6X0 for more information.
if $VIM_CRONTAB == "true"
    set nobackup
    set nowritebackup
endif

" Add Go's vim bits to the runtimepath so that syntax, indentation, etc.
" works properly for the Go language.
if exists("$GOROOT")
    set rtp+=$GOROOT/misc/vim
endif

" Set some printing options.
" Left/Right/Top margins:  0.5in (1pt = 1/72 inch)
" Bottom margin:  1in
" Print line numbers
" Paper size:  letter (default is A4)
set printoptions=left:27pt,right:54pt,top:36pt,bottom:36pt,number:y,paper:letter,header:3
set printheader=%<%F%=\ [Page\ %N]

" Enable line numbering
set number

" Flash the window instead of beeping
set visualbell

" have fifty lines of command-line (etc) history:
set history=50

" Things to save in .viminfo:
" Save 10 items in the search pattern history;
" Save marks for the last 10 edited files;
" Don't save marks for files in /tmp or /Volumes;
" Do not store file marks;
" Disable 'hlsearch' when loading the viminfo file;
" Save 100 lines for each register.
set viminfo=/10,'10,r/tmp,r/Volumes,f0,h,\"100

" have command-line completion <Tab> (for filenames, help topics, option
" names) first list the available options and complete the longest common
" part, then have further <Tab>s cycle through the possibilities:
set wildmode=list:longest,full

" use "[RO]" for "[readonly]" to save space in the message line:
set shortmess+=r

if has('cmdline_info')
    " display the current mode and partially-typed commands in the status
    " line:
    set showmode
    set showcmd
    " Always display the current cursor position in the lower right corner
    " of the Vim window.
    set ruler
endif

" Enable the mouse in Visual, Insert, and Command modes
" This can be weird sometimes.
if has("mouse")
    set mouse=vic
endif

" enable spell-checking, if we have it.
" you'll probably want to read ':help spell'.
if has('spell')
    set nospell
    " Map F2 to toggle spell-check mode:
    map <silent> <F2> :set spell!<CR>:set spell?<CR>
    imap <silent> <F2> <C-O>:set spell!<CR><C-O>:set spell?<CR>
endif

" show matching brackets / parentheses
set showmatch

" Disable visual line-wrapping.  This does not prevent hard-wraps.
set nowrap

" use four spaces for each step of (auto)indent.
set shiftwidth=4
" hitting <Tab> will insert four spaces instead.
set softtabstop=4
" round indent to multiple of shiftwidth.
set shiftround
" use spaces instead of tabs to insert a tab.
set expandtab
" Copy indent from current line when starting a new line.
" Also deletes indents if nothing else is written on the line.
set autoindent

" don't automatically format `text' as it is typed; i.e. only do this with
" comments, and reflow at 72 characters:
set formatoptions-=t
set textwidth=72

" get rid of the default style of C comments, and define a style with two
" stars at the start of `middle' rows which (looks nicer and) avoids
" asterisks used for bullet lists being treated like C comments; then define
" a bullet list style for single stars (like already is for hyphens):
set comments-=s1:/*,mb:*,ex:*/
set comments+=s:/*,mb:**,ex:*/
set comments+=fb:*

" Look in the current directory and work upwards for a tags file.
set tags=./tags;/

" Lower the timeout when pressing <Esc>
set timeout timeoutlen=3000 ttimeoutlen=100

" enable filetype detection:
if has('eval')
    filetype on
    filetype indent on
    filetype plugin on
endif

if has('autocmd')
    " in human-language files, automatically format everything at 72
    " chars:
    autocmd FileType human set formatoptions+=t textwidth=72
endif

" Set up an informative status line.
if has('statusline')
    if version >= 700
        set statusline=%-02.2n\ %t\ %y\ %m\ %r\ %L\ lines%=%lL,%cC\ \(%P\)
        " Enable the status line
        set laststatus=2
    endif
endif

" Enable folding.  This uses syntax folding (so your syntax file must
" support folding).  It doesn't start folded by default, and sets up a
" left-hand gutter of three columns dedicated to the folding structure.
if has('folding')
    set foldmethod=syntax
    set foldnestmax=10
    set foldenable
    set foldcolumn=0
    set foldlevel=255

    " This toggles the nearest fold open and closed.
    map <F9> za
    imap <F9> <C-O>za
    " This does the same thing, but with Control-Space.
    nmap <silent> <C-Space> @=(foldlevel('.')?'za':"\<C-Space>")<CR>

    " A function to toggle the fold column.
    map <F10> :call FoldColumnToggle()<CR>
    function! FoldColumnToggle()
        if &foldcolumn
            setlocal foldcolumn=0
        else
            setlocal foldcolumn=4
        endif
    endfunction
endif

" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

" show the `best match so far' as search strings are typed:
set incsearch

" assume the /g flag on :s substitutions to replace all matches in a line:
set gdefault

" Stay in visual mode when indenting
vnoremap > >gv
vnoremap < <gv

" have the usual indentation keystrokes still work in visual mode:
vmap <C-T> >
vmap <C-D> <LT>
vmap <Tab> <C-T>
vmap <S-Tab> <C-D>

" have Y behave analogously to D and C rather than to dd and cc (which is
" already done by yy):
noremap Y y$

" Yank/paste to the OS clipboard
nnoremap <leader>y "+y
nnoremap <leader>Y "+yy
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" allow <BkSpc> to delete line breaks, beyond the start of the current
" insertion, and over indentations:
set backspace=eol,start,indent

" Toggle List mode using F5.  Like 'Show Codes' for WordPerfect.
map <F5> :set list!<CR>:set list?<CR>
imap <F5> <C-O>:set list!<CR><C-O>:set list?<CR>
set listchars=tab:▸·,eol:¬

" Have Control-Enter do the same as 'O'
" ...that is, insert a line above the current line.
" This comes from Visual Studio key bindings.
imap <C-Enter> <Esc>O

" Remap PageUp and PageDown such that the keys act like Control-U and
" Control-D, respectively.
map <PageUp> <C-U>
map <PageDown> <C-D>
imap <PageUp> <C-O><C-U>
imap <PageDown> <C-O><C-D>

" Map/remap Control-J and Control-K to cycle left and right through tabs
map <C-J> :tabnext<CR>
map <C-K> :tabprev<CR>
imap <C-J> <C-O>:tabnext<CR>
imap <C-K> <C-O>:tabprev<CR>

" Keep the cursor in the same column, if possible, when using C-U and
" C-D, etc.
set nostartofline

" Indicates a fast terminal connection.  More characters will be sent to
" the screen for redrawing, instead of using insert/delete line
" commands.  Improves smoothness of redrawing when there are multiple
" windows and the terminal does not support a scrolling region.
set ttyfast

" Do not redraw screen while executing macros, registers and other
" commands that have not been typed.
set lazyredraw

" Control the behavior when switching between buffers:
" * Jump to the first open window that contains the specified buffer (if
"   there is one).
" * Also consider windows in other tab pages.
" * Open a new tab before loading a buffer for a quickfix command that
" display errors.
set switchbuf=useopen,usetab,newtab

" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=3

" Use <F6> to call :make
map <F6> :make<CR>
imap <F6> <C-O>:make<CR>

" Strip all trailing whitespace in the current file
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Open a new vertical split and switch over to it.
nnoremap <leader>w :vertical botright new<CR>
nnoremap <leader>C :call OpenComplementaryFile()<CR>

function! OpenComplementaryFile()
    let l:ext = expand("%:e")
    if ext == "c"
        let l:f = expand("%:r") . ".h"
        exec "vertical botright split " . l:f
    elseif ext == "h"
        let l:f = expand("%:r") . ".c"
        exec "vsplit " . l:f
    endif
endfunction

" Automatically save the buffer when performing various commands
set autowrite

" Do not use a swapfile for buffers.
set noswapfile

" Set the terminal title, if possible
set title

" Toggle the quickfix window.
nnoremap <leader>q :call QuickfixToggle()<CR>

let g:quickfix_is_open = 0
function! QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
    else
        copen
        let g:quickfix_is_open = 1
    endif
endfunction

" Avoid some security problems with directory-specific vimrc files
" This should be the last line of the file.
set secure
