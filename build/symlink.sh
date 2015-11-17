#!/bin/sh

echo "==> Creating symlinks in ${HOME}/bin"

BINDIR=$(cd "$(dirname "$0")/../bin" && pwd -P)
cd $BINDIR
for file in $(find . -mindepth 1 -not -name '.*.swp'); do
    f=$(basename $file)
    ln -sfn "$file" "${HOME}/bin/$f"
done
