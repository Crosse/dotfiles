# vim: set ft=sh: -*- mode: sh -*-

export COLOR_SCHEME=light

shell=$(basename "${0#-}")
case "${shell#-}" in
    bash)
        # Source global bashrc files, if they exist.
        #shellcheck source=/dev/null
        [[ -r /etc/bashrc ]] && . /etc/bashrc

        # Enable history appending instead of overwriting.
        shopt -s histappend
        # Enable the ability to use ** in pathname expansion.
        [[ ${BASH_VERSINFO[0]} -gt 3 ]] && shopt -s globstar

        # Do not append duplicate lines and lines that begin with a
        # space to history
        export HISTCONTROL=ignoreboth

        ;;
    ksh)
        case "$-" in
            *i*)
                # Things to do if the shell is interactive.

                # Map ^L to clear, but only for pdksh.
                if [[ "$KSH_VERSION" == *PD* ]]; then
                    bind -m '^L'='^Uclear^J^Y'
                fi

                # Create tracked aliases for all commands.  This is the
                # equivalent of "hashall" in bash.
                set -o trackall
                ;;
        esac
        ;;
    sh)
        # don't even try.
        return
        ;;
esac

# XDG Base Directory specification.
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-${HOME}/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-${HOME}/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-${HOME}/.local/share}

export UNAME=$(uname -s)

######## Functions required for the rest of this behemoth to operate.

rc_log() {
    [[ $- == *i* ]] && printf "%s\n" "${*}" 1>&2
}

rc_source_file() {
    #shellcheck disable=SC1090
    [[ -r $1 ]] && . "$1"
}

remove_from_path() {
    # Remove a path from a path variable.
    #
    # Usage:
    #   $ remove_from_path path/to/remove [PATH_VAR_NAME]
    #
    # (Note the lack of "$" on PATH_VAR_NAME)
    # If PATH_VAR_NAME isn't provided, PATH is assumed.
    local NEWPATH DIR
    local PATHVARIABLE=${2:-PATH}
    eval "typeset TEMPPATH=\"\$$PATHVARIABLE\""
    typeset IFS=":"
    for DIR in $TEMPPATH; do
        if [ "$DIR" != "$1" ] ; then
            NEWPATH="${NEWPATH:+$NEWPATH:}$DIR"
        fi
    done
    #shellcheck disable=SC2086
    export $PATHVARIABLE="${NEWPATH%%:}"
}

prepend_to_path() {
    # Prepend a path to a path variable.  If the path already exists, it
    # will be removed first.
    #
    # Usage:
    #   $ prepend-to-path path/to/prepend [PATH_VAR_NAME]
    #
    # (Note the lack of "$" on PATH_VAR_NAME)
    # If PATH_VAR_NAME isn't provided, PATH is assumed.
    remove_from_path "$1" "$2"
    local PATHVARIABLE=${2:-PATH}
    if [ -d "$1" ]; then
        eval "typeset TEMPPATH=\"$1:\$$PATHVARIABLE\""
        TEMPPATH="${TEMPPATH%%:}"
        #shellcheck disable=SC2086
        export $PATHVARIABLE="$TEMPPATH"
    fi
}

append_to_path() {
    # Append a path to a path variable.  If the path already exists, it
    # will be removed first.
    #
    # Usage:
    #   $ append-to-path path/to/append [PATH_VAR_NAME]
    #
    # (Note the lack of "$" on PATH_VAR_NAME)
    # If PATH_VAR_NAME isn't provided, PATH is assumed.
    remove_from_path "$1" "$2"
    local PATHVARIABLE=${2:-PATH}
    if [ -d "$1" ]; then
        eval "typeset TEMPPATH=\"\$$PATHVARIABLE:$1\""
        TEMPPATH="${TEMPPATH##:}"
        #shellcheck disable=SC2086
        export $PATHVARIABLE="$TEMPPATH"
    fi
}

