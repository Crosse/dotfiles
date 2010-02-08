#!/bin/sh
#
# $Id$
#
# X startup script

# Load any Xdefaults
if [ -f ${HOME}/.Xdefaults ]; then
    xrdb -merge ${HOME}/.Xdefaults
fi

xscreensaver -no-splash &

# Set the background
fbsetbg -l

#xterm -geometry 140x50 &

exec /usr/local/bin/startfluxbox
#exec cwm
