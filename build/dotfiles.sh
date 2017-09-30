#!/bin/sh

set -e

. ./funcs.sh

WRKDIR=$(cd "$(dirname "$0")/.." && pwd -P)
cd "$WRKDIR"

for file in $(find "$WRKDIR"            \
                -mindepth 1 -maxdepth 1	\
                \! -name '.git'	\
                \! -name '.gitignore'	\
                \! -name '.gitmodules'\
                \! -name 'README.md'	\
                \! -name 'LICENSE'	\
                \! -name 'bin'	\
                \! -name 'build'	\
                \! -name 'etc'	\
                \! -name '.*.swp'	\
            ); do
    f=$(basename $file)
    if [ -e "${HOME}/$f" -a ! -L "${HOME}/$f" ]; then
        echo "Backing up ${HOME}/$f to ${HOME}/backup/$f"
        [ -d "${HOME}/backup" ] || mkdir -p "${HOME}/backup"
        mv "${HOME}/$f" "${HOME}/backup/" && ln -sfn "$file" "${HOME}/$f"
    else
        echo "$file --> ${HOME}/$f"
        ln -sfn "$file" "${HOME}/$f"
    fi
done
