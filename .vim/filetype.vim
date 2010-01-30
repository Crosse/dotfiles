" local filetype file
" loads the PowerShell filetype

if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.ps1  setfiletype ps1
augroup END

