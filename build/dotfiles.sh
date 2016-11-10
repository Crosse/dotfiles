#!/bin/sh

set -e -o pipefail

. ./funcs.sh

WRKDIR=$(cd "$(dirname "$0")/.." && pwd -P)
cd "$WRKDIR"

for file in $(find "$WRKDIR"            \
                -mindepth 1 -maxdepth 1	\
                -not -name '.git'	\
                -not -name '.gitignore'	\
                -not -name '.gitmodules'\
                -not -name 'README.md'	\
                -not -name 'bin'	\
                -not -name 'build'	\
                -not -name 'etc'	\
                -not -name '.*.swp'	\
            ); do
    f=$(basename $file)
    if [ -e "${HOME}/$f" -a ! -L "${HOME}/$f" ]; then
        echo "Backing up ${HOME}/$f to ${HOME}/backup/$f"
        [ -d "${HOME}/backup" ] || mkdir -p "${HOME}/backup"
        mv "${HOME}/$f" "${HOME}/backup/" && ln -sfnv "$file" "${HOME}/$f"
    else
        ln -sfnv "$file" "${HOME}/$f"
    fi
done

echo "Retrieving the latest sks-keyservers.net CA"
$(downloader) https://sks-keyservers.net/sks-keyservers.netCA.pem > ${HOME}/.gnupg/sks-keyservers.netCA.pem
