#!/bin/sh

BINDIR=$(cd "$(dirname "$0")/../bin" && pwd -P)
cd "$BINDIR"

if [ ! -d "${HOME}/bin" ]; then
    mkdir "${HOME}/bin"
fi

for file in $(find "$BINDIR" -maxdepth 1 -mindepth 1 -not -name '.*.swp'); do
    f=$(basename $file)
    if [ -e "${HOME}/$f" -a ! -L "${HOME}/$f" ]; then
        echo "Backing up ${HOME}/$f to ${HOME}/backup/$f"
        [[ -d "${HOME}/backup" ]] || mkdir -p "${HOME}/backup"
        cp -pvR "${HOME}/$f" "${HOME}/backup/"
    fi
    ln -sfn "$file" "${HOME}/bin/$f"
done
