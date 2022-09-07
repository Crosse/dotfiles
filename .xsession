#!/bin/sh
#
# X startup script

LOGFILE=${HOME}/.xsession.log
log() {
    printf "[%s] %s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$1" >>$LOGFILE
}

run() {
    if [[ ! -n $(command -v "$1") ]]; then
        log "command $1 not found"
        return
    fi

    log "running $1"
    "$@"
}

log "Reading .xsession"

# Load any Xdefaults
if [ -f ${HOME}/.Xresources ]; then
    log "Merging Xresources"
    xrdb -merge ${HOME}/.Xresources
fi

export LANG=en_US.UTF-8
export LC_ALL="$LANG"
export LC_CTYPE="$LANG"

# Disable the bell
log "Disabling bell"
xset -b
setxkbmap -option terminate:ctrl_alt_bksp

#USE_GNOME_SESSION=1
#SESSION=$(readlink "${XDG_CONFIG_HOME:-$HOME/.config}/default-shell")
#log "Validating $SESSION"
#if [ -x $SESSION ]; then
#    run compton -Gb &
#    log "Starting $SESSION"
#    if [ $USE_GNOMESESSION ]; then
#        SESSION=$(basename $$SESSION)
#        exec gnome-session --session=${SESSION}
#    else
#        exec ${SESSION}
#    fi
#else
#    log "No default shell set! Symlink your desired shell to ${XDG_CONFIG_HOME:-$HOME/.config}/default-shell"
#fi

exec quartz-wm
#exec ssh -Y lantern gnome-session --session=gnome-shell
