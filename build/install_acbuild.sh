#!/bin/sh

set -e
DEFAULT_VERSION="v0.2.2"

. ./funcs.sh

if [ -n "$1" ]; then
    VERSION=$1
else
    VERSION=$DEFAULT_VERSION
fi
URI="https://github.com/appc/acbuild/releases/download/${VERSION}/acbuild.tar.gz"


echo "==> Downloading acbuild $VERSION"
$(downloader) $URI | tar xzf - -C /usr/local/bin
