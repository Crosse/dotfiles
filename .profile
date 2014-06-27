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
# ~/.profile
#
# This file is read by interactive login shells and non-interactive
# shells with the -l/--login option, and also when bash/ksh is invoked
# with the name 'sh'.
########################################################################

# Some shell-specific things.
if [ ${0#-} == "ksh" ]; then
    # As per ksh(1): "If the ENV parameter is set when an
    # interactive shell starts (or, in the case of login shells,
    # after any profiles are processed), its value is subjected to
    # parameter, command, arithmetic, and tilde (`~') substitution
    # and the resulting file (if any) is read and executed."
    [[ -f "${HOME}/.kshrc" ]] && export ENV="${HOME}/.kshrc"
fi

# Look for Vim...
EDITOR="$(command -v vim)"
if [ -z "$EDITOR" ]; then
    # ...but use vi if Vim doesn't exist.
    EDITOR=vi
fi
VISUAL=$EDITOR
export EDITOR VISUAL

PAGER="$(command -v less)"
if [ -x "${PAGER}" ]; then
    # Set options for less so that it:
    #   quits if only one screen (-F);
    #   causes searches to ignore case (-i);
    #   displays a status column (-J);
    #   displays a more verbose prompt, including % into the file (-m);
    #   interprets ANSI color escape sequences (-R);
    #   doesn't clear the screen after quitting (-X).
    export LESS="-FiJmRX"
else
    PAGER="$(command -v more)"
fi
export PAGER

# start gpg-agent, if installed.
if [ -x "$(command -v gpg-agent)" ]; then
    if [ -f "${HOME}/.gpg-agent-info" ]; then
        . "${HOME}/.gpg-agent-info"
        export GPG_AGENT_INFO SSH_AUTH_SOCK SSH_AGENT_PID
    fi

    if [ ! -S "$(echo $GPG_AGENT_INFO | cut -f1 -d':')" ]; then
        eval $(gpg-agent --enable-ssh-support --daemon --write-env-file)
    fi
fi

# If Go is installed, let it set whatever variables it wants to.
if [ -x "$(command -v go)" ]; then
    eval $(go env)
    export GOROOT
fi

# If Rbenv is installed (http://rbenv.org), initialize it.
if [ -x "$(command -v rbenv)" ]; then
    eval "$(rbenv init -)"
fi

# If Python's virtualenvwrapper is installed, initialize it.
if [ -x $(command -v virtualenvwrapper.sh) ]; then
    export WORKON_HOME=${HOME}/.virtualenvs
    export PROJECT_HOME=${HOME}/code
    source /usr/local/bin/virtualenvwrapper.sh
fi
