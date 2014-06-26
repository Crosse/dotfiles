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

RC_PATH=${HOME}/.rc
[[ -r "$RC_PATH/functions" ]] && source "${RC_PATH}/functions"

# Set $PS1 to something pretty.
[[ -r "${RC_PATH}/prompt" ]] && source "${RC_PATH}/prompt"

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

[[ -r "${RC_PATH}/aliases" ]] && source "${RC_PATH}/aliases"
