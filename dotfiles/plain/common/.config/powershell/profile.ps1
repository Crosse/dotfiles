################################################################################
#
# Copyright (c) 2009-2016 Seth Wright (wrightst@jmu.edu)
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
################################################################################

$host.UI.RawUI.BufferSize.Width = 120
$host.UI.RawUI.BufferSize.Height = 5000
$host.UI.RawUI.WindowSize.Width = 120
$host.UI.RawUI.WindowSize.Height = 50

$thisScript = [IO.FileInfo]$(($MyInvocation.MyCommand).Definition)
$scriptPath = $thisScript.DirectoryName

Write-Host -Fore Cyan "Executing profile script $thisScript"

# Allow Unix-like functionality with the 'cd' command.
if (Test-Path Alias:\cd) { Remove-Item Alias:\cd }
if (Test-Path Function:\cd) { Remove-Item Function:\cd }
function cd {
    param ($Path)

    if ([String]::IsNullOrEmpty($Path)) {
        if ($host.Version.Major -ge 6 -and $IsWindows) {
            $Path = (Get-Item Env:UserProfile).Value
        } else {
            $Path = (Get-Item Env:HOME).Value
        }
    }

    $curDir = $PWD
    if ($Path -eq '-' -and ![String]::IsNullOrEmpty($global:OldPWD)) {
        $destDir = $global:OldPWD
    } else {
        $destDir = $Path
    }

    try {
        Set-Location $destDir -ErrorAction Stop
        $global:OldPWD = $curDir
    } catch {
        throw $_
    }
}

Set-Alias -Name new -Value New-Object -Force

$global:GitCommand = Get-Command git -ErrorAction SilentlyContinue

if (Test-Path Function:ParseGitStatus) { Remove-Item Function:\ParseGitStatus }
function ParseGitStatus {
    [CmdletBinding()]
    param ()

    # Bail early if the git executable isn't in the path.
    if ($global:GitCommand -eq $null) {
        Write-Verbose "Git was not found."
        return
    }

    # Iterate up the directory tree until a .git directory is found, if one
    # exists.
    $path = Get-Item $PWD -Force
    do {
        $gitDir = Join-Path -Path $path.FullName -ChildPath ".git"
        if (Test-Path $gitDir) {
            $head = Get-Content (Join-Path -Path $gitDir -ChildPath "HEAD" -ErrorAction SilentlyContinue)
            $branch = $head -replace 'ref: refs/heads/(.*)', '$1'
            if ([String]::IsNullOrEmpty($branch)) {
                return
            }

            if ($PWD.Path -eq $gitDir) {
                Write-Verbose "Not parsing git status because it must be run in a work tree."
            } else {
                $status = $(git status --porcelain)
                $result = ""
                if ($status -match '^ D')   { $result += "-" }
                if ($status -match '^\s?M') { $result += "*" }
                if ($status -match '^\?\?') { $result += "+" }
            }

            "[$($branch)$($result)] "
            break
        } else {
            $path = $path.Parent
        }
    } while ($path)
}

# Quicker way to clear the console.
# http://powershell.com/cs/blogs/tips/archive/2010/10/21/clearing-console-content.aspx
if (Test-Path Function:\Clear-Host) { Remove-Item Function:\Clear-Host }
function Clear-Host { [System.Console]::Clear() }

if (Test-Path Function:\which) { Remove-Item Function:\which }
function which {
    param ( [string]$Command )
    $cmd = Get-Command $Command -ErrorAction SilentlyContinue
    if (![String]::IsNullOrEmpty($cmd)) {
        $cmd.Source
    }
}

# Set the prompt to the current path (excluding the provider).  If the path
# would be longer than half the width of the window, remove the middle bits.
function prompt {
    $fullPath = (Get-Location).ProviderPath
    if ($fullPath.Length -gt ($Host.UI.RawUI.WindowSize.Width / 2)) {
        $null = $fullPath -match '(\w+:\\|\\\\.*?\\.*?\\).*\\(.*)'
        if ($matches.Count -ge 3) {
            $promptPath = $Matches[1] + "..." + $Matches[2]
        }
    } else {
        $promptPath = $fullPath
    }

    if ($host.Version.Major -lt 6 -or $IsWindows) {
        $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $user = $currentUser.Name -replace '.*\\(.+)', '$1'

        $adminRole = [System.Security.Principal.WindowsBuiltInRole]"Administrator"
        $isAdmin = ([System.Security.Principal.WindowsPrincipal]$CurrentUser).IsInRole($adminRole)
        $hostname = $Env:COMPUTERNAME

    } else {
        $user = $(Get-Item Env:USER).Value
        $hostname = hostname -s
        if ($(id -u) -eq 0) {
            $isAdmin = $true
        }
    }

    $host.UI.RawUI.WindowTitle = "[{0}@{1}] {2}" -f $user, $hostname, $fullPath

    if ($isAdmin) {
        $pre = "[!!]"; $user = $user.ToUpper()
    } else {
        $pre = "[PS]"
    }


    if ($PSSenderInfo -eq $null) {
        return $("{0} {1}{2}> " -f $pre, $(ParseGitStatus), $promptPath)
    } else {
        # We're in a remote session.  Remote sessions don't play nice with
        # changing the prompt.
        return "$promptPath> "
    }
}

# Blank line before initial prompt.
Write-Host ""
