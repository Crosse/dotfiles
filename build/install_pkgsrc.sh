#!/bin/sh
# This script installs and verifies pkgsrc for OSX.

BOOTSTRAP_TAR="bootstrap-trunk-x86_64-20191204.tar.gz"
BOOTSTRAP_SHA="e4c585ca0d80ccac887824432e94e5715abc85ec"
######################################################

. funcs.sh

PKGSRC_SITE=https://pkgsrc.joyent.com/packages/Darwin/bootstrap/
DOWNLOADER=$(downloader)
if [ -z "$DOWNLOADER" ]; then
    echo "no valid HTTP downloader found"
    exit
fi

TMPDIR=$(mktemp -d)
if [ -z "$TMPDIR" ]; then
    echo "temp dir creation failed"
    exit
fi
cd "$TMPDIR"

trap "rm -rf $TMPDIR" EXIT

# Download 64-bit bootstrap kit
echo "==> Downloading $BOOTSTRAP_TAR"
$DOWNLOADER "${PKGSRC_SITE}${BOOTSTRAP_TAR}" > $BOOTSTRAP_TAR

# Verify the download. Kind of hacky right now.
echo "==> Verifying SHA hash"
echo "$BOOTSTRAP_SHA  $BOOTSTRAP_TAR" > cksumfile
shasum -c cksumfile
[[ $? == 0 ]] || exit

# Install bootstrap kit to /opt/pkg
echo "==> Installing $BOOTSTRAP_TAR"
sudo tar -zxpf $BOOTSTRAP_TAR -C /
[[ $? == 0 ]] || exit

# Fetch package repository information
sudo rm -rf /var/db/pkgin
sudo /opt/pkg/bin/pkgin -y update

echo "pkgsrc installation finished.  Please add /opt/pkg/bin to your PATH."
