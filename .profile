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


# Only add ~/bin to the path if it exists, and if it doesn't already
# exist in $PATH.
HOMEBIN=${HOME}/bin
[[ -d "$HOMEBIN" && "$PATH" != *${HOMEBIN}* ]] && PATH=$HOMEBIN:$PATH

case $(uname) in
    "Darwin")
        # Added to support git on Mac OSX.
        if [ -d /usr/local/git/bin ]; then
            PATH=$PATH:/usr/local/git/bin
        fi
    ;;
esac

# ccache stuff, if ever needed.
export CCACHE_DIR=${HOME}/.ccache
#export CCACHE_LOGFILE=${CCACHE_DIR}/ccache.log

export PATH HOME TERM

#######################################
#        Environment Variables        #
#######################################

# Look for vim...
VI="$(which vim 2>/dev/null)"
if [ -z "$VI" ]; then
    # ...but use vi if vim doesn't exist.
    VI=$(which vi 2>/dev/null)
fi
# Note that setting these in ksh means vi keybindings
# are also active instead of emacs...
EDITOR=$VI
VISUAL=$VI
unset VI
export EDITOR VISUAL

# Using ksh, setting EDITOR or VISUAL (above) also sets vi key bindings.
# This sets it back to emacs, which is what I prefer.
set -o emacs

PAGERCMD="$(which less 2>/dev/null)"
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
    PAGERCMD="$(which more 2>/dev/null)"
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
        # For OpenBSD, if the colorls package has been installed,
        # use it instead of ls.
        if [ -x "$(which colorls)" ]; then
            alias ls='colorls -G'
            export CLICOLOR=""
            export LSCOLORS=gxfxcxdxbxegEdabagacad
        fi
        ;;

    "Darwin")
        # Darwin includes some GNU things and some less-than-GNU
        # things, but color options exist on the default
        # 'ls' and 'grep' commands so enable them.
        alias ls='ls -G'
        alias grep='grep --colour=auto'
        export CLICOLOR=""
        export LSCOLORS=gxfxcxdxbxegEdabagacad
        # Work around a VIM incompatibility with crontab on OSX.
        alias crontab='VIM_CRONTAB=true crontab'
        ;;
esac

#######################################
#      System-Independent Aliases     #
#######################################
alias cls='clear'
alias ll='ls -lah'
alias la='ls -a'
alias dir='ls -lah'
alias rdp='rdesktop -ANDzP'
alias t='tmux attach-session -t main'

# As per ksh(1): "If the ENV parameter is set when an interactive shell
# starts (or, in the case of login shells, after any profiles are
# processed), its value is subjected to parameter, command, arithmetic,
# and tilde (`~') substitution and the resulting file (if any) is read
# and executed."
case ${0#-} in
    "bash")
        if [ -f "${HOME}/.kshrc" ]; then
            . "${HOME}/.kshrc"
        fi
    ;;

    "ksh")
        export ENV="${HOME}/.kshrc"
    ;;
esac
