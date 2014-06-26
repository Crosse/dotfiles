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
# ~/.profile
#
# This file is read by interactive login shells and non-interactive
# shells with the -l/--login option, and also when bash/ksh is invoked
# with the name 'sh'.
########################################################################

# Use UTF-8.  It's the 21st century.
if [ -n "$LANG" ]; then
    export LANG=en_US.UTF-8
    export LC_ALL="$LANG"
fi

# Some shell-specific things.
case ${0#-} in
    "bash")
        # Enable history appending instead of overwriting.
        shopt -s histappend
        ;;
    "ksh")
        # As per ksh(1): "If the ENV parameter is set when an
        # interactive shell starts (or, in the case of login shells,
        # after any profiles are processed), its value is subjected to
        # parameter, command, arithmetic, and tilde (`~') substitution
        # and the resulting file (if any) is read and executed."
        [[ -f "${HOME}/.kshrc" ]] && export ENV="${HOME}/.kshrc"
        ;;
esac

# Attempt to sanitize TERM.
if [ "$TERM" = "xterm" ] ; then
    if [ -z "$COLORTERM" ] ; then
        if [ -z "$XTERM_VERSION" ] ; then
            echo "Warning: Terminal wrongly calling itself 'xterm'."
        else
            case "$XTERM_VERSION" in
                "XTerm(256)")
                    TERM="xterm-256color"
                    ;;
                "XTerm(88)")
                    TERM="xterm-88color"
                    ;;
                XTerm/OpenBSD*)
                    # OpenBSD's xterm can handle 256 colors, but doesn't
                    # seem to advertise it.
                    TERM="xterm-256color"
                    ;;
                XTerm)
                    ;;
                *)
                    echo "Warning: Unrecognized XTERM_VERSION: $XTERM_VERSION"
                    ;;
            esac
        fi
    else
        case "$COLORTERM" in
            gnome-terminal)
                # Those crafty Gnome folks require you to check COLORTERM,
                # but don't allow you to just *favor* the setting over TERM.
                # Instead you need to compare it and perform some guesses
                # based upon the value. This is, perhaps, too simplistic.
                TERM="gnome-256color"
                ;;
            *)
                echo "Warning: Unrecognized COLORTERM: $COLORTERM"
                ;;
        esac
    fi
fi

# ...and now, try to figure out how many colors $TERM supports, along
# with more $TERM sanitization.
SCREEN_COLORS="`tput colors`"
if [ -z "$SCREEN_COLORS" ] ; then
    case "$TERM" in
        screen-*color-bce)
            echo "Unknown terminal $TERM. Falling back to 'screen-bce'."
            export TERM=screen-bce
            ;;
        *-88color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-88color'."
            export TERM=xterm-88color
            ;;
        *-256color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-256color'."
            export TERM=xterm-256color
            ;;
    esac
    SCREEN_COLORS=`tput colors`
    if [ -z "$SCREEN_COLORS" ] ; then
        case "$TERM" in
            gnome*|xterm*|konsole*|aterm|[Ee]term)
                echo "Unknown terminal $TERM. Falling back to 'xterm'."
                export TERM=xterm
                ;;
            rxvt*)
                echo "Unknown terminal $TERM. Falling back to 'rxvt'."
                export TERM=rxvt
                ;;
            screen*)
                echo "Unknown terminal $TERM. Falling back to 'screen'."
                export TERM=screen
                ;;
        esac
        SCREEN_COLORS=`tput colors`
    fi
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
