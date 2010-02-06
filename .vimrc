""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 
" $Id$
" 
" Copyright (c) 2009 Seth Wright (wrightst@jmu.edu)
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
" ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
" OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" This file isn't compatible with vi.
set nocompatible

" don't have files trying to override this .vimrc:
set nomodeline

" Clear any existing autocommands
autocmd!

" Set some variables we'll use a few times
" The colorscheme to use for GVIM
let gui_scheme = "torte"
" The colorscheme to use for vim
let console_scheme = "slate"
" The font to use in GVIM for Windows
let ms_font = "Consolas:h11"
" The font to use in GVIM on Unix
let unix_font = "Monospace"
" GVIM window size
if has('gui_running')
    set lines=50
    set columns=150
endif

if has("win32") || has("win16") || has("win95") || has("win64")
    " Windows-specific settings
    behave mswin
    source $VIMRUNTIME/mswin.vim

    if has("gui_running")
        " The font to use
        exec "set guifont=".ms_font
    endif 
else
    " Unix-specific settings
    if has('gui_running')
        " Set the font
        exec "set guifont=".unix_font
    else
        exec "colorscheme ".console_scheme
    endif
endif

" GVIM options for all platforms
if has('gui_running')
    " Turn off the toolbar
    set guioptions-=T
    " Set a color scheme
    exec "colorscheme ".gui_scheme
endif

" Turn syntax highlighting on
if has('syntax')
    syntax on

    if has('extra_search')
        " Turn on search highlighting
        set hlsearch
        " Map F4 to toggle search highlighting:
        map <silent> <F4> :set hlsearch!<CR>:set hlsearch?<CR>
        imap <silent> <F4> <Esc>:set hlsearch!<CR>:set hlsearch?<CR>
    endif
endif

" Enable line numbering
set number

set visualbell

" have fifty lines of command-line (etc) history:
set history=50

" remember all of these between sessions, but only 10 search terms; also
" remember info for 10 files, but never any on removable disks, don't remember
" marks in files, don't rehighlight old search patterns, and only save up to
" 100 lines of registers; including @10 in there should restrict input buffer
" but it causes an error for me:
set viminfo=/10,'10,r/mnt/zip,r/mnt/floppy,f0,h,\"100

" have command-line completion <Tab> (for filenames, help topics, option names)
" first list the available options and complete the longest common part, then
" have further <Tab>s cycle through the possibilities:
set wildmode=list:longest,full

" use "[RO]" for "[readonly]" to save space in the message line:
set shortmess+=r

if has('cmdline_info')
    " display the current mode and partially-typed commands in the status line:
    set showmode
    set showcmd
    " show the ruler
    set ruler
endif

" Enable the mouse in Visual, Insert, and Command modes
if has("mouse")
    set mouse=vic
endif

" enable spell-checking.
if has('spell')
    set nospell
    " Map F2 to toggle spell-check mode:
    map <silent> <F2> :set spell!<CR>:set spell?<CR>
endif

" show matching brackets / parentheses
set showmatch

" Disable line-wrapping
set nowrap

" use indents of 4 spaces, and have them copied down lines:
set shiftwidth=4
set softtabstop=4
set shiftround
set expandtab
set autoindent
set smartindent

" normally don't automatically format `text' as it is typed, IE only do this
" with comments, at 79 characters: 
set formatoptions-=t
set textwidth=79

" get rid of the default style of C comments, and define a style with two stars
" at the start of `middle' rows which (looks nicer and) avoids asterisks used
" for bullet lists being treated like C comments; then define a bullet list
" style for single stars (like already is for hyphens):
set comments-=s1:/*,mb:*,ex:*/
set comments+=s:/*,mb:**,ex:*/
set comments+=fb:*

" Lower the timeout when pressing <Esc>
set timeout timeoutlen=3000 ttimeoutlen=100

" enable filetype detection:
if has('eval')
    filetype on
    filetype indent on
    filetype plugin on
endif

if has('autocmd')
    " in human-language files, automatically format everything at 72 chars:
    autocmd FileType mail,human set formatoptions+=t textwidth=72
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

" allow <BkSpc> to delete line breaks, beyond the start of the current
" insertion, and over indentations:
set backspace=eol,start,indent

" Map F3 to Find Next:
map <F3> n
imap <F3> <Esc>n

" Map Shift-F3 to Find Previous:
map <S-F3> N
imap <S-F3> <Esc>N

" Toggle List mode using F5
map <F5> :set list!<CR>:set list?<CR>
imap <F5> :set list!<CR>:set list?<CR>

" Have Control-Enter do the same as 'O'
imap <C-Enter> <Esc>O

" Set up an informative status line.
if has('statusline')
  if version >= 700
    set statusline=%-02.2n\ %t\ %y\ %m\ %r\ %L\ lines%=%lL,%cC\ \(%P\)\ 
    " Enable the status line
    set laststatus=2
  endif

endif

" Avoid some security problems with directory-specific vimrc files
" This should be the last line of the file.
set secure
