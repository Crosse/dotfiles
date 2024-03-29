#!/bin/sh

set -eu

WRKDIR=$(cd "$(dirname "$0")/.." && pwd -P)
file=
lang=

usage() {
    echo >&2 "Usage: $(basename "$0") -l go|ruby|py2|py3"
}

if [ $# = 0 ]; then
    set -- go ruby py2 py3
fi

#shellcheck disable=SC2068
for l in $@; do
    file="$WRKDIR/tools/${l}tools.txt"
    packages=$(awk '/^\s*([^# ]+)/ { print $1 }' "$file" | paste -sd' ' -)
    echo "installing from $file"

    case "$l" in
        go)
            if ! command -v go >/dev/null; then
                printf >&2 "Go is not installed!"
                exit 1
            fi
            for package in $packages; do
                go install $package@latest
            done
            ;;
        ruby)
            if ! command -v gem >/dev/null; then
                printf >&2 "Ruby's 'gem' command not found!"
                exit 1
            fi
            #shellcheck disable=SC2086
            gem install $packages
            ;;
        py2)
            if ! command -v python2 >/dev/null; then
                printf >&2 "Python 2 is not installed!"
                exit 1
            fi
            #shellcheck disable=SC2086
            python2 -m pip install --user $packages
            ;;
        py3)
            if ! command -v python3 >/dev/null; then
                printf >&2 "Python 3 is not installed!"
                exit 1
            fi
            #shellcheck disable=SC2086
            python3 -m pip install --user $packages
            ;;
        rust)
            if ! command -v cargo >/dev/null; then
                printf >&2 "Rust is not installed!"
                exit 1
            fi
            #shellcheck disable=SC2086
            cargo install $packages
            ;;
        vscode)
            if ! command -v code > /dev/null; then
                printf >&2 "VS Code 'code' command is not installed!"
                exit 1
            fi
            #shellcheck disable=SC2086
            for ext in $packages; do
                code --install-extension $ext
            done
            ;;
        *)
            echo >&2 "Unsupported language: $l"
            usage
            exit 1
    esac
done