dedupe_path() {
    if [ -n "$PATH" ]; then
        local old_PATH=$PATH:
        #shellcheck disable=2123
        PATH=
        while [ -n "$old_PATH" ]; do
            local x=${old_PATH%%:*}       # the first remaining entry
            case $PATH: in
                *:"$x":*) ;;         # already there
                *) PATH=$PATH:$x;;    # not there yet
            esac
            old_PATH=${old_PATH#*:}
        done
        export PATH=${PATH#:}
    fi
}


PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

prepend_to_path /usr/pkg/sbin                       # For pkgsrc on Darwin, illumos
prepend_to_path /opt/pkg/sbin                       # For pkgsrc on Darwin, illumos
prepend_to_path /opt/local/sbin                     # illumos

prepend_to_path /usr/pkg/bin                        # For pkgsrc on Darwin, illumos
prepend_to_path /opt/pkg/bin                        # For pkgsrc on Darwin, illumos
prepend_to_path /opt/local/bin                      # illumos

prepend_to_path "${HOME}/.local/bin"
prepend_to_path "${HOME}/bin"

for link in "${HOME}"/.paths.d/*; do
    [[ ! -h $link ]] && continue
    case $UNAME in
        "Darwin")
            path=$(readlink "$link")
            if [[ $path != /* ]]; then # relative path
                rc_log "resolving $link using python; use a full path for the target to avoid this"
                path=$(python -c "import os; print(os.path.realpath('$link'))")
            fi
            ;;
        *)
            path=$(readlink -f "$link")
            ;;
    esac
    [[ -n ${path:-} ]] && prepend_to_path "$path"
done


# Shell-agnostic things to do if the shell is interactive.
if [[ "$-" == *i* ]]; then
    # Using ksh, setting EDITOR or VISUAL (above) also sets vi key bindings.
    # This sets it back to emacs, which is what I prefer.
    # In other shells, it doesn't hurt to set it as well.
    set -o emacs

    # For ksh, enable history.  For both ksh and bash, log to the same file.
    export HISTFILE=$HOME/.history

    # Disable Ctrl-S.
    stty -ixon

    # Attempt to sanitize TERM.  This is (mostly) wholesale-taken from the
    # comment by Steven Black at:
    #   http://vim.wikia.com/wiki/256_colors_in_vim.
    if [ "$TERM" = "xterm" ] ; then
        if [ -z "$COLORTERM" ] ; then
            if [ -z "$XTERM_VERSION" ] ; then
                rc_log "Warning: Terminal wrongly calling itself 'xterm'."
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
                        rc_log "Warning: Unrecognized XTERM_VERSION: $XTERM_VERSION"
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
                    rc_log "Warning: Unrecognized COLORTERM: $COLORTERM"
                    ;;
            esac
        fi
    fi

    get_best_term() {
        local t term colors
        t=${1%-*color}

        for term in "${t}-256color" "${t}-88color" "${t}"; do
            colors="$(tput -T "${term}" colors 2>/dev/null)"
            if [ -n "$colors" ] ; then
                echo "$term"
                return
            fi
        done

        rc_log "Unknown terminal type/class '$1'. Things may not work right."
        echo "$1"
    }

    # ...and now, try to figure out how many colors $TERM supports, along
    # with more $TERM sanitizing.
    TERM="$(get_best_term $TERM)"

    SCREEN_COLORS="$(tput colors)"
    if [ -z "$SCREEN_COLORS" ] ; then
        # A 256-color version of this terminal must not exist.
        TERM=${TERM:%-*color}

        case "$TERM" in
            screen-*color-bce)
                rc_log "Unknown terminal $TERM. Falling back to 'screen-bce'."
                export TERM=screen-bce
                ;;
            *-88color)
                rc_log "Unknown terminal $TERM. Falling back to 'xterm-88color'."
                export TERM=xterm-88color
                ;;
            *-256color)
                rc_log "Unknown terminal $TERM. Falling back to 'xterm-256color'."
                export TERM=xterm-256color
                ;;
        esac
        SCREEN_COLORS="$(tput colors)"
        if [ -z "$SCREEN_COLORS" ] ; then
            case "$TERM" in
                gnome*|xterm*|konsole*|aterm|[Ee]term)
                    echoerr "Unknown terminal $TERM. Falling back to 'xterm'."
                    export TERM=xterm
                    ;;
                rxvt*)
                    echoerr "Unknown terminal $TERM. Falling back to 'rxvt'."
                    export TERM=rxvt
                    ;;
                screen*)
                    echoerr "Unknown terminal $TERM. Falling back to 'screen'."
                    export TERM=screen
                    ;;
            esac
            SCREEN_COLORS="$(tput colors)"
        fi
    fi

    if [[ $SCREEN_COLORS -gt 0 ]]; then
        typeset -A SHELL_COLORS
        SHELL_COLORS[bold]="\[$(tput bold 2> /dev/null)\]"
        SHELL_COLORS[dim]="\[$(tput dim 2> /dev/null)\]"

        if [[ $COLOR_SCHEME == "light" ]]; then
            SHELL_COLORS[color0]="\[$(tput setaf 106)\]"
            SHELL_COLORS[color1]="\[$(tput setaf 160)\]"
            SHELL_COLORS[color2]="\[$(tput setaf 028)\]"
            SHELL_COLORS[color3]="\[$(tput setaf 094)\]"
            SHELL_COLORS[color4]="\[$(tput setaf 026)\]"
            SHELL_COLORS[color5]="\[$(tput setaf 125)\]"
            SHELL_COLORS[color6]="\[$(tput setaf 023)\]"
            SHELL_COLORS[color7]="\[$(tput setaf 188)\]"
            SHELL_COLORS[color8]="\[$(tput setaf 060)\]"
            SHELL_COLORS[color9]="\[$(tput setaf 124)\]"
            SHELL_COLORS[color10]="\[$(tput setaf 022)\]"
            SHELL_COLORS[color11]="\[$(tput setaf 058)\]"
            SHELL_COLORS[color12]="\[$(tput setaf 026)\]"
            SHELL_COLORS[color13]="\[$(tput setaf 097)\]"
            SHELL_COLORS[color14]="\[$(tput setaf 024)\]"
            SHELL_COLORS[color15]="\[$(tput setaf 230)\]"

            SHELL_COLORS[background]=${SHELL_COLORS[color15]}
            SHELL_COLORS[foreground]="\[$(tput setaf 016)\]"
        else
            SHELL_COLORS[color0]="\[$(tput setaf 106)\]"
            SHELL_COLORS[color1]="\[$(tput setaf 160)\]"
            SHELL_COLORS[color2]="\[$(tput setaf 028)\]"
            SHELL_COLORS[color3]="\[$(tput setaf 094)\]"
            SHELL_COLORS[color4]="\[$(tput setaf 026)\]"
            SHELL_COLORS[color5]="\[$(tput setaf 125)\]"
            SHELL_COLORS[color6]="\[$(tput setaf 023)\]"
            SHELL_COLORS[color7]="\[$(tput setaf 188)\]"
            SHELL_COLORS[color8]="\[$(tput setaf 060)\]"
            SHELL_COLORS[color9]="\[$(tput setaf 124)\]"
            SHELL_COLORS[color10]="\[$(tput setaf 022)\]"
            SHELL_COLORS[color11]="\[$(tput setaf 058)\]"
            SHELL_COLORS[color12]="\[$(tput setaf 026)\]"
            SHELL_COLORS[color13]="\[$(tput setaf 097)\]"
            SHELL_COLORS[color14]="\[$(tput setaf 024)\]"
            SHELL_COLORS[color15]="\[$(tput setaf 230)\]"

            SHELL_COLORS[background]=${SHELL_COLORS[color15]}
            SHELL_COLORS[foreground]="\[$(tput setaf 016)\]"
        fi

        export SHELL_COLORS
    fi

    # Set $PS1 to something pretty.
    if [ -x "$(unalias -a; command -v git)" ]; then
        # If the "git" command exists on this system, define a function that
        # can be used in the $PS1 prompt to show the user relevant
        # information about a git repository, if the user is currently in
        # one.
        parse_git_status() {
            local branch status result
            branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
            [[ -z $branch ]] && return

            status=$(git status 2> /dev/null)
            result=$branch

            [[ "$status" = *deleted:* ]] && result=${result}-
            [[ "$status" = *modified:* ]] && result=${result}*
            [[ "$status" = *Untracked\ files:* ]] && result=${result}+
            printf "%s" "[$result] "
        }
        GITPARSING=1
    fi

    if [[ $SCREEN_COLORS -eq 0 ]]; then
        # Build a "dumb" prompt that should work everywhere.
        #shellcheck disable=SC2016
        [[ -n "$GITPARSING" ]] && g='$(parse_git_status)'
        export PS1="\n\u@\h\$($g) \w\n\$ "
    else
        # Force 256-color in tmux if the "real" terminal supports 256
        # colors.
        if [[ $TERM == screen* && $SCREEN_COLORS -eq 256 ]]; then
            TERM=screen-256color
        fi

        reset=${SHELL_COLORS[reset]}

        # Change the prompt color depending on whether the real UID is root
        # or a regular user.
        if [[ $(id -ru) -eq 0 ]]; then
            HOSTCOLOR=${SHELL_COLORS[color1]}
        else
            HOSTCOLOR=${SHELL_COLORS[color4]}
        fi

        [[ -n "$GITPARSING" ]] && g="$reset${SHELL_COLORS[color5]}\$(parse_git_status)$reset"
        [[ -n "$SSH_CLIENT" ]] && host="${SHELL_COLORS[color2]}@$reset${SHELL_COLORS[color10]}\h$reset"

        # Set the title of an xterm.
        case $TERM in
            xterm*|rxvt*|screen*)
                TERMTITLE="\e]0;\u@\h: \w\a"
                ;;
        esac

        # Build a colorized prompt.
        PS1="\n${TERMTITLE}"                                # Set the xterm title.
        PS1="${PS1}${HOSTCOLOR}\u"                          # Username
        PS1="${PS1}$host"                                   # Add the host, if not local
        PS1="${PS1} "
        PS1="${PS1}$g"                                      # git status, if available
        PS1="${PS1}${SHELL_COLORS[color2]}\w$reset"         # working directory
        PS1="${PS1}\n"                                      # new line.
        PS1="${PS1}${SHELL_COLORS[color2]}\$$reset "        # Either '$' or '#'
        export PS1

        PS2="${SHELL_COLORS[color3]}> $reset"
        export PS2
    fi

    unset HOSTCOLOR g b host TERMTITLE GITPARSING


    ######## ALIASES ########

    # (only need to be defined when interactive)
    alias la='ls -a'
    alias ll='ls -lah'

    # Allow sudo to work with aliases.
    # from github.com/jfrazelle/dotfiles
    alias sudo='sudo '

    [[ -n "$(command -v hd)" ]] || alias hd='hexdump -C'
    [[ -n "$(command -v mds5um)" ]] || alias md5sum='md5'

    for bits in 1 224 256 384 512; do
        #shellcheck disable=SC2139
        [[ -n "$(command -v sha${bits}sum)" ]] || alias sha${bits}sum="shasum -a $bits"
    done


    case "$UNAME" in
        Darwin)
            # Darwin/OS X includes some GNU things and some less-than-GNU
            # things, but color options exist on the default 'ls' and 'grep'
            # commands so enable them.
            alias ls='ls -G'
            export CLICOLOR=""
            export LSCOLORS=gxfxcxdxbxegEdabagacad

            # Darwin uses BSD grep, but it seems to respect options set via GREP_OPTIONS just like
            # GNU grep. Set options such that color support is enabled, binary files will be
            # ignored, and files named "tags" will not be searched.
            export GREP_OPTIONS="--colour=auto --binary-files=without-match --exclude=tags"

            # Work around a Vim incompatibility with crontab on OS X.  This
            # requires settings in .vimrc as well.
            alias crontab='VIM_CRONTAB=true crontab'

            if ! command -v realpath > /dev/null; then
                realpath() { python -c "import os; print(os.path.realpath('$1'))"; }
            fi
            ;;
        Linux)
            # Linux uses GNU less, which includes color support.
            alias ls='ls --color=auto'

            # set DIRCOLORS, if the "dircolors" command is available.
            if [[ -x "$(command -v dircolors)" ]]; then
                if [[ -r "${HOME}/.dircolors" ]]; then
                    eval "$(dircolors "${HOME}/.dircolors")"
                else
                    eval "$(dircolors)"
                fi
            fi

            # Linux uses GNU grep.  Set options such that color support is
            # enabled, binary files will be ignored, and files named "tags"
            # will not be searched.
            export GREP_OPTIONS="--colour=auto --binary-files=without-match --exclude=tags"

            unset command_not_found_handle
            ;;
        OpenBSD)
            # For OpenBSD, if the colorls(1) package has been installed, use it
            # instead of ls.
            if [[ -x "$(command -v colorls)" ]]; then
                alias ls='colorls -G'
                export CLICOLOR=""
                export LSCOLORS=gxfxcxdxbxegEdabagacad
            fi

            # Ignore binary files by default.  This is the only option that
            # BSD grep supports that is the same as GNU grep.
            export GREP_OPTS="--binary-files=without-match"
            for cmd in {,/usr}/bin/*grep; do
                cmd=$(basename "$cmd")
                [[ "$cmd" == "pgrep" || "$cmd" == "*grep" ]] && continue
                #shellcheck disable=SC2139,SC2086
                alias $cmd="$cmd \$GREP_OPTS"
            done
            ;;
        SunOS)
            # illumos uses GNU less, which includes color support.
            alias ls='ls --color=auto'

            if [[ -x "$(command -v dircolors)" ]]; then
                if [[ -r "${HOME}/.dircolors" ]]; then
                    eval "$(dircolors "${HOME}/.dircolors")"
                else
                    eval "$(dircolors)"
                fi
            fi

            # illumos includes GNU grep.  Set options such that color support is
            # enabled, binary files will be ignored, and files named "tags"
            # will not be searched.
            export GREP_OPTIONS="--colour=auto --binary-files=without-match --exclude=tags"
            ;;
    esac

    # Use UTF-8.  It's the 21st century.
    if [ -z "$LANG" ]; then
        export LANG=en_US.UTF-8
        export LC_ALL="$LANG"
        export LC_CTYPE="$LANG"
    fi

    for editor in eclient emacsclient emacs vim nvi vi; do
        if command -v $editor >/dev/null; then
            [[ $editor == "emacsclient" ]] && editor='emacsclient -c -t -a ""'
            export EDITOR=$editor VISUAL=$editor
            alias e=$editor
            unset editor
            break
        fi
    done

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

        # OpenBSD doesn't set this by default, but Linux does, so let's just
        # force it to the Linux default since that's what I'm used to at
        # this point.
        export LESSHISTFILE="${HOME}/.lesshst"
    else
        PAGER="$(command -v more)"
    fi
    export PAGER


   ### Shell Completion
    if [[ $SHELL == *bash* ]]; then
        if ! shopt -oq posix ; then
            # Some standard paths.
            rc_source_file /usr/share/bash-completion/bash_completion
            rc_source_file /usr/local/share/bash-completion/bash_completion
            rc_source_file /etc/bash_completion
            rc_source_file "${HOME}/.bash_completion"

            if [[ -d ${HOME}/.bash_completion.d ]]; then
                for f in ${HOME}/.bash_completion.d/*; do
                    rc_source_file "$f"
                done
            fi

            # pkgsrc on OSX
            rc_source_file /opt/pkg/share/bash-completion/bash_completion

            # pkgsrc on Linux
            rc_source_file /usr/pkg/share/bash-completion/bash_completion

            # Homebrew
            if [ "$(command -v brew)" ]; then
                rc_source_file "$(brew --prefix)/etc/bash_completion"
            fi

            # git on OSX, when installed via the official DMG package.
            rc_source_file /usr/local/git/contrib/completion/git-completion.bash
            # ...or when installed via pkgin.
            rc_source_file /opt/pkg/share/examples/git/git-completion.bash
            rc_source_file /usr/pkg/share/examples/git/git-completion.bash
        fi
    fi


    ### TURN OFF THE FRIGGIN' CONSOLE BELL.
    if [[ -n $DISPLAY && $UNAME != "Darwin" ]]; then
        [[ -n "$(command -v xset)" ]] && xset -b
    else
        [[ -n "$(command -v setterm)" ]] && setterm --blength 0 2> /dev/null
    fi


    ######## FUNCTIONS ########
    # Syntax-highlit less(1)
    cless() {
        if [ -z "$(command -v pygmentize)" ]; then
            echo "install pygmentize to use cless" 1>&2
            return
        fi
        local f="$1"
        [[ -z "$f" ]] && f="-"
        #shellcheck disable=2002
        cat "$f" | pygmentize -g | less
    }

    repo() {
        local giturl
        giturl=$(git ls-remote --get-url 2>/dev/null | perl -pe 's#^(?:git@|https?://)([^/:]+)(?:[/:](.*?))?(?:\.git)?$#https://\1/\2#')
        if [[ $giturl == "" ]]; then
            echo "Not a git repository or no remote.origin.url is set."
        else
            local gitbranch
            gitbranch=$(git rev-parse --abbrev-ref HEAD)

            if [[ $gitbranch != "master" ]]; then
                if [[ "$giturl" == *bitbucket* ]]; then
                    local giturl="${giturl}/branch/${gitbranch}"
                else
                    local giturl="${giturl}/tree/${gitbranch}"
                fi
            fi

            echo "$giturl"
        fi
    }

    elfdiff() {
        local diff="diff -Nauri"
        local left="$1"
        local right="$2"
        [[ -z "$left" || -z "$right" ]] && return
        local section="$3"

        local sections
        if [[ -n "$section" ]]; then
            sections=$section
        else
            declare -a s
            s+=("$(readelf -WS "$left")")
            s+=("$(readelf -WS "$right")")
            sections=$(echo "${s[*]}" | perl -ne '/\[[ 0-9]+\] ([^ ]+)/ && print "$1\n"' | sort -u)
        fi

        local header_printed
        for s in $sections; do
            local d heading
            case $s in
                .rodata|.comment|.GCC.command.line|.strtab|.dynstr)
                    # Dump these sections as strings.
                    d=$($diff <(readelf -p "$s" "$left") <(readelf -p "$s" "$right"))
                    heading="String dump of section '$s':"
                    ;;
                .text)
                    # Dump these sections as disassembly.
                    d=$($diff <(objdump -dj "$s" "$left") <(objdump -dj "$s" "$right"))
                    heading="Disassembly of section '$s':"
                    ;;
                *)
                    # For all other sections, show a hex-dump.
                    d=$($diff <(readelf -x "$s" "$left") <(readelf -x "$s" "$right"))
                    heading="Hex dump of section '$s':"
                    ;;
            esac
            if [[ -n "$d" ]]; then
                if [[ -z $header_printed ]]; then
                    echo "--- a/${left}"
                    echo "+++ b/${right}"
                    header_printed=1
                fi
                d=$(echo "$d" | sed -re "/^(---|\+\+\+).*/d" -e "s/^(@@.*)$/\1 $heading/")
                echo "$d"
                printf "\n"
            fi
        done
    }

    server() {
        local port="${1:-8000}";
        python3 -m http.server "$port"
    }

    man() {
        LESS_TERMCAP_mb=$(printf '\e[01;31m')   \
                       LESS_TERMCAP_md=$(printf '\e[01;35m')   \
                       LESS_TERMCAP_me=$(printf '\e[0m')       \
                       LESS_TERMCAP_se=$(printf '\e[0m')       \
                       LESS_TERMCAP_so=$(printf '\e[01;33m')   \
                       LESS_TERMCAP_ue=$(printf '\e[0m')       \
                       LESS_TERMCAP_us=$(printf '\e[04;36m')   \
                       command man "$@"
    }
    ######## END OF FUNCTIONS ########
