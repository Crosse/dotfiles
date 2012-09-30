########################################################################
#
# Copyright (c) 2010-2012 Seth Wright (seth@crosse.org)
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
# ~/.profile
#
# This file is read by interactive login shells and non-interactive
# shells with the -l/--login option, and also when bash is invoked with
# the name 'sh'.
########################################################################

# Some shell-specific things
case ${0#-} in
    "bash")
        # Run various non-interactive scripts.
        if [ -f "${HOME}/.bashrc" ]; then
            . "${HOME}/.bashrc"
        fi

        # Enable history appending instead of overwriting.
        shopt -s histappend
        ;;
    "ksh")
        if [ -o interactive ]; then
            # Map ^L to clear
            bind -m ''=clear^J
        fi

        # As per ksh(1): "If the ENV parameter is set when an
        # interactive shell starts (or, in the case of login shells,
        # after any profiles are processed), its value is subjected to
        # parameter, command, arithmetic, and tilde (`~') substitution
        # and the resulting file (if any) is read and executed."
        if [ -f "${HOME}/.kshrc" ]; then
            export ENV="${HOME}/.kshrc"
        fi
        ;;
esac

# For ksh, enables history.  For both ksh and bash, log to the same
# file.
export HISTFILE=$HOME/.history

# Function used to add the git branch name to PS1.
if [ -x "$(command -v git)" ]; then
    function add_git_branch {
        if [ -z "$NOPATHBRANCHES" ]; then
            git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
        fi
    }
else
    function add_git_branch {
        return
    }
fi

# Change the prompt color depending on whether the real uid is root or a
# regular user.
if [ $(id -ru) == '0' ] ; then
    HOSTCOLOR="\[\e[0;31m\]"
else
    HOSTCOLOR="\[\e[0;32m\]"
fi

# Set the title of an xterm.
case $TERM in
    xterm*|rxvt*|screen)
    TERMTITLE="\[\e]0;\u@\h: \w\a\]"
    ;;
esac

# Build a colorized prompt that should work in ksh and bash.
export PS1="${TERMTITLE}${HOSTCOLOR}\u@\h\$(add_git_branch)\[\e[0;34m\] \w \$\[\e[00m\] "

# Look for vim...
VI="$(command -v vim)"
if [ -z "$VI" ]; then
    # ...but use vi if vim doesn't exist.
    VI=vi
fi

# Note that setting these in ksh means vi keybindings are also active
# instead of emacs...
EDITOR=$VI
VISUAL=$VI
unset VI
export EDITOR VISUAL

# Using ksh, setting EDITOR or VISUAL (above) also sets vi key bindings.
# This sets it back to emacs, which is what I prefer.
set -o emacs

PAGERCMD="$(command -v less)"
if [ -x "${PAGERCMD}" ]; then
    PAGER=${PAGERCMD}
    # Set options for less so that it:
    #   quits if only one screen (-F);
    #   causes searches to ignore case (-i);
    #   displays a status column (-J);
    #   displays a more verbose prompt, including % into the file (-m);
    #   interprets ANSI color escape sequences (-R);
    #   doesn't clear the screen after quitting (-X).
    export LESS="-FiJmRX"
else
    PAGERCMD="$(command -v more)"
    if [ -x "${PAGERCMD}" ]; then
        PAGER=${PAGERCMD}
    fi
fi
unset PAGERCMD
export PAGER

case $(uname) in
    "Linux")
        # Linux uses GNU less, which includes color support
        alias ls='ls --color=auto'
        # Enable color by default for grep as well
        alias grep='grep --colour=auto'
        ;;
    "OpenBSD")
        # Workaround for OpenBSD not showing colors for TERM=xterm.
        if [ "$TERM" == "xterm" ]; then
            export TERM="xterm-xfree86"
        fi
        # For OpenBSD, if the colorls package has been installed, use it
        # instead of ls.
        if [ -x "$(command -v colorls)" ]; then
            alias ls='colorls -G'
            export CLICOLOR=""
            export LSCOLORS=gxfxcxdxbxegEdabagacad
        fi
        ;;
    "Darwin")
        # Darwin includes some GNU things and some less-than-GNU things,
        # but color options exist on the default 'ls' and 'grep'
        # commands so enable them.
        alias ls='ls -G'
        alias grep='grep --colour=auto'
        export CLICOLOR=""
        export LSCOLORS=gxfxcxdxbxegEdabagacad
        # Work around a VIM incompatibility with crontab on OSX.
        alias crontab='VIM_CRONTAB=true crontab'
        ;;
esac

# ccache stuff, if ever needed.
export CCACHE_DIR=${HOME}/.ccache
#export CCACHE_LOGFILE=${CCACHE_DIR}/ccache.log

# start gpg-agent, if installed.
if [ -x "$(command -v gpg-agent)" ]; then
    if [ -f "${HOME}/.gpg-agent-info" ]; then
        . "${HOME}/.gpg-agent-info"
        export GPG_AGENT_INFO SSH_AUTH_SOCK SSH_AGENT_PID
    fi

    if [ ! -S "$SSH_AUTH_SOCK" ]; then
        eval $(gpg-agent --enable-ssh-support --daemon --write-env-file)
    fi
fi

alias cls='clear'
alias ll='ls -lah'
alias la='ls -a'
alias dir='ls -lah'
alias rdp='rdesktop -ANDzP'
alias t='tmux attach-session -t main'
