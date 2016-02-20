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

# Disable the bell
if [ -n "$DISPLAY" ]; then
    log "Disabling bell"
    xset b off
    setxkbmap -option terminate:ctrl_alt_bksp
fi

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
        if [ -x "$(command -v dconf)" ]; then
            log "Disabling the GNOME mouse plugin"
            dconf write /org/gnome/settings-daemon/plugins/mouse/active false
        fi
        if [ -n "$(command -v synclient)" ]; then
            log "Enabling Two-Finger Scrolling"
            synclient VertTwoFingerScroll=1
            synclient HorizTwoFingerScroll=1
        fi
        [ -x /usr/lib/x86_64-linux-gnu/notify-osd ] && /usr/lib/x86_64-linux-gnu/notify-osd &
        if [ -n "$(command -v gnome-settings-daemon)" ]; then
            log "Starting the GNOME settings daemon"
            gnome-settings-daemon &
        fi
        ;;
esac

SESSION="${XDG_CONFIG_HOME:-$HOME/.config}/default-shell"
if [ -h "$SESSION" ]; then
    log "Starting $SESSION"
    if [ -f "$(command -v xcompmgr)" ]; then
        xcompmgr -cCn &
    fi
    exec "$SESSION"
else
    log "No default shell set! Symlink your desired shell to $SESSION"
fi
