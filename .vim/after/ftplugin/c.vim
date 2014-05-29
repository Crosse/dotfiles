if exists('loaded_cstyles')
    finish
endif
let loaded_cstyles = 1

" Ignore indents caused by parentheses in FreeBSD style.
function! IgnoreParenIndent()
    let indent = cindent(v:lnum)

    if indent > 4000
        if cindent(v:lnum - 1) > 4000
            return indent(v:lnum - 1)
        else
            return indent(v:lnum - 1) + 4
        endif
    else
        return (indent)
    endif
endfun


" BSD style.
function! BSDStyle()
    setlocal cindent
    setlocal cinoptions=(4200,u4200,+0.5s,*500,:0,t0,U4200
    setlocal indentexpr=IgnoreParenIndent()
    setlocal indentkeys=0{,0},0),:,0#,!^F,o,O,e
    setlocal noexpandtab
    setlocal shiftwidth=8
    setlocal tabstop=8
    setlocal textwidth=78
endfun

" GNU Coding Standards
function GNUStyle()
    setlocal cindent
    setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
    setlocal shiftwidth=2
    setlocal softtabstop=2
    setlocal textwidth=79
    setlocal fo-=ro fo+=cql
endfunction

if exists('cstyle')
    if cstyle == 'bsd'
        call BSDStyle()
    elseif cstyle= 'gnu'
        call GNUStyle()
    endif
endif
