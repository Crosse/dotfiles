#!/bin/sh
#
# X startup script

LOGFILE=${HOME}/.xsession.log
log() {
    printf "[%s] %s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$1" >> $LOGFILE
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

[[ -n $(command -v xidle) ]] && xidle &
if [[ -x "$(command -v feh)" && -s ${HOME}/.config/background.jpg ]]; then
    feh --no-fehbg --bg-fill ${HOME}/.config/background.jpg
elif [[ -x $(command -v xsetroot) ]]; then
    xsetroot -solid steelblue
fi

# Disable the bell
log "Disabling bell"
xset -b
setxkbmap -option terminate:ctrl_alt_bksp

#if [[ -n $(command -v syndaemon) ]]; then
#    log "starting syndaemon"
#    syndaemon -dtk
#fi
#
#if [[ -n $(command -v xflux) ]]; then
#    log "starting xflux"
#    xflux
#fi
run syndaemon -dtk
run xflux

#xautolock -locker "fancylock.py lock" -detectsleep -time 15 &

#USE_GNOME_SESSION=1
SESSION=$(readlink "${XDG_CONFIG_HOME:-$HOME/.config}/default-shell")
log "Validating $SESSION"
if [ -x $SESSION ]; then
    run compton -Gb &
    log "Starting $SESSION"
    if [ $USE_GNOMESESSION ]; then
        SESSION=$(basename $$SESSION)
        exec gnome-session --session=${SESSION}
    else
        exec ${SESSION}
    fi
else
    log "No default shell set! Symlink your desired shell to ${XDG_CONFIG_HOME:-$HOME/.config}/default-shell"
fi
