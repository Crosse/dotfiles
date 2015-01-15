# Rename these files
@(
    "_gitconfig"
    "_gitignore_global"
) | % { New-Object PSObject -Property @{ Name = $_; Rename = $true } }

# Do not rename these files
@(
    "_vim"
    "_vimrc"
) | % { New-Object PSObject -Property @{ Name = $_; Rename = $false } }
