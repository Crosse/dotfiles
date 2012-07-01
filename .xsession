#!/bin/sh
#
# $Id$
#
# X startup script

# Load any Xdefaults
if [ -f ${HOME}/.Xresources ]; then
    xrdb -merge ${HOME}/.Xresources
fi

if [ -f "`which xidle`" ]; then
    xidle &
fi

# Set the background
xsetroot -solid steelblue

#xterm -geometry 140x50 &

if [ "$(uname)" == "Darwin" ]; then
    exec /usr/bin/quartz-wm
else
    #exec /usr/X11R6/bin/twm
    exec /usr/X11R6/bin/cwm
    #exec /usr/X11R6/bin/fvwm
fi
