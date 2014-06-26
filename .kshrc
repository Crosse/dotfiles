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

RC_PATH=${HOME}/.rc
[[ -r "$RC_PATH/functions" ]] && source "${RC_PATH}/functions"
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


# Set $PS1 to something pretty.
[[ -r "${RC_PATH}/prompt" ]] && source "${RC_PATH}/prompt"

# OS-specific stuff can be found in .rc/<uname>; for instance:
# - OpenBSD:    .rc/OpenBSD
# - Linux:      .rc/Linux
# - OSX:        .rc/Darwin
OS_RCFILE="${RC_PATH}/$(uname)"
[[ -r "$OS_RCFILE" ]] && source "$OS_RCFILE"

prepend-to-path "${HOME}/.rbenv/bin"
prepend-to-path "${HOME}/bin"
export PATH

[[ -r "${RC_PATH}/aliases" ]] && source "${RC_PATH}/aliases"
[[ -r "${RC_PATH}/local" ]] && source "${RC_PATH}/local"
