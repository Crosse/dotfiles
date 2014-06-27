########################################################################
#
# Copyright (c) 2010-2014 Seth Wright (seth@crosse.org)
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
# * For bash, this file could be renamed to ~/.bashrc, or simply
#   symlinked.
# * For ksh, the following line should be placed in your ~/.profile:
#       export ENV=${HOME}/.kshrc
########################################################################

RC_PATH=${HOME}/.rc
[[ -r "$RC_PATH/functions" ]] && . "${RC_PATH}/functions"

# Use UTF-8.  It's the 21st century.
if [ -n "$LANG" ]; then
    export LANG=en_US.UTF-8
    export LC_ALL="$LANG"
fi

case "${0#-}" in
    bash)
        # Source global bashrc files, if they exist.
        if [ -f /etc/bashrc ]; then . /etc/bashrc; fi

        # Enable history appending instead of overwriting.
        shopt -s histappend
        ;;
    ksh*)
        if [ "${-}" == *i* ]; then
            # Things to do if the shell is interactive.

            # Map ^L to clear.
            bind -m '^L'='^Uclear^J^Y'

            # Create tracked aliases for all commands.  This is the
            # equivalent of "hashall" in bash.
            set -o trackall
        fi
        ;;
esac

if [ "${-}" == *i* ]; then
    # Shell-agnostic things to do if the shell is interactive.

    # Using ksh, setting EDITOR or VISUAL (above) also sets vi key bindings.
    # This sets it back to emacs, which is what I prefer.
    # In other shells, it doesn't hurt to set it as well.
    set -o emacs

    # For ksh, enable history.  For both ksh and bash, log to the same file.
    export HISTFILE=$HOME/.history

    # Set $PS1 to something pretty.
    [[ -r "${RC_PATH}/prompt" ]] && . "${RC_PATH}/prompt"
fi


# OS-specific stuff can be found in .rc/os/<uname>; for instance:
# - OpenBSD:    .rc/os/OpenBSD
# - Linux:      .rc/os/Linux
# - OSX:        .rc/os/Darwin
OS_RCFILE="${RC_PATH}/os/$(uname)"
[[ -r "$OS_RCFILE" ]] && . "$OS_RCFILE"

prepend-to-path "${HOME}/.rbenv/bin"
prepend-to-path "${HOME}/bin"
export PATH

[[ -r "${RC_PATH}/aliases" ]] && . "${RC_PATH}/aliases"
[[ -r "${RC_PATH}/local" ]] && . "${RC_PATH}/local"