fi # end of interactive block


### ccache support
if [[ -n "$(command -v ccache)" ]]; then
    if [[ -d /usr/lib/ccache ]]; then
        prepend_to_path /usr/lib/ccache
    else
        ccache="$(command -v ccache)"
        for i in gcc g++ cc c++; do
            [[ -e "${HOME}/bin/${i}" ]] && continue
            ln -s "$ccache" "${HOME}/bin/$i"
        done
        unset ccache
    fi
fi


### Emacs
if [[ "$-" == *i* ]]; then
    if [[ -d /Applications/Emacs.app ]]; then
        [[ -e "${HOME}/bin/emacs" ]] || ln -sf /Applications/Emacs.app/Contents/MacOS/Emacs "${HOME}/bin/emacs"
        [[ -e "${HOME}/bin/emacsclient" ]] || ln -sf /Applications/Emacs.app/Contents/MacOS/bin/emacsclient "${HOME}/bin/emacsclient"
    fi

    if [[ -n "$(command -v emacsclient)" ]]; then
        alias e='emacsclient -t -a ""'
    fi
fi

### Erlang (and probably Elixir?)
prepend_to_path "${HOME}/.cache/rebar3/bin"


### Go
export GOENV_DISABLE_GOPATH=1
export GOPATH="${HOME}/code/go"
prepend_to_path "${GOPATH}/bin"


