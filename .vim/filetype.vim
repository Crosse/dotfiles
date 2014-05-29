" local filetype file

if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
    " PowerShell
    au! BufRead,BufNewFile *.ps1  setfiletype ps1
    au! BufRead,BufNewFile *.psm1 setfiletype ps1
    au! BufRead,BufNewFile *.psd1 setfiletype ps1
    " Octopress
    au! BufRead,BufNewFile *.markdown setfiletype octopress
    " human-readable files
    au! BufRead,BufNewFile *.txt setfiletype human
    au! BufRead,BufNewFile *.tex setfiletype human
    au! BufRead,BufNewFile COMMIT_EDITMSG setlocal formatoptions+=t textwidth=72
augroup END

