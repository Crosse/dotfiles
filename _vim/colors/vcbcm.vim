" Vim color file
" Maintainer:	Rajas Sambhare <rajas dot sambhare squigglylittleA gmail dot com>
" Last Change:	Nov 18, 2004
" Version:		1.0
" Based on the colors for Visual C++ 6.0 and Beyond Compare for diffs.
" Inspired by vc.vim by Vladimir Vrzic
"
" Modified by Michael Lam <arrow014 squigglylittleA freearrow dot com>
" 27 Jan 2007

"set background=light
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="vcbcm"

hi Normal		cterm=NONE		ctermfg=NONE		ctermbg=NONE		gui=NONE			guifg=NONE			guibg=NONE
hi NonText		cterm=NONE		ctermfg=NONE		ctermbg=DarkGrey	gui=NONE			guifg=NONE			guibg=LightGrey
hi LineNr		cterm=NONE		ctermfg=NONE		ctermbg=DarkGrey	gui=NONE			guifg=NONE			guibg=LightGrey
hi Comment		cterm=NONE		ctermfg=DarkGreen	ctermbg=NONE		gui=NONE			guifg=DarkGreen		guibg=NONE
hi Constant		cterm=NONE		ctermfg=Red			ctermbg=NONE		gui=NONE			guifg=Red	 		guibg=NONE
hi Identifier	cterm=NONE		ctermfg=Yellow		ctermbg=NONE		gui=NONE			guifg=DarkOrange	guibg=NONE
hi Statement 	cterm=bold		ctermfg=Blue		ctermbg=NONE		gui=bold			guifg=Blue			guibg=NONE
hi PreProc		cterm=NONE		ctermfg=DarkRed		ctermbg=NONE		gui=NONE			guifg=DarkRed		guibg=NONE	
hi Type			cterm=NONE		ctermfg=Blue		ctermbg=NONE		gui=NONE			guifg=Blue			guibg=NONE
hi Underlined	cterm=underline	ctermfg=NONE		ctermbg=NONE		gui=underline		guifg=NONE			guibg=NONE
hi Error		cterm=NONE		ctermfg=Yellow		ctermbg=Red			gui=NONE			guifg=Yellow		guibg=Red
hi Todo			cterm=NONE		ctermfg=NONE		ctermbg=DarkYellow	gui=NONE			guifg=NONE			guibg=LightYellow
"Diff colors
hi DiffAdd		cterm=NONE		ctermfg=Green		ctermbg=NONE		gui=NONE			guifg=Green			guibg=NONE
hi DiffChange	cterm=NONE		ctermfg=Yellow		ctermbg=NONE		gui=NONE			guifg=Yellow		guibg=NONE
hi DiffText		cterm=italic	ctermfg=NONE		ctermbg=NONE		gui=bold,italic		guifg=NONE			guibg=NONE
hi DiffDelete	cterm=NONE		ctermfg=Red			ctermbg=NONE		gui=NONE			guifg=NONE			guibg=NONE