### GnuPG
if [[ "$-" == *i* && -x "$(command -v gpg-agent)" ]]; then
    unset GPG_TTY
    unset GPG_AGENT_INFO
    unset SSH_AUTH_SOCK
    unset SSH_AGENT_PID

    # For versions of GPG less than 2.1.0 the GPG_AGENT_INFO environment
    # variable is still a thing and needs to be set appropriately.
    #
    # I hear you asking, "who still installs versions of GPG from 2009?"
    # RHEL/CentOS 6, my friend. Oh, how I hate it.
    #
    # Ping from 2021: when exactly are you going to remove this?
    gpg_version=$(gpg-agent --version | awk '/GnuPG/ { print $3 }')
    major=${gpg_version:0:1}
    minor=${gpg_version:2:1}
    revision=${gpg_version:4}
    if [[ $major -le 1 || ($major -eq 2 && $minor -eq 0 || ($minor -eq 1 && $revision -eq 0)) ]]; then
        needs_gpg_agent_info=1
    fi
    unset gpg_version major minor revision

    if [[ -n $needs_gpg_agent_info ]]; then
        pgrep -u "$USER" -x gpg-agent &>/dev/null
        if [ $? -ne 0 ]; then
            eval $(gpg-agent --daemon --write-env-file "${HOME}/.gnupg/agent-info")
        else
            if [ -f "${HOME}/.gnupg/agent-info" ]; then
                . "${HOME}/.gnupg/agent-info"
                export GPG_AGENT_INFO SSH_AUTH_SOCK SSH_AGENT_PID
            fi
        fi
    else
        gpg-connect-agent -q /bye
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    fi

    function gpg_update_tty {
        if pgrep gpg-agent >/dev/null; then
            gpg-connect-agent -q UPDATESTARTUPTTY /bye >/dev/null
        fi
    }

    export GPG_TTY=$(tty)
    export PROMPT_COMMAND="gpg_update_tty;$PROMPT_COMMAND"
