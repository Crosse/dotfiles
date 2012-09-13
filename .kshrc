################################################################################
#
# Copyright (c) 2010-2012 Seth Wright (seth@crosse.org)
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

if [ -x "$(which git 2>/dev/null)" ]; then
    function parse_git_branch_and_add_brackets {
        if [ -z "$NOPATHBRANCHES" ]; then
            git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
        fi
    }
else
    function parse_git_branch_and_add_brackets {
        return
    }
fi

# Colorized prompt that should work in ksh and bash
if [ $(id -ru) == '0' ] ; then
    HOSTCOLOR="\[\e[0;31m\]"
else
    HOSTCOLOR="\[\e[0;32m\]"
fi

PS1="${HOSTCOLOR}\u@\h\$(parse_git_branch_and_add_brackets)\[\e[0;34m\] \w \$\[\e[00m\] "

# This section will set the title of an xterm.
case $TERM in
    xterm*|rxvt*|screen)
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
        bind -m ''=clear^J
    fi
fi

#######################################
#                 End                 #
#######################################
