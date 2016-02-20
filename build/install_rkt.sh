#!/bin/sh

set -e 
DEFAULT_VERSION="v1.0.0"

. ./funcs.sh

if [ -n "$1" ]; then
    VERSION=$1
else
    VERSION=$DEFAULT_VERSION
fi
URI="https://github.com/coreos/rkt/releases/download/${VERSION}/rkt-${VERSION}.tar.gz"


echo "==> Downloading rkt $VERSION"
TMP=$(mktemp -d)
$(downloader) $URI | tar xzf - -C "$TMP"
cd "$TMP/rkt-${VERSION}"
install -v -m 755 -o root -g root rkt /usr/bin
install -v -m 755 -o root -g root -d /var/lib/rkt
install -v -m 755 -o root -g root -d /usr/local/lib/rkt/stage1-images
install -v -m 644 -o root -g root -t /usr/local/lib/rkt/stage1-images stage1-*.aci
install -v -m 644 -o root -g root bash_completion/* /etc/bash_completion.d
install -v -m 644 -o root -g root -t /lib/systemd/system init/systemd/*.service init/systemd/*.timer init/systemd/*.socket
install -v -m 644 -o root -g root -t /usr/lib/tmpfiles.d init/systemd/tmpfiles.d/*

./scripts/setup-data-dir.sh