fi


### Java
prepend_to_path "${HOME}/code/jdk/Contents/Home/bin"

## Set a default JAVA_HOME.
if [ -n "$(command -v java_home)" ]; then
    java_home=$(command -v java_home)
elif [ -x /usr/libexec/java_home ]; then
    java_home=/usr/libexec_java_home
fi

if [[ -n $java_home ]]; then
    JAVA_HOME=$java_home
    export JAVA_HOME
fi

prepend_to_path "/usr/local/maven/bin"


### MacTex
append_to_path /Library/TeX/texbin


### Node.js
#NVM_DIR="$XDG_CONFIG_HOME/nvm"
#
#if [[ -r ${NVM_DIR}/nvm.sh ]]; then
#    export NVM_DIR
#
#    #shellcheck source=../../.config/nvm/nvm.sh
#    . "${NVM_DIR}"/nvm.sh
#else
#    unset NVM_DIR
#fi
#
#append_to_path "${HOME}/.npm-global/bin"


### Yarn
prepend_to_path "$HOME/.yarn/bin"
prepend_to_path "$HOME/.config/yarn/global/node_modules/.bin"


### PlatformIO
if [[ "$-" == *i* && -n "$(command -v platformio)" ]]; then
    eval "$(_PLATFORMIO_COMPLETE=source platformio)"
    eval "$(_PIO_COMPLETE=source pio)"
