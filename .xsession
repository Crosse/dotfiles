#!/bin/sh
#
# X startup script

LOGFILE=${HOME}/.xsession.log
log() {
    printf "[%s] %s\n" "$(date +'%Y-%m-%dT%H:%M:%S %z')" "$1" >> $LOGFILE
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

PLATFORM=$(uname -s)
log "Turns out I'm running on $PLATFORM"
case "$PLATFORM" in
    OpenBSD)
        if [ -n "$(command -v xidle)" ]; then
            xidle &
        fi
        if [ -n "$(command -v xsetroot)" ]; then
            # Set the background
            xsetroot -solid steelblue
        fi
        #xterm -geometry 140x50 &
        ;;
    Linux)
        [ -x "$(command -v feh)" ] && feh --no-fehbg --bg-fill ${HOME}/.config/background.jpg
        ;;
esac

# Disable the bell
log "Disabling bell"
xset -b
setxkbmap -option terminate:ctrl_alt_bksp

[[ -n $(command -v xflux) ]] && xflux

#xautolock -locker "fancylock.py lock" -detectsleep -time 15 &

SESSION="${XDG_CONFIG_HOME:-$HOME/.config}/default-shell"
if [ -h "$SESSION" ]; then
    #[ -f "$(command -v compton)" ] && compton -Gb &
    SESSION=$(basename $(readlink -f $SESSION))
    log "Starting $SESSION"
    exec gnome-session --session=${SESSION}
    exec ${SESSION}
else
    log "No default shell set! Symlink your desired shell to $SESSION"
fi
