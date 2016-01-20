#!/bin/sh

. ./funcs.sh

XDG_DATA_HOME=${XDG_DATA_HOME:-${HOME}/.local/share}
FONTS_DIR="${XDG_DATA_HOME}/fonts"
FONTS_LIST=$(cat ./fontslist.txt)

DL_CMD=$(downloader)

if [ ! -d "$FONTS_DIR" ]; then
    echo "Creating $FONTS_DIR"
    mkdir "$FONTS_DIR"
fi

cd "$FONTS_DIR"
for f in $FONTS_LIST; do
    fdir="${FONTS_DIR}/${f}"
    if [ ! -d "$fdir" ]; then
        echo "Creating $fdir"
        mkdir "$fdir"
    fi
    echo "Downloading $f to $fdir"
    $DL_CMD "http://www.fontsquirrel.com/fonts/download/${f}" > "${f}.zip"
    unzip -quo "${f}.zip" -d "$fdir"
done
