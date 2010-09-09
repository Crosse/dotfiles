################################################################################
# 
# $Id$
# 
# Copyright (c) 2010 Seth Wright (seth@crosse.org)
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
#
# .{ksh,bash}rc
# This file is read by interactive shells.
#
# 
# For bash, this file should be renamed to ~/.bashrc
# For ksh, this file should be renamed to ~/.kshrc and
# the following line should be placed in your ~/.profile file:
#       export ENV=${HOME}/.kshrc
################################################################################

# Some bash-specific things
if [ ${0#-} == 'bash' ]; then
    # Source global definitions, if they exist
    if [ -f /etc/bashrc ]; then . /etc/bashrc; fi

    # Enable history appending instead of overwriting.
    shopt -s histappend
fi

# Colorized prompt that should work in ksh and bash
if [[ $(id -ru) == 'root' ]] ; then
    PS1='\[\e[0;31m\]\u@\h\[\e[0;34m\] \w \$\[\e[00m\] '
else
    PS1='\[\e[0;32m\]\u@\h\[\e[0;34m\] \w \$\[\e[00m\] '
fi

case $TERM in
    xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
    *)
    ;;
esac


# For ksh, enables history.  For both ksh and bash, log
# to the same file.
export HISTFILE=$HOME/.history

#######################################
#            Key Bindings             #
#######################################
if [ ${0#-} == 'ksh' ]; then
    if [ -o interactive ]; then
        # Map ^L to clear
        bind -m ''=clear^J
    fi
fi


#######################################
#        Environment Variables        #
#######################################

# Look for vim...
VI=$(which vim)
if [ -z "$VI" ]; then
    # ...but use vi if vim doesn't exist.
    VI=$(which vi)
fi
# Note that setting these in ksh means vi keybindings
# are also active instead of emacs...
EDITOR=$VI
VISUAL=$VI
export EDITOR VISUAL

# Using ksh, setting EDITOR or VISUAL (above) also sets vi
# key bindings.  This sets it back to emacs.
set -o emacs

PAGERCMD=$(which less)
if [ -x "${PAGERCMD}" ]; then
    PAGER=${PAGERCMD}
    # Set options for less so that it:
    # quits if only one screen;
    # cause searches to ignore case;
    # display a status column;
    # display a more verbose prompt, including % into the file;
    # don't clear the screen after quitting.
    export LESS="-F -i -J -m -X"
else
    PAGERCMD=$(which more)
    if [ -x "${PAGERCMD}" ]; then
        PAGER=${PAGERCMD}
    fi
fi
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
    fi
    ;;

    "Darwin")
    # Darwin includes some GNU things and some less-than-GNU
    # things, but color options exist on the default 
    # 'ls' and 'grep' commands so enable them.
    alias ls='ls -G'
    alias grep='grep --colour=auto'
    ;;
esac

#######################################
# System-Independent Aliases
#######################################
alias mv='mv -i'
alias cp='cp -i'
alias ll='ls -lah'
alias dir='ls -lah'
alias rdp='rdesktop -ANDzP'
alias t='tmux attach-session -t main'

#######################################
#       Clean up the environment      #
#######################################
unset PAGERCMD
unset VI

#######################################
# Start any necessary programs, etc.  #
#######################################
if [ -o interactive ]; then
    if [ "$TERM" != "screen" ]; then
        # we're not in tmux...(easy test)
        # now check if tmux exists.
        if [ -x "$(which tmux)" ]; then
            tmux has-session -t main 2> /dev/null
            if [ $? -ne 0 ]; then
                # no sessions exist; start up a new one
                # Otherwise, we'll ignore this section and the 
                # user can enter the session manually.
                #tmux attach-session -t main
                echo "Enter tmux session by using `t`"
            fi
        fi
    fi
    if [ -x "$(which fortune)" ]; then
        fortune -s
    fi
fi
