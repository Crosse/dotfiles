#!/bin/sh

DEFAULT_VERSION=1.5.1
GO_URI="https://storage.googleapis.com/golang/"

. funcs.sh

if [ -n "$1" ]; then
    VERSION=$1
else
    VERSION=$DEFAULT_VERSION
fi


UNAME=$(uname)
ARCH=$(uname -m | tr [A-Z] [a-z])
GOFILE="go$VERSION"

# This only works for Linux and Darwin.
GOFILE="go${VERSION}.${ARCH}"

case "$ARCH" in
    x86_64)
        GOFILE="${GOFILE}-amd64"
        ;;
    i386)
        GOFILE="${GOFILE}-386"
        ;;
esac
GOFILE="${GOFILE}.tar.gz"

@echo "==> Downloading Go $(GO_VERSION)"
$(downloader) ${GO_URI}${GOFILE} | sudo tar xzf - -C /usr/local
