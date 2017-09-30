#!/bin/sh

set -e

BINDIR=$(cd "$(dirname "$0")/../bin" && pwd -P)
cd "$BINDIR"

if [ ! -d "${HOME}/bin" ]; then
    mkdir -p "${HOME}/bin"
fi

for file in $(find "$BINDIR" -maxdepth 1 -mindepth 1 \! -name '.*.swp'); do
    f=$(basename $file)
    if [ -e "${HOME}/$f" -a ! -L "${HOME}/$f" ]; then
        echo "Backing up ${HOME}/$f to ${HOME}/backup/$f"
        [[ -d "${HOME}/backup" ]] || mkdir -p "${HOME}/backup"
        mv "${HOME}/$f" "${HOME}/backup/" && ln -sfnv "$file" "${HOME}/bin/$f"
    else
        echo "$file --> ${HOME}/bin/$f"
        ln -sfn "$file" "${HOME}/bin/$f"
    fi
done
