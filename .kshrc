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

# These two functions will only add a path to the PATH if it exists.
function prepend-to-path {
    [[ -d "$1" && "$PATH" != *${1}* ]] && PATH=$1:$PATH
}

function append-to-path {
    [[ -d "$1" && "$PATH" != *${1}* ]] && PATH=$PATH:$1
}

prepend-to-path "${HOME}/bin"
prepend-to-path "${HOME}/.rbenv/bin"
prepend-to-path "/usr/local/git/bin"
export PATH

# Some bash-specific things
if [ ${0#-} == 'bash' ]; then
    # Source global definitions, if they exist
    if [ -f /etc/bashrc ]; then . /etc/bashrc; fi
fi

if [ -f "${HOME}/.gpg-agent-info" ]; then
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO SSH_AUTH_SOCK SSH_AGENT_PID
    export GPG_TTY=$(tty)
fi

if [ -x "$(command -v rbenv)" ]; then
    eval "$(rbenv init -)"
fi