fi


### Python
[[ -r "${HOME}/.pythonrc" ]] && export PYTHONSTARTUP="${HOME}/.pythonrc"

if [[ -d "${HOME}/.pyenv/bin" ]]; then
    prepend_to_path "${HOME}/.pyenv/bin"
    if [[ "$-" == *i* ]]; then
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
    fi
else
    if [[ $UNAME -eq "Darwin" ]]; then
        # On OSX, Apple puts Python things here.
        for ver in "${HOME}"/Library/Python/*; do
            prepend_to_path "$ver"
        done
    fi
fi

# Get rid of the deprecation warning for Python 2.
export PYTHONWARNINGS=ignore:Please.upgrade::pip._internal.cli.base_command


### Ruby
for d in ~/.gem/ruby/*; do
    prepend_to_path "$d/bin"
done

### Rust
prepend_to_path "${HOME}/.cargo/bin"
if [[ "$-" == *i* ]]; then
    [[ -n "$(command -v rustup)" ]] && eval "$(rustup completions bash)"
fi

if [[ -n "$(command -v rustc)" ]]; then
    RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
    [[ -d $RUST_SRC_PATH ]] && export RUST_SRC_PATH
fi


### SSH
if [[ "$-" == *i* ]]; then
    # Create a directory for SSH control sockets.
    # To use this, you need to put the following line in your .ssh/config:
    #
    # ControlPath ~/.cache/ssh/ssh_mux_%C
    [[ -w "${HOME}/.cache/ssh" ]] || mkdir -p "${HOME}/.cache/ssh"

    # bash completion follows; no reason to continue if we're not bash
    if [[ $SHELL == *bash* ]]; then
        # Complete SSH hostnames based on what is in ssh config.
        [[ -e "${HOME}/.ssh/config" ]] && complete -o "default" \
            -o "nospace"                                        \
            -W "$(grep "^Host" "${HOME}/.ssh/config" |          \
            grep -v "[?*]" | cut -d " " -f2 |                   \
            tr ' ' '\n')" scp sftp ssh

        # Wire up completion for known_hosts to ssh if the function exists.
        # I have no idea why this isn't working for me by default, but...okay.
        declare -f _known_hosts >/dev/null && complete -F _known_hosts ssh
    fi
fi


### tmux
if [[ "$-" == *i* ]]; then
    if [[ -n "$(command -v tmux)" ]]; then
        t() {
            local session
            if [[ -n $1 ]]; then
                # ksh doesn't like a shift if there isn't anything to shift...
                session="${1}" ; shift
            else
                session="main"
            fi
            tmux new-session -A -s "$session" "$@"
        }

        # bash-specific configuration follows; no reason to continue if we're not bash
        if [[ $SHELL == *bash* ]]; then
            update_tmux_env() {
                [[ -n $TMUX ]] || return
                local v
                while read v; do
                    if [[ $v == -* ]]; then
                        unset ${v/#-/}
                    else
                        v=${v//$/\$}
                        v=${v//\`/\`}
                        v=${v//\"/\"}
                        v=${v//\/\\}
                        v=${v/=/=\"}
                        v=${v/%/\"}
                        eval export $v
                    fi
                done < <(tmux show-environment)
            }
            [[ "$PROMPT_COMMAND" == *update_tmux_env* ]] || PROMPT_COMMAND="update_tmux_env; $PROMPT_COMMAND"

            _t() {
                local IFS=$'\n'
                local cur
                COMPREPLY=()
                cur="${COMP_WORDS[COMP_CWORD]}"
                COMPREPLY=( ${COMPREPLY[@]:-} $(compgen -W "$(tmux -q list-sessions 2>/dev/null | cut -f 1 -d ':')" -- "${cur}") )
                return 0

            }

            complete -F _t t
        fi
    fi
fi

rc_source_file "${HOME}/.rc/local"

# These are at the bottom because we always want them to be first in the search order.
prepend_to_path "${HOME}/.local/bin"
prepend_to_path "${HOME}/bin"
dedupe_path
export PATH
