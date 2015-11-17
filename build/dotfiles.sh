#!/bin/sh

echo "==> Symlinking dotfiles into ${HOME}"

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
                -not -name '.*.swp'	\
            ); do
    f=$(basename $file);
    ln -sfn "$file" "${HOME}/$f";
done
