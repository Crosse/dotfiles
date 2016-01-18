#!/bin/sh
#
# X startup script

# Load any Xdefaults
if [ -f ${HOME}/.Xresources ]; then
    xrdb -merge ${HOME}/.Xresources
fi

case "$(uname)" in
    OpenBSD)
        if [ -f "`which xidle`" ]; then
            xidle &
        fi

        # Set the background
        xsetroot -solid steelblue

        #xterm -geometry 140x50 &

        # Choose a window manager.
        #exec /usr/X11R6/bin/twm
        exec /usr/X11R6/bin/cwm
        #exec /usr/X11R6/bin/fvwm
        #exec /usr/local/bin/gnome-shell
        ;;
    Darwin)
        exec /usr/bin/quartz-wm
        ;;
    Linux)
        exec /usr/bin/gnome-shell
        ;;
esac
