""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Copyright (c) 2009-2014 Seth Wright (seth@crosse.org)
"
" Permission to use, copy, modify, and distribute this software for any
" purpose with or without fee is hereby granted, provided that the above
" copyright notice and this permission notice appear in all copies.
"
" THE SOFTWARE IS PROVIDED 'AS IS' AND THE AUTHOR DISCLAIMS ALL WARRANTIES
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
"   Enter - in normal mode, disable search highlighting temporarily
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

" don't have files trying to override this .vimrc.  If you like adding
" modelines to files you edit, you may want to unset this.
set nomodeline

" Clear any existing autocommands
autocmd!



"""""""""""""""""""""""""""""""""""""""""""""""""
"                                               "
"     Colorschemes, Fonts, and Window Sizes     "
"                                               "
"""""""""""""""""""""""""""""""""""""""""""""""""

" Set some variables we'll use a few times
" Note that these are just my preferences; substitute
" whatever works for you if you don't like them.
"
" The colorscheme to use for GVim/MacVim
let gui_scheme = "solarized"
" The colorscheme to use for vim
let console_scheme = "default"

" Fonts section.  First, create a list of desired fonts for GUI vims.
let fonts = ["Source\\ Code\\ Pro", "Consolas", "Inconsolata", "Monospace"]
let win_font_size = "h11"
let mac_font_size = "h14"
let unix_font_size = "h11"
let print_font_size = "h8"

" GVim default window size
if has('gui_running') && !exists('g:loaded_WindowSizes')
    set lines=60
    set columns=120

    " Use this to not have GVim reset the window size every time you
    " reload this file (":so ~/.vimrc").
    let g:loaded_WindowSizes = 1
endif

if has("win32") || has("win16") || has("win95") || has("win64")
    " Windows-specific settings
    behave mswin
    source $VIMRUNTIME/mswin.vim
    let font_size=win_font_size
elseif has('mac') || has('macvim')
    " MacVim-specific settings
    let font_size=mac_font_size
else
    " Unix-specific settings
    let font_size=unix_font_size
endif

if has("gui_running")
    " The font to use for MacVim
    let &guifont = join(fonts, ":".font_size.",")
endif

" GVim options for all platforms
if has('gui_running')
    " Turn off the toolbar
    set guioptions-=T
    " Set a color scheme
    exec "colorscheme ".gui_scheme
    set background=light
else
    exec "colorscheme ".console_scheme
endif



""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                "
"                    Printing                    "
"                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

" Set some printing options.
" Left/Right/Top margins:  0.5in (1pt = 1/72 inch)
" Bottom margin:  1in
" Print line numbers
" Paper size:  letter (default is A4)
set printoptions=left:27pt,right:54pt,top:36pt,bottom:36pt,number:y,paper:letter,header:3
set printheader=%<%F%=\ [Page\ %N]

" Use the same fonts for printing as for the GUI.
let &printfont = join(fonts, ":".print_font_size.",")



""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                "
"            Editor Visual Stylings              "
"                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable line numbering
set number

" Flash the window instead of beeping
set visualbell

" show matching brackets / parentheses
set showmatch

" show which mode you're currently in.
set showmode

" Disable visual line-wrapping.  This does not prevent hard-wraps.
set nowrap

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
        " Use Enter in Normal mode to disable highlighing after searching
        nmap <silent> <CR> :nohlsearch<CR>
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




""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                "
"                  Status Line                   "
"                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

" use "[RO]" for "[readonly]" to save space in the message line:
set shortmess+=r

if has('cmdline_info')
    " display the current mode and partially-typed commands in the status
    " line:
    set showmode
    set showcmd
    " Always display the current cursor position in the lower right corner
    " of the Vim window.  Note that 'statusline' (below) takes precendence
    " over this option, but if you have a Vim that was not compiled with
    " 'statusline' at least you'll have a ruler...if it was compiled with
    " 'cmdline_info'.
    set ruler
endif

" Set up an informative status line.
if has('statusline')
    if version >= 700
        set statusline=%-02.2n\ %t\ %y\ %m\ %r\ %L\ lines%=%([%{b:cstd}]\%)\ %lL,%cC\ \(%P\)
        " Always show the status line
        set laststatus=2
    endif
endif



""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                "
"                  Indentation                   "
"                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

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



""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                "
"               Text Formatting                  "
"                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

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



""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                "
"                    General                     "
"                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

" Disable some things that tick off crontab on at least Mac OSX.  See
" http://goo.gl/LP6X0 for more information.
if $VIM_CRONTAB == "true"
    set nobackup
    set nowritebackup
endif

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
set wildmode=longest:full
set wildmenu

" Ignore case when completing file names and directories.
set wildignorecase

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

" I like BSD style by default.
if !exists('g:cstd')
    let g:cstd="BSD"
endif

" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

" show the `best match so far' as search strings are typed:
set incsearch

" assume the /g flag on :s substitutions to replace all matches in a line:
set gdefault

" allow <BkSpc> to delete line breaks, beyond the start of the current
" insertion, and over indentations:
set backspace=eol,start,indent

" Change the characters used in list mode, but since one of the
" characters is a UTF-8 character, make sure that vim a) can handle
" multi-byte character sets, and b) set UTF-8 as vim's encoding.  This
" doesn't change the encoding of files, though.
if has("multi_byte") && matchstr($LANG, "UTF-8") == "UTF-8"
    scriptencoding utf-8
    set listchars=tab:»·,eol:¬
    scriptencoding
endif

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
if version <= 700
    set switchbuf=useopen,usetab
else
    set switchbuf=useopen,usetab,newtab
endif

" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=3

" Automatically save the buffer when performing various commands
set autowrite

" Set the terminal title, if possible
set title



""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                "
"                   Functions                    "
"                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

" Used to toggle the QuickFix window open and closed. Mapped to
" <leader>q (see below).
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
nnoremap <leader>q :call QuickfixToggle()<CR>



""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                "
"                 Key Bindings                   "
"                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

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

" Copy (Yank) selected text to the OS clipboard
noremap <leader>y "+y
" Copy an entire line to the OS clipboard
noremap <leader>Y "+yy

" Paste from the OS clipboard
noremap <leader>p "+p
noremap <leader>P "+P

" Toggle List mode using F5.  Like 'Show Codes' for WordPerfect.
map <F5> :set list!<CR>:set list?<CR>
imap <F5> <C-O>:set list!<CR><C-O>:set list?<CR>

" Have Control-Enter do the same as 'O'
" ...that is, insert a line above the current line.
" This comes from Visual Studio key bindings.
" Note that this doesn't seem to work in anything other than GVim.
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

" Use <F6> to call :make
map <F6> :make<CR>
imap <F6> <C-O>:make<CR>

" Strip all trailing whitespace in the current file
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Open a new vertical split and switch over to it.
nnoremap <leader>w :vertical botright new<CR>



" Avoid some security problems with directory-specific vimrc files
" This should be the last line of the file.
set secure
