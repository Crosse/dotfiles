#!/bin/sh
echo "Updating submodules..."
git submodule update --init --recursive
echo "Symlinking..."
for file in $(find "$PWD" -mindepth 1 -maxdepth 1   \
                -not -name "bin"                    \
                -not -name "per-os"                 \
                -not -name ".gitignore"             \
                -not -name ".gitmodules"            \
                -not -name ".git"                   \
                -not -name ".*.swp"                 \
             ); do
    f=$(basename $file)
    ln -sfn "$file" "${HOME}/$f"
done

mkdir -p ${HOME}/bin
for file in $(find "${PWD}/bin" -mindepth 1); do
    f=$(basename $file)
    ln -sfn "$file" "${HOME}/bin/$f"
done
