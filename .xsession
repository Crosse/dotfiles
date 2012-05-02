#!/bin/sh
#
# $Id$
#
# X startup script

# Load any Xdefaults
if [ -f ${HOME}/.Xdefaults ]; then
    xrdb -merge ${HOME}/.Xresources
fi

xidle &

# Set the background
xsetroot -solid steelblue

#xterm -geometry 140x50 &

#exec /usr/X11R6/bin/twm
#exec /usr/X11R6/bin/cwm
exec /usr/X11R6/bin/fvwm
