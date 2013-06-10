########################################################################
#
# Copyright (c) 2010-2013 Seth Wright (seth@crosse.org)
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
# AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
# DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
# PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
# TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
########################################################################
#
# ~/.kshrc
#
# This file is read by interactive shells.
#
#
# * For bash, this file could be renamed to ~/.bashrc.
# * For ksh, the following line should be placed in your ~/.profile:
#       export ENV=${HOME}/.kshrc
########################################################################

if [ ${0#-} == 'bash' ]; then
    # Source global definitions, if they exist.
    if [ -f /etc/bashrc ]; then . /etc/bashrc; fi
fi

if [ -o interactive ]; then
    # Map ^L to clear.
    bind -m '^L'='^Uclear^J^Y'

    # Create tracked aliases for all commands.  This is the
    # equivalent of "hashall" in bash.
    set -o trackall

    # Using ksh, setting EDITOR or VISUAL (above) also sets vi key bindings.
    # This sets it back to emacs, which is what I prefer.
    set -o emacs
fi

# These two functions will only add a path to the PATH if it exists.
function prepend-to-path {
    [[ -d "$1" && "$PATH" != *${1}* ]] && PATH=$1:$PATH
}

function append-to-path {
    [[ -d "$1" && "$PATH" != *${1}* ]] && PATH=$PATH:$1
}

# Function used to add the git branch name to PS1.
if [ -x "$(command -v git)" ]; then
    function parse_git_status {
        if [ -z "$NOPATHBRANCHES" ]; then
            local branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
            [[ -z $branch ]] && return

            local status=$(git status 2> /dev/null)
            local result=$branch

            [[ "$status" = *deleted:* ]] && result=${result}-
            [[ "$status" = *modified:* ]] && result=${result}*
            [[ "$status" = *Untracked\ files:* ]] && result=${result}+
            printf " [$result]"
        fi
    }
else
    function parse_git_status {
        return
    }
fi

SCREEN_COLORS=$(tput colors)
if [ $SCREEN_COLORS -gt 0 ]; then
    # Force 256-color in tmux if the "real" terminal supports 256
    # colors.
    if [ "$TERM" == "screen" -a "$SCREEN_COLORS" == 256 ]; then
        TERM=screen-256color
    fi

    # Change the prompt color depending on whether the real uid is root
    # or a regular user.
    if [ $(id -ru) == '0' ] ; then
        HOSTCOLOR="\[\e[0;31m\]"
    else
        HOSTCOLOR="\[\e[0;32m\]"
    fi

    # Set the title of an xterm.
    case $TERM in
        xterm*|rxvt*|screen*)
            TERMTITLE="\[\e]0;\u@\h: \w\a\]"
            ;;
    esac

    # Build a colorized prompt.
    export PS1="${TERMTITLE}${HOSTCOLOR}\u@\h\$(parse_git_status)\[\e[0;34m\] \w \$\[\e[00m\] "
else
    # Build a "dumb" prompt that should work everywhere.
    export PS1="\u@\h\$(parse_git_status) \w \$ "
fi

case $(uname) in
    "Linux")
        # Linux uses GNU less, which includes color support
        alias ls='ls --color=auto'
        [[ -x "$(command -v dircolors)" ]] && eval $(dircolors)

        # Linux uses GNU grep.  Set options such that color support is
        # enabled, binary files will be ignored, and files named "tags"
        # will not be searched.
        export GREP_OPTIONS="--colour=auto --binary-files=without-match --exclude=tags"

        [[ -x "$(command -v dircolors)" ]] && eval $(dircolors)
        ;;
    "OpenBSD")
        # For OpenBSD, if the colorls package has been installed, use it
        # instead of ls.
        if [ -x "$(command -v colorls)" ]; then
            alias ls='colorls -G'
            export CLICOLOR=""
            export LSCOLORS=gxfxcxdxbxegEdabagacad
        fi

        # Ignore binary files by default.  This is the only option that
        # BSD grep supports that is the same as GNU grep.
        alias grep='grep --binary-files=without-match'
        ;;
    "Darwin")
        # Darwin/OSX includes some GNU things and some less-than-GNU
        # things, but color options exist on the default 'ls' and 'grep'
        # commands so enable them.
        alias ls='ls -G'
        export CLICOLOR=""
        export LSCOLORS=gxfxcxdxbxegEdabagacad

        # Darwin uses BSD grep, but it seems to respect options set via
        # GREP_OPTIONS just like GNU grep, even though it is not
        # mentioned in the man page.  Set options such that color
        # support is enabled, binary files will be ignored, and files
        # named "tags" will not be searched.
        export GREP_OPTIONS="--colour=auto --binary-files=without-match --exclude=tags"

        # Work around a VIM incompatibility with crontab on OSX.  This
        # requires settings in .vimrc as well.
        alias crontab='VIM_CRONTAB=true crontab'
        ;;
esac

prepend-to-path "${HOME}/bin"
prepend-to-path "${HOME}/.rbenv/bin"
prepend-to-path "/usr/local/git/bin"
export PATH

# Miscellaneous aliased commands.
alias cls='clear'
alias ll='ls -lah'
alias la='ls -a'
alias dir='ls -lah'
alias rdp='rdesktop -ANDzP'
alias t='tmux attach-session -t main'
[[ -z "$(command -v hd)" ]] && alias hd='hexdump -C'
