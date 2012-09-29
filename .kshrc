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
# ~/.kshrc
#
# This file is read by interactive shells.
#
#
# * For bash, this file could be renamed to ~/.bashrc.
# * For ksh, this file should be renamed to ~/.kshrc and
#   the following line should be placed in your ~/.profile file:
#       export ENV=${HOME}/.kshrc
########################################################################

# Only add ~/bin to the path if it exists, and if it doesn't already
# exist in $PATH.
HOMEBIN=${HOME}/bin
[[ -d "$HOMEBIN" && "$PATH" != *${HOMEBIN}* ]] && PATH=$HOMEBIN:$PATH
export PATH

case $(uname) in
    "Darwin")
        # Added to support git on Mac OSX.
        if [ -d /usr/local/git/bin ]; then
            PATH=/usr/local/git/bin:$PATH
        fi
    ;;
esac

# Some bash-specific things
if [ ${0#-} == 'bash' ]; then
    # Source global definitions, if they exist
    if [ -f /etc/bashrc ]; then . /etc/bashrc; fi
fi
